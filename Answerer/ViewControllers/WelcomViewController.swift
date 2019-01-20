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

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let defaults = UserDefaults()
        if defaults.object(forKey: "TeacherData") != nil {
            let chatVC = SegueHelper.createViewController(storyboardName: "Chat", viewControllerId: "ChatConversationViewController")
            let nv = UINavigationController()
            nv.viewControllers = [chatVC]
            present(nv, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "ToLoginView", sender: self)
        }
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
