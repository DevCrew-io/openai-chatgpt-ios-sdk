//
//  ImageWithTextViewController.swift
//  Example
//
//  Created by Ghullam Abbas on 16/06/2023.
//

import UIKit
import ChatGPTAPIManager

class ImageWithTextViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let vm = ImageGenerationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.onSuccess = {
            DispatchQueue.main.async { [weak self] in
                
                //                 Download image from url and show
                print("Generated image URL:", self!.vm.imageURLString)
                if let url = URL(string: self!.vm.imageURLString!) {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async { /// execute on main thread
                            EZLoadingActivity.hide(true,animated: true)
                            self?.imageView.image = UIImage(data: data)
                        }
                    }
                    
                    task.resume()
                }
                
                
                // Show image from base64 string
                //                EZLoadingActivity.hide(true,animated: true)
                //                self?.imageView.image = convertBase64ToImage(base64Image: self?.vm.base64String ?? "")
            }
        }
        vm.onFailure = {
            EZLoadingActivity.hide(false,animated: true)
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func sendImageRequestMessage(_ sender: UIButton) {
        // Send user message to ChatGPT
        generateImageWithText("Create an image of cat with awesom background")
    }
    
    @IBAction func editImage(_ sender: UIButton) {
        guard let image = UIImage(named: "pngwing.com") else { return }
                //self.imageView.image else { return }
        guard let imageData = image.pngData() else { return }
        vm.editImage("add one more cat in existing image along with flowers", imageData: imageData)
    }
    
    @IBAction func imageVariation(_ sender: UIButton) {
        
        guard let image = UIImage(named: "pngwing.com") else { return }
                //self.imageView.image else { return }
        guard let imageData = image.pngData() else { return }
        vm.imageVariations(imageData: imageData)
    }
    
    func generateImageWithText(_ text: String)  {
        vm.sendImageRequest(text)
    }
    
}

func convertBase64ToImage(base64Image:String) -> UIImage? {
    var strImage = base64Image
    let strArray = base64Image.split(separator: ",")
    if strArray.count > 1 {
        strImage = "\(strArray[1])"
    }
    
    if let dataDecoded : Data = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters) {
        return UIImage(data: dataDecoded as Data)
    }
    
    return nil
}
