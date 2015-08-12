
//
//  CMD.swift
//  tdzs
//
//  Created by xu dongming on 14/7/15.
//  Copyright (c) 2015 xu dongming. All rights reserved.
//
import Alamofire
import Foundation
import AFNetworking

public class RSP {
    public let code:String
    public let message:String
    public let data:AnyObject
    
    private init(code:String,message:String,data:AnyObject){
        self.code = code
        self.message = message
        self.data = data
    }
}

class CMD {
    
    static let API_URL = "http://221.7.213.104:9090/api/ttapi"
    static let IMAGE_URL = "http://221.7.213.104:9090/find_image?"
    
    class private func request(body:[String : AnyObject],completion:(RSP:RSP) -> Void){
//        Alamofire.request(.POST, CMD.API_URL, parameters: body as [String : AnyObject], encoding: .JSON)
//            .responseJSON { (_, _, JSON, _) in
//                println("##DEBUG RESPONSE BEGIN##")
//                println(JSON)
//                println("##DEBUG RESPONSE END##")
//                
//                if JSON == nil {
//                    return
//                }
//                var dic = JSON as! NSDictionary
//                let code = dic["code"] as! String
//                let message = dic["message"] as! String
//                var data: AnyObject? = dic["data"]
//                
//                let rsp = RSP(code: code, message: message, data: data!)
//                completion(RSP: rsp)
//        }
        Utility.hudShow("操作进行中...")
        
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL)
        let data = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: nil)
        let length = data?.length.description
        request.HTTPMethod="POST"
        request.HTTPBody=data
        request.timeoutInterval = 180000
        request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let op = AFHTTPRequestOperation(request: request)
        op.responseSerializer = AFJSONResponseSerializer()
        op.responseSerializer.acceptableContentTypes=NSSet(object: "text/plain") as Set<NSObject>
        op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, JSON:AnyObject!) -> Void in
                Utility.hudHide()
                println("JSON: " + JSON.description)
                if JSON == nil {
                    return
                }
                var dic = JSON as! NSDictionary
                let code = dic["code"] as! String
                let message = dic["message"] as! String
                var data: AnyObject? = dic["data"]
            
                let rsp = RSP(code: code, message: message, data: data!)
                completion(RSP: rsp)
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("Error: " + error.description)
                Utility.hudHide()
                Utility.av("错误", content: "网络错误")
        })
        op.start()
    }
    
    class private func cmdPackage(cmd:String,cmdBody:String) ->[String : AnyObject]{
        let package = [
            "version": "1",
            "cmd":cmd,
            "cmdbody": cmdBody
        ]
        return package
    }
    
    //LOGIN
    class func login(userName:String,passwd:String,completion:(RSP:RSP) -> Void){
        let cmdBody = [
            "phone_number":userName,
            "password":passwd
        ]
        
        let data = NSJSONSerialization.dataWithJSONObject(cmdBody, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("user_login", cmdBody: dataString as! String)
        self.request(package, completion: completion)
    }
    
    //LOGOUT
    class func logout(completion:(RSP:RSP) -> Void){
        let cmdBody = [
            "token":Cache.token(),
        ]
        
        let data = NSJSONSerialization.dataWithJSONObject(cmdBody, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("user_logout", cmdBody: dataString as! String)
        self.request(package, completion: completion)
    }
    
    //SCAN ORDER
    class func scanOrder(page:String,size:String,state:String,city:String, town:String,completion:(RSP:RSP) -> Void) {
        let cmdBody = [
            "token":Cache.token(),
            "order_type":"shigong",
            "page":page,
            "size":size,
            "state":state,
            "city":city,
            "town":town
        ]

        let data = NSJSONSerialization.dataWithJSONObject(cmdBody, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("scan_order", cmdBody: dataString as! String)
        self.request(package, completion: completion)
    }
    
    //GET USER ORDER
    class func getUserOrders(completion:(RSP:RSP) -> Void) {
        let cmdBody = [
            "token":Cache.token(),
            "order_type":"shigong",
            "is_done":"0"
        ]
        
        let data = NSJSONSerialization.dataWithJSONObject(cmdBody, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("get_user_orders", cmdBody: dataString as! String)
        self.request(package, completion: completion)
    }
    
    //GET ORDER WORKS
    class func getOrderWorks(orderId:String, completion:(RSP:RSP)->Void){
        let cmdBody = [
            "token":Cache.token(),
            "order_type":"shigong",
            "order_id":orderId
        ]
        let data = NSJSONSerialization.dataWithJSONObject(cmdBody, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("get_order_works", cmdBody: dataString as! String)
        self.request(package, completion: completion)
        
    }
    
    //SCAN ORDER POINT
    class func scanOrderPoint(order_id:String,completion:(RSP:RSP) -> Void) {
        let cmdBody = [
            "token":Cache.token(),
            "order_id":order_id,
        ]
        
        let data = NSJSONSerialization.dataWithJSONObject(cmdBody, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("scan_order_point", cmdBody: dataString as! String)
        self.request(package, completion: completion)
    }
    
    //Update Order Info
    class func updateOrderInfo(order_id:String,key:String,value:String,completion:(RSP:RSP) -> Void){
        
        let dic = NSMutableDictionary()
        dic.setObject(Cache.token(), forKey: "token")
        dic.setObject(order_id, forKey: "order_id")
        dic.setObject(value, forKey: key)
        
        let data = NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("update_order_info", cmdBody: dataString as! String)
        self.request(package, completion: completion)
    }
    
    //Update ORDER POINT
    class func updateOrderPoint(order_id:String,infoDic:NSMutableDictionary,completion:(RSP:RSP) -> Void) {
        infoDic.setObject(Cache.token(), forKey: "token")
        infoDic.setObject(order_id, forKey: "order_id")
        
        let data = NSJSONSerialization.dataWithJSONObject(infoDic, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("update_order_point", cmdBody: dataString as! String)
        self.request(package, completion: completion)
    }
    
    //Upload Order Point Image
    class func uploadOrderPointImage(order_id:String,point_name:String,image_name:String,image_data:String,completion:(RSP:RSP) -> Void) {
        println("image_data length: \(image_data.lengthOfBytesUsingEncoding(1))")
        let cmdBody = [
            "token":Cache.token(),
            "order_id":order_id,
            "point_name":point_name,
            "image_name":image_name,
            "image_data":image_data
        ]
        
        let data = NSJSONSerialization.dataWithJSONObject(cmdBody, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("upload_order_point_image", cmdBody: dataString as! String)
        self.request(package, completion: completion)
    }
    
    //Find Order Point Image
    class func scanOrderPointImage(order_id:String,point_name:String,completion:(RSP:RSP) -> Void){
        let cmdBody = [
            "token":Cache.token(),
            "order_id":order_id,
            "point_name":point_name
        ]
        
        let data = NSJSONSerialization.dataWithJSONObject(cmdBody, options: nil, error: nil)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let package = cmdPackage("scan_order_point_image", cmdBody: dataString as! String)
        self.request(package, completion: completion)
    }
    
    //Find Image
    class func findImageUrl(order_id:String,point_name:String,image_name:String) -> String {
        let urlPointName = point_name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        return IMAGE_URL+"token="+Cache.token()+"&order_id="+order_id+"&point_name="+urlPointName!+"&image_name="+image_name
    }
}


