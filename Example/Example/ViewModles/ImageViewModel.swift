//
//  ImageViewModel.swift
//  Example
//
//  Created by Ghullam Abbas on 22/06/2023.
//

import Foundation
import OpenAIAPIManager

class ImageGenerationViewModel {
    
    var onSuccess:(()-> Void)? = nil
    var onFailure:(()-> Void)? = nil
    var imageURLString: String?
    var base64String: String?
    
    func sendImageRequest(_ text: String ) {
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        OpenAIAPIManager.shared.generateImage(prompt: text) { result in
            switch result {
            case .success(let response):
                // Handle the response as needed
                
                DispatchQueue.main.async {
                    if response.count > 0 {
                        self.imageURLString = response[0]
//                        self.base64String = response[0]
                        self.onSuccess?()
                    }
                    
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
    func editImage(_ prompt: String,imageData: Data) {
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        OpenAIAPIManager.shared.createImageEditRequest(image: imageData, prompt: prompt, imageConversionFormat: .rgba) { result in
            switch result {
            case .success(let response):
                // Handle the response as needed
                
                DispatchQueue.main.async {
                    if response.count>0 {
                        self.imageURLString = response[0]
                        self.onSuccess?()
                    }
                    
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
    
    func imageVariations(imageData: Data) {
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        OpenAIAPIManager.shared.createImageVariationsRequest(image: imageData) { result in
            switch result {
            case .success(let response):
                // Handle the response as needed
                
                DispatchQueue.main.async {
                    if response.count>0 {
                        self.imageURLString = response[0]
                        self.onSuccess?()
                    }
                    
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
