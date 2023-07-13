//
//  File.swift
//  
//
//  Created by Ghulam Abbas on 12/07/2023.
//

import Foundation

class FilesParser {
    
    func parseResponse<T: Decodable>(data: Data,completion: @escaping(Result<T,Error>)->Void) {
        do {
            
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            debugPrint(responseJSON ?? [])
            if let transcription = responseJSON?["data"] as? [[String:Any]] {
                //debugPrint(transcription)
                //completion(.success(transcription))
                do {
                    // Parse the JSON response into an array of type T
                    let models = try JSONDecoder().decode(T.self, from: data)
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

class FileParser {
    
    /// Parse the response data for generating an image.
    /// - Parameter data: The response data from the API.
    /// - Returns: The parsed image URL.
    /// - Throws: An error if the response cannot be parsed.
    func parseResponse(data: Data,completion: @escaping(Result<FileModel,Error>)->Void) {
        do {
            
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            debugPrint(responseJSON ?? [])
            if let status = responseJSON?["status"] as? String, status == "uploaded" || status == "processed" {
                //debugPrint(transcription)
                //completion(.success(transcription))
                do {
                    // Parse the JSON response into an array of type T
                    let models = try JSONDecoder().decode(FileModel.self, from: data)
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
