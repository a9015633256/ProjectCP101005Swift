//
//  CommonURL.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/7/20.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation

//let BASE_URL_WEN_SING = "http://10.0.2.2:8080/SchoolConnectionBook/"
let BASE_URL_WEN_SING = "http://localhost:8080/SchoolConnectionBook/"

let STUDENT_SERVLET = BASE_URL_WEN_SING + "StudentServlet"
let STUDENT_ACCOUNT_SERVLET = BASE_URL_WEN_SING + "StudentAccountServlet"
let TEACHER_LIST_SERVLET = BASE_URL_WEN_SING + "TeachersListServerlet"

let ACTION_GET_TEACHER_LIST = "findTeachers"
let ACTION_GET_STUDENT_LIST = "findStudents"
let ACTION_FIND_STUDENT_BY_ID = "findById"
let ACTION_ADD_STUDENT = "insert"
let ACTION_GET_TEACHER_FILE = "findById"
let ACTION_JOIN_TEACHER_TO_CLASS = "SubjectTeacherInsert"
let ACTION_UPDATE_PROFILE = "update"


let ACTION_GET_ALL = "getAll"
let ACTION_GET_IMAGE = "getImage"

let ACTION_DELETE_STUDENT = "studentsDeleteid"
let ACTION_DELETE_TEACHER = "delete"
