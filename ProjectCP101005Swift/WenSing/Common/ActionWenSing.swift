//
//  Action.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/7/30.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation

struct GetStudentInfo : Codable {
    var action: String?
//    var id: String?
    var id: StudentsFile
}

struct GetStudentList : Codable {
    var action: String?
    var Class_Name: String
}

struct GetTeacherInfo : Codable {
    var action: String?
//    var id: String?
    var id: TeachersFile
    
}

struct GetTeacherList : Codable {
    var action: String?
    var Class_Name: String
}

struct GetImageAction : Codable{
    var action : String?
    var id : Int
    var imageSize : Int
}

struct DeleteStudent: Codable {
    var action: String?
    var students: Int
}

struct DeleteTeacher: Codable {
    var action: String?
    var teacherList: Int
}

struct FindStudentById: Codable {
    var action: String?
    var id: Int
}

struct AddNewStudentAccount: Codable {
    var action: String?
    var Student_ID: String?
    var Student_Password: String?
    var Student_Name: String?
    var Class_Name: String?
    
}

struct FindTeacherFile: Codable {
    var action: String?
    var Teacher_Account: String
    
}

struct JoinTeacherToClass: Codable {
    var action: String?
    var Class_Name: Int
    var Class_SubjectTeacher: Int
}

struct UpdateTeacherProfile: Codable {
    var action: String?
    var teacherList: TeachersFile
    var Teacher_Photo: Data?
}


