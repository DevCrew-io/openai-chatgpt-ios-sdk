//
//  EmbeddingViewModel.swift
//  Example
//
//  Created by Ghullam Abbas on 07/07/2023.
//

import Foundation
import OpenAIAPIManager

class EmbeddingViewModel {
    
    var onSuccess:(()-> Void)? = nil
    var onFailure:(()-> Void)? = nil
    var outPut: EmbeddingModel?
    
    func embeddingText(inputText: String) {
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        OpenAIAPIManager.shared.createEmbeddingsRequest(input: inputText) { result in
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
