//
//  ClassJoin:Create.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/7/26.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation

class  Class: Codable,CustomStringConvertible {
    var description: String {
        return "name:\(name ?? ""),class:\(classID ?? 0), SubjectTeacherID:\(SubjectTeacherID ?? 0)"
    }
    
    var name:String?
    var classID,SubjectTeacherID:Int?
}

