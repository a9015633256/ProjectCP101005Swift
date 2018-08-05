//
//  Action.swift
//  ProjectCP101005Swift
//
//  Created by 涂文鴻 on 2018/8/1.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation

struct Action: Codable {
    var action : String?
    var name: String?
    var password: String?
}

struct GetClass: Codable  {
    var action: String?
    var name: String?
}
struct Register: Codable{
    var action : String?
    var account: String?
    var password: String?
    var name: String?
    var phone: String?
    var gender: Int?
    var birthday: String?
    var subject: String?
}

struct deleteClass: Codable{
    var action: String?
    var classname: String?
    var teachername: String?
    
}
