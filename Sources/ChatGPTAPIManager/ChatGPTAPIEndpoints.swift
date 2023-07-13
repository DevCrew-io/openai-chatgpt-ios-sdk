//
//  ChatGPTAPIEndpoints.swift
//  
//
//  Created by Najam us Saqib on 7/5/23.
//

import Foundation

// MARK: - API Enum
/// Enum defining the base URL for an API.
enum ChatGPTAPIEndpoint {
    enum Domains {
        static let dev = "https://api.openai.com"
        static let production = "https://api.openai.com"
        static let qa = "https://api.openai.com"
    }
    
    enum Routes {
        static let api = "/v1"
    }
    
    private static let domain = Domains.dev
    private static let route = Routes.api
    private static let baseURL = domain + route
    
    // MARK: Base URLs
    case completion
    case chat
    case textEdit
    case generateImage
    case imageEdits
    case imageVariations
    case translations
    case transcriptions
    case modelsList
    case retrievedModel(String)
    case moderations
    case embeddings
    case files
    case deleteFile(String)
    case retrieveFile(String)
    case retrieveFileContent(String)
    case fineTunes
    case retrieveFineTune(String)
    case cancelFineTune(String)
    case listFineTuneEvents(String)
    case deleteFineTuneModel(String)

}

extension ChatGPTAPIEndpoint {
    
    var method: String {
        switch self {
        case .completion, .chat, .generateImage, .imageEdits, .imageVariations, .translations, .transcriptions, .moderations, .textEdit, .embeddings, .fineTunes, .cancelFineTune:
            return "POST"
        
        case .modelsList, .retrievedModel, .files, .retrieveFile, .retrieveFileContent, .retrieveFineTune, .listFineTuneEvents:
            return "GET"
        case.deleteFile, .deleteFineTuneModel:
            return "DELETE"

        }
    }
    
    var url: URL {
        switch self {
        case.completion:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/completions")!
        case .chat:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/chat/completions")!
        case .textEdit:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/edits")!
        case .generateImage:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/images/generations")!
        case.imageEdits:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/images/edits")!
        case.imageVariations:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/images/variations")!
        case.transcriptions:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/audio/transcriptions")!
        case.translations:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/audio/translations")!
        case.modelsList:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/models")!
        case.retrievedModel(let modelName):
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/models/\(modelName)")!
        case .moderations:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/moderations")!
        case .embeddings:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/embeddings")!
        case.files:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/files")!
        case.deleteFile(let fileID):
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/files/\(fileID)")!
        case.retrieveFile(let fileID):
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/files/\(fileID)")!
        case.retrieveFileContent(let fileID):
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/files/\(fileID)/content")!
        case.fineTunes:
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/fine-tunes")!
        case.retrieveFineTune(let id):
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/fine-tunes/\(id)")!
        case.cancelFineTune(let id):
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/fine-tunes/\(id)/cancel")!
        case.listFineTuneEvents(let id):
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/fine-tunes/\(id)/events")!
        case.deleteFineTuneModel(let model):
            return URL(string: ChatGPTAPIEndpoint.baseURL + "/models-tunes/\(model)")!

        }
    }
}
