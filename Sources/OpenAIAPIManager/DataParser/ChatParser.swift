//
//  File.swift
//  
//
//  Created by Ghullam Abbas on 26/06/2023.
//

import Foundation
class ChatCompletionResponseParser {
    
    /// Parse the response data for generating text.
    /// - Parameter data: The response data from the API.
    /// - Returns: The parsed completion text.
    /// - Throws: An error if the response cannot be parsed.
    func parseResponse(data: Data,completion: @escaping(Result<[String],Error>)->Void) {
        
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            guard let output = responseJSON?["choices"] as? [[String: Any]] else {
                
                if let error = responseJSON?["error"] as? [String:Any],let message = error["message"]  as? String {
                    let error = NSError(domain: message, code: 401, userInfo: [ NSLocalizedDescriptionKey: message])
                    
                    completion(.failure(error))
                    return
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
            }
            var tempArray = [String]()
            for item in output {
                guard let completionText = item["message"] as? [String: Any] ,let content = completionText["content"] as? String else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                tempArray.append(content)
                
            }
            completion(.success(tempArray))
        } catch (let error){
            completion(.failure(error))
        }
    }
}


