//
//  AudioViewModel.swift
//  Example
//
//  Created by Najam us Saqib on 7/4/23.
//

import Foundation
import ChatGPTAPIManager

protocol AudioViewModelProtocol {
    func audioTranscriptions(url: URL, completioin: @escaping(Result<String, Error>) -> Void)
    func audioTranslation(url: URL, completioin: @escaping(Result<String, Error>) -> Void)
}

class AudioViewModel: AudioViewModelProtocol {
    
    func audioTranscriptions(url: URL, completioin: @escaping(Result<String, Error>) -> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.audioTranscriptionRequest(fileUrl: url, prompt: "Translate this audio", language: "en", model: .whisper1, endPoint: .transcriptions, completion: { result in
            
            switch result {
            case.success(let text):
                print(text)
                completioin(.success(text))
                EZLoadingActivity.hide(true, animated: true)
                
            case.failure(let error):
                print(error)
                completioin(.failure(error))
                EZLoadingActivity.hide(false, animated: true)
            }
            
        })
    }
    
    func audioTranslation(url: URL, completioin: @escaping(Result<String, Error>) -> Void) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.audioTranslationRequest(fileUrl: url, temperature: 0.8, model: .whisper1, endPoint: .translations, completion: { result in
            
            switch result {
            case.success(let text):
                print(text)
                completioin(.success(text))
                EZLoadingActivity.hide(true, animated: true)
                
            case.failure(let error):
                print(error)
                completioin(.failure(error))
                EZLoadingActivity.hide(false, animated: true)
            }
            
        })
    }
    
}
