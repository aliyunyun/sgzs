//
//  Cache.swift
//  tdzs
//
//  Created by xu dongming on 15/7/15.
//  Copyright (c) 2015 xu dongming. All rights reserved.
//

import Foundation

class Cache {
    private static let cacheDic = NSMutableDictionary()
        
    class func cache(key:String,obj:AnyObject) {
        cacheDic.setObject(obj, forKey: key)
    }
    class func getCache(key:String) -> AnyObject? {
        return cacheDic.objectForKey(key)
    }
    class func removeCache(key:String) {
        cacheDic.removeObjectForKey(key)
    }
    class func store(key:String,obj:AnyObject){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(obj, forKey: key)
    }
    class func get(key:String) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(key)
    }
    class func remove(key:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(key)
    }
    
    class func setToken(token:String) {
        self.store("token", obj: token)
    }
    class func removeToken() {
        self.remove("token");
    }
    
    class func token() -> String {
        
        if let tk: AnyObject = self.get("token") {
            return tk as! String
        }else{
            return ""
        }
    }
    
}
