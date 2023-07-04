//
//  ModelsListVC.swift
//  Example
//
//  Created by Ghullam Abbas on 04/07/2023.
//

import UIKit


class ModelsListVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var modelsTableView: UITableView!
    
    // MARK: - Properties
    let vm = ModelsListViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        modelsTableView.register(UINib(nibName: "AssistantCell", bundle: nil), forCellReuseIdentifier: "AssistantCell")
        vm.getModelsList(completion: { [weak self] result  in
            
            switch result {
            case.success(_ ):
                DispatchQueue.main.async {
                    self?.modelsTableView.reloadData()
                }
                
            case.failure(let error) :
                debugPrint(error)
            }
        })
        // Do any additional setup after loading the view.
    }
    
}
// MARK: - TableViewDataSource
extension ModelsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.modelsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.vm.modelsArray[indexPath.row]
        
        let cellIdentifier =  "AssistantCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AssistantCell
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ModelsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.vm.modelsArray[indexPath.row]
        let labelWidth = tableView.frame.width - 20 // Adjust as needed
        let labelFont = UIFont.systemFont(ofSize: 17) // Adjust font size if necessary
        let labelHeight = model.id.height(withConstrainedWidth: labelWidth, font: labelFont)
        return labelHeight + 20 // Add padding
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.vm.modelsArray[indexPath.row]
        self.getModelDetail(modelName: model.id)
    }
    func getModelDetail(modelName: String) {
        vm.retrieveModel(modelName: modelName, completion: { [weak self] result in
            switch result {
            case.success(_):
                DispatchQueue.main.async { [weak self] in
                    let alert = UIAlertController(title: "Model", message: "name: \(self?.vm.model?.id ?? "") object: \(self?.vm.model?.object ?? "") owned_by: \(self?.vm.model?.owned_by ?? "")", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .destructive)
                    alert.addAction(ok)
                    self?.present(alert, animated: true)
                }
            case.failure(let error):
                debugPrint(error)
            }
            
        })
    }
}


