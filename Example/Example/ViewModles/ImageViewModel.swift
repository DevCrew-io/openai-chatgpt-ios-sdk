//
//  ImageViewModel.swift
//  Example
//
//  Created by Ghullam Abbas on 22/06/2023.
//

import Foundation
import ChatGPTAPIManager

class ImageGenerationViewModel {
    
     var onSuccess:(()-> Void)? = nil
     var onFailure:(()-> Void)? = nil
     var imageURLString: String?
    
    let chatGPTAPI = ChatGPTAPIManager(apiKey: "xxxxx")
   
    
    func sendImageRequest(_ text: String ) {
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        chatGPTAPI.generateImage(prompt: text,model: .gptThreePointFiveTurbo, imageSize: .fiveTwelve,endPoint: .generateImage) { result in
            switch result {
            case .success(let response):
                print("API response: \(response)")
                // Handle the response as needed
                
                DispatchQueue.main.async {
                    self.imageURLString = response
                    self.onSuccess?()
                }
                
            case .failure(let error):
                print("API error: \(error.localizedDescription)")
                // Handle the error gracefully
                DispatchQueue.main.async {
                    self.onFailure?()
                }
            }
        }
    }
}
