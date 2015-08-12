//
//  WorkDetailViewController.swift
//  sgzs
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import UIKit

class WorkDetailViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table: UITableView!
    
    var TableViewSelectedFlag = true
    
    var SectionSelectBoolArray = Array<Bool>()
    
    var testArray:NSArray?
    
    var WorkDetailData : NSDictionary = NSDictionary()
    
    var projectName:String = String()
    var progress:String = String()
    var projectNum:String = String()
    var startTime:String = String()
    var orderSignTime:String = String()
    var projectDiscription:String = String()
    var orderId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        initTitleView()
        
        getdata()
        
        //initWortData()
        initWortTestData()
        getOrderDetailInfo()
        
        SectionSelectBoolArray = [true, true, true, true]

    }
    

    
    func getdata(){
        
        testArray = ["施工人员安全措施很好很好的哦,我要弄一个超级长的来试试","弄一个不长也不短的试是","完成"]
        
            }
    
    //初始化title
    func initTitleView(){
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "施工详情"
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.hidden = false;
        let leftBtn = UIBarButtonItem(title: " 返回", style: UIBarButtonItemStyle.Plain , target: self, action: "backToTabVC");
        self.navigationItem.leftBarButtonItem = leftBtn;
        
        let rightBtn = UIBarButtonItem(title: "地图", style: UIBarButtonItemStyle.Plain, target: self, action: "conToMapViewVC")
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }

    
    func initWortData(){
     
        
        
        let project =   WorkDetailData["project_name"] as! String
         projectName = "项目名称：\(project)"
        
        let progressNumStr:String = WorkDetailData["progress"]  as! String
        let peogressNum = NSNumberFormatter().numberFromString(progressNumStr)!.intValue
        progress = "\(peogressNum)%" as String
        
        projectNum = WorkDetailData["project_num"] as! String
        
        startTime = WorkDetailData["start_time"] as! String
        
        orderSignTime = WorkDetailData["order_sign_time"] as! String
        
    
        orderId = WorkDetailData["order_id"] as? String
        
        let review_unit =  WorkDetailData["review_unit"] as? String

        let state =  WorkDetailData["state"] as? String

        let status =  WorkDetailData["status"] as? String
        
        let tag =  WorkDetailData["tag"] as? String
        
        let town =  WorkDetailData["town"] as? String

        let work_days =  WorkDetailData["work_days"] as? String
 
        println(review_unit, state,  status,  tag, town, work_days)

        
    }
    
    func initWortTestData(){
        
        projectName = "项目名称：来厚薄英潢回荡是警察粗暴瀑想啥呢东明路域或者暴力刊工"

        progress = "30%"
        
        projectNum = "XDCD123CDE31231"
        
        startTime = "2015-08-01"
        
        orderSignTime = "2015-06-01"
        
        projectDiscription = "AJSKDFJAOIJKASA工业大学朝暮林河开发区花样滑冰起草戛花园路塔顶卖萌可不好意思苫东凌上有黄鹂深树鸣"
        
        orderId = "xxxxxxx"
    }
    
    func getOrderDetailInfo(){
        if (orderId?.isEmpty != nil) {
            CMD.scanOrderPoint(orderId!, completion: { (RSP) -> Void in
                println("order = \(RSP)")
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateLabelHeight(content:String, size:CGSize)-> CGFloat{
        var height = 0
        
        let size  = UIConfig.sizeWithString(content, font: UIFont.systemFontOfSize(15), maxSize:size)
        println("\(size)")
        
        return  size.height
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            let size = CGSizeMake(self.view.frame.size.width - 90, 300)
            let heigh = calculateLabelHeight(projectName, size: size)
            println("heigh = ",heigh, indexPath.section, indexPath.row)
            return heigh + 60
        }else if indexPath.section == 1 {
            let size = CGSizeMake(self.view.frame.size.width - 20, 300)
            let heigh = calculateLabelHeight(projectDiscription, size: size)
            println("heigh = ",heigh, indexPath.section, indexPath.row)
            return heigh + 70
        }else{
            println("heigh = ", indexPath.section, indexPath.row)
            if indexPath.row == 0 {
                return 44
            }else{
                let content = testArray?.objectAtIndex(indexPath.row) as! String
                let size = CGSizeMake(80, 300)
                let heigh = calculateLabelHeight(content, size: size)
                    if heigh < 44 {
                        return 44
                    }else{
                        return heigh + 6
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((section == 0)||(section == 1)){
            
            return 1
        }else{
            
            if SectionSelectBoolArray[section] ==  true{
                let count = testArray!.count
                return count
            }
            return 1

        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        println("\(indexPath.row)")

        var cell:UITableViewCell?
        
        if (indexPath.section == 0){
            
            cell = table.dequeueReusableCellWithIdentifier("projectNameCell", forIndexPath: indexPath) as? UITableViewCell
            cell?.userInteractionEnabled = false
            initTableViewCellProjectName(cell!)
        }else if(indexPath.section == 1){
            
            cell = table.dequeueReusableCellWithIdentifier("projectNumCell", forIndexPath: indexPath) as? UITableViewCell
            cell?.userInteractionEnabled = false
            initTalbeViewCellProjectNum(cell!)
        }else{
            
            if(indexPath.row == 0){
                cell = table.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as? UITableViewCell
            }else{
                cell = table.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath) as? UITableViewCell
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                intiTableViewCellContentView(cell!)
              //  initTalbeViewCellContentCell(cell!, indexPath: indexPath)
            }
        }
        return cell!
    }
    
    
    func initTableViewCellProjectName( cell: UITableViewCell){
        
        let progressBtn = cell.viewWithTag(301) as! UIButton
        progressBtn.layer.cornerRadius = 5
        progressBtn.layer.borderWidth = 2
        progressBtn.layer.borderColor = UIColor.greenColor().CGColor
        progressBtn.layer.masksToBounds = true
        progressBtn.setTitle(progress, forState: UIControlState.Normal)
        progressBtn.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        progressBtn.userInteractionEnabled = false
        
        let projectNameLbel = cell.viewWithTag(302) as! UILabel
        projectNameLbel.text = projectName
    }
    
    func initTalbeViewCellProjectNum(cell:UITableViewCell){
        
        let projectNumLabel = cell.viewWithTag(401) as! UILabel
        projectNumLabel.text = projectNum
        
        let startTimeLabel = cell.viewWithTag(402) as! UILabel
        startTimeLabel.text = startTime
        
        let signTimeLabel = cell.viewWithTag(403) as! UILabel
        signTimeLabel.text = orderSignTime
        
        let projectDiscription = cell.viewWithTag(404) as! UILabel
        projectDiscription.text = self.projectDiscription
        
    }
    
    func intiTableViewCellContentView(cell:UITableViewCell){
        
        let doneBtn = cell.viewWithTag(205) as! UIButton
        doneBtn.layer.cornerRadius = 17
        doneBtn.layer.masksToBounds = true
        doneBtn.setTitle("D", forState: UIControlState.Normal)
        doneBtn.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)

        let startBtn = cell.viewWithTag(204) as! UIButton
        startBtn.layer.cornerRadius = 17
        startBtn.layer.masksToBounds = true
        startBtn.setTitle("SA", forState: UIControlState.Normal)
        startBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)

        let stopBtn = cell.viewWithTag(204) as! UIButton
        stopBtn.layer.cornerRadius = 17
        stopBtn.layer.masksToBounds = true
        stopBtn.setTitle("St", forState: UIControlState.Normal)
        stopBtn.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.selected = false
        
        if indexPath.section != 1 && indexPath.section != 0 && indexPath.row == 0 {
            
            SectionSelectBoolArray[indexPath.section] = !SectionSelectBoolArray[indexPath.section]
            table.reloadData()
        }
        
    }
    
    
    
    
    
    
    
    
    func StopTaskAction(sender: UIButton) {
        println("buttontag = \(sender.tag)")
    }
    
    func doneTaskAction(sender: UIButton) {
        println("buttontag = \(sender.tag)")
    }
    
    func startTaskAction(sender: UIButton){
        println("buttontag = \(sender.tag)")
        var superview:UIView? = sender.superview
        while (superview?.isKindOfClass(UITableViewCell.classForCoder()) == false){
            superview = superview?.superview
        }
    }
    
    @IBAction func contentCellStartAction(sender: UIButton) {
        let (indexpath, boolValue) = getTableViewIndexPathFromBtn(sender)
        println("buttontag = \(indexpath.section) \(indexpath.row) \(boolValue) \(sender.tag)")
    }
    
    @IBAction func contentCellTaskDoneAction(sender: UIButton) {
        let (indexpath, boolValue) = getTableViewIndexPathFromBtn(sender)
        println("buttontag = \(indexpath.section) \(indexpath.row) \(boolValue) \(sender.tag)")
    }
    
    @IBAction func contentCellTaskStopAction(sender: UIButton) {
        let (indexpath, boolValue) = getTableViewIndexPathFromBtn(sender)
        println("buttontag = \(indexpath.section) \(indexpath.row) \(boolValue) \(sender.tag)")
    }
    
    func getTableViewIndexPathFromBtn(sender: UIButton) -> (NSIndexPath, Bool ){
        
        var superView:UIView? = sender.superview
        while superView?.isKindOfClass(UITableViewCell.classForCoder()) == false {
           superView = superView?.superview
        }
        
        var indexpath:NSIndexPath?
        if let cell = superView as? UITableViewCell {
           indexpath = self.table.indexPathForCell(cell)
        }
        
        if indexpath == nil {
            return (indexpath!, false)
        }
        
        return (indexpath!, true)
    }
    
    func backToTabVC(){
        
        
        self.navigationController?.navigationBar.hidden = true;
        self.navigationController?.popViewControllerAnimated(true)
    }
    func conToMapViewVC(){
        let mapVC = self.storyboard?.instantiateViewControllerWithIdentifier("mapvc") as! UIViewController
        self.navigationController?.pushViewController(mapVC, animated:true)

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
