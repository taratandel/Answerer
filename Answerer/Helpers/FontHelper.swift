//
//  FontHelper.swift
//  Questioner
//
//  Created by ZoodFood Mac on 1/21/1397 AP.
//  Copyright © 1397 AP negar. All rights reserved.
//

import UIKit
class FontHelper: NSObject {

    class func getFooFont(size: CGFloat) -> UIFont! {
        let font = UIFont(name: "foo.ttf", size: size)
        return font
    }

    class func getSHOWGFont(size: CGFloat) -> UIFont! {
        let font = UIFont(name: "SHOWGF.ttf", size: size)
        return font
    }

}

