//
//  File.swift
//  
//
//  Created by Ghullam Abbas on 07/07/2023.
//

import Foundation

public struct EmbeddingModel: Codable, Equatable {

    public struct Embedding: Codable, Equatable {
        public let object: String
        public let embedding: [Double]
        public let index: Int
    }
    
    public struct Usage: Codable, Equatable {
        public let promptTokens: Int
        public let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case totalTokens = "total_tokens"
        }
    }
    
    public let data: [Embedding]
    public let model: String
    public let usage: Usage
}
