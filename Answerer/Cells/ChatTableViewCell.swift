//
//  ChatTableViewCell.swift
//  Answerer
//
//  Created by Tara Tandel on 6/2/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class TextChatTableViewCell: UITableViewCell {

    @IBOutlet weak var textMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ImageChatTableViewCell : UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
}
class FileChatTableViewCell: UITableViewCell {
    @IBOutlet weak var readFileButton: UIButton!
    @IBOutlet weak var nameOfTheFile: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class VoiceChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playVoiceButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
