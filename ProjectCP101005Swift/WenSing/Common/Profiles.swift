//
//  Profiles.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/7/30.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation

struct StudentsFile : Codable{
    
    var id: Int?
    var Student_Name: String?
    var Student_Gender: Int?
    var Student_Birthday: String?
    var Student_ID: String?
    var Student_Phone: Int?
    var Student_AdmissionDate: Int?
    var Student_Address: String?
    var Student_Class: Int?
    var Student_Password: String?
        enum CodingKeys: String, CodingKey{
            case id = "id"
            case Student_Name = "Student_Name"
            case Student_Gender = "Student_Gender"
            case Student_Birthday = "Student_Birthday"
            case Student_ID = "Student_ID"
            case Student_Phone = "Student_Phone"
            case Student_AdmissionDate = "Student_AdmissionDate"
            case Student_Address = "Student_Address"
            case Student_Class = "Student_Class"
            case Student_Password = "Student_Password"
    
    }
    
}

struct TeachersFile: Codable{
    var id: Int?
    var Teacher_Account: String?
    var Teacher_Password: String?
    var Teacher_Email: String?
    var Teacher_Gender: Int?
    var Teacher_Phone: String?
    var Teacher_TakeOfficeDate: String?
//    var Teacher_Subject: String?
    var Class_Name: String?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case Teacher_Account = "Teacher_Account"
        case Teacher_Password = "Teacher_Password"
        case Teacher_Email = "Teacher_Email"
        case Teacher_Gender = "Teacher_Gender"
        case Teacher_Phone = "Teacher_Phone"
        case Teacher_TakeOfficeDate = "Teacher_TakeOfficeDate"
//        case Teacher_Subject = "Teacher_Subject"
        case Class_Name = "Class_Name"
        
    }
    
}

struct AddStudent: Codable {
    var Student_ID: String?
    var Student_Password: String?
    var Student_Name: String?
    var Class_Name: String
    enum CodingKeys: String, CodingKey{
        case Student_ID = "Student_ID"
        case Student_Password = "Student_Password"
        case Student_Name = "Student_Name"
        case Class_Name = "Class_Name"
    }
}

//"id":2,"Teacher_Account":"cp102@hotmail.com","Teacher_Password":"22222","Teacher_Email":"Bob","Teacher_Gender":1,"Teacher_Phone":"0987654322","Teacher_TakeOfficeDate":"2018-04-02"}]
struct TeachersFile2: Codable{
    var id: Int?
    var Teacher_Account: String?
    var Teacher_Password: String?
    var Teacher_Email: String?
    var Teacher_Gender: Int?
    var Teacher_Phone: String?
    var Teacher_TakeOfficeDate: String?
    //    var Teacher_Subject: String?
//    var Class_Name: String?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"//0
        case Teacher_Account = "Teacher_Account"//1
        case Teacher_Password = "Teacher_Password"//2
        case Teacher_Email = "Teacher_Email"//3
        case Teacher_Gender = "Teacher_Gender"//4
        case Teacher_Phone = "Teacher_Phone"//5
        case Teacher_TakeOfficeDate = "Teacher_TakeOfficeDate"//6
        //        case Teacher_Subject = "Teacher_Subject"
//        case Class_Name = "Class_Name"
        
    }
    
}


