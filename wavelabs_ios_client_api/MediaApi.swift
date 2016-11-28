//
//  MediaApi.swift
//  IOSStarter
//
//  Created by afsarunnisa on 1/27/16.
//  Copyright (c) 2016 NBosTech. All rights reserved.
//

import Foundation
import Alamofire

@objc public protocol getMediaApiResponseDelegate {
    
    @objc optional func handleMedia(_ mediaEntity:MediaApiModel)
    
    @objc optional func handleMessages(_ messageCodeEntity: MessagesApiModel)
    @objc optional func handleValidationErrors(_ messageCodeEntityArray: NSArray) // multiple MessagesRespApiModel - 404(Validation errors)
    @objc optional func handleRefreshToken(_ JSON : AnyObject) // multiple MessagesRespApiModel - 404(Validation errors)
}


open class MediaApi {
    
    open var delegate: getMediaApiResponseDelegate?
    var apiUrl : String = "api/media/v0/"
    
    var mediaUrl : String = "media"
    
    public init() {
        
    }
    
    open func getMedia(){
        
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "user_id")
        
        let requestUrl =  "\(WAVELABS_HOST_URL)\(apiUrl)\(mediaUrl)?id=\(userID!)&mediafor=profile"
        let token: AnyObject = UserDefaults.standard.object(forKey: "access_token")! as AnyObject
        
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
            switch response.result {
            case .success(let JSON):
                let jsonResp = JSON as! NSDictionary
                
                if(response.response?.statusCode == 200){
                    let mediaApiEntity : MediaApiModel = Communicator.respMediaFromJson(jsonResp)
                    self.delegate!.handleMedia!(mediaApiEntity)
                }else if(response.response?.statusCode == 400){
                    self.validationErrorsCodes(jsonResp)
                }else{
                    self.messagesErrorsCodes(jsonResp)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        
        
    }
    
    
    open func uploadMedia(_ mediaFor : NSString, imgName: NSString,userID : NSString){
        let requestUrl = "\(WAVELABS_HOST_URL)\(apiUrl)\(mediaUrl)"
        
        let token: AnyObject = UserDefaults.standard.object(forKey: "access_token")! as AnyObject
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        
        var fileName : String = ""
        var storePath : String = ""
        var imageData : Data = Data()
        
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first {
            let imagesDirectory = (dirPath as NSString).appendingPathComponent("Images")
            
            fileName  =  NSString(format:"%@.png", userID) as String
            storePath = (imagesDirectory as NSString).appendingPathComponent(fileName)
            imageData = UIImageJPEGRepresentation(UIImage(contentsOfFile: storePath)!, 1)!
        }
        
        
        let key = "id"
        let value = userID
        
        let key1 = "mediafor"
        let value1 = mediaFor
        
        let filename = "file"
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append((value.data(using: String.Encoding.utf8.rawValue)!), withName: key)
                multipartFormData.append((value1.data(using: String.Encoding.utf8.rawValue)!), withName: key1)
                multipartFormData.append(imageData, withName: "\(filename)", fileName: imgName as String, mimeType: "image/png")
        },
            to: requestUrl,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in switch response.result {
                    case .success(let JSON):
                        
                        let jsonResp = JSON as! NSDictionary
                        
                        if(response.response?.statusCode == 200){
                            let messageCodeEntity : MessagesApiModel = Communicator.respMessageCodesFromJson(jsonResp)
                            self.delegate!.handleMessages!(messageCodeEntity)
                        }else if(response.response?.statusCode == 400){
                            self.validationErrorsCodes(jsonResp)
                        }else{
                            self.messagesErrorsCodes(jsonResp)
                        }
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                    }
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    
    
    open func validationErrorsCodes(_ JSON : AnyObject){
        let validationErrors : NSArray = Communicator.respValidationMessageCodesFromJson(JSON)
        self.delegate!.handleValidationErrors!(validationErrors)
    }
    
    open func messagesErrorsCodes(_ JSON : AnyObject){
        let messageCodeEntity : MessagesApiModel = Communicator.respMessageCodesFromJson(JSON)
        self.delegate!.handleMessages!(messageCodeEntity)
    }    
}
