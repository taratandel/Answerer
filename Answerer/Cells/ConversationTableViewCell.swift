//
//  ConversationTableViewCell.swift
//  Answerer
//
//  Created by Tara Tandel on 5/13/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    var conversationId = ""
    var questionType = ""
    var isEnd = false

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var idOfSender: UILabel!
    @IBOutlet weak var SomePartOfTheLastMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
