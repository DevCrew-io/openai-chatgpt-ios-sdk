//
//  ViewController.swift
//  Example
//
//  Created by Ghullam Abbas on 21/06/2023.
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

    @IBAction func audioTranscriptions(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

