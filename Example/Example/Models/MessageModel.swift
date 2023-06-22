//
//  MessageModel.swift
//  Example
//
//  Created by Ghullam Abbas on 22/06/2023.
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
