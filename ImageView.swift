//
//  ImageView.swift
//  tdzs
//
//  Created by xu dongming on 21/7/15.
//  Copyright (c) 2015 xu dongming. All rights reserved.
//

import UIKit

class BtnCell: UICollectionViewCell {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame=CGRectMake(0, 0, 75.0, 75.0)
        self.addSubview(UIImageView(image: UIImage(named: "add")))
    }
}

class ImageCell:  UICollectionViewCell{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame=CGRectMake(0, 0, 75.0, 75.0)
    }
    func setImage(image:UIImage){
        let imageView = UIImageView(image: image)
        imageView.frame = CGRectMake(0, 0, 75.0, 75.0)
        self.addSubview(imageView)
    }
}

class ImageView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var outVC:UIViewController?
    var hideAdd:Bool?
    var orderId:String?
    var pointName:String?
    var imageName:String?
    var imageType:Int?
    
    let queue:dispatch_queue_t = dispatch_queue_create("imageViewQueue", nil)
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(75, 75);
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        self.registerClass(ImageCell.classForCoder(), forCellWithReuseIdentifier: "imageCell")
        self.registerClass(BtnCell.classForCoder(), forCellWithReuseIdentifier: "btnCell")
        self.dataSource = self
        self.delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    var images:NSMutableArray?
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images == nil {
            if hideAdd != nil {
                return 0
            }
            return 1
        }
        if hideAdd != nil {
            return images!.count
        }
        return images!.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var addBtnIndex:Int?
        if images == nil {
            addBtnIndex = 0
        }else {
            addBtnIndex = images!.count
        }
        if hideAdd != nil {
            addBtnIndex = -1
        }
        
        var cellName:String?
        if indexPath.row == addBtnIndex {
            cellName = "btnCell";
        }else {
            cellName = "imageCell";
        }
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellName!, forIndexPath: indexPath) as? UICollectionViewCell
        
        if indexPath.row == addBtnIndex {
        }else {
            let imageCell = cell as! ImageCell
            imageCell.setImage(images?.objectAtIndex(indexPath.row) as! UIImage)
        }
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if (cell?.isKindOfClass(BtnCell.classForCoder()) == true){
            println("add button")
            self.setPhoto()
        }
    }
    
    func setPhoto(){
        //let actionSheet = UIActionSheet("", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "拍照")
        let actionSheet:UIActionSheet = UIActionSheet(title: "请选择一种方式", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "拍照")
        actionSheet.addButtonWithTitle("从相册中选择")
        actionSheet.showInView(self)
        
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex == 0 {
            //拍照
            let imagePC = UIImagePickerController()
            imagePC.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            //imagePC.mediaTypes = [kUTTypeImage]
            imagePC.sourceType = UIImagePickerControllerSourceType.Camera
            imagePC.delegate = self
            
            if outVC != nil {
                outVC?.navigationController?.presentViewController(imagePC, animated: false, completion: nil)
            }
        }
        else if buttonIndex == 2 {
            //从相册中选择
            let imagePC = UIImagePickerController()
            imagePC.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            //imagePC.mediaTypes = [kUTTypeImage]
            imagePC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePC.delegate = self
            
            if outVC != nil {
                outVC?.navigationController?.presentViewController(imagePC, animated: false, completion: nil)
            }
        }
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(image,0.001)
        
        if images == nil {
            images = NSMutableArray()
        }
        images?.addObject(UIImage(data: imageData)!)
        self.reloadData()
        picker.dismissViewControllerAnimated(false, completion: { () -> Void in
            self.uploadImage(imageData)
        })
    }
    
    func uploadImage(imageData:NSData){
        if imageType == 1 {
            //全景图
            imageName = "全景"+self.timestamp()+".jpg"
        }else if imageType == 2 {
            //合同图
            imageName = "合同"+self.timestamp()+".jpg"
        }else {
            return
        }
        
        println("imageDataLength: \(imageData.length)")
        if pointName != nil && orderId != nil && imageName != nil {
            
            dispatch_async(self.queue, { () -> Void in
                CMD.uploadOrderPointImage(self.orderId!, point_name: self.pointName!, image_name: self.imageName!, image_data: OUtility.NSDataToHex(imageData) as String, completion: { (RSP:RSP) -> Void in
                        Utility.av("", content: RSP.message)
                })
            })
        }
    }
    
    func timestamp() -> String{
        let date = NSDate()
        return date.timeIntervalSince1970.description
    }
    
    func loadImages(imageUrls:NSArray){
        if pointName != nil && orderId != nil {
            for imageName in imageUrls as! [String] {
                let urlString = CMD.findImageUrl(orderId!, point_name: pointName!, image_name: imageName)
                //let url = urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
                println(urlString)
                self.load_image(urlString)
            }
        }
    }
    func load_image(urlString:String)
    {
        var imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    if self.images == nil {
                        self.images = NSMutableArray()
                    }
                    if data.length > 1000 {
                        self.images?.addObject(UIImage(data: data)!)
                        self.reloadData()
                    }
                    
                }
        })
        
    }
}