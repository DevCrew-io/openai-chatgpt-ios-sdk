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
    case completion
    case chat
    case generateImage
    
    var url: URL {
        switch self {
        case.completion:
            return URL(string: APPURL.baseURL + "/completions")!
        case .chat:
            return URL(string: APPURL.baseURL + "/chat/completions")!
        case .generateImage:
            return URL(string: APPURL.baseURL + "/images/generations")!
        }
    }
}
/// Private instance of JSONDecoder used for decoding JSON data.
private let jsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    return jsonDecoder
}()
/// Represents a chat message.
struct ChatMessage: Codable {
    let content: String
    let role: Role
}
/// Represents the role of a chat message sender.
enum Role: Codable {
    case user
    case assistant
}
/// Extension on Array to provide additional functionality related to ChatMessage.
extension Array where Element == ChatMessage {
    
    var contentCount: Int { reduce(0, { $0 + $1.content.count })}
}

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
// MARK: - ChatGPTModels Enum

/// Enum representing different ChatGPT models.
public enum ChatGPTModels: String {
    case gptThreePointFiveTurbo = "gpt-3.5-turbo"
    case engine =  "davinci"
    
    // Completions
    
    /// Can do any language task with better quality, longer output, and consistent instruction-following than the curie, babbage, or ada models. Also supports inserting completions within text.
    case  textDavinci003 = "text-davinci-003"
    /// Similar capabilities to text-davinci-003 but trained with supervised fine-tuning instead of reinforcement learning.
    case  textDavinci002 = "text-davinci-002"
    /// Very capable, faster and lower cost than Davinci.
    case  textCurie = "text-curie-001"
    /// Capable of straightforward tasks, very fast, and lower cost.
    case  textBabbage = "text-babbage-001"
    /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
    case  textAda = "text-ada-001"
    
    // Edits
    
    case  textDavinci001 = "text-davinci-001"
    case  codeDavinciEdit001 = "code-davinci-edit-001"
    
    // Transcriptions / Translations
    
    case  whisper1 = "whisper-1"
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
    
    public static let shared = ChatGPTAPIManager()
    
    private let systemMessage = NSMutableDictionary()
    private var historyList = [NSDictionary]()
    public  var apiKey: String = ""
    
    
    /// Initializes the ChatGPTAPIManager.
    
    private init() {
        self.systemMessage.setValue("assistant", forKey: "role")
        self.systemMessage.setValue("You are a helpful assistant.", forKey: "content")
    }
    
    // MARK: - Public Functions
    
