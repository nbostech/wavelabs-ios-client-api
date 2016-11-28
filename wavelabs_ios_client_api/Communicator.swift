//
//  Communicator.swift
//  IOSStarter
//
//  Created by afsarunnisa on 1/27/16.
//  Copyright (c) 2016 NBosTech. All rights reserved.
//

import Foundation
class Communicator {
    
    
    
    class func userEntityFromJSON(_ JSONdata : AnyObject) -> NewMemberApiModel{
        
        let userEntity = NewMemberApiModel()
        var tokenDetails : NSDictionary!
        var memberDetails : NSDictionary!
        
        if(JSONdata.object(forKey: "token") != nil){
            tokenDetails = JSONdata.object(forKey: "token") as! NSDictionary
        }
        
        if(JSONdata.object(forKey: "member") != nil){
            memberDetails = JSONdata.object(forKey: "member") as! NSDictionary
        }
        
        if(tokenDetails != nil && memberDetails != nil){
            
            let tokenEntity : TokenApiModel = self.tokenDetailsEntity(tokenDetails)
            let memberEntity : MemberApiModel = self.memberDetailsEntity(memberDetails)
            
            userEntity.tokenApiModel = tokenEntity
            userEntity.memberApiModel = memberEntity
        }
        
        return userEntity
    }
    
    
    
    class func tokenDetailsEntity(_ tokenDetails: NSDictionary) -> TokenApiModel{
        
        let tokenEntity = TokenApiModel()
        
        if(tokenDetails.object(forKey: "access_token") != nil){
            tokenEntity.access_token = Utilities.isValueNull(tokenDetails.object(forKey: "access_token")! as AnyObject) as! String
        }
        
        if(tokenDetails.object(forKey: "expires_in") != nil){
            tokenEntity.expires_in = Utilities.isValueNull(tokenDetails.object(forKey: "expires_in")! as AnyObject) as! Int
        }
        
        if(tokenDetails.object(forKey: "refresh_token") != nil){
            tokenEntity.refresh_token = Utilities.isValueNull(tokenDetails.object(forKey: "refresh_token")! as AnyObject) as! String
        }
        
        if(tokenDetails.object(forKey: "scope") != nil){
            tokenEntity.scope = Utilities.isValueNull(tokenDetails.object(forKey: "scope")! as AnyObject) as! String
        }
        
        
        if(tokenDetails.object(forKey: "token_type") != nil){
            tokenEntity.token_type = Utilities.isValueNull(tokenDetails.object(forKey: "token_type")! as AnyObject) as! String
        }
        
        return tokenEntity
    }
    
        
    
    class func memberDetailsEntity(_ memberDetails: NSDictionary) -> MemberApiModel{
        
        let socialActAry : NSMutableArray = NSMutableArray()
        let socialActs : NSArray = memberDetails.object(forKey: "socialAccounts") as! NSArray
        
        for i in 0 ..< socialActs.count {
            
            let socialActsEntity = SocialApiModel()
            
            let dict : NSDictionary = socialActs.object(at: i) as! NSDictionary
            
            socialActsEntity.email = Utilities.isValueNull(dict.object(forKey: "email")! as AnyObject) as! String
            socialActsEntity.id = Utilities.isValueNull(dict.object(forKey: "id")! as AnyObject) as! Int
            socialActsEntity.imageUrl = Utilities.isValueNull(dict.object(forKey: "imageUrl")! as AnyObject) as! String
            socialActsEntity.socialType = Utilities.isValueNull(dict.object(forKey: "socialType")! as AnyObject) as! String
            
            socialActAry.add(socialActsEntity)
        }
        
        let memberEntity = MemberApiModel()
        
        memberEntity.desc = Utilities.isValueNull(memberDetails.object(forKey: "description")! as AnyObject) as! String
        memberEntity.email = Utilities.isValueNull(memberDetails.object(forKey: "email")! as AnyObject) as! String
        memberEntity.firstName = Utilities.isValueNull(memberDetails.object(forKey: "firstName")! as AnyObject) as! String
        memberEntity.id = Utilities.isValueNull(memberDetails.object(forKey: "id")! as AnyObject) as! Int
        memberEntity.lastName = Utilities.isValueNull(memberDetails.object(forKey: "lastName")! as AnyObject) as! String
        memberEntity.phone = Utilities.isValueNull(memberDetails.object(forKey: "phone")! as AnyObject) as! Int
        memberEntity.socialAccounts = socialActAry as NSArray
        
