//
//  ImagePhotoViewController.swift
//  sgzs
//
//  Created by Franklin Zhang on 8/11/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

import UIKit

class ImagePhotoViewController: UIViewController {

    var isDone:Bool?
    var pointInfo:AnyObject?
    var potoView:ImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        potoView = ImageView(frame: CGRectMake(10, 60, self.view.frame.width-20, 200))
        potoView?.outVC = self
        potoView?.backgroundColor = UIColor.clearColor()
      //  potoView?.hideAdd = false
        
        self.view.addSubview(potoView!)
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    func showImage(){
        let orderInfo = Cache.getCache("orderInfo") as? NSDictionary
        let order_id = orderInfo?.objectForKey("order_id") as? String
        if self.pointInfo != nil {
            let pointDic = self.pointInfo as? NSMutableDictionary
            let point_name = pointDic?.objectForKey("point_name") as? String
            
            if point_name != nil {
                self.potoView?.orderId = order_id
                self.potoView?.pointName = point_name
                self.potoView?.imageType = 1
                
                CMD.scanOrderPointImage(order_id!, point_name: point_name!, completion: { (RSP:RSP) -> Void in
                    let dataArray = RSP.data as? NSArray
                    let imageNameArray:NSMutableArray = NSMutableArray()
                    
                    for dic in dataArray as! [NSDictionary]{
                        for  (key,value) in dic {
                            let tmpValue:String = value as! String
                            if tmpValue.rangeOfString("全景") != nil {
                                imageNameArray.addObject(key)
                            }
                        }
                    }
                    println(imageNameArray)
                    self.potoView?.loadImages(imageNameArray)
                })
            }
        }
        
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
