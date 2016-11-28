//
//  TokenApiModel.swift
//  IOSStarter
//
//  Created by afsarunnisa on 1/22/16.
//  Copyright (c) 2016 NBosTech. All rights reserved.
//

import Foundation
import UIKit


open class TokenApiModel :NSObject{
    // MARK: Properties
    open var access_token: String = ""
    open var expires_in: Int = 0
    open var refresh_token: String = ""
    open var scope: String = ""
    open var token_type: String = ""
    
}
