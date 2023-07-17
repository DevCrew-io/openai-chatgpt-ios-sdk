//
//  AudioViewController.swift
//  Example
//
//  Created by Ghullam Abbas on 23/06/2023.
//

import UIKit
import OpenAIAPIManager

class AudioViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    // MARK: - Variables
    var vm = AudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func audioTranslation(sender: UIButton) {
        if let fileURL = Bundle.main.url(forResource: "translation_file", withExtension: "m4a") {
            vm.audioTranslation(url: fileURL) { result in
                
                switch result {
                case .success(let audioText):
                    DispatchQueue.main.async {
                        self.textView.text = audioText
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.textView.text = failure.localizedDescription
                    }
                }
                
            }
        }
    }
    
    @IBAction func audioTranscription(sender: UIButton) {
        if let fileURL = Bundle.main.url(forResource: "english_song", withExtension: "m4a") {
            vm.audioTranscriptions(url: fileURL) { result in
                
                switch result {
                case .success(let audioText):
                    DispatchQueue.main.async {
                        self.textView.text = audioText
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.textView.text = failure.localizedDescription
                    }
                }
                
            }
        }
    }
    
}
