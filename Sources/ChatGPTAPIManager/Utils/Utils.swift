//
//  Utils.swift
//  
//
//  Created by Najam us Saqib on 7/5/23.
//

import Foundation

///// Represents the response format.
public enum ResponseFormat: String {
    case url = "url"
    case b64_json = "b64_json"
}

/// Enum representing different  ImageSizes supported by imagegeneration API.
public enum ChatGPTImageSize : String {
    case twoFiftySix = "256x256"
    case fiveTwelve = "512x512"
    case tenTwentyFour = "1024x1024"
}
