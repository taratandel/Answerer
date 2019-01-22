//
//  ChatTableViewCell.swift
//  Answerer
//
//  Created by Tara Tandel on 6/2/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class TextChatTableViewCell: UITableViewCell {

    @IBOutlet weak var timeStamp: UILabel!
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
    var message = Chat()
    var parentVC = ChatViewController()

    @IBAction func loadData(_ sender: Any) {
        let imageVC = SegueHelper.createViewController(storyboardName: "Chat", viewControllerId: "imagePreview") as! ImageViewController
        imageVC.imageContent = imageCell.image!
        SegueHelper.presentViewController(sourceViewController: parentVC, destinationViewController: imageVC)
    }

    func showImage() {
        if message.image.count == 0{
            imageCell.image = UIImage(named: "noImg")
        }else{
            do {
                let url = URL(string: message.image)
                let data = try Data(contentsOf: url!)
                self.imageCell.image = UIImage(data: data)
            }catch{
                imageCell.image = UIImage(named: "noImg")
            }
        }
    }

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

protocol ContactAndVoiceMessageCellProtocol: class {
    func cellDidTapedVoiceButton(_ cell: VoiceChatTableViewCell, isPlayingVoice: Bool, index: Int)
}

class VoiceChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playVoiceButton: UIButton!
    weak var delegate: ContactAndVoiceMessageCellProtocol?
    weak var parentVeiwController: ChatViewController?

    var message = Chat()
    var indexpathraw = Int()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func resetVoiceAnimation(audioPlayStatus: AudioPlayerStatus) {

        switch audioPlayStatus {
        case .start:
            playVoiceButton.setTitle("playing", for: .selected)
        case .finished:
            playVoiceButton.setTitle("Play Voice", for: .normal)
            playVoiceButton.isSelected = false
        case .failed:
            ViewHelper.showToastMessage(message: "Unable to play sound")
        default:
            playVoiceButton.setTitle("Play Voice", for: .normal)
            playVoiceButton.isSelected = false
        }
    }
    @IBAction func playVoice(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let delegate = self.delegate else { return }
        delegate.cellDidTapedVoiceButton(self, isPlayingVoice: sender.isSelected, index: indexpathraw)
    }
}
