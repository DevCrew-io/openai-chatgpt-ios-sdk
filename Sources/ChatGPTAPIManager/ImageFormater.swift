//
//  File.swift
//  
//
//  Created by Ghullam Abbas on 05/07/2023.
//

import Foundation
import UIKit

public enum ImageConversionFormat: String {
    case RGBA = "RGBA"
    case LA = "LA"
    case L = "L"
}

//extension UIImage {
//    // Convert the image to the required format
//    guard let cgImage = UIImage(data: image)?.cgImage else {
//        print("Failed to convert the image to CGImage.")
//        return
//    }
//
//    let colorSpace = CGColorSpaceCreateDeviceRGB()
//    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//    guard let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
//        print("Failed to create CGContext.")
//        return
//    }
//
//    context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
//
//    guard let convertedImage = context.makeImage() else {
//        print("Failed to convert the image to the required format.")
//        return
//    }
//
//    let convertedImageData = UIImage(cgImage: convertedImage).pngData()
//}
