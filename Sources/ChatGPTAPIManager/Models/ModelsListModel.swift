//
//  ModelsListModel.swift
//  Example
//
//  Created by Ghullam Abbas on 04/07/2023.
//

import Foundation

public struct ChatGPTModel: Codable, Equatable {
    public let id: String
    public let object: String
    public let owned_by: String
}

public struct ChatGPTModelList: Codable, Equatable {
    public let data: [ChatGPTModel]
    public let object: String
}
