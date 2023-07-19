//
//  AssistantCell.swift
//  Open AI ChatGPT iOS SDK
//
//  Copyright © 2023 DevCrew I/O
//

import UIKit
import OpenAIAPIManager

class AssistantCell: UITableViewCell {
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.content
    }
    func configure(with model: ChatGPTModel) {
        messageLabel.text = model.id
    }
    
}
