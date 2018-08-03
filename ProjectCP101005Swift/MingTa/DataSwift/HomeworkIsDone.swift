//
//  HomeworkIsDone.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/6/6.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.


import Foundation

struct HomeworkIsDone:Codable ,CustomStringConvertible {
    var description: String {

        return "id: \(id ?? 0), subjectId: \(subjectId ?? 0), teacherId: \(teacherId ?? 0), classId: \(classId ?? 0), subject: \(subject ?? ""), teacher: \(teacher ?? ""), title: \(title ?? ""), content: \(content ?? ""), date: \(date ?? Date())"
    }

    var id, subjectId, teacherId, classId:Int?
    var subject, teacher, title, content:String?
    var date:Date?
    var isHomeworkDone:Bool?

}
