//
//  ModelsListModel.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
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
