# chatgpt-ios-sdk
A comprehensive SDK for integrating Chat GPT APIs into iOS applications.It provides a convenient and easy-to-use interface for making API requests and handling responses.

## API Struct (APPURL)
The `APPURL` struct defines the base URL for the API. It includes different domains for development, production, and QA environments. The base URLs for specific API endpoints like Chat and Image Generation are also defined.

## NetworkError Enum
The `NetworkError` enum represents possible network errors that can occur during API requests. It includes cases for invalid URL, request failure, and invalid response.

## Model Enums (ChatGPTModels, ChatGPTImageSize)
The `ChatGPTModels` enum represents different ChatGPT models available for text generation. It includes cases for "gpt-3.5-turbo" and "davinci".

The `ChatGPTImageSize` enum represents different image sizes supported by the image generation API. It includes cases for "512x512" and "1024x1024".

## ChatGPT API Class (ChatGPTAPIManager)
The `ChatGPTAPIManager` class is responsible for making API requests to ChatGPT. It requires an API key for authentication and provides methods for sending text generation and image generation requests.


## Obtaining an API Key

To use the ChatGPT API, you need to obtain an API key from OpenAI. Follow these steps to get your API key:

1. Visit the OpenAI website (https://openai.com) and sign in to your account.

2. Navigate to the API section or go directly to the API page.

3. Follow the instructions provided to sign up for the ChatGPT API access. This might involve joining a waitlist or subscribing to a plan, depending on the availability and pricing options.

4. Once you have access to the API, locate your API key in your OpenAI account dashboard or API settings.

5. Copy the API key, as you will need it to authenticate your API requests.

Now that you have obtained your API key, you can use it to initialize the `ChatGPTAPIManager` in your iOS application as mentioned in the below section.


### Initialization
To initialize the `ChatGPTAPIManager`, you need to provide the API key as a parameter.

```swift
let apiManager = ChatGPTAPIManager(apiKey: "YOUR_API_KEY")
```

### Sending Text Generation Request
You can send a request to generate text based on a prompt using the `sendRequest` method. It takes the prompt, ChatGPT model, endpoint URL, and a completion block as parameters.

```swift
apiManager.sendRequest(prompt: "Your prompt", model: .gptThreePointFiveTurbo, endPoint: APPURL.chat) { result in
    switch result {
    case .success(let generatedText):
        // Handle the generated text
    case .failure(let error):
        // Handle the error
    }
}
```

### Generating Image
You can generate an image based on a prompt using the `generateImage` method. It takes the prompt, ChatGPT model, desired image size, endpoint URL, and a completion block as parameters.

```swift
apiManager.generateImage(prompt: "Your prompt", model: .engine, imageSize: .fiveTwelve, endPoint: APPURL.generateImage) { result in
    switch result {
    case .success(let imageURL):
        // Handle the generated image URL
    case .failure(let error):
        // Handle the error
    }
}
```

## ChatGPT API Response Parser
The code includes response parser classes for parsing the API responses.

### ChatCompletionResponseParser
The `ChatCompletionResponseParser` class parses the response data for generating text. It extracts the completion text from the JSON response.

### ImageGenerationResponseParser
The `ImageGenerationResponseParser` class parses the response data for generating an image. It extracts the image URL from the JSON response.

Both parser classes implement the `APIResponseParcer` protocol, which defines a method `parseResponse` that takes the response data and a completion block as parameters. The completion block provides the parsed result or an error.

These parser classes can be extended or modified to handle different response structures or extract additional information if required.


Note: The code snippets provided in this README assume that you have replaced `"YOUR_API_KEY"` with your actual API key.


This code should serve as a starting point for integrating ChatGPT API requests into your Swift application. Feel free to modify and extend it according

 to your specific requirements.
