//
//  File.swift
//  
//
//  Created by Ghulam Abbas on 12/07/2023.
//

import Foundation

public struct FineTuneModel: Codable {
    public let id: String
    public let object: String
    public let model: String
    public let created_at: Int
    public let events: [FineTuneEventeModel]?
    public let fine_tuned_model: String
    public let hyperparams: HyperParamsModel?
    public let organization_id: String
    public let result_files: [ValidationFilesModel]?
    public let status: String
    public let validation_files: [ValidationFilesModel]?
    public let training_files: [ValidationFilesModel]?
    public let updated_at: Int
}
public struct FineTuneEventeModel: Codable {
    public let message: String
    public let object: String
    public let level: String
    public let created_at: Int
}

public struct HyperParamsModel: Codable {
    public let batch_size: Double
    public let learning_rate_multiplier: String
    public let n_epochs: Double
    public let prompt_loss_weight: Double
}

public struct ValidationFilesModel: Codable {
    public let id: String
    public let object: String
    public let bytes: Int
    public let created_at: Int
    public let filename: String
    public let purpose: String
}
public struct TrainingFilesModel: Codable {
    public let id: String
    public let object: String
    public let bytes: Int
    public let created_at: Int
    public let filename: String
    public let purpose: String
}

public struct FineTuneResponse: Codable {
    public let object: String
    public let data: [FineTuneModel]
}

public struct DeleteFineTuneResponse: Codable {
    public let id: String
    public let object: String
    public let deleted: Bool
}

public struct FineTuneEventsParser: Codable {
    public let object: String
    public let data: [FineTuneEventeModel]
}
