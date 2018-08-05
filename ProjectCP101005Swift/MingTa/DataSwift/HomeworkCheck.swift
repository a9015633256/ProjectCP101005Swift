//
//  HomeworkCheck.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/8/1.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import Foundation

struct HomeworkCheck:Codable, CustomStringConvertible {
    
    var description: String {
        
        return "id: \(studentId ?? 0), studentName: \(studentName ?? ""), studentNumber: \(studentNumber ?? ""), isHomeworkDone: \(isHomeworkDone ?? false)"
    }
    
    var studentId: Int?
    var studentName, studentNumber: String?
    var isHomeworkDone:Bool?

}
