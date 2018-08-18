//
//  ResetPasswordVC.swift
//  Answerer
//
//  Created by negar on 97/Farvardin/21 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController, UserDelegate {

    @IBOutlet weak var password2TF: UITextField!
    @IBOutlet weak var password1TF: UITextField!
    var userHelper = UserDefaultHelper()
    
    @IBOutlet weak var indic: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indic.isHidden = true
        userHelper.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        if password1TF.text != nil && password1TF.text?.count == 11 && password2TF != nil {
            self.indic.isHidden = false
            userHelper.rsetPass(phone: password1TF.text!, password: password2TF.text!)
            
        }else {
            
            ViewHelper.showToastMessage(message: "All fields required")
        }
        
    }
    func userLoggedIn() {
        self.indic.isHidden = true
        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: "Reset successfully")
        // indicator segue
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
