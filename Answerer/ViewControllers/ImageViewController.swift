//
//  ImageViewController.swift
//  Answerer
//
//  Created by Apple on 9/30/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {


    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var image: UIImageView!
    var imageContent = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = imageContent
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        // Do any additional setup after loading the view.
    }

    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
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
