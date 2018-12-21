//
//  WelcomViewController.swift
//  Answerer
//
//  Created by Tara Tandel on 7/30/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import Foundation

class WelcomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults()
        if defaults.object(forKey: "TeacherData") != nil{
            let vc = SegueHelper.createViewController(storyboardName: "Chat", viewControllerId: "ChatConversationViewController")
            SegueHelper.presentViewController(sourceViewController: self, destinationViewController: vc)
        }else {
            performSegue(withIdentifier: "ToLoginView", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
