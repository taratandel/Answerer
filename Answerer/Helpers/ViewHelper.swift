//
//  ViewHelper.swift
//  Answerer
//
//  Created by Tara Tandel on 1/21/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
//
//  ViewHelper.swift
//  Questioner
//
//  Created by negar on 97/Farvardin/05 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import UIKit

class ViewHelper {
    class func MakeShadowView(frame: CGRect, color: UIColor, opacity: Float, radius: CGFloat) -> UIView {

        let shadowView = UIView(frame: frame)
        shadowView.backgroundColor = color
        shadowView.layer.opacity = opacity
        shadowView.layer.cornerRadius = radius;
        return shadowView
    }
    class func showToastMessage(message: String) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let holder = UIView(frame: CGRect.zero)
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = FontHelper.getFooFont(size: 13)
        label.adjustsFontSizeToFitWidth = true
        holder.backgroundColor = UIColor.black
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3

        holder.frame = CGRect(x: 0, y: -64, width: appDelegate.window!.frame.size.width, height: 64)
        label.frame = CGRect(x: 0, y: 20, width: appDelegate.window!.frame.size.width, height: 44)

        label.alpha = 1
        holder.addSubview(label)
        appDelegate.window!.addSubview(holder)
        //        appDelegate.window!.addSubview(label)

        var basketTopFrame = holder.frame
        basketTopFrame.origin.y = 0
        //        basketTopFrame.origin.x = 0

        UIView.animate(withDuration
            : 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                    //                label.frame = basketTopFrame
                    holder.frame = basketTopFrame
            }, completion: {
                    (value: Bool) in
                UIView.animate(withDuration: 1.0, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                        holder.frame = CGRect(x: 0, y: -64, width: appDelegate.window!.frame.size.width, height: 64)
                    }, completion: {
                            (value: Bool) in
                            holder.removeFromSuperview()
                        })
            })
    }

}
