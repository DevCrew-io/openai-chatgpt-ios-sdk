//
//  ViewController.swift
//  Example
//
//  Created by Ghullam Abbas on 13/06/2023.
//

import UIKit

class ViewController: UIViewController {
    let chatGPTAPI = ChatGPTAPIManager(apiKey: "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")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.generateImageWithText()
    }
    
    func sendQueryToChatGPT()  {
        
          chatGPTAPI.sendRequest(prompt: "hello, how are you?",model: .gpt_3_5_turbo,endPoint: APPURL.Chat) { result in
            switch result {
            case .success(let response):
                print("API response: \(response)")
                // Handle the response as needed
                
            case .failure(let error):
                print("API error: \(error.localizedDescription)")
                // Handle the error gracefully
            }
        }
    }
    func generateImageWithText()  {
         chatGPTAPI.generateImage(prompt: "Generate an image of a cat", model: .gpt_3_5_turbo, imageSize: .five_twelve,endPoint: APPURL.GenerateImage) { result in
            switch result {
            case .success(let imageURL):
                print("Generated image URL:", imageURL)
                // Handle the generated image URL as desired
            case .failure(let error):
                print("Error:", error)
                // Handle the error appropriately
            }
        }
    }
}

