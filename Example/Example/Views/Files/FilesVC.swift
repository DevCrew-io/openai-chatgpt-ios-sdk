//
//  filesVC.swift
//  Example
//
//  Created by Ghulam Abbas on 11/07/2023.
//

import UIKit

class FilesVC: UIViewController {
   let vm = FilesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.getFiles()
       // self.uploadFile()
        
    }
    @IBAction func uploadFileButtonDidTab(sender: UIButton) {
        self.uploadFile()
    }
    @IBAction func retrievedFileButtonDidTab(sender: UIButton) {
        vm.retrievedFile(fileID: vm.fileID ?? "", completion: { [weak self] result in
            switch result {
            case.success:
                print(self?.vm.models?.data.count ?? 0)
            case.failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    @IBAction func retrievedFileContentButtonDidTab(sender: UIButton) {
        vm.retrievedFileContent(fileID: vm.fileID ?? "", completion: { [weak self] result in
            switch result {
            case.success:
                print(self?.vm.models?.data.count ?? 0)
            case.failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    @IBAction func listFileButtonDidTab(sender: UIButton) {
        self.getFiles()
    }
    @IBAction func deleteFileButtonDidTab(sender: UIButton) {
        vm.deleteFile(fileID: vm.fileID ?? "", completion: { [weak self] result in
            switch result {
            case.success:
                print(self?.vm.models?.data.count ?? 0)
            case.failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    func getFiles() {
        vm.getFilesList(completion: { [weak self] result in
            
            switch result {
            case.success:
                print(self?.vm.models?.data.count ?? 0)
            case.failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
    func uploadFile() {
        if let fileURL = Bundle.main.url(forResource: "mj_test_dataset_2", withExtension: "jsonl") {
            vm.uploadFile(fileURL: fileURL, purpose: "fine-tune", completion: { [weak self] result in
                switch result {
                case.success(_):
                    print("fileName:\(String(describing: self?.vm.model?.filename))fileID:\(self?.vm.model?.id)")
                    print(self?.vm.fileID ?? "")
                case.failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        
    }
    

}
