//
//  SocialApi.swift
//  IOSStarter
//
//  Created by afsarunnisa on 1/29/16.
//  Copyright (c) 2016 NBosTech. All rights reserved.
//

import Foundation
import Alamofire


@objc public protocol getSocialApiResponseDelegate {
    
    @objc optional func handleLogin(_ userEntity:NewMemberApiModel)
    @objc optional func handleWebLinkLoginResponse(_ response:NSDictionary)
    
    
    @objc optional func handleMessages(_ messageCodeEntity: MessagesApiModel)
    @objc optional func handleValidationErrors(_ messageCodeEntityArray: NSArray) // multiple MessagesRespApiModel - 404(Validation errors)
    @objc optional func handleRefreshToken(_ JSON : AnyObject) // multiple MessagesRespApiModel - 404(Validation errors)
    
}


open class SocialApi {
        
    public init() {
        
    }
    
    
    var socialIdentityApiUrl : String = "api/identity/v0/auth/social/"
    
    var fbConnectUrl : String = "facebook/connect"
    var googleConnectUrl : String = "googlePlus/connect"
    var digitsLoginUrl : String = "digits/connect"
    
    var gitLoginUrl : String = "gitHub/login"
    var linkedInLoginUrl : String = "linkedIn/login"
    var instagramLoginUrl : String = "instagram/login"
    
    var utilities : Utilities = Utilities()
    
    
    open var delegate: getSocialApiResponseDelegate?
    
    open func socialLogin(_ socialLoginDetails : NSDictionary, socialType : String){
        let socialConnectUrl : String = "\(socialType)/connect"
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(socialIdentityApiUrl)\(socialConnectUrl)"
        let token: AnyObject = utilities.getClientAccessToken() as AnyObject
                
        Alamofire.request(requestUrl, method: .post, parameters: utilities.getParams(socialLoginDetails), encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
        
            switch response.result {
            case .success(let JSON):
                
                let jsonResp = JSON
                if(response.response?.statusCode == 200){
                    let userEntity : NewMemberApiModel = Communicator.userEntityFromJSON(jsonResp as AnyObject)
                    self.delegate!.handleLogin!(userEntity)
                }else if(response.response?.statusCode == 400){
                    self.validationErrorsCodes(jsonResp as AnyObject)
                }else{
                    self.messagesErrorsCodes(jsonResp as AnyObject)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        
        
        }
        
        
    }
    
    open func socialWebLogin(_ socialType : String) {
        
        
        let socialwebLinkUrl : String = "\(socialType)/login"
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(socialIdentityApiUrl)\(socialwebLinkUrl)"
        let token: AnyObject = utilities.getClientAccessToken() as AnyObject
        
        
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
            switch response.result {
            case .success(let JSON):
                
                let jsonResp = JSON
                if(response.response?.statusCode == 200){
                    let respDict : NSDictionary = Communicator.webLinkLoginFromJSON(jsonResp as AnyObject)
                    self.delegate!.handleWebLinkLoginResponse!(respDict)
                }else if(response.response?.statusCode == 400){
                    self.validationErrorsCodes(jsonResp as AnyObject)
                }else{
                    self.messagesErrorsCodes(jsonResp as AnyObject)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        
        
    }
    
    open func digitsLoginUser(_ digitsLogin : NSDictionary) {
        
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(socialIdentityApiUrl)\(digitsLoginUrl)"
        let token: AnyObject = utilities.getClientAccessToken() as AnyObject
        
        Alamofire.request(requestUrl, method: .post, parameters: utilities.getParams(digitsLogin), encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
            
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let jsonResp = JSON
                
                if(response.response?.statusCode == 200){
                    let userEntity : NewMemberApiModel = Communicator.userEntityFromJSON(jsonResp as AnyObject)
                    self.delegate!.handleLogin!(userEntity)
                }else if(response.response?.statusCode == 400){
                    self.validationErrorsCodes(jsonResp as AnyObject)
                }else{
                    self.messagesErrorsCodes(jsonResp as AnyObject)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        
        
        }
        
        
    }
    
    open func socialConnect(_ socialLoginDetails : NSDictionary, socialType : String){
        
        
        let socialConnectUrl : String = "\(socialType)/connect"
        let requestUrl = "\(WAVELABS_HOST_URL)\(socialIdentityApiUrl)\(socialConnectUrl)"
        
        let token: AnyObject = utilities.getUserAccessToken() as AnyObject
        
        Alamofire.request(requestUrl, method: .post, parameters: utilities.getParams(socialLoginDetails), encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let jsonResp = JSON
                
                if(response.response?.statusCode == 200){
                    let messageCodeEntity : MessagesApiModel = Communicator.respMessageCodesFromJson(jsonResp as AnyObject)
                    self.delegate!.handleMessages!(messageCodeEntity)
                }else if(response.response?.statusCode == 400){
                    self.validationErrorsCodes(jsonResp as AnyObject)
                }else{
                    self.messagesErrorsCodes(jsonResp as AnyObject)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        
        }        
    }
    
    open func socialWebConnect(_ socialType : String){
        
        let socialwebLinkUrl : String = "\(socialType)/login"
        let requestUrl = "\(WAVELABS_HOST_URL)\(socialIdentityApiUrl)\(socialwebLinkUrl)"
        
        let token: AnyObject = utilities.getUserAccessToken() as AnyObject        
        
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let jsonResp = JSON
                
                if(response.response?.statusCode == 200){
                    let respDict : NSDictionary = Communicator.webLinkLoginFromJSON(jsonResp as AnyObject)
                    self.delegate!.handleWebLinkLoginResponse!(respDict)
                }else if(response.response?.statusCode == 400){
                    self.validationErrorsCodes(jsonResp as AnyObject)
                }else{
                    self.messagesErrorsCodes(jsonResp as AnyObject)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        
        }
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
