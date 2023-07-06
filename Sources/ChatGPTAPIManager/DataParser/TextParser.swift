//
//  File.swift
//  
//
//  Created by Ghullam Abbas on 26/06/2023.
//

import Foundation
// MARK: - ChatGPT API Response Parser

/// A parser for ChatGPT API responses.
protocol APIResponseParcer {
    func parseResponse(data: Data, completion: @escaping(Result<String,Error>)->Void)
}

class TextCompletionResponseParser: APIResponseParcer {
    // Parsing logic for text completion API response...
    
    /// Parse the response data for generating text.
    /// - Parameter data: The response data from the API.
    /// - Returns: The parsed completion text.
    /// - Throws: An error if the response cannot be parsed.
    func parseResponse(data: Data,completion: @escaping(Result<String,Error>)->Void) {
        
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            guard let output = responseJSON?["choices"] as? [[String: Any]] else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            for item in output {
                guard let completionText = item["text"] as? String else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                completion(.success(completionText))
            }
            
        } catch (let error){
            completion(.failure(error))
        }
    }
}

