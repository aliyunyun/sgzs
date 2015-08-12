//
//  Utility.swift
//  tdzs
//
//  Created by xu dongming on 15/7/15.
//  Copyright (c) 2015 xu dongming. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class Utility {
    static var hud:MBProgressHUD?
    
    class func av(title:String,content:String){
        let av = UIAlertView(title: title, message: content, delegate: nil, cancelButtonTitle: "关闭")
        av.show()
    }
    
    class func hudShow(msg:String){
        let window =  UIApplication.sharedApplication().keyWindow
        if self.hud == nil {
            hud = MBProgressHUD(window: window)
        }
        window?.addSubview(self.hud!)
        self.hud?.detailsLabelText = msg
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.hud?.show(true)
        })
    }
    
    class func hudHide() {
        let window =  UIApplication.sharedApplication().keyWindow
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideAllHUDsForView(window, animated: true)
        })
    }
}