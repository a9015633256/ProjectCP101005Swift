//
//  Account.swift
//  ProjectCP101005Swift
//
//  Created by 涂文鴻 on 2018/8/1.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation

struct Account: Codable {
    var name : String
    var password : String
}

struct IsUserValid: Codable{
    var isUserValid = false
    var id = 0
    var subject = 0
    
    
}


