//
//  ModerationsModel.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//
import Foundation

public struct ModerationsModel: Codable, Equatable {
    
    public struct ModerationsResult: Codable, Equatable {
        
        public struct Categories: Codable, Equatable {
            public let hate: Bool
            public let hateThreatening: Bool
            public let selfHarm: Bool
            public let sexual: Bool
            public let sexualMinors: Bool
            public let violence: Bool
            public let violenceGraphic: Bool
            
            enum CodingKeys: String, CodingKey {
                case hate
                case hateThreatening = "hate/threatening"
                case selfHarm = "self-harm"
                case sexual
                case sexualMinors = "sexual/minors"
                case violence
                case violenceGraphic = "violence/graphic"
            }
        }
        
        public struct CategoryScores: Codable, Equatable {
            public let hate: Double
            public let hateThreatening: Double
            public let selfHarm: Double
            public let sexual: Double
            public let sexualMinors: Double
            public let violence: Double
            public let violenceGraphic: Double
            
            enum CodingKeys: String, CodingKey {
                case hate
                case hateThreatening = "hate/threatening"
                case selfHarm = "self-harm"
                case sexual
                case sexualMinors = "sexual/minors"
                case violence
                case violenceGraphic = "violence/graphic"
            }
        }
        
        public let flagged: Bool
        public let categories: Categories
        public let categoryScores: CategoryScores
        
        enum CodingKeys: String, CodingKey {
            case categories
            case categoryScores = "category_scores"
            case flagged
        }
    }
    
    public let id: String
    public let model: String
    public let results: [ModerationsResult]
}
