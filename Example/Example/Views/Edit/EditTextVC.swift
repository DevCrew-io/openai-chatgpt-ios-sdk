//
//  EditTextVC.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import UIKit

class EditTextVC: UIViewController {
    
    @IBOutlet weak var inPutTextField: UITextField!
    @IBOutlet weak var instructionsTextField: UITextField!
    @IBOutlet weak var outPutLabel: UITextView!
    
    let vm = EditTextViewModelViewModel()
    
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
            self.outPutLabel.text = self.vm.ouPutText
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func editText(_ sender: UIButton) {
        vm.editText(inputText: inPutTextField.text!, instructionText: instructionsTextField.text!)
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