    /// Sends a chat request to the ChatGPT API.
    ///
    /// - Parameters:
    ///   - prompt: The input prompt for the chat request.
    ///   - model: The ChatGPT model to use for generating the response.
    ///   - maxTokens: The maximum number of tokens in the generated response. Defaults to 500.
    ///   - endPoint: The API endpoint to send the request to.
    ///   - completion: A closure to be called with the result of the request. The result is either a success containing the generated response string or a failure containing an error.
    
    
    public func sendChatRequest(prompt: String, model: ChatGPTModels,maxTokens:Int = 500,endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        self.chatRequest(prompt: prompt, model: model, maxTokens: maxTokens, endPoint: endPoint) { result in
            switch result {
                
            case .success(let successString):
                completion(.success(successString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /// Sends a request to generate text based on the provided prompt using the generateText function.
    ///
    /// - Parameters:
    ///   - prompt: The prompt to generate text from.
    ///   - model: The ChatGPT model to use for text generation.
    ///   - maxTokens: The maximum number of tokens in the generated text. Defaults to 500.
    ///   - n: The number of text samples to generate. Defaults to 1.
    ///   - endPoint: The endpoint URL for the API request.
    ///   - completion: A completion block that is called with the result of the request. The block receives a Result object containing either the generated text as a String in case of success, or an Error in case of failure.
    
    public func sendTextRequest(prompt: String, model: ChatGPTModels,maxTokens:Int = 500,n: Int = 1, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        self.sendTextCompletionRequest(prompt: prompt, model: model, maxTokens: maxTokens,n: n,endPoint: endPoint) { result in
            switch result {
                
            case .success(let successString):
                completion(.success(successString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Generates an image based on the prompt.
    ///
    /// - Parameters:
    ///   - prompt: The prompt for image generation.
    ///   - model: The ChatGPT model to use for image generation.
    ///   - imageSize: The desired size of the generated image.
    ///   - n: The number of images to generate (default is 1).
    ///   - endPoint: The endpoint URL for the API request.
    ///   - completion: The completion block called with the result of the request. The block receives a Result object containing either the generated image as a String in case of success, or an Error in case of failure.
    
    public func generateImage(prompt: String, model: ChatGPTModels,imageSize: ChatGPTImageSize,n: Int = 1, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        self.generateImageFromText(prompt: prompt, model: model, imageSize: imageSize, endPoint: endPoint, n: n) { result in
            switch result {
            case .success(let successString):
                completion(.success(successString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Requests audio transcription based on the provided parameters.
    ///
    /// - Parameters:
    ///   - fileUrl: The URL of the audio file to be transcribed.
    ///   - prompt: The prompt or context for the transcription.
    ///   - temperature: (Optional) The temperature value for generating diverse transcriptions. Defaults to nil.
    ///   - language: (Optional) The language of the transcription. Defaults to nil.
    ///   - model: (Optional) The model to be used for transcription. Defaults to ChatGPTModels.
    ///   - endPoint: The URL endpoint for the transcription service.
    ///   - completion: A completion handler to be called with the result of the transcription request.
    ///                 The handler takes a Result object, which contains either the transcribed text or an error.
    ///                 Use the `.success` case to access the transcribed text and the `.failure` case to handle errors.
    public func audioTranscriptionRequest(fileUrl: URL, prompt: String, temperature: Double? = nil, language: String? = nil, model: ChatGPTModels, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void) {
        
        self.audioTranscription(fileUrl: fileUrl, prompt: prompt,temperature: temperature,language: language, model: model, endPoint: endPoint, completion: { result in
            
            switch result {
            case.success(let success):
                completion(.success(success))
            case.failure(let error):
                completion(.failure(error))
            }
            
        })
        
    }
    /// Requests audio translation based on the provided parameters.
    ///
    /// - Parameters:
    ///   - fileUrl: The URL of the audio file to be translated.
    ///   - prompt: (Optional) The prompt or context for the translation. Defaults to nil.
    ///   - temperature: (Optional) The temperature value for generating diverse translations. Defaults to nil.
    ///   - model: The ChatGPT model to use for translation.
    ///   - endPoint: The endpoint URL for the API request.
    ///   - completion: The completion block called with the result of the request. The block receives a Result object containing either the translated text as a String in case of success, or an Error in case of failure.
    public func audioTranslationRequest(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, model: ChatGPTModels, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void) {
        // Implementation of audio translation request goes here
        self.audioTranslation(fileUrl: fileUrl,prompt: prompt,temperature: temperature, model: model, endPoint: endPoint, completion: { result in
            
            switch result {
            case.success(let success):
                completion(.success(success))
            case.failure(let error):
                completion(.failure(error))
            }
            
        })
    }
    
    // MARK: - Private Functions
    
    private func chatRequest(prompt: String, model: ChatGPTModels,maxTokens:Int ,endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        
        let messages = generateMessages(from: prompt)
        
        let parameters: [String: Any] = [
            "messages":messages
            ,
            "max_tokens": maxTokens,
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
                        self.appendToHistoryList(userText: prompt, responseText: succesString)
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
    
    private func sendTextCompletionRequest(prompt: String, model: ChatGPTModels,maxTokens:Int,n: Int, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "max_tokens": maxTokens,
            "model":model.rawValue,
            "n": n
        ]
        
        guard let request = self.createUrlRequest(params: parameters, endPoint: endPoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        self.performDataTask(with: request) { result in
            
            switch result {
            case.success(let data):
                let parser = TextCompletionResponseParser()
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
    
    
    private func generateImageFromText(prompt: String, model: ChatGPTModels,imageSize: ChatGPTImageSize, endPoint: APPURL,n: Int, completion: @escaping (Result<String, Error>) -> Void)  {
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": n,
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
    private func audioTranscription(fileUrl: URL, prompt: String, temperature: Double? = nil, language: String? = nil, model: ChatGPTModels, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void) {
        
        // Define the key-value pairs
        let parameters: [String: Any] = [
            "model": model.rawValue,
            "prompt": prompt,
            "temperature": temperature ?? 0.8,
            "language": language ?? "en"
        ]
        guard let request = self.createMultiPartUrlRequest(audioURL: fileUrl, params: parameters, endPoint: endPoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        self.performDataTask(with: request) { result in
            
            switch result {
            case.success(let data):
                let parser = AudioParser()
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
    private func audioTranslation(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, model: ChatGPTModels, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void) {
        // Define the key-value pairs
        let parameters: [String: Any] = [
            "model": model.rawValue,
            "prompt": prompt ?? "",
            "temperature": temperature ?? 0.8,
        ]
        guard let request = self.createMultiPartUrlRequest(audioURL: fileUrl, params: parameters, endPoint: endPoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        self.performDataTask(with: request) { result in
            
            switch result {
            case.success(let data):
                let parser = AudioParser()
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
    private func createMultiPartUrlRequest(audioURL:URL, params: [String: Any], endPoint: APPURL)-> URLRequest? {
        
        var request = URLRequest(url: endPoint.url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the multipart form data
        let boundary = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // Create the body of the request
        let requestBody = NSMutableData()
        
        
        // Append the parameters
        for (key, value) in params {
            requestBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            requestBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            requestBody.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Append the audio file
        
        let audioFilename = audioURL.lastPathComponent
        let audioData: Data
        do {
            audioData = try Data(contentsOf: audioURL)
        } catch {
            return nil
        }
        
        requestBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        requestBody.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(audioFilename)\"\r\n".data(using: .utf8)!)
        requestBody.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        requestBody.append(audioData)
        requestBody.append("\r\n".data(using: .utf8)!)
        
        requestBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Set the request body
        request.httpBody = requestBody as Data
        
        return request
    }
    private func generateMessages(from text: String) -> [NSDictionary] {
        let userMessage = NSMutableDictionary()
        userMessage.setValue("user", forKey: "role")
        userMessage.setValue(text, forKey: "content")
        var messages = [systemMessage] + historyList + [userMessage]
        if messages.count > 150 {
            _ = historyList.removeLast()
            messages = generateMessages(from: text)
        }
        return messages
    }
    
    private func appendToHistoryList(userText: String, responseText: String) {
        let userMessage = NSMutableDictionary()
        userMessage.setValue("user", forKey: "role")
        userMessage.setValue(userText, forKey: "content")
        let assistantMessage = NSMutableDictionary()
        assistantMessage.setValue("assistant", forKey: "role")
        assistantMessage.setValue(responseText, forKey: "content")
        self.historyList.append(userMessage)
        self.historyList.append(assistantMessage)
    }
}

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

class ChatCompletionResponseParser: APIResponseParcer {
    
    /// Parse the response data for generating text.
    /// - Parameter data: The response data from the API.
    /// - Returns: The parsed completion text.
    /// - Throws: An error if the response cannot be parsed.
    func parseResponse(data: Data,completion: @escaping(Result<String,Error>)->Void) {
        
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
            for item in output {
                guard let completionText = item["message"] as? [String: Any] ,let content = completionText["content"] as? String else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                completion(.success(content))
            }
            
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
