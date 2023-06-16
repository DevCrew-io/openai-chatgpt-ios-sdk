//
//  ChatViewController.swift
//  Example
//
//  Created by Ghullam Abbas on 16/06/2023.
//

import UIKit
import ChatGPTAPIManager
class ChatViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var messageTextField: UITextField!
    
    // MARK: - Variables
    
    let chatGPTAPI = ChatGPTAPIManager(apiKey: "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")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Set up chatTextView appearance
        chatTextView.layer.borderWidth = 1.0
        chatTextView.layer.borderColor = UIColor.lightGray.cgColor
        chatTextView.layer.cornerRadius = 8.0
        chatTextView.text = ""
        

    }
   

    // MARK: - IBAction
    @IBAction func sendMessage(_ sender: UIButton) {
        if let message = messageTextField.text, !message.isEmpty {
            appendMessageToChat(message, sender: "User")
            messageTextField.text = ""
            
            // Send user message to ChatGPT
            self.messageTextField.resignFirstResponder()
            sendMessageToChatGPT(message)
        }
    }
    // MARK: - Helper Functions
    func appendMessageToChat(_ message: String, sender: String) {
        let formattedMessage = "\(sender): \(message)\n"
        DispatchQueue.main.async {
            
            self.chatTextView.text += formattedMessage
            self.chatTextView.scrollRangeToVisible(NSMakeRange(self.chatTextView.text.count - 1, 1))
        }
        
    }
    // MARK: - NetworkCall
    func sendMessageToChatGPT(_ message: String) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        chatGPTAPI.sendRequest(prompt: message,model: .gptThreePointFiveTurbo,endPoint: .chat) { result in
            switch result {
            case .success(let response):
                print("API response: \(response)")
                // Handle the response as needed
                DispatchQueue.main.async {
                    EZLoadingActivity.hide(true,animated: true)
                }
                self.appendMessageToChat(response, sender: "ChatGPT")
                
            case .failure(let error):
                print("API error: \(error.localizedDescription)")
                // Handle the error gracefully
                DispatchQueue.main.async {
                    EZLoadingActivity.hide(false,animated: true)
                }
                self.appendMessageToChat("Error: \(error)", sender: "ChatGPT")
            }
        }
        
    }
    
    
}
