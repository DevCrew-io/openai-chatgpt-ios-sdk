//
//  File.swift
//  
//
//  Created by Ghullam Abbas on 26/06/2023.
//

import Foundation

class ImageGenerationResponseParser: APIResponseParcer {
    
    /// Parse the response data for generating an image.
    /// - Parameter data: The response data from the API.
    /// - Returns: The parsed image URL.
    /// - Throws: An error if the response cannot be parsed.
    
    func parseResponse(data: Data,completion: @escaping(Result<String,Error>)->Void) {
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let output = responseJSON?["data"] as? [[String: Any]] else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            for item in output {
                guard let completionText = item["url"] as? String else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                completion(.success(completionText))
            }
        } catch (let error) {
            completion(.failure(error))
        }
    }
}
