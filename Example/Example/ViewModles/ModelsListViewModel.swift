//
//  ModelsListViewModel.swift
//  Example
//
//  Created by Ghullam Abbas on 04/07/2023.
//

import Foundation
import ChatGPTAPIManager

protocol ModelsListProtocol {
    func getModelsList(completion: @escaping (Result<Bool, Error>) -> Void)
    func retrieveModel(modelName: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class ModelsListViewModel: ModelsListProtocol {
    
    var modelsArray = [ChatGPTModel]()
    var model: ChatGPTModel?
    
    func retrieveModel(modelName: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.retrieveAIModel(model: modelName) { [weak self] result in
            
            switch result {
            case .success(let model):
                // Handle the models list
                EZLoadingActivity.hide(true, animated: true)
                self?.model = model
                completion(.success(true))
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
                EZLoadingActivity.hide(false, animated: true)
                completion(.failure(error))
            }
        }
    }
    
    func getModelsList(completion: @escaping (Result<Bool, Error>) -> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.getOpenAIModels { [weak self] result in
            
            switch result {
            case .success(let models):
                // Handle the models list
                EZLoadingActivity.hide(true, animated: true)
                self?.modelsArray = models.data ?? []
                completion(.success(true))
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
                EZLoadingActivity.hide(false, animated: true)
                completion(.failure(error))
            }
        }
    }
}
