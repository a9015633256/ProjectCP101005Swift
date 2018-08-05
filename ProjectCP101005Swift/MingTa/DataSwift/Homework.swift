//
//  Homework.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/6/5.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import Foundation

struct Homework:Codable, CustomStringConvertible {
    
    var description: String {

        return "id: \(id ?? 0), subjectId: \(subjectId ?? 0), teacherId: \(teacherId ?? 0), classId: \(classId ?? 0), subject: \(subject ?? ""), teacher: \(teacher ?? ""), title: \(title ?? ""), content: \(content ?? ""), date: \(date ?? Date())"
    }
    
    var id, subjectId, teacherId, classId:Int?
    var subject, teacher, title, content:String?
    var date:Date?
    
//    init() {
//    }
//
//    init(id:Int, subject:String, teacher:String, title:String, content:String, date:Date) {
//        self.id = id;
//        self.subject = subject;
//        self.teacher = teacher;
//        self.title = title;
//        self.content = content;
//        self.date = date;
//
//    }
//
//    init(subjectId:Int, teacherId:Int, classId:Int, title:String, content:String) {
//        self.title = title;
//        self.content = content;
//        self.subjectId = subjectId;
//        self.teacherId = teacherId;
//        self.classId = classId;
//
//    }
    
}






