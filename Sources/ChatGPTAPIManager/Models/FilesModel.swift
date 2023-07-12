//
//  File.swift
//  
//
//  Created by Ghulam Abbas on 11/07/2023.
//

import Foundation

public struct FilesModel: Codable {

    public let data: [FileModel]
    public let object: String
}

public struct FileModel: Codable {
    public let id: String
    public let object: String
    public let bytes: Int
    public let created_at: Int
    public let filename: String
    public let purpose: String
}
