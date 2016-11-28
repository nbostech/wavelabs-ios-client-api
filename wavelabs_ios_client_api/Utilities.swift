//
//  Utilities.swift
//  APIStarters
//
//  Created by afsarunnisa on 6/19/15.
//  Copyright (c) 2015 NBosTech. All rights reserved.
//

import Foundation
import UIKit



var WAVELABS_CLIENT_ID = (Bundle.main.infoDictionary?["WavelabsAPISettings"]! as AnyObject).object(forKey: "WAVELABS_CLIENT_ID") as! String
var WAVELABS_HOST_URL = (Bundle.main.infoDictionary?["WavelabsAPISettings"]! as AnyObject).object(forKey: "WAVELABS_BASE_URL") as! String
var WAVELABS_CLIENT_SECRET = (Bundle.main.infoDictionary?["WavelabsAPISettings"]! as AnyObject).object(forKey: "WAVELABS_CLIENT_SECRET") as! String

var WAVELABS_CLIENT_ACCESS_TOKEN : String = ""

open class Utilities {

    var WAVELABS_API_HOST_URL : String = ""
    
    class func nullToNil(_ value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }

    class func isValueNull(_ value : AnyObject) -> AnyObject {
        var str : AnyObject!
        if value is NSNull {
            str = "" as AnyObject!
        }else{
            str = value
        }
        return str
    }
    
    
    open func getParams(_ paramsDict : NSDictionary) -> [String : AnyObject]{
        var parameters : [String : AnyObject] = [:]
        
        
        for index in 0 ..< paramsDict.allKeys.count {
            let keysList : NSArray = paramsDict.allKeys as NSArray
            
            let key : String = keysList.object(at: index) as! String
            let value : String = paramsDict.object(forKey: key) as! String
            
            parameters[key] = value as AnyObject
        }

        return parameters
    }

    
    open func getClientAccessToken() -> String{
        return WAVELABS_CLIENT_ACCESS_TOKEN
    }

    
    open func getUserAccessToken() -> String{
        let token: AnyObject = UserDefaults.standard.object(forKey: "access_token")! as AnyObject
        return token as! String
    }

    

}
