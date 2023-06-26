//
//  File.swift
//  
//
//  Created by Ghullam Abbas on 26/06/2023.
//

import Foundation
class AudioParser: APIResponseParcer {
    
    /// Parse the response data for generating an image.
    /// - Parameter data: The response data from the API.
    /// - Returns: The parsed image URL.
    /// - Throws: An error if the response cannot be parsed.
    func parseResponse(data: Data,completion: @escaping(Result<String,Error>)->Void) {
        do {
            
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let transcription = responseJSON?["text"] as? String {
                debugPrint(transcription)
                completion(.success(transcription))
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
