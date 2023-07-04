//
//  ModelsListModel.swift
//  Example
//
//  Created by Ghullam Abbas on 04/07/2023.
//

import Foundation

struct ChatGPTModel: Decodable {
    let id: String
    let object: String
    let owned_by: String
}
struct RootModel: Decodable {
    let data: [ChatGPTModel]
    let object: String
}
