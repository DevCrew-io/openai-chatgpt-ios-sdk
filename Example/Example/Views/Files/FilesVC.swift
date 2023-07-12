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
        self.getFiles()
    }
    
    func getFiles() {
        vm.getFilesList(completion: { [weak self] result in
            
            switch result {
            case.success:
                print(self?.vm.model?.data.count ?? 0)
            case.failure(let error):
                print(error.localizedDescription)
            }
            
        })
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
