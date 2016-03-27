//
//  LoginViewController.swift
//  IoFood
//
//  Created by Wilson Ding on 3/27/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var transparentIcon: UIImageView!
    
    let defaultDuration = 3.0
    let defaultDamping = 0.25
    let defaultVelocity = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        animateButton()
        
        UINavigationBar.appearance().barTintColor = colorWithHexString("FF9302")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Creates a UIColor from a Hex string.
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    func animateButton() {
        transparentIcon.transform = CGAffineTransformMakeScale(0.75, 0.75)
        
        UIView.animateWithDuration(defaultDuration,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(defaultDamping),
                                   initialSpringVelocity: CGFloat(defaultVelocity),
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    self.transparentIcon.transform = CGAffineTransformIdentity
            },
                                   completion: { finished in
                                    self.animateButton()
            }
        )
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
