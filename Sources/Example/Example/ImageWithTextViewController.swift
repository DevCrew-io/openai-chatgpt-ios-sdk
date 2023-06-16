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
    
    let chatGPTAPI = ChatGPTAPIManager(apiKey: "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")
    
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
        EZLoadingActivity.show("Loading...", disableUI: true)
         chatGPTAPI.generateImage(prompt: text, model: .gptThreePointFiveTurbo, imageSize: .fiveTwelve,endPoint: .generateImage) { result in
            switch result {
            case .success(let imageURL):
                print("Generated image URL:", imageURL)
                if let url = URL(string: imageURL) {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async { /// execute on main thread
                            EZLoadingActivity.hide(true,animated: true)
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                    
                    task.resume()
                }
                // Handle the generated image URL as desired
            case .failure(let error):
                print("Error:", error)
                DispatchQueue.main.async {
                    EZLoadingActivity.hide(false,animated: true)
                }
                // Handle the error appropriately
            }
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

