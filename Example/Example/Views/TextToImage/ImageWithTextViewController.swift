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
    @IBOutlet weak var textField: UITextField!
    let vm = ImageGenerationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - IBAction
    @IBAction func sendImageRequestMessage(_ sender: UIButton) {
        if let textInstruction = textField.text, !textInstruction.isEmpty {
            textField.text = ""
            // Send user message to ChatGPT
            generateImageWithText(textInstruction)
        }
    }
    func generateImageWithText(_ text: String)  {
        vm.sendImageRequest(text)
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

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

