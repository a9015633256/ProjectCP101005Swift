//
//  Student.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/24.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import Foundation

struct Student:Codable, CustomStringConvertible {
    
    var description: String {

        return "id: \(id ?? 0), classId: \(classId ?? 0), gender: \(gender ?? 0), name: \(name ?? ""), phoneNumber: \(phoneNumber ?? ""), address: \(address ?? ""), className: \(className ?? ""), studentNumber: \(studentNumber ?? ""), dayOfBirth: \(dayOfBirth ?? Date())"
    }
    
    var id, gender, classId: Int?
    
    var name,phoneNumber,address,className, studentNumber: String?
    
    var dayOfBirth: Date?
    
    
}





//public class Student implements Serializable{
//
//
//
//    public Student(int id, int gender, String studentNumber, int classId, String name, String phoneNumber, String address,
//    Date dayOfBirth) {
//        super();
//        this.id = id;
//        this.gender = gender;
//        this.studentNumber = studentNumber;
//        this.classId = classId;
//        this.name = name;
//        this.phoneNumber = phoneNumber;
//        this.address = address;
//        this.dayOfBirth = dayOfBirth;
//    }
//
//    //顯示學生資訊用
//    public Student(int id, int gender, String studentNumber, String className, String name, String phoneNumber, String address,
//    Date dayOfBirth) {
//        super();
//        this.id = id;
//        this.gender = gender;
//        this.studentNumber = studentNumber;
//        this.className = className;
//        this.name = name;
//        this.phoneNumber = phoneNumber;
//        this.address = address;
//        this.dayOfBirth = dayOfBirth;
//    }
//
//    public Student(int id, String studentNumber, Date dayOfBirth) {
//        super();
//        this.id = id;
//        this.studentNumber = studentNumber;
//        this.dayOfBirth = dayOfBirth;
//    }
//
//
//    public String getClassName() {
//        return className;
//    }
//
//    public void setClassName(String className) {
//        this.className = className;
//    }
//
//    public int getId() {
//        return id;
//    }
//
//    public void setId(int id) {
//        this.id = id;
//    }
//
//    public int getGender() {
//        return gender;
//    }
//
//    public void setGender(int gender) {
//        this.gender = gender;
//    }
//
//    public String getStudentNumber() {
//        return studentNumber;
//    }
//
//    public void setStudentNumber(String studentNumber) {
//        this.studentNumber = studentNumber;
//    }
//
//    public int getClassId() {
//        return classId;
//    }
//
//    public void setClassId(int classId) {
//        this.classId = classId;
//    }
//
//    public String getName() {
//        return name;
//    }
//
//    public void setName(String name) {
//        this.name = name;
//    }
//
//    public String getPhoneNumber() {
//        return phoneNumber;
//    }
//
//    public void setPhoneNumber(String phoneNumber) {
//        this.phoneNumber = phoneNumber;
//    }
//
//    public String getAddress() {
//        return address;
//    }
//
//    public void setAddress(String address) {
//        this.address = address;
//    }
//
//    public Date getDayOfBirth() {
//        return dayOfBirth;
//    }
//
//    public void setDayOfBirth(Date dayOfBirth) {
//        this.dayOfBirth = dayOfBirth;
//    }
//}

