//
//  MediaApiModel.swift
//  IOSStarter
//
//  Created by afsarunnisa on 1/22/16.
//  Copyright (c) 2016 NBosTech. All rights reserved.
//

import Foundation

@objc open class MediaApiModel:NSObject {
    // MARK: Properties
    open var mediaExtension : String = ""
    open var supportedsizes : String = ""
    
    open var mediaFileDetailsList : NSArray!
}
