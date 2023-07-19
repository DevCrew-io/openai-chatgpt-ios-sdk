//
//  ModerationsViewModel.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import Foundation
import OpenAIAPIManager

class ModerationsViewModel {
    
    var onSuccess:(()-> Void)? = nil
    var onFailure:(()-> Void)? = nil
    var outPut: ModerationsModel?
    
    func moderationText(inputText: String) {
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        OpenAIAPIManager.shared.moderationsRequest(input: inputText) { result in
            switch result {
            case .success(let response):
                print("API response: \(response)")
                // Handle the response as needed
                
                DispatchQueue.main.async {
                    
                        self.outPut = response
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
