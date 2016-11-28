//
//  AuthAPI.swift
//  IOSStarter
//
//  Created by afsarunnisa on 1/27/16.
//  Copyright (c) 2016 NBosTech. All rights reserved.
//

import Foundation
import Alamofire

@objc public protocol getAuthApiResponseDelegate {
    
    @objc optional func handleLogin(_ userEntity:NewMemberApiModel)
    @objc optional func handleLogOut(_ messageCodeEntity: MessagesApiModel)
    
    @objc optional func handleMessages(_ messageCodeEntity: MessagesApiModel)
    @objc optional func handleValidationErrors(_ messageCodeEntityArray: NSArray) // multiple MessagesRespApiModel - 404(Validation errors)
    @objc optional func handleRefreshToken(_ JSON : AnyObject) // multiple MessagesRespApiModel - 404(Validation errors)
    
    @objc optional func handleRefreshTokenResponse(_ tokenEntity : TokenApiModel)
    
    @objc optional func handleClientTokenResponse(_ tokenEntity : TokenApiModel)
    
    
    @objc optional func moveToLogin()
    
}

open class AuthApi {
    
    
    var identityApiUrl : String = "api/identity/v0/auth/"
    
    
    var loginUrl : String = "login"
    var logOutUrl : String = "logout"
    var changePswUrl : String = "changePassword"
    var forgotPswUrl : String = "forgotPassword"
    
    var refreshTokenUrl : String = "oauth/token"
    
    open var delegate: getAuthApiResponseDelegate?
    
    
    var utilities : Utilities = Utilities()
    
    
    public init() {
        
    }
    
    open func getClientToken(_ clientTokenDict : NSDictionary){
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(refreshTokenUrl)"
        
        Alamofire.request(requestUrl, method: .post, parameters: utilities.getParams(clientTokenDict), headers: nil).responseJSON {
            response in
        
        
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let jsonResp = JSON as! NSDictionary
                
                if(response.response?.statusCode == 200){
                    
                    let tokenDetails : TokenApiModel = Communicator.tokenDetailsEntity(jsonResp)
                    WAVELABS_CLIENT_ACCESS_TOKEN = tokenDetails.access_token
                    self.delegate!.handleClientTokenResponse!(tokenDetails)
                    
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
    
    open func loginUser(_ login : NSDictionary) {
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(identityApiUrl)\(loginUrl)"
        let token: AnyObject = utilities.getClientAccessToken() as AnyObject
        
        
        Alamofire.request(requestUrl, method: .post, parameters: utilities.getParams(login), headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
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
    
    open func logOut() {
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(identityApiUrl)\(logOutUrl)"
        let token: AnyObject = utilities.getUserAccessToken() as AnyObject
        
        Alamofire.request(requestUrl, method: .get, parameters: nil, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
            switch response.result {
            case .success(let JSON):
                
                let jsonResp = JSON
                
                if(response.response?.statusCode == 200){
                    let messageCodeEntity : MessagesApiModel = Communicator.respMessageCodesFromJson(jsonResp as AnyObject)
                    self.delegate!.handleLogOut!(messageCodeEntity)
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
    
    open func changePassword(_ changePsw : NSDictionary) {
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(identityApiUrl)\(changePswUrl)"
        let token: AnyObject = utilities.getUserAccessToken() as AnyObject
        
        
        Alamofire.request(requestUrl, method: .post, parameters: utilities.getParams(changePsw), encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
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
    
    open func forgotPassword(_ forgotPsw : NSDictionary) {
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(identityApiUrl)\(forgotPswUrl)"
        let token: AnyObject = utilities.getClientAccessToken() as AnyObject
        
        Alamofire.request(requestUrl, method: .post, parameters: utilities.getParams(forgotPsw), encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
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
    
    open func refreshToken() {
        
        let refreshToken: AnyObject = UserDefaults.standard.object(forKey: "refresh_token")! as AnyObject
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(refreshTokenUrl)?grant_type=refresh_token&refresh_token=\(refreshToken)&client_id=\(WAVELABS_CLIENT_ID)&scope=read"
        
        let token: AnyObject = utilities.getUserAccessToken() as AnyObject
        
        Alamofire.request(requestUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
        
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let jsonResp = JSON as! NSDictionary
                if(response.response?.statusCode == 200){
                    
                    let tokenApi : TokenApiModel = Communicator.tokenDetailsEntity(jsonResp)
                    self.delegate!.handleRefreshTokenResponse!(tokenApi)
                    
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
    
    
    open func validationErrorsCodes(_ JSON : AnyObject){
        let validationErrors : NSArray = Communicator.respValidationMessageCodesFromJson(JSON)
        self.delegate!.handleValidationErrors!(validationErrors)
    }
    
    open func messagesErrorsCodes(_ JSON : AnyObject){
        let messageCodeEntity : MessagesApiModel = Communicator.respMessageCodesFromJson(JSON)
        self.delegate!.handleMessages!(messageCodeEntity)
    }
    
}
