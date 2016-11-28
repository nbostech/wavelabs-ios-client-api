//
//  MemberApiModel.swift
//  IOSStarter
//
//  Created by afsarunnisa on 1/22/16.
//  Copyright (c) 2016 NBosTech. All rights reserved.
//

import Foundation
@objc open class MemberApiModel :NSObject{
    // MARK: Properties
    
    open var desc: String = ""
    open var id: Int = 0
    open var email: String = ""
    open var firstName: String = ""
    open var lastName: String = ""
    open var phone: Int = 0
    open var userName: String = ""

    open var socialAccounts : NSArray! // Array of socail accounts    
}
