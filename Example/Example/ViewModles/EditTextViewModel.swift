//
//  EditTextViewModel.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import Foundation
import OpenAIAPIManager

class EditTextViewModelViewModel {
    
    var onSuccess:(()-> Void)? = nil
    var onFailure:(()-> Void)? = nil
    var ouPutText = ""
    

    func editText(inputText: String,instructionText: String) {
        
        
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        OpenAIAPIManager.shared.createEditsRequest(input: inputText,instruction: instructionText) { result in
            switch result {
            case .success(let response):
                print("API response: \(response)")
                // Handle the response as needed
                
                DispatchQueue.main.async {
                    if (response.count > 0) {
                        self.ouPutText = response[0]
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
