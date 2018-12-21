//
//  SegueHelper.swift
//  Answerer
//
//  Created by Tara Tandel on 7/30/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class SegueHelper: NSObject {

    class func createViewController(storyboardName: String, viewControllerId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        return viewController
    }

    class func pushViewController(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
    }

    class func pushViewControllerWithoutAnimation(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: false)
    }

    class func presentViewController(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        sourceViewController.present(destinationViewController, animated: true, completion: nil)
    }

}
