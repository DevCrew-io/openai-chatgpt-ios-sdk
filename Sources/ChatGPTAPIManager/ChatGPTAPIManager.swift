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
    case translations
    case transcriptions
    case modelsList
    case retrievedModel(String)
    
    var url: URL {
        switch self {
        case.completion:
            return URL(string: APPURL.baseURL + "/completions")!
        case .chat:
            return URL(string: APPURL.baseURL + "/chat/completions")!
        case .generateImage:
            return URL(string: APPURL.baseURL + "/images/generations")!
        case.transcriptions:
            return URL(string: APPURL.baseURL + "/audio/transcriptions")!
        case.translations:
            return URL(string: APPURL.baseURL + "/audio/translations")!
        case.modelsList:
            return URL(string: APPURL.baseURL + "/models")!
        case.retrievedModel(let modelName):
            return URL(string: APPURL.baseURL + "/models/\(modelName)")!
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
}

// MARK: - AudioGPTModels Enum
public enum AudioGPTModels: String {
    case whisper1 = "whisper-1"
}

/// Enum representing different  ImageSizes supported by imagegeneration API.
public enum ChatGPTImageSize : String {
    case fiveTwelve = "512x512"
    case tenTwentyFour = "1024x1024"
}

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
    
    /// Retrieves a list of OpenAI models from the API.
    ///
    /// - Parameters:
    ///   - completion: A completion handler that receives the result of the API request.
    ///                 The result will either contain an array of models of type `T` on success,
    ///                 or an error on failure.
    ///
    /// - Note: The `T` generic type should conform to `Decodable` to support JSON decoding.
    
    public func getOpenAIModels<T: Decodable>(endPoint: APPURL = .modelsList, completion: @escaping (Result<T, Error>) -> Void) {
        self.getModelsList(endPoint: endPoint, completion: completion)
    }
    
    
    /// Retrieves  OpenAI model from the API.
    ///
    /// - Parameters:
    ///   - completion: A completion handler that receives the result of the API request.
    ///                 The result will either contain  model of type `T` on success,
    ///                 or an error on failure.
    ///
    /// - Note: The `T` generic type should conform to `Decodable` to support JSON decoding.
    
    public func retrieveAIModel<T: Decodable>(endPoint: APPURL, completion: @escaping (Result<T, Error>) -> Void) {
        self.retrieveSingleModel(endPoint: endPoint, completion: completion)
    }
    
    /// Sends a chat request to the ChatGPT API.
    ///
    /// - Parameters:
    ///   - prompt: The input prompt for the chat request.
    ///   - model: The ChatGPT model to use for generating the response.
    ///   - maxTokens: The maximum number of tokens in the generated response. Defaults to 500.
    ///   - endPoint: The API endpoint to send the request to.
    ///   - completion: A closure to be called with the result of the request. The result is either a success containing the generated response string or a failure containing an error.
    public func sendChatRequest(prompt: String, model: ChatGPTModels, maxTokens: Int = 500, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        self.chatRequest(prompt: prompt, model: model, maxTokens: maxTokens, endPoint: endPoint, completion: completion)
    }
    
    
    /// Sends a request to generate text based on the provided prompt using the generateText function.
    ///
    /// - Parameters:
    ///   - prompt: The prompt to generate text from.
    ///   - model: The ChatGPT model to use for text generation.
    ///   - maxTokens: The maximum number of tokens in the generated text. Defaults to 500.
    ///   - numberOfResponse: The number of text samples to generate. Defaults to 1.
    ///   - endPoint: The endpoint URL for the API request.
    ///   - completion: A completion block that is called with the result of the request. The block receives a Result object containing either the generated text as a String in case of success, or an Error in case of failure.
    public func sendTextRequest(prompt: String, model: ChatGPTModels, maxTokens: Int = 500, numberOfResponse: Int = 1, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        self.sendTextCompletionRequest(prompt: prompt, model: model, maxTokens: maxTokens, n: numberOfResponse, endPoint: endPoint, completion: completion)
    }
    
    /// Generates an image based on the prompt.
    ///
    /// - Parameters:
    ///   - prompt: The prompt for image generation.
    ///   - model: The ChatGPT model to use for image generation.
    ///   - imageSize: The desired size of the generated image.
    ///   - numberOfResponse: The number of images to generate (default is 1).
    ///   - endPoint: The endpoint URL for the API request.
    ///   - completion: The completion block called with the result of the request. The block receives a Result object containing either the generated image as a String in case of success, or an Error in case of failure.
    public func generateImage(prompt: String, model: ChatGPTModels, imageSize: ChatGPTImageSize, numberOfResponse: Int = 1, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        self.generateImageFromText(prompt: prompt, model: model, imageSize: imageSize, endPoint: endPoint, n: numberOfResponse, completion: completion)
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
    public func audioTranscriptionRequest(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, language: String? = nil, model: AudioGPTModels = .whisper1, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void) {
        self.audioTranscription(fileUrl: fileUrl, prompt: prompt, temperature: temperature, language: language, model: model, endPoint: endPoint, completion: completion)
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
    public func audioTranslationRequest(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, model: AudioGPTModels = .whisper1, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void) {
        self.audioTranslation(fileUrl: fileUrl,prompt: prompt, temperature: temperature, model: model, endPoint: endPoint, completion: completion)
    }
    
    // MARK: - Private Functions
    private func retrieveSingleModel<T: Decodable>(endPoint: APPURL, completion: @escaping (Result<T, Error>) -> Void) {
        let requestBuilder = GetRequestBuilder()
        guard let request = requestBuilder.buildRequest(params: nil, endPoint: endPoint, apiKey: apiKey) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        self.performDataTask(with: request) { result in
            
            switch result {
            case.success(let data):

                do {
                    // Parse the JSON response into an array of type T
                    let models = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(models))
                } catch {
                    // Error occurred during decoding, return failure in completion handler
                    completion(.failure(error))
                }
                
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getModelsList<T: Decodable>(endPoint: APPURL, completion: @escaping (Result<T, Error>) -> Void) {
        let requestBuilder = GetRequestBuilder()
        guard let request = requestBuilder.buildRequest(params: nil, endPoint: endPoint, apiKey: apiKey) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        self.performDataTask(with: request) { result in
            
            switch result {
            case.success(let data):

                do {
                    // Parse the JSON response into an array of type T
                    let models = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(models))
                } catch {
                    // Error occurred during decoding, return failure in completion handler
                    completion(.failure(error))
                }
                
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func chatRequest(prompt: String, model: ChatGPTModels, maxTokens: Int, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        
        let messages = generateMessages(from: prompt)
        
        let parameters: [String: Any] = [
            "messages":messages,
            "max_tokens": maxTokens,
            "model": model.rawValue
        ]
        
        let requestBuilder = DefaultRequestBuilder()
        guard let request = requestBuilder.buildRequest(params: parameters, endPoint: endPoint, apiKey: apiKey) else {
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
    
    private func sendTextCompletionRequest(prompt: String, model: ChatGPTModels, maxTokens: Int, n: Int, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void)  {
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "max_tokens": maxTokens,
            "model":model.rawValue,
            "n": n
        ]
        
        let requestBuilder = DefaultRequestBuilder()
        guard let request = requestBuilder.buildRequest(params: parameters, endPoint: endPoint, apiKey: apiKey) else {
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
    
    
    private func generateImageFromText(prompt: String, model: ChatGPTModels, imageSize: ChatGPTImageSize, endPoint: APPURL, n: Int, completion: @escaping (Result<String, Error>) -> Void)  {
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": n,
            "size": imageSize.rawValue,
            "user": ""
        ]
        
        let requestBuilder = DefaultRequestBuilder()
        guard let request = requestBuilder.buildRequest(params: parameters, endPoint: endPoint, apiKey: apiKey) else {
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
    
    private func audioTranscription(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, language: String? = nil, model: AudioGPTModels, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void) {
        
        // Define the key-value pairs
        var parameters: [String: Any] = [
            "model": model.rawValue
        ] 

        if let prompt = prompt {
            parameters["prompt"] = prompt
        }

        if let temperature = temperature {
            parameters["temperature"] = temperature
        }

        if let language = language {
            parameters["language"] = language
        }
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
    
    private func audioTranslation(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, model: AudioGPTModels, endPoint: APPURL, completion: @escaping (Result<String, Error>) -> Void) {
        
        var parameters: [String: Any] = [
            "model": model.rawValue
        ]

        if let prompt = prompt {
            parameters["prompt"] = prompt
        }

        if let temperature = temperature {
            parameters["temperature"] = temperature
        }
        
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
    
    private func createMultiPartUrlRequest(audioURL: URL, params: [String: Any], endPoint: APPURL)-> URLRequest? {
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
        if historyList.count > 148 {
            historyList = historyList.suffix(148)
        }
        
        return [systemMessage] + historyList + [userMessage]
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

