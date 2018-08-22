
//
//  ChatViewController.swift
//  Answerer
//
//  Created by Tara Tandel on 6/1/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var viewBotton: NSLayoutConstraint!
    
    @IBOutlet weak var chatTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTextView.layer.cornerRadius = 4.0
        chatTextView.layer.borderWidth = 2
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func keyboardWillShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.viewBotton.constant = keyboardHeight * -1
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
