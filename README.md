# chatgpt-ios-sdk
[![license](https://img.shields.io/badge/license-MIT-green)](https://github.com/DevCrew-io/chatgpt-ios-sdk/blob/main/LICENSE)
![](https://img.shields.io/badge/Code-Swift-informational?style=flat&logo=swift&color=FFA500)
[![Github tag](https://img.shields.io/github/v/tag/DevCrew-io/chatgpt-ios-sdk.svg)]()

A comprehensive SDK for integrating Chat GPT APIs into iOS applications. It provides a convenient and easy-to-use interface for making API requests and handling responses.


## Model Enums (ChatGPTModels, ChatGPTImageSize)
The `ChatGPTModels` enum represents different ChatGPT models available for text generation. It includes cases for "gpt-3.5-turbo" and "davinci".

The `ChatGPTImageSize` enum represents different image sizes supported by the image generation API. It includes cases for "512x512" and "1024x1024".

## ChatGPT API Class (OpenAIAPIManager)
The `OpenAIAPIManager` class is responsible for making API requests to ChatGPT. It requires an API key for authentication and provides methods for sending text generation and image generation requests.

## Obtaining an API Key
To use the ChatGPT API, you need to obtain an API key from OpenAI. Follow these steps to get your API key:

1. Visit the [OpenAI website](https://openai.com) and sign in to your account.

2. Navigate to the API section or go directly to the API page.

3. Follow the instructions provided to sign up for the ChatGPT API access. This might involve joining a waitlist or subscribing to a plan, depending on the availability and pricing options.

4. Once you have access to the API, locate your API key in your OpenAI account dashboard or API settings.

5. Copy the API key, as you will need it to authenticate your API requests.

Now that you have obtained your API key, you can use it to initialize the `OpenAIAPIManager` in your iOS application as mentioned in the below section.

## Installation

### Swift Package Manager
The [Swift Package Manager](https://www.swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

```
dependencies: [
    .package(url: "https://github.com/DevCrew-io/chatgpt-ios-sdk.git", .upToNextMajor(from: "1.0.4"))
]
```

### Manually
If you prefer not to use any of the aforementioned dependency managers, you can integrate **OpenAIAPIManager** into your project manually.

1. Download zip file
2. Open OpenAIAPIManager/Sources/OpenAIAPIManager
3. Drag and drop OpenAIAPIManager.swift file into project

### Usage
To use the **OpenAIAPIManager** library, follow these steps:

 Import the **OpenAIAPIManager** module in the file where you want to use it:
 
 ```
 import OpenAIAPIManager
  ```

### Set Api Key
To set the api key in `OpenAIAPIManager`, You need to add it in AppDelegate.swift.
 
```swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        OpenAIAPIManager.shared.apiKey = "YOUR_API_KEY"

        return true
    }
}

```

### Sending Chat Request
You can send a chat request to generate text based on a prompt using the `sendChatRequest` method.

```swift
/// Sends a chat request to the ChatGPT API.
///
/// - Parameters:
///   - prompt: The input prompt for the chat request.
///   - model: The ChatGPT model to use for generating the response. Defaults is .gptThreePointFiveTurbo
///   - maxTokens: The maximum number of tokens in the generated response. Defaults to 500.
///   - completion: A closure to be called with the result of the request. The result is either a success containing the generated response string or a failure containing an error.
OpenAIAPIManager.shared.sendChatRequest(prompt: "Your prompt") { result in
    switch result {
    case .success(let generatedChat):
        // Handle the generated chat
    case .failure(let error):
        // Handle the error
    }
}
```

### Sending Text Generation Request
You can send a request to generate text based on a prompt using the `sendTextRequest` method.

```swift
/// Sends a request to generate text based on the provided prompt using the generateText function.
///
/// - Parameters:
///   - prompt: The prompt to generate text from.
///   - model: The ChatGPT model to use for text generation. Defaults is .textDavinci003
///   - maxTokens: The maximum number of tokens in the generated text. Defaults to 500.
///   - numberOfResponse: The number of text samples to generate. Defaults to 1.
///   - completion: A completion block that is called with the result of the request. The block receives a Result object containing either the generated text as a String in case of success, or an Error in case of failure.
OpenAIAPIManager.shared.sendTextRequest(prompt: "Your prompt") { result in
    switch result {
    case .success(let generatedText):
        // Handle the generated text
    case .failure(let error):
        // Handle the error
    }
}
```

### Generating Image
You can generate an image based on a prompt using the `generateImage` method.

```swift
/// Generates an image based on the prompt.
///
/// - Parameters:
///   - prompt: The prompt for image generation.
///   - imageSize: The desired size of the generated image. Defaults is .fiveTwelve
///   - responseFormat: The desired api response format (url or b64_json). Defaults is url.
///   - numberOfResponse: The number of images to generate (default is 1).
///   - user: (Optional) A unique identifier representing your end-user.
///   - completion: The completion block called with the result of the request. The block receives as Result object containing either the generated image as a String in case of success, or an Error in case of failure.
OpenAIAPIManager.shared.generateImage(prompt: "Your prompt") { result in
    switch result {
    case .success(let imageURL):
        // Handle the generated image URL
    case .failure(let error):
        // Handle the error
    }
}
```

### Creeate Edited Image
You can generate edited image based on a prompt using the `createImageEditRequest` method.

```swift
/// Edit an image based on the prompt.
///
/// - Parameters:
///    - image: The image data to edit. Must be a valid PNG file, less than 4MB, and square. If mask is not provided, the image must have transparency, which will be used as the mask.
///    - mask:  An additional image whose fully transparent areas indicate where the image should be edited. Must be a valid PNG file, less than 4MB, and have the same dimensions as the image.
///    - prompt: A text description of the desired image(s). The maximum length is 1000 characters.
///    - n: The number of images to generate. Defaults to 1. Must be between 1 and 10.
///    - size: The size of the generated images. Defaults to 512x512. Must be one of 256x256, 512x512, or 1024x1024.
///    - responseFormat: The format in which the generated images are returned. Defaults to "url". Must be one of "url" or "b64_json".
///    - user: A unique identifier representing your end-user, which can help OpenAI monitor and detect abuse.
///    - imageConversionFormat: (Optional) Convert invalid image type into open ai supported .rgba
///    - completion: The completion block called with the result of the request. The block receives as Result object containing either the generated images Array as a String in case of success, or an Error in case of failure.
OpenAIAPIManager.shared.createImageEditRequest(image: imageData, prompt: "Your prompt") { result in
    switch result {
    case .success(let imageURL):
        // Handle the generated image URL
    case .failure(let error):
        // Handle the error
    }
}
```

### Create Image Variation
Creates a variation of a given image using the `createImageVariationsRequest` method.

```swift
/// Request for generating image variations.
///
///  - Parameters:
///    - image: The image data to generate variations from. Must be a valid PNG file.
///    - n: The number of image variations to generate. Defaults to 1. Must be between 1 and 10.
///    - size: The size of the generated images. Defaults to 512x512. Must be one of 256x256, 512x512, or 1024x1024.
///    - responseFormat: The format in which the generated images are returned. Defaults to "url". Must be one of "url" or "b64_json".
///    - user: A unique identifier representing your end-user, which can help OpenAI monitor and detect abuse.
///    - imageConversionFormat: (Optional) Convert invalid image type into open ai supported .rgba
///    - completion: The completion block called with the result of the request. The block receives as Result object containing either the generated images Array as a String in case of success, or an Error in case of failure.
OpenAIAPIManager.shared.createImageVariationsRequest(image: imageData) { result in
    switch result {
    case .success(let imageURL):
        // Handle the generated image URL
    case .failure(let error):
        // Handle the error
    }
}
```

### Audio Translation
To make an audio translation request using the ChatGPT API, you can use the `audioTranslationRequest` function provided by the `OpenAIAPIManager`.

```swift
/// Requests audio transcription based on the provided parameters.
///
/// - Parameters:
///   - fileUrl: The URL of the audio file to be transcribed.
///   - prompt: (Optional) The prompt or context for the transcription.
///   - temperature: (Optional) The temperature value for generating diverse transcriptions. Defaults to nil.
///   - language: (Optional) The language of the transcription. Defaults to nil.
///   - model: (Optional) The model to be used for transcription. Defaults is .whisper1
///   - completion: A completion handler to be called with the result of the transcription request.
///                 The handler takes a Result object, which contains either the transcribed text or an error.
OpenAIAPIManager.shared.audioTranslationRequest(fileUrl: url, completion: { result in
    switch result {
    case .success(let success):
        // Handle successful translation
        print(success)
    case .failure(let error):
        // Handle error
        print(error)
    }
})
```

### Audio Transcription
To transcribe an audio file into text using the ChatGPT API, you can use the `audioTranscriptionRequest` function provided by the `OpenAIAPIManager` class. This function allows you to convert audio recordings into written transcripts.

```swift
/// Requests audio translation based on the provided parameters.
///
/// - Parameters:
///   - fileUrl: The URL of the audio file to be translated.
///   - prompt: (Optional) The prompt or context for the translation. Defaults to nil.
///   - temperature: (Optional) The temperature value for generating diverse translations. Defaults to nil.
///   - model: The ChatGPT model to use for translation. Defaults is .whisper1
///   - completion: The completion block called with the result of the request. The block receives a Result object containing either the translated text as a String in case of success, or an Error in case of failure.
OpenAIAPIManager.shared.audioTranscriptionRequest(fileUrl: url, completion: { result in
    switch result {
    case .success(let success):
        // Handle successful transcription
        print(success)
    case .failure(let error):
        // Handle error
        print(error)
    }
})
```

### Edits
Given a prompt and an instruction, the model will return an edited version of the prompt. You can use the `createEditsRequest` function provided by the `OpenAIAPIManager`.

```swift
///  Endpoint for generating edits.
///
/// - Parameters:
///   - model: The ID of the model to use for generating edits. Defaults is .textDavinciEdit001
///   - input: The input text to use as a starting point for the edit. Optional parameter, defaults to an empty string.
///   - instruction: The instruction that tells the model how to edit the prompt.
///   - n: The number of edits to generate for the input and instruction. Optional parameter, defaults to 1.
///   - temperature: The sampling temperature to use, ranging from 0 to 2. Higher values like 0.8 make the output more random, while lower values like 0.2 make it more focused and deterministic. Optional parameter, defaults to 1.0.
///   - topP: An alternative to sampling with temperature, known as nucleus sampling. It considers the results of tokens with top_p probability mass. A value of 0.1 means only tokens comprising the top 10% probability mass are considered. Optional parameter, defaults to 1.0.
///   - completion: The completion block called with the result of the request. The block receives as Result object containing either the generated Array of Strings in case of success, or an Error in case of failure.
OpenAIAPIManager.shared.createEditsRequest(instruction: "Your_Instruction", completion: { result in
    switch result {
    case .success(let success):
        // Handle successful transcription
        print(success)
    case .failure(let error):
        // Handle error
        print(error)
    }
})
```

### Moderations
Given a input text, outputs if the model classifies it as violating OpenAI's content policy, You can use the `moderationsRequest` function provided by the `OpenAIAPIManager`.

```swift
/// Requests text moderations based on the provided parameters.
///
/// - Parameters:
///   - input: The input text to classify
///   - model: The ChatGPT model to use for moderations. Defaults is .textModerationStable
///   - completion: The completion block called with the result of the request. The block receives a Result object containing either the 'ModerationsModel'  in case of success, or an Error in case of failure.
OpenAIAPIManager.shared.moderationsRequest(input: "Your prompt", completion: { result in
    switch result {
    case .success(let success):
        // Handle successful transcription
        print(success)
    case .failure(let error):
        // Handle error
        print(error)
    }
})
```

### Embeddings
Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms. You can use the `createEmbeddingsRequest` function provided by the `OpenAIAPIManager`.

```swift
/// Requests text moderations based on the provided parameters.
///
/// - Parameters:
///   - input: The input text to classify
///   - model: The ChatGPT model to use for moderations. Defaults is .textModerationStable
///   - completion: The completion block called with the result of the request. The block receives a Result object containing either the 'ModerationsModel'  in case of success, or an Error in case of failure.
OpenAIAPIManager.shared.createEmbeddingsRequest(input: "Your prompt", completion: { result in
    switch result {
    case .success(let success):
        // Handle successful transcription
        print(success)
    case .failure(let error):
        // Handle error
        print(error)
    }
})
```
Note: The code snippets provided in this README assume that you have replaced `"YOUR_API_KEY"` with your actual API key.


## Security Disclaimer
The ChatGPT SDK for iOS provides convenient methods for developers to integrate ChatGPT APIs into their applications. It is essential to ensure the security and confidentiality of your API key while using our SDK. Please note the following disclaimer regarding the management and safekeeping of your API key.

### Responsibility for API Key Security
As a developer, you are solely responsible for safeguarding your API key. The API key grants access to ChatGPT APIs and must be treated as sensitive information. Any misuse, loss, or unauthorized access to your API key is your responsibility.
### Confidentiality
You should treat your API key with the utmost confidentiality. Do not share it with unauthorized individuals or store it in insecure locations, such as public repositories or unprotected storage.
### Secure Storage
When using our SDK, ensure that you store your API key in a secure location within your application. We recommend utilizing secure storage mechanisms, such as Keychain, to encrypt and protect your API key.

By adhering to these guidelines, you can help maintain the security and integrity of your API key while using the ChatGPT SDK for iOS. Remember, maintaining the confidentiality of your API key is crucial to protect your application and the data it processes. 

 
## Author
[DevCrew.IO](https://devcrew.io/)

If you have any questions or comments about **OpenAIAPIManager** , please feel free to contact us at info@devcrew.io.

<h3 align="left">Connect with Us:</h3>
<p align="left">
<a href="https://devcrew.io" target="blank"><img align="center" src="https://devcrew.io/wp-content/uploads/2022/09/logo.svg" alt="devcrew.io" height="35" width="35" /></a>
<a href="https://www.linkedin.com/company/devcrew-io/mycompany/" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="mycompany" height="30" width="40" /></a>
<a href="https://github.com/DevCrew-io" target="blank"><img align="center" src="https://cdn-icons-png.flaticon.com/512/733/733553.png" alt="DevCrew-io" height="32" width="32" /></a>
</p>


## Contributing 
Contributions, issues, and feature requests are welcome! See [Contributors](https://github.com/DevCrew-io/chatgpt-ios-sdk/graphs/contributors) for details.

### Contributions
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

### Show your Support
Give a star if this project helped you.

### Copyright & License
Code copyright 2023 DevCrew I/O. Code released under the [MIT license](https://github.com/DevCrew-io/chatgpt-ios-sdk/blob/main/LICENSE).
