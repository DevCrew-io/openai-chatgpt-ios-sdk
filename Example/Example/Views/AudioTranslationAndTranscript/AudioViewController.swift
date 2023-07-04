//
//  AudioViewController.swift
//  Example
//
//  Created by Ghullam Abbas on 23/06/2023.
//

import UIKit
import ChatGPTAPIManager

class AudioViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func audioTranslation(sender: UIButton) {
        if let fileURL = Bundle.main.url(forResource: "translation_file", withExtension: "m4a") {
            self.audioTranslation(url: fileURL)
        }
    }
    @IBAction func audioTranscription(sender: UIButton) {
        if let fileURL = Bundle.main.url(forResource: "english_song", withExtension: "m4a") {
            self.audioTranscriptions(url: fileURL)
        }
    }
    
    func audioTranslation(url: URL) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.audioTranslationRequest(fileUrl: url,temperature: 0.8, model: .whisper1, endPoint: .translations, completion: { result in
            
            switch result {
            case.success(let success):
                print(success)
                DispatchQueue.main.async {
                    self.textView.text = success
                    EZLoadingActivity.hide(true, animated: true)
                }
            case.failure(let error):
                print(error)
                self.textView.text = "\(error)"
                EZLoadingActivity.hide(false, animated: true)
            }
        })
    }
    func audioTranscriptions(url: URL) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.audioTranscriptionRequest(fileUrl: url, prompt: "Translate this audio", language: "en", model: .whisper1, endPoint: .transcriptions, completion: { result in
            
            switch result {
            case.success(let success):
                print(success)
                DispatchQueue.main.async {
                    self.textView.text = success
                    EZLoadingActivity.hide(true, animated: true)
                }
            case.failure(let error):
                print(error)
                self.textView.text = "\(error)"
                EZLoadingActivity.hide(false, animated: true)
            }
        })
    }
}
