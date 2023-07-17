//
//  NetworkError.swift
//  
//
//  Created by Najam us Saqib on 7/5/23.
//

import Foundation

// MARK: - NetworkError Enum
/// Enum representing possible network errors.
public enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case apiKeyNotFound
    case invalidApiKey(Error)
}

public extension NetworkError {
    var errorDescription: String? {
        switch self {
        case.apiKeyNotFound:
            return "Please check your api key is not set.Do set it in app delegate"
        case .invalidURL:
            return "Invalid url"
        case .requestFailed(_):
            return "Request failed"
        case .invalidResponse:
            return "Invalid api response"
        default:
            return nil
        }
    }
}
