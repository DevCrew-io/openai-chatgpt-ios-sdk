# chatgpt-ios-sdk
A comprehensive SDK for integrating Chat GPT APIs into iOS applications.It provides a convenient and easy-to-use interface for making API requests and handling responses.


## Model Enums (ChatGPTModels, ChatGPTImageSize)
The `ChatGPTModels` enum represents different ChatGPT models available for text generation. It includes cases for "gpt-3.5-turbo" and "davinci".

The `ChatGPTImageSize` enum represents different image sizes supported by the image generation API. It includes cases for "512x512" and "1024x1024".

## ChatGPT API Class (ChatGPTAPIManager)
The `ChatGPTAPIManager` class is responsible for making API requests to ChatGPT. It requires an API key for authentication and provides methods for sending text generation and image generation requests.


## Obtaining an API Key

To use the ChatGPT API, you need to obtain an API key from OpenAI. Follow these steps to get your API key:

1. Visit the [OpenAI website](https://openai.com) and sign in to your account.

2. Navigate to the API section or go directly to the API page.

3. Follow the instructions provided to sign up for the ChatGPT API access. This might involve joining a waitlist or subscribing to a plan, depending on the availability and pricing options.

4. Once you have access to the API, locate your API key in your OpenAI account dashboard or API settings.

5. Copy the API key, as you will need it to authenticate your API requests.

Now that you have obtained your API key, you can use it to initialize the `ChatGPTAPIManager` in your iOS application as mentioned in the below section.

### Installation

### Swift Package Manager

The [Swift Package Manager](https://www.swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

```
dependencies: [
    .package(url: "https://github.com/DevCrew-io/chatgpt-ios-sdk.git", .upToNextMajor(from: "1.0.2"))
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate **ChatGPTAPIManager** into your project manually.

1. Download zip file
2. Open ChatGPTAPIManager/Sources/ChatGPTAPIManager
3. Drag and drop ChatGPTAPIManager.swift file into project

### Usage

To use the **ChatGPTAPIManager** library, follow these steps:

 Import the **ChatGPTAPIManager** module in the file where you want to use it:
 
 ```
 import ChatGPTAPIManager
  ```

### Set Api Key

To set the api key in `ChatGPTAPIManager`, you need to add it in AppDelegate.

 In AppDelegate.swift.
 
```swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

              ChatGPTAPIManager.shared.apiKey = "plece your api key here"

      return true
    }
}

```

### Sending Chat Request
You can send a chat request to generate text based on a prompt using the `sendChatRequest` method. It takes the prompt, ChatGPT model, endpoint URL, and a completion block as parameters.

```swift
        ChatGPTAPIManager.shared.sendChatRequest(prompt: "Your prompt", model: .gptThreePointFiveTurbo, endPoint: .chat) { result in
    switch result {
    case .success(let generatedChat):
        // Handle the generated chat
    case .failure(let error):
        // Handle the error
    }
}
```

### Sending Text Generation Request
You can send a request to generate text based on a prompt using the `sendTextRequest` method. It takes the prompt, ChatGPT model, endpoint URL, and a completion block as parameters.

```swift
        ChatGPTAPIManager.shared.sendTextRequest(prompt: "Your prompt", model: .textDavinci003, endPoint: .completion) { result in
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
        ChatGPTAPIManager.shared.generateImage(prompt: "Your prompt", model: .engine, imageSize: .fiveTwelve, endPoint: .generateImage) { result in
    switch result {
    case .success(let imageURL):
        // Handle the generated image URL
    case .failure(let error):
        // Handle the error
    }
}
```


Note: The code snippets provided in this README assume that you have replaced `"YOUR_API_KEY"` with your actual API key.


This code should serve as a starting point for integrating ChatGPT API requests into your Swift application. Feel free to modify and extend it according to your specific requirements.
 
## Author

[DevCrew.IO](https://devcrew.io/)

If you have any questions or comments about **ChatGPTAPIManager** , please feel free to contact us at info@devcrew.io.

<h3 align="left">Connect with Us:</h3>
<p align="left">
<a href="https://devcrew.io" target="blank"><img align="center" src="https://devcrew.io/wp-content/uploads/2022/09/logo.svg" alt="devcrew.io" height="35" width="35" /></a>
<a href="https://www.linkedin.com/company/devcrew-io/mycompany/" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="mycompany" height="30" width="40" /></a>
<a href="https://github.com/DevCrew-io" target="blank"><img align="center" src="https://cdn-icons-png.flaticon.com/512/733/733553.png" alt="DevCrew-io" height="32" width="32" /></a>
</p>


## Contributing 
Contributions, issues, and feature requests are welcome! See [Contributors](https://github.com/DevCrew-io/viper-sample-ios) for details.

### Show your Support

Give a star if this project helped you.

### Copyright & License

Code copyright 2023 DevCrew I/O. Code released under the [MIT license](https://github.com/DevCrew-io/expandable-richtext/blob/main/LICENSE).
