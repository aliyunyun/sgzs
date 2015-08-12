//
//  FirstViewController.swift
//  sgzs
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import UIKit

struct ProjDescription{
    let projName:String?
    let projSchedule:String?
    let projScheduleNum = 0
    let projPersent:String?
}


class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate {
    
   
    
    var EgoRefresh:EGORefreshTableHeaderView?
    var isLoading = false
    var URLData:NSMutableArray  = NSMutableArray()
    
    @IBOutlet var table: UITableView!
    var items:NSArray?
    var total:Int?
    var testArray = [["project_name":"test111122223334455ffggggddeccddgghhjj",
                        "progress":"50%",
                        "status":"时尚" ]]
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        
        self.initEGORefresh()
     //   self.work()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initEGORefresh(){
        self.EgoRefresh = EGORefreshTableHeaderView(frame: CGRectMake(0, 0-self.table.bounds.size.height, self.table.frame.size.width, self.table.frame.size.height))
        self.EgoRefresh?.delegate = self
        self.table.addSubview(self.EgoRefresh!)
        self.EgoRefresh?.refreshLastUpdatedDate()
        
    }
    
    func work(){

       CMD.getUserOrders{ (RSP:RSP) -> Void in
        
        self.URLData.removeAllObjects()
        
        let count = RSP.data.count
        println("count = ", count)
        let data:NSArray = RSP.data as! NSArray
        let array:NSMutableArray = NSMutableArray()
        for array in data{
            if array.count != 0 {
           // if (array.isEmpty != nil) {
                self.URLData.addObject(array)
            }
        }
        
        println("count \(self.URLData.count)")
        
         self.table.reloadData()
        
        }
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
            let dic:NSDictionary = self.URLData[indexPath.row] as! NSDictionary

            let data = dic["project_name"] as! String
            let heigh = calculateLabelHeight(data)
            if heigh < 60 {
                return 60
            }else{
                return heigh + 15 + 15 + 18
            }

    }

    func calculateLabelHeight(content:String)-> CGFloat{
        var height = 0
        
        let space = self.view.frame.size.width - (15 + 44 + 10 + 49 + 10 )
        let size  = UIConfig.sizeWithString(content, font: UIFont.systemFontOfSize(17), maxSize: CGSizeMake(space, 300)) as CGSize
    
        return  size.height
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.URLData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell" , forIndexPath: indexPath) as! UITableViewCell
        let image = UIImage(named: "login_avatar_default")
        
        let titleLabel = cell.viewWithTag(102) as! UILabel
        
        let stateLabel = cell.viewWithTag(104) as! UILabel

        let titleImage = cell.viewWithTag(101) as! UIImageView
        
        let button = cell.viewWithTag(103) as! UIButton
        
        let dic:NSDictionary = self.URLData[indexPath.row] as! NSDictionary
        let progress:String = dic["progress"]  as! String
        
        let peogressNum = NSNumberFormatter().numberFromString(progress)!.intValue
        
        let str = "\(peogressNum)%"
        titleLabel.text = (dic["project_name"] as! String)
        stateLabel.text = (dic["status"] as! String)
        titleImage.image = image
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.greenColor().CGColor
        button.layer.masksToBounds = true
        button.setTitle(str, forState: UIControlState.Normal)
        
   
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.selected = false
       // workDetailVC
        
        let workDetaileVC  = self.storyboard?.instantiateViewControllerWithIdentifier("workDetailVC") as! WorkDetailViewController;
        
        workDetaileVC.WorkDetailData = self.URLData[indexPath.row] as! NSDictionary
        self.navigationController?.pushViewController(workDetaileVC, animated: true)
        println("touch down")
        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //reloadData
    func reloadTableViewDataSource(){
        self.isLoading = true
        self.work()
        //self.table.reloadData()
    }
    
    func doneLoadingTableViewData(){
        self.isLoading = false
        self.EgoRefresh?.egoRefreshScrollViewDataSourceDidFinishedLoading(self.table)
    }
    
    //scrollview delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.EgoRefresh?.egoRefreshScrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.EgoRefresh?.egoRefreshScrollViewDidEndDragging(scrollView)
    }
    
    //egodelegate
    //下拉一定距离后触发
    func egoRefreshTableHeaderDidTriggerRefresh(view: EGORefreshTableHeaderView!) {
        self.reloadTableViewDataSource()
        
        
        let delayTime = 2.0*Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.doneLoadingTableViewData()
        }
    }
    
    func egoRefreshTableHeaderDataSourceIsLoading(view: EGORefreshTableHeaderView!) -> Bool {
        return isLoading
    }
    
    func egoRefreshTableHeaderDataSourceLastUpdated(view: EGORefreshTableHeaderView!) -> NSDate! {
        return NSDate()
    }

}
