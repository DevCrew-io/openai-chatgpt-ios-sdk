//
//  File.swift
//  
//
//  Created by Ghulam Abbas on 12/07/2023.
//

import Foundation

class FineTuneParser {
    
    func parseResponse(data: Data,completion: @escaping(Result<FineTuneModel,Error>)->Void) {
        do {
            
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            debugPrint(responseJSON ?? [])
            if let transcription = responseJSON?["data"] as? [[String:Any]] {
                //debugPrint(transcription)
                //completion(.success(transcription))
                do {
                    // Parse the JSON response into an array of type T
                    let models = try JSONDecoder().decode(FineTuneModel.self, from: data)
                    completion(.success(models))
                } catch {
                    // Error occurred during decoding, return failure in completion handler
                    completion(.failure(error))
                }
                
            } else {
                if let error = responseJSON?["error"] as? [String:Any],let message = error["message"]  as? String {
                    let error = NSError(domain: message, code: 401, userInfo: [ NSLocalizedDescriptionKey: message])
                    
                    completion(.failure(error))
                    return
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
            }
            
        } catch (let error) {
            completion(.failure(error))
        }
    }
}

class DeleteFineTuneParser {
    
    func parseResponse(data: Data,completion: @escaping(Result<DeleteFineTuneResponse,Error>)->Void) {
        do {
            
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            debugPrint(responseJSON ?? [])
            if let transcription = responseJSON?["data"] as? [[String:Any]] {
                //debugPrint(transcription)
                //completion(.success(transcription))
                do {
                    // Parse the JSON response into an array of type T
                    let models = try JSONDecoder().decode(DeleteFineTuneResponse.self, from: data)
                    completion(.success(models))
                } catch {
                    // Error occurred during decoding, return failure in completion handler
                    completion(.failure(error))
                }
                
            } else {
                if let error = responseJSON?["error"] as? [String:Any],let message = error["message"]  as? String {
                    let error = NSError(domain: message, code: 401, userInfo: [ NSLocalizedDescriptionKey: message])
                    
                    completion(.failure(error))
                    return
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
            }
            
        } catch (let error) {
            completion(.failure(error))
        }
    }
}
