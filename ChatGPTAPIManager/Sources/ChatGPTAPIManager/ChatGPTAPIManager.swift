import Foundation

// MARK: - API Enum

/// Enum defining the base URL for an API.

public enum APPURL {
    enum Domains {
        static let dev = "https://api.openai.com"
        static let production = "https://api.openai.com"
        static let qa = "https://api.openai.com"
    }
    
    enum Routes {
        static let api = "/v1"
    }
    
    private static let domain = Domains.dev
    private static let route = Routes.api
    private static let baseURL = domain + route
    
    // MARK: Base URLs
    case chat
    case generateImage
    
    var url: URL {
        switch self {
        case .chat:
            return URL(string: APPURL.baseURL + "/chat/completions")!
        case .generateImage:
            return URL(string: APPURL.baseURL + "/images/generations")!
        }
    }
}


// MARK: - NetworkError Enum

/// Enum representing possible network errors.
public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
}

// MARK: - ChatGPTModels Enum

/// Enum representing different ChatGPT models.
public enum ChatGPTModels: String {
    case gptThreePointFiveTurbo = "gpt-3.5-turbo"
    case engine =  "davinci"
}
/// Enum representing different  ImageSizes supported by imagegeneration API.
public enum ChatGPTImageSize : String {
    
    case fiveTwelve = "512x512"
    case tenTwenty = "1024x1024"
}

//
// MARK: - ChatGPT API Class

/// A class responsible for making API requests to ChatGPT.
final public class ChatGPTAPIManager {
    
    private let apiKey: String
    //    private let responseParser: ChatGPTAPIResponseParser
    
    /// Initializes the ChatGPTAPIManager.
    /// - Parameters:
    ///   - apiKey: The API key to authenticate the requests.
   public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /// Sends a request to generate text based on the prompt.
    /// - Parameters:
    ///   - prompt: The prompt to generate text from.
    ///   - model: The ChatGPT model to use for text generation.
    ///   - endPoint: The endpoint URL for the API request.
    ///   - completion: The completion block called with the result of the request.
    public func sendRequest(prompt: String, model: ChatGPTModels, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        self.sendChatRequest(prompt: prompt, model: model, endPoint: endPoint) { result in
            switch result {
            case .success(let successString):
                completion(.success(successString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Generates an image based on the prompt.
    /// - Parameters:
    ///   - prompt: The prompt for image generation.
    ///   - model: The ChatGPT model to use for image generation.
    ///   - imageSize: The desired size of the generated image.
    ///   - endPoint: The endpoint URL for the API request.
    ///   - completion: The completion block called with the result of the request.
    public func generateImage(prompt: String, model: ChatGPTModels,imageSize: ChatGPTImageSize, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        self.generateImageFromText(prompt: prompt, model: model, imageSize: imageSize, endPoint: endPoint) { result in
            switch result {
            case .success(let successString):
                completion(.success(successString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func sendChatRequest(prompt: String, model: ChatGPTModels, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        let parameters: [String: Any] = [
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 50,
            "model": model.rawValue
        ]
        
        guard let request = self.createUrlRequest(params: parameters, endPoint: endPoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        self.performDataTask(with: request) { result in
            
            switch result {
            case.success(let data):
                let parser = ChatCompletionResponseParser()
                parser.parseResponse(data: data, completion: { result in
                    
                    switch result {
                    case.success(let succesString):
                        completion(.success(succesString))
                        
                    case.failure(let error):
                        completion(.failure(error))
                    }
                })
            case.failure(let error):
                completion(.failure(error))
            }
        }
        
        
    }
    
    private func performDataTask(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    
    private func generateImageFromText(prompt: String, model: ChatGPTModels,imageSize: ChatGPTImageSize, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": 1,
            "size": imageSize.rawValue,
            "user": ""
        ]
        
        guard let request = self.createUrlRequest(params: parameters, endPoint: endPoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        
        
        self.performDataTask(with: request, completion: { result in
            
            switch result {
            case.success(let data):
                let parser = ImageGenerationResponseParser()
                parser.parseResponse(data: data, completion: { result in
                    
                    switch result {
                    case.success(let succesString):
                        completion(.success(succesString))
                        
                    case.failure(let error):
                        completion(.failure(error))
                    }
                })
            case.failure(let error):
                completion(.failure(error))
            }
            
        })
    }
    
    private func createUrlRequest(params: [String: Any], endPoint: APPURL) -> URLRequest? {
        var request = URLRequest(url: endPoint.url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            return nil
        }
        
        return request
    }
}

// MARK: - ChatGPT API Response Parser

/// A parser for ChatGPT API responses.

protocol APIResponseParcer {
    func parseResponse(data: Data, completion: @escaping(Result<String,Error>)->Void)
}
class ChatCompletionResponseParser: APIResponseParcer {
    
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
            
            debugPrint(output)
            
            guard let completionText = output.first?["message"] as? [String: Any],
                  let content = completionText["content"] as? String else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            completion(.success(content))
        } catch (let error){
            completion(.failure(error))
        }
    }
}
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
            
            debugPrint(output)
            
            guard let completionText = output.first?["url"] as? String else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            completion(.success(completionText))
        } catch (let error) {
            completion(.failure(error))
        }
    }
}
