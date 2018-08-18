//
//  RegisterVC.swift
//  Answerer
//
//  Created by negar on 97/Farvardin/21 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UserDelegate {

    @IBOutlet weak var password2TF: UITextField!
    @IBOutlet weak var password1TF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var indic: UIActivityIndicatorView!
    
    var userHelper = UserDefaultHelper()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indic.isHidden = true
        userHelper.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if phoneTF.text?.count == 11 && phoneTF.text != nil && emailTF.text != nil && usernameTF.text != nil{
            if password1TF.text != nil && password2TF.text != nil && password1TF.text == password2TF.text {
     
                
                userHelper.signup(userName: usernameTF.text!, password: password1TF.text!, phone: phoneTF.text!, email: emailTF.text!)
            }
            else {
                ViewHelper.showToastMessage(message: "Passwords should match")
            }
        }else {
            
            ViewHelper.showToastMessage(message: "All fields are required")
        }
        
    }
    func userLoggedIn() {
        self.indic.isHidden = true
        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: "Signed UP Succesfully")
        
        //indicator
        //segue
    }
    func userCouldNotLoggedIn(error: String) {
        self.indic.isHidden = true
        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: error)
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