        return memberEntity
    }
    
    
    
    class func webLinkLoginFromJSON(_ JSONdata : AnyObject) -> NSDictionary{
        return JSONdata as! NSDictionary
    }
    
    
    
    class func respMediaFromJson(_ JSONdata : AnyObject) -> MediaApiModel {
        let mediaApi = MediaApiModel()
        
        mediaApi.mediaExtension = Utilities.isValueNull(JSONdata.object(forKey: "extension")! as AnyObject) as! String
        mediaApi.supportedsizes = Utilities.isValueNull(JSONdata.object(forKey: "supportedsizes")! as AnyObject) as! String
        
                
        let mediaDetailsList : NSMutableArray = NSMutableArray()
        let mediaDetails : NSArray = JSONdata.object(forKey: "mediaFileDetailsList") as! NSArray
        
        for i in 0 ..< mediaDetails.count {
            
            let mediaFileDetails = MediaFileDetailsApiModel()
            
            let dict : NSDictionary = mediaDetails.object(at: i) as! NSDictionary
            
            mediaFileDetails.mediapath = Utilities.isValueNull(dict.object(forKey: "mediapath")! as AnyObject) as! String
            mediaFileDetails.mediatype = Utilities.isValueNull(dict.object(forKey: "mediatype")! as AnyObject) as! String
            
            mediaDetailsList.add(mediaFileDetails)
        }
        
        mediaApi.mediaFileDetailsList = mediaDetailsList
        
        return mediaApi
    }
    
    
    class func ProfileFromJson(_ JSONdata : AnyObject) -> MemberApiModel {
        var memberEntity : MemberApiModel!
        memberEntity = self.memberDetailsEntity(JSONdata as! NSDictionary)
        return memberEntity
    }

    
    class func respMessageCodesFromJson(_ JSONdata : AnyObject) -> MessagesApiModel {
        
        let messagesEntity = MessagesApiModel()
        
        if(JSONdata.object(forKey: "message") != nil){
            
            messagesEntity.message = Utilities.isValueNull(JSONdata.object(forKey: "message")! as AnyObject) as! String
            messagesEntity.messageCode = Utilities.isValueNull(JSONdata.object(forKey: "messageCode")! as AnyObject) as! String
        }
        
        if(JSONdata.object(forKey: "error") != nil){
            messagesEntity.message = Utilities.isValueNull(JSONdata.object(forKey: "error_description")! as AnyObject) as! String
            messagesEntity.messageCode = Utilities.isValueNull(JSONdata.object(forKey: "error")! as AnyObject) as! String
        }
        
        return messagesEntity
    }
    
    
    class func respValidationMessageCodesFromJson(_ JSONdata : AnyObject) -> NSArray {
        
        let validationArray : NSMutableArray = NSMutableArray()
        var errorsDict : NSDictionary!
        
        
        if(JSONdata.object(forKey: "errors") != nil){
            let errorsArray : NSArray = JSONdata.object(forKey: "errors") as! NSArray
            
            for i in 0 ..< errorsArray.count {
                errorsDict = errorsArray.object(at: i) as! NSDictionary
                let messagesEntity = ValidationMessagesApiModel()
                
                messagesEntity.message = Utilities.isValueNull(errorsDict.object(forKey: "message")! as AnyObject) as! String
                messagesEntity.messageCode = Utilities.isValueNull(errorsDict.object(forKey: "messageCode")! as AnyObject) as! String
                messagesEntity.objectName = Utilities.isValueNull(errorsDict.object(forKey: "objectName")! as AnyObject) as! String
                messagesEntity.propertyName = Utilities.isValueNull(errorsDict.object(forKey: "propertyName")! as AnyObject) as! String

                validationArray.add(messagesEntity)
            }
        }else{
            errorsDict = JSONdata as! NSDictionary
            
            let messagesEntity = MessagesApiModel()
            messagesEntity.message = Utilities.isValueNull(JSONdata.object(forKey: "message")! as AnyObject) as! String
            messagesEntity.messageCode = Utilities.isValueNull(JSONdata.object(forKey: "messageCode")! as AnyObject) as! String
            validationArray.add(messagesEntity)
        }
        return validationArray
    }
    
}
