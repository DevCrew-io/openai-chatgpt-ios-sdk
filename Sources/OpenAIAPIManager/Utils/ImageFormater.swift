//
//  ImageConversionFormat.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import Foundation
import UIKit

public enum ImageConversionFormat: String {
    case rgba = "RGBA"
    case la = "LA"
    case l = "L"
}

class ImageFormatConvertor {
    
   static func converImage(with image: Data, format: ImageConversionFormat)-> Data? {
        // Convert the image to the required format
        guard let cgImage = UIImage(data: image)?.cgImage else {
            print("Failed to convert the image to CGImage.")
            return nil
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            print("Failed to create CGContext.")
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))

        guard let convertedImage = context.makeImage() else {
            print("Failed to convert the image to the required format.")
            return nil
        }

         return UIImage(cgImage: convertedImage).pngData()
    }
}
