//
//  MessageModel.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import Foundation

struct ChatMessage: Codable {
    let content: String
    let role: String
}

enum Role: String, Codable {
    case user = "user"
    case assistant = "assistant"
}
