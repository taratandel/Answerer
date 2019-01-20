//
//  LoginVC.swift
//  Answerer
//
//  Created by negar on 97/Farvardin/21 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UserDelegate, UITextFieldDelegate {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var indic: UIActivityIndicatorView!

    var userHelper = UserHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indic.isHidden = true
        userHelper.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: Any) {
        if usernameTF.text != nil && passwordTF.text != nil {
            self.indic.isHidden = false
            userHelper.login(userName: usernameTF.text!, password: passwordTF.text!)
        }
        else {
            ViewHelper.showToastMessage(message: "All fields are required")
        }
    }
    func userLoggedIn() {
        self.indic.isHidden = true
        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: "Logged In Succesfully")

        let chatVC = SegueHelper.createViewController(storyboardName: "Chat", viewControllerId: "ChatConversationViewController")
        let nv = UINavigationController()
        nv.viewControllers = [chatVC]
        present(nv, animated: true, completion: nil)
    }
    func userCouldNotLoggedIn(error: String) {
        self.indic.isHidden = true
        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: error)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTF {
            passwordTF.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }
        return true
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
