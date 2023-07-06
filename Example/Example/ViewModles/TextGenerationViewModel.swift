//
//  TextGenerationViewModel.swift
//  Example
//
//  Created by Ghullam Abbas on 22/06/2023.
//

import Foundation
import ChatGPTAPIManager

class TextGenerationViewModel: ChatViewModelProtocols {
    
    var onSuccess:(()-> Void)? = nil
    var onFailure:(()-> Void)? = nil
    var reloadTableView:(()-> Void)? = nil
    var chatMessages: [ChatMessage] = []
    
    
    var rows:Int {
        return self.chatMessages.count
    }
    
    func sendMessage(message: String ) {
        
        let userMessage = ChatMessage(content: message, role: Role.user.rawValue)
        chatMessages.append(userMessage)
        
        self.reloadTableView?()
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ChatGPTAPIManager.shared.sendTextRequest(prompt: message, model: .textDavinci003) { result in
            switch result {
            case .success(let response):
                print("API response: \(response)")
                // Handle the response as needed
                
                DispatchQueue.main.async {
                    let assistantMessage = ChatMessage(content: response, role: Role.assistant.rawValue)
                    self.chatMessages.append(assistantMessage)
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
