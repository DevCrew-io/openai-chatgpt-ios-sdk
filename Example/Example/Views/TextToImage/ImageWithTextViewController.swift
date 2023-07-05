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
        guard let image = self.imageView.image else { return }
        guard let imageData = image.pngData() else { return }
        vm.editImage("add on tree in this image along with flowers", imageData: imageData)
    }
    @IBAction func imageVariation(_ sender: UIButton) {
        
            // Send user message to ChatGPT
            generateImageWithText("Create an image of cat with awesom background")
        
    }
    func generateImageWithText(_ text: String)  {
        vm.sendImageRequest(text)
    }
    
}

