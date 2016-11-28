//
//  UsersApi.swift
//  IOSStarter
//
//  Created by afsarunnisa on 1/27/16.
//  Copyright (c) 2016 NBosTech. All rights reserved.
//

import Foundation
import Alamofire

@objc public protocol getUsersApiResponseDelegate {
    
    @objc optional func handleRegister(_ userEntity:NewMemberApiModel)
    @objc optional func handleProfile(_ memberEntity:MemberApiModel)
    @objc optional func handleUpdateProfile(_ memberEntity:MemberApiModel)
    
    @objc optional func handleMessages(_ messageCodeEntity: MessagesApiModel)
    @objc optional func handleValidationErrors(_ messageCodeEntityArray: NSArray) // multiple MessagesRespApiModel - 404(Validation errors)
    @objc optional func handleRefreshToken(_ JSON : AnyObject) // multiple MessagesRespApiModel - 404(Validation errors)
}

open class UsersApi {
    
    var identityApiUrl : String = "api/identity/v0/users/"
    var rigistrationUrl : String = "signup"
    
    open var delegate: getUsersApiResponseDelegate?
    
    var utilities : Utilities = Utilities()
    
    
    public init() {
        
    }
    
    open func registerUser(_ userRegister : NSDictionary) {
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(identityApiUrl)\(rigistrationUrl)"
        let token: AnyObject = utilities.getClientAccessToken() as AnyObject
        
        Alamofire.request(requestUrl, method: .post, parameters: utilities.getParams(userRegister), encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
            switch response.result {
            case .success(let JSON):
                let jsonResp = JSON
                if(response.response?.statusCode == 200){
                    let newMemberApi : NewMemberApiModel = Communicator.userEntityFromJSON(jsonResp as AnyObject)
                    self.delegate!.handleRegister!(newMemberApi)
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
    
    open func getProfile() {
        
        let defaults = UserDefaults.standard
        var userID : String
        
        if(Utilities.nullToNil(defaults.string(forKey: "user_id") as AnyObject?) == nil){ // checking for null
            userID = ""
        }else{
            userID = defaults.string(forKey: "user_id")!
        }
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(identityApiUrl)\(userID)"
        let token: AnyObject = utilities.getUserAccessToken() as AnyObject

        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
            switch response.result {
            case .success(let JSON):
                
                let jsonResp = JSON
                if(response.response?.statusCode == 200){
                    let memberDetails : MemberApiModel = Communicator.ProfileFromJson(jsonResp as AnyObject)
                    self.delegate!.handleProfile!(memberDetails)
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
    
    open func updateProfile(_ profile : NSDictionary) {
        
        let utilities : Utilities = Utilities()
        let defaults = UserDefaults.standard
        var userID : String
        
        if(Utilities.nullToNil(defaults.string(forKey: "user_id") as AnyObject?) == nil){ // checking for null
            userID = ""
        }else{
            userID = defaults.string(forKey: "user_id")!
        }
        
        let requestUrl = "\(WAVELABS_HOST_URL)\(identityApiUrl)\(userID)"
        let token: AnyObject = utilities.getUserAccessToken() as AnyObject
        
        
        Alamofire.request(requestUrl, method: .get, parameters: utilities.getParams(profile), encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseJSON {
            response in
        
            switch response.result {
            case .success(let JSON):

                let jsonResp = JSON
                if(response.response?.statusCode == 200){
                    let memberDetails : MemberApiModel = Communicator.ProfileFromJson(jsonResp as AnyObject)
                    self.delegate!.handleUpdateProfile!(memberDetails)
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
