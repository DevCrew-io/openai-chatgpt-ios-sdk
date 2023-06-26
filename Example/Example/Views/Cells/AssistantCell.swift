//
//  AssistantCell.swift
//  Example
//
//  Created by Ghullam Abbas on 19/06/2023.
//

import UIKit

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
    
}
