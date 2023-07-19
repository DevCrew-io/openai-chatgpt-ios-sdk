//
//  ImageGenerationResponseParser.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import Foundation

class ImageGenerationResponseParser {
    
    /// Parse the response data for generating an image.
    /// - Parameter data: The response data from the API.
    /// - Returns: The parsed image URL.
    /// - Throws: An error if the response cannot be parsed.
    func parseResponse(data: Data, completion: @escaping(Result<[String],Error>)->Void) {
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let output = responseJSON?["data"] as? [[String: Any]] else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            var urlTempArray = [String]()
            for item in output {
                if let imageUrl = item["url"] as? String {
                    urlTempArray.append(imageUrl)
                } else if let base64Image = item["b64_json"] as? String {
                    urlTempArray.append(base64Image)
                }
            }
            completion(.success(urlTempArray))
        } catch (let error) {
            completion(.failure(error))
        }
    }
}
