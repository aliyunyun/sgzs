//
//  projectCompleteViewController.swift
//  sgzs
//
//  Created by Franklin Zhang on 8/11/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

import UIKit

class projectCompleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnAction(sender: UIButton) {
        
//        let imagePhotoVC = self.storyboard?.instantiateViewControllerWithIdentifier("photoUpdataVC") as? ImagePhotoViewController
//        
//        self.navigationController?.pushViewController(imagePhotoVC!, animated: true)
        
        let workDetaileVC  = self.storyboard?.instantiateViewControllerWithIdentifier("workDetailVC") as! WorkDetailViewController;
        
      //  workDetaileVC.WorkDetailData = self.URLData[indexPath.row] as! NSDictionary
        self.navigationController?.pushViewController(workDetaileVC, animated: true)
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

}
