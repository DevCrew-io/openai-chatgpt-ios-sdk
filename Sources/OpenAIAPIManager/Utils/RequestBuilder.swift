//
//  RequestBuilder.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import Foundation

protocol RequestBuilder {
    func buildRequest(params: [String: Any]?, endPoint: OpenAIAPIEndpoints?, apiKey: String) -> URLRequest?
}

struct DefaultRequestBuilder: RequestBuilder {
    func buildRequest(params: [String: Any]?, endPoint: OpenAIAPIEndpoints?, apiKey: String) -> URLRequest? {
        guard let endPoint = endPoint else {
            return nil
        }
        
        var request = URLRequest(url: endPoint.url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let params = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params)
            } catch {
                return nil
            }
        }
        
        return request
    }
}

struct GetRequestBuilder: RequestBuilder {
    func buildRequest(params: [String: Any]?, endPoint: OpenAIAPIEndpoints?, apiKey: String) -> URLRequest? {
        guard let endPoint = endPoint else {
            return nil
        }
        
        var request = URLRequest(url: endPoint.url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

func createUrlRequest(requestBuilder: RequestBuilder, params: [String: Any]?, endPoint: OpenAIAPIEndpoints?, apiKey: String) -> URLRequest? {
    return requestBuilder.buildRequest(params: params, endPoint: endPoint, apiKey: apiKey)
}
