//
//  ViewController.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func chatVC(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let vm = ChatViewModel()
        vc.vm = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func textVC(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let vm = TextGenerationViewModel()
        vc.vm = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func txtToImageVC(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageWithTextViewController") as! ImageWithTextViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func getModelsList(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModelsListVC") as! ModelsListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func audioTranscriptions(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func editText(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditTextVC") as! EditTextVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func embeddingsTab(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmbeddingVC") as! EmbeddingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func moderationsTab(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModerationVC") as! ModerationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

