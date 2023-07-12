//
//  FilesViewModel.swift
//  Example
//
//  Created by Ghulam Abbas on 11/07/2023.
//

import Foundation
import ChatGPTAPIManager


class FilesViewModel  {
    
    var model: FileModel?
    var models: FilesModel?
    var fileID: String?
    
    func getFilesList(completion: @escaping (Result<Bool,Error>)-> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.getFilesList() { [weak self] result in
            
            switch result {
            case .success(let model):
                // Handle the models list
                EZLoadingActivity.hide(true, animated: true)
                self?.models = model
                completion(.success(true))
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
                EZLoadingActivity.hide(false, animated: true)
                completion(.failure(error))
            }
        }
    }
    
    func uploadFile(fileURL: URL, purpose: String, completion: @escaping (Result<Bool,Error>)-> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.fileRequest(fileUrl: fileURL, purpose: purpose) { [weak self] result in
            
            switch result {
            case .success(let model):
                // Handle the models list
                EZLoadingActivity.hide(true, animated: true)
                self?.model = model
                self?.fileID = model.id
                completion(.success(true))
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
                EZLoadingActivity.hide(false, animated: true)
                completion(.failure(error))
            }
        }
    }
    func retrievedFile(fileID: String, completion: @escaping (Result<Bool,Error>)-> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.retrieveFile(fileID: fileID) { [weak self] result in
            
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
    func retrievedFileContent(fileID: String, completion: @escaping (Result<Bool,Error>)-> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.retrieveFileContent(fileID: fileID) { [weak self] result in
            
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8))
                EZLoadingActivity.hide(true, animated: true)
              //  self?.model = model
                completion(.success(true))
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
                EZLoadingActivity.hide(false, animated: true)
                completion(.failure(error))
            }
        }
    }
    func deleteFile(fileID: String, completion: @escaping (Result<Bool,Error>)-> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.deleteFile(fileID: fileID) { [weak self] result in
            
            switch result {
            case .success(let model):
                // Handle the models list
                EZLoadingActivity.hide(true, animated: true)
              //  self?.model = model
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
