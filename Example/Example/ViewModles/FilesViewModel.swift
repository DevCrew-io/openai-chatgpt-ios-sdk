//
//  FilesViewModel.swift
//  Example
//
//  Created by Ghulam Abbas on 11/07/2023.
//

import Foundation
import ChatGPTAPIManager


class FilesViewModel  {
    
    var model: FielsModel?
    
    func getFilesList(completion: @escaping (Result<Bool,Error>)-> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.getFilesList() { [weak self] result in
            
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
}
