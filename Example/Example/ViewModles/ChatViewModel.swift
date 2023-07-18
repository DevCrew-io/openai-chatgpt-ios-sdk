//
//  ChatViewModel.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import Foundation
import OpenAIAPIManager

protocol ChatViewModelProtocols {
    func sendMessage(message: String )
    var onSuccess:(()-> Void)? { get set }
    var onFailure:(()-> Void)? { get set }
    var reloadTableView:(()-> Void)? { get set }
    var chatMessages: [ChatMessage] { get set }
}

class ChatViewModel: ChatViewModelProtocols {
    
    var onSuccess:(()-> Void)? = nil
    var onFailure:(()-> Void)? = nil
    var reloadTableView:(()-> Void)? = nil
    var chatMessages: [ChatMessage] = []
    
    func sendMessage(message: String ) {
        
        let userMessage = ChatMessage(content: message, role: Role.user.rawValue)
        chatMessages.append(userMessage)
        
        self.reloadTableView?()
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        OpenAIAPIManager.shared.sendChatRequest(prompt: message, model: .gptThreePointFiveTurbo) { result in
            switch result {
            case .success(let response):
                print("API response: \(response)")
                // Handle the response as needed
                
                DispatchQueue.main.async {
                    if response.count > 0 {
                        let assistantMessage = ChatMessage(content: response[0], role: Role.assistant.rawValue)
                        self.chatMessages.append(assistantMessage)
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
