//
//  LoginViewController.swift
//  tdzs
//
//  Created by xu dongming on 15/7/15.
//  Copyright (c) 2015 xu dongming. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var userName: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var logImage: UIImageView!
    var name:String?
    var passWord:String?
    @IBOutlet var btn: UIButton!
 

    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()


        self.btn.layer.cornerRadius = 4
        self.btn.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func nameAction(sender: UITextField) {
        self.name = sender.text;
    }
    
    @IBAction func passwordAction(sender: UITextField) {
        self.passWord = sender.text;
    }
    

    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        self.userName.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    @IBAction func loginAction(sender: AnyObject) {
        println("name: \(name) passWord: \(passWord)")
        self.name = "18076606969"
        self.passWord = "gxtt@123456"
        if name != nil && passWord != nil {
            CMD.login(name!, passwd: passWord!, completion: { (RSP:RSP) -> Void in
                if RSP.code == "0" {
                    //successful
                    Cache.setToken(RSP.data["token"] as! String)
                    Cache.store("userInfo", obj: RSP.data)
                    let rootController = self.storyboard!.instantiateViewControllerWithIdentifier("tabVC") as! UIViewController
                    let navigationController = UINavigationController(rootViewController: rootController)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                }else {
                    //login failed
                    Utility.av("", content: RSP.message)
                    
                }
            })
        }
    }
}
