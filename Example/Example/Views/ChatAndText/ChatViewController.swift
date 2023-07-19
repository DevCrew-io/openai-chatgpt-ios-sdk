//
//  ChatViewController.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//
import UIKit
import OpenAIAPIManager

class ChatViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var vm: ChatViewModelProtocols!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        messageTextField.delegate = self
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        tableView.register(UINib(nibName: "AssistantCell", bundle: nil), forCellReuseIdentifier: "AssistantCell")
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add a tap gesture recognizer to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    // MARK: - Keyboard
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let safeAreaBottomInset = view.safeAreaInsets.bottom
            
            textFieldBottomConstraint.constant = -keyboardHeight + safeAreaBottomInset
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        // Unregister for keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBAction
    @IBAction func sendMessage(_ sender: UIButton) {
        if let message = messageTextField.text, !message.isEmpty {
            // Send user message to ChatGPT
            self.messageTextField.resignFirstResponder()
            sendMessageToChatGPT(message)
        }
    }
    
    // MARK: - NetworkCall
    func sendMessageToChatGPT(_ message: String) {
        
        vm.reloadTableView = {
            self.tableView.reloadData() // reload tableview to show user message
        }
        messageTextField.text = ""
        vm.sendMessage(message: message)
        vm.onSuccess = {
            self.tableView.reloadData()
            
            // Scroll to the last message
            let lastRow = (self.vm.chatMessages.count) - 1
            let indexPath = IndexPath(row: lastRow, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            EZLoadingActivity.hide(true,animated: true)
        }
        vm.onFailure = {
            DispatchQueue.main.async {
                EZLoadingActivity.hide(false,animated: true)
            }
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.vm.chatMessages[indexPath.row]
        
        let cellIdentifier = message.role == "user" ? "UserCell" : "AssistantCell"
        
        if (message.role == "user") {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserCell
            cell.configure(with: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AssistantCell
            cell.configure(with: message)
            return cell
        }
        
        
        
    }
}

// MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.vm.chatMessages[indexPath.row]
        let labelWidth = tableView.frame.width - 20 // Adjust as needed
        let labelFont = UIFont.systemFont(ofSize: 17) // Adjust font size if necessary
        let labelHeight = message.content.height(withConstrainedWidth: labelWidth, font: labelFont)
        return labelHeight + 20 // Add padding
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            sendMessageToChatGPT(textField.text ?? "")
            return false
        }
        return true
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
