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
    let url = Bundle.main.url(forResource: "Boswell Interview - Ted 2023-05-16", withExtension: "m4a")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func audioTranslation(sender: UIButton) {
        let fileURL = URL(fileURLWithPath: url!.path)
        self.audioTranslation(url: fileURL)
    }
    @IBAction func audioTranscription(sender: UIButton) {
        let fileURL = URL(fileURLWithPath: url!.path)
        self.audioTranscriptions(url: fileURL)
    }
    
    func audioTranslation(url: URL) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.audioTranslationRequest(fileUrl: url,temperature: 0.8, model: .whisper1, endPoint: .translations, completion: { result in
            
            switch result {
            case.success(let success):
                print(success)
                DispatchQueue.main.async {
                    self.textView.text =  success
                }
            case.failure(let error):
                print(error)
            }
        })
    }
    func audioTranscriptions(url: URL) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        ChatGPTAPIManager.shared.audioTranscriptionRequest(fileUrl: url, prompt: "Translate this audio", model: .whisper1, endPoint: .transcriptions, completion: { result in
            
            switch result {
            case.success(let success):
                print(success)
                DispatchQueue.main.async {
                    EZLoadingActivity.hide(true,animated: true)
                    self.textView.text =  success
                }
            case.failure(let error):
                print(error)
                EZLoadingActivity.hide(false,animated: true)
            }
        })
    }
}
