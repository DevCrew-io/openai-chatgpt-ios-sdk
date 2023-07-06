import Foundation

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
    ///                 The result will either contain an array of models of type `ChatGPTModelList` on success,
    ///                 or an error on failure.
    ///
    public func getOpenAIModels(completion: @escaping (Result<ChatGPTModelList, Error>) -> Void) {
        self.getModelsList(endPoint: .modelsList, completion: completion)
    }
    
    
    /// Retrieves  OpenAI model from the API.
    ///
    /// - Parameters:
    ///   - model: The input model name / id.
    ///   - completion: A completion handler that receives the result of the API request.
    ///                 The result will either contain  model of type `ChatGPTModel` on success,
    ///                 or an error on failure.
    ///
    
    public func retrieveAIModel(model: String, completion: @escaping (Result<ChatGPTModel, Error>) -> Void) {
        self.retrieveSingleModel(endPoint: .retrievedModel(model), completion: completion)
    }
    
    /// Sends a chat request to the ChatGPT API.
    ///
    /// - Parameters:
    ///   - prompt: The input prompt for the chat request.
    ///   - model: The ChatGPT model to use for generating the response.
    ///   - maxTokens: The maximum number of tokens in the generated response. Defaults to 500.
    ///   - completion: A closure to be called with the result of the request. The result is either a success containing the generated response string or a failure containing an error.
    public func sendChatRequest(prompt: String, model: ChatGPTModels = .gptThreePointFiveTurbo, maxTokens: Int = 500, completion: @escaping (Result<[String], Error>) -> Void)  {
        self.chatRequest(prompt: prompt, model: model, maxTokens: maxTokens, endPoint: .chat, completion: completion)
    }
    
    
    /// Sends a request to generate text based on the provided prompt using the generateText function.
    ///
    /// - Parameters:
    ///   - prompt: The prompt to generate text from.
    ///   - model: The ChatGPT model to use for text generation.
    ///   - maxTokens: The maximum number of tokens in the generated text. Defaults to 500.
    ///   - numberOfResponse: The number of text samples to generate. Defaults to 1.
    ///   - completion: A completion block that is called with the result of the request. The block receives a Result object containing either the generated text as a String in case of success, or an Error in case of failure.
    public func sendTextRequest(prompt: String, model: ChatGPTModels = .textDavinci003, maxTokens: Int = 500, numberOfResponse: Int = 1, completion: @escaping (Result<[String], Error>) -> Void)  {
        self.sendTextCompletionRequest(prompt: prompt, model: model, maxTokens: maxTokens, n: numberOfResponse, endPoint: .completion, completion: completion)
    }
    
    /// Generates an image based on the prompt.
    ///
    /// - Parameters:
    ///   - prompt: The prompt for image generation.
    ///   - model: The ChatGPT model to use for image generation.
    ///   - imageSize: The desired size of the generated image.
    ///   - numberOfResponse: The number of images to generate (default is 1).
    ///   - completion: The completion block called with the result of the request. The block receives as Result object containing either the generated image as a String in case of success, or an Error in case of failure.
    public func generateImage(prompt: String, imageSize: ChatGPTImageSize = .fiveTwelve, responseFormat: ResponseFormat = .url, numberOfResponse: Int = 1,user: String? = nil, completion: @escaping (Result<[String], Error>) -> Void)  {
        self.generateImageFromText(prompt: prompt, imageSize: imageSize, responseFormat: responseFormat, endPoint: .generateImage, n: numberOfResponse,user: user, completion: completion)
    }
    
    /// Edit an image based on the prompt.
    ///
    /// - Parameters:
    ///    - image: The image data to edit. Must be a valid PNG file, less than 4MB, and square. If mask is not provided, the image must have transparency, which will be used as the mask.
    ///    - mask:  An additional image whose fully transparent areas indicate where the image should be edited. Must be a valid PNG file, less than 4MB, and have the same dimensions as the image.
    ///    - prompt: A text description of the desired image(s). The maximum length is 1000 characters.
    ///    - n: The number of images to generate. Defaults to 1. Must be between 1 and 10.
    ///    - size: The size of the generated images. Defaults to 1024x1024. Must be one of 256x256, 512x512, or 1024x1024.
    ///    - responseFormat: The format in which the generated images are returned. Defaults to "url". Must be one of "url" or "b64_json".
    ///    - user: A unique identifier representing your end-user, which can help OpenAI monitor and detect abuse.
    ///    - completion: A completion handler called when the request is completed. Provides the response data, URL response, and error.
    
    public func createImageEditRequest(image: Data, mask: Data? = nil, prompt: String, n: Int = 1, size: ChatGPTImageSize = .fiveTwelve, responseFormat: ResponseFormat = .url, user: String? = nil, imageConversionFormat: ImageConversionFormat? = .rgba, completion: @escaping (Result<[String],Error>) -> Void) {
        
        self.editImageRequest(endPoint: .imageEdits, image: image, prompt: prompt, n: n, size: size, responseFormat: responseFormat, user: user, imageConversionFormat: imageConversionFormat, completion: completion)
    }
    
    
    
    /// Request for generating image variations.
    
    ///  - Parameters:
    ///    - image: The image data to generate variations from. Must be a valid PNG file.
    ///   - n: The number of image variations to generate. Defaults to 1. Must be between 1 and 10.
    ///  - prompt: An optional text prompt to guide the image generation process. The maximum length is 1000 characters.
    ///  - completion: A completion handler called when the request is completed. Provides the response data, URL response, and error.
    
    public  func createImageVariationsRequest(image: Data, n: Int = 1,size: ChatGPTImageSize = .fiveTwelve, response_format: ResponseFormat = .url, user: String? = nil, imageConversionFormat: ImageConversionFormat? = nil, completion: @escaping (Result<[String],Error>) -> Void) {
        
        self.imageVariationsRequest(endPoint:.imageVariations , image: image, n: n, size: size, responseFormat: response_format, user: user,imageConversionFormat: imageConversionFormat, completion: completion)
    }
    
    
    /// Requests audio transcription based on the provided parameters.
    ///
    /// - Parameters:
    ///   - fileUrl: The URL of the audio file to be transcribed.
    ///   - prompt: The prompt or context for the transcription.
    ///   - temperature: (Optional) The temperature value for generating diverse transcriptions. Defaults to nil.
    ///   - language: (Optional) The language of the transcription. Defaults to nil.
    ///   - model: (Optional) The model to be used for transcription. Defaults to ChatGPTModels.
    ///   - completion: A completion handler to be called with the result of the transcription request.
    ///                 The handler takes a Result object, which contains either the transcribed text or an error.
    ///                 Use the `.success` case to access the transcribed text and the `.failure` case to handle errors.
    public func audioTranscriptionRequest(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, language: String? = nil, model: AudioGPTModels = .whisper1, completion: @escaping (Result<String, Error>) -> Void) {
        self.audioTranscription(fileUrl: fileUrl, prompt: prompt, temperature: temperature, language: language, model: model, endPoint: .transcriptions, completion: completion)
    }
    /// Requests audio translation based on the provided parameters.
    ///
    /// - Parameters:
    ///   - fileUrl: The URL of the audio file to be translated.
    ///   - prompt: (Optional) The prompt or context for the translation. Defaults to nil.
    ///   - temperature: (Optional) The temperature value for generating diverse translations. Defaults to nil.
    ///   - model: The ChatGPT model to use for translation.
    ///   - completion: The completion block called with the result of the request. The block receives a Result object containing either the translated text as a String in case of success, or an Error in case of failure.
    public func audioTranslationRequest(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, model: AudioGPTModels = .whisper1, completion: @escaping (Result<String, Error>) -> Void) {
        self.audioTranslation(fileUrl: fileUrl,prompt: prompt, temperature: temperature, model: model, endPoint: .translations, completion: completion)
    }
    
   
    ///  Endpoint for generating edits.
    
    /// - Parameters:
    /// - model: The ID of the model to use for generating edits. Use either "text-davinci-edit-001" or "code-davinci-edit-001" with this endpoint.
    /// - input: The input text to use as a starting point for the edit. Optional parameter, defaults to an empty string.
    ///  - instruction: The instruction that tells the model how to edit the prompt.
    ///  - n: The number of edits to generate for the input and instruction. Optional parameter, defaults to 1.
    ///   - temperature: The sampling temperature to use, ranging from 0 to 2. Higher values like 0.8 make the output more random, while lower values like 0.2 make it more focused and deterministic. Optional parameter, defaults to 1.0.
    ///   - topP: An alternative to sampling with temperature, known as nucleus sampling. It considers the results of tokens with top_p probability mass. A value of 0.1 means only tokens comprising the top 10% probability mass are considered. Optional parameter, defaults to 1.0.
       
    public func createEditsRequest(model: EditGPTModels = .textDavinciEdit001, input: String? = nil, instruction: String, n: Int = 1, temperature: Double = 1.0, topP: Double = 1.0, completion: @escaping (Result<[String],Error>) -> Void) {
        self.textEditsRequest(endPoint: .textEdit, model: model, input: input, instruction: instruction, n: n, temperature: temperature, topP: topP, completion: completion)
    }

    
    
    // MARK: - Private Functions -
    private  func textEditsRequest(endPoint: ChatGPTAPIEndpoint, model: EditGPTModels, input: String?, instruction: String, n: Int, temperature: Double, topP: Double, completion: @escaping (Result<[String],Error>) -> Void) {
        
       var parameters: [String: Any] = [
           "instruction":instruction,
           "model": model.rawValue,
           "n":n,
           "temperature":temperature,
           "top_p":topP
       ]
        if let input = input {
            parameters["input"] = input
        }
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
    private func retrieveSingleModel(endPoint: ChatGPTAPIEndpoint, completion: @escaping (Result<ChatGPTModel, Error>) -> Void) {
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
                    let models = try JSONDecoder().decode(ChatGPTModel.self, from: data)
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
    
    private func getModelsList(endPoint: ChatGPTAPIEndpoint, completion: @escaping (Result<ChatGPTModelList, Error>) -> Void) {
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
                    let models = try JSONDecoder().decode(ChatGPTModelList.self, from: data)
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
    
    private func chatRequest(prompt: String, model: ChatGPTModels, maxTokens: Int, endPoint: ChatGPTAPIEndpoint, completion: @escaping (Result<[String], Error>) -> Void)  {
        
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
    
    private func sendTextCompletionRequest(prompt: String, model: ChatGPTModels, maxTokens: Int, n: Int, endPoint: ChatGPTAPIEndpoint, completion: @escaping (Result<[String], Error>) -> Void)  {
        
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
    
    private func generateImageFromText(prompt: String, imageSize: ChatGPTImageSize, responseFormat: ResponseFormat = .url, endPoint: ChatGPTAPIEndpoint, n: Int, user: String?, completion: @escaping (Result<[String], Error>) -> Void)  {
        
        var parameters: [String: Any] = [
            "prompt": prompt,
            "n": n,
            "size": imageSize.rawValue,
            "response_format": responseFormat.rawValue
        ]
        if let user = user {
            parameters["user"] = user
        }
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
    
    private  func editImageRequest(endPoint: ChatGPTAPIEndpoint, image: Data, mask: Data? = nil, prompt: String, n: Int?, size: ChatGPTImageSize?, responseFormat: ResponseFormat = .url, user: String?, imageConversionFormat: ImageConversionFormat?, completion: @escaping (Result<[String],Error>) -> Void) {
        
        // Define the key-value pairs
        var parameters: [String: Any] = [
            "prompt": prompt,
            "response_format": responseFormat.rawValue
        ]
        
        if let numberOfResponse = n {
            parameters["n"] = numberOfResponse
        }
        
        if let size = size {
            parameters["size"] = size.rawValue
        }
        
        
        if let user = user {
            parameters["user"] = user
        }
        
        var dataArray = [Data]()
        var fileNamesArray = [String]()
        fileNamesArray.append("image.png")
        if let imageConversionFormat = imageConversionFormat {
            let convertedData = ImageFormatConvertor.converImage(with: image, format: .rgba)
            if let convertedData = convertedData {
                dataArray.append(convertedData)
                
            }
        } else {
            dataArray.append(image)
        }
        
        if let mask = mask {
            dataArray.append(mask)
            fileNamesArray.append("mask")
        }
        guard let request = self.createMultiPartRequest(data: dataArray, fileNames: fileNamesArray, params: parameters, name: "image", contentType: "image/png", endPoint: endPoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        self.performDataTask(with: request) { result in
            
            switch result {
            case.success(let data):
                let parser = ImageGenerationResponseParser()
                parser.parseResponse(data: data, completion: { result in
                    
                    switch result {
                    case.success(let succesString):
                        print(succesString)
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
    private func imageVariationsRequest(endPoint: ChatGPTAPIEndpoint, image: Data, n: Int?,size: ChatGPTImageSize?, responseFormat: ResponseFormat, user: String?, imageConversionFormat: ImageConversionFormat?, completion: @escaping (Result<[String],Error>) -> Void) {
        // Define the key-value pairs
        var parameters: [String: Any] = [
            "response_format": responseFormat.rawValue
        ]
        if let numberOfResponse = n {
            parameters["n"] = numberOfResponse
        }
        
        if let size = size {
            parameters["size"] = size.rawValue
        }
        
        
        if let user = user {
            parameters["user"] = user
        }
        
        var dataArray = [Data]()
        var fileNamesArray = [String]()
        fileNamesArray.append("image.png")
        if let imageConversionFormat = imageConversionFormat {
            let convertedData = ImageFormatConvertor.converImage(with: image, format: .rgba)
            if let convertedData = convertedData {
                dataArray.append(convertedData)
            }
        } else {
            dataArray.append(image)
        }
        
        guard let request = self.createMultiPartRequest(data: dataArray, fileNames: fileNamesArray, params: parameters, name: "image", contentType: "image/png", endPoint: endPoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        self.performDataTask(with: request) { result in
            
            switch result {
            case.success(let data):
                let parser = ImageGenerationResponseParser()
                parser.parseResponse(data: data, completion: { result in
                    
                    switch result {
                    case.success(let succesString):
                        print(succesString)
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
    
    private func audioTranscription(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, language: String? = nil, model: AudioGPTModels, endPoint: ChatGPTAPIEndpoint, completion: @escaping (Result<String, Error>) -> Void) {
        
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
        
        let audioFilename = fileUrl.lastPathComponent
        let audioData: Data
        do {
            audioData = try Data(contentsOf: fileUrl)
        } catch {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        guard let request = self.createMultiPartRequest(data: [audioData],fileNames: [audioFilename],params: parameters, name: "file", contentType: "audio/wav", endPoint: endPoint) else {
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
    
    private func audioTranslation(fileUrl: URL, prompt: String? = nil, temperature: Double? = nil, model: AudioGPTModels, endPoint: ChatGPTAPIEndpoint, completion: @escaping (Result<String, Error>) -> Void) {
        
        var parameters: [String: Any] = [
            "model": model.rawValue
        ]
        
        if let prompt = prompt {
            parameters["prompt"] = prompt
        }
        
        if let temperature = temperature {
            parameters["temperature"] = temperature
        }
        let audioFilename = fileUrl.lastPathComponent
        let audioData: Data
        do {
            audioData = try Data(contentsOf: fileUrl)
        } catch {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        guard let request = self.createMultiPartRequest(data: [audioData],fileNames: [audioFilename],params: parameters, name: "file", contentType: "audio/wav", endPoint: endPoint) else {
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
    
    private func createMultiPartRequest(data: [Data],fileNames: [String], params: [String: Any],name: String, contentType: String , endPoint: ChatGPTAPIEndpoint)-> URLRequest? {
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
        
        
        for i in 0..<data.count {
            
            let dataItem = data[i]
            let fileName = fileNames[i]
            
            requestBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            requestBody.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            requestBody.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
            requestBody.append(dataItem)
            requestBody.append("\r\n".data(using: .utf8)!)
            
        }
        
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
    
    private func appendToHistoryList(userText: String, responseText: [String]) {
        let userMessage = NSMutableDictionary()
        userMessage.setValue("user", forKey: "role")
        userMessage.setValue(userText, forKey: "content")
        let assistantMessage = NSMutableDictionary()
        assistantMessage.setValue("assistant", forKey: "role")
        assistantMessage.setValue(responseText, forKey: "content")
        self.historyList.append(userMessage)
        self.historyList.append(assistantMessage)
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
    
}

