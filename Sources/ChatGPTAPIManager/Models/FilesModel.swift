//
//  File.swift
//  
//
//  Created by Ghulam Abbas on 11/07/2023.
//

import Foundation

public struct FielsModel: Codable {
    public struct FileModel: Codable {
        public let id: String
        public let object: String
        public let bytes: String
        public let created_at: String
        public let filename: String
        public let purpose: String
    }
    
    public let data: [FileModel]
    public let object: String
}
