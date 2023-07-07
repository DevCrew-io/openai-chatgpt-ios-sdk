//
//  EmbeddingVC.swift
//  Example
//
//  Created by Ghullam Abbas on 07/07/2023.
//

import UIKit

class EmbeddingVC: UIViewController {
    
    @IBOutlet weak var inPutTextField: UITextField!
    @IBOutlet weak var outPutTextView: UITextView!
    let vm = EmbeddingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.onFailure = {
            DispatchQueue.main.async {
                EZLoadingActivity.hide(false,animated: true)
            }
        }
        vm.onSuccess = {
            DispatchQueue.main.async {
                EZLoadingActivity.hide(true,animated: true)
            }
            self.outPutTextView.text = "\(String(describing: self.vm.outPut))"
        }
        
    }
    @IBAction func moderationButtonTab(_ sender: UIButton) {
        guard let text = inPutTextField.text else { return }
        vm.embeddingText(inputText: text)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
