//
//  TeacherAccountTabTwoViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/7/26.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TeacherAccountTabTwoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let communicator = CommunicatorWenSing()
    
    var teacherImageDictionary = [Int:UIImage]()
    
    var teacherList = [TeachersFile]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        findTeachers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell", for: indexPath) as? TeacherAccountTabTwoTableViewCell else {
            return UITableViewCell()
        }
        
        let teacherPhoneNumber = teacherList[indexPath.row].Teacher_Phone
        let teacherId = teacherList[indexPath.row].id
        cell.tabTwoTeacherNameLabel.text = teacherList[indexPath.row].Teacher_Email
        cell.tabTwoTeacherPhoneLable.text = "\(teacherPhoneNumber ?? "")"
        
        UserDefaults.standard.set(teacherId, forKey: "teacherId\(indexPath.row)")
        
        //抓圖片的部分
        let imageId = UserDefaults.standard.integer(forKey: "teacherId\(indexPath.row)")
        let image = teacherImageDictionary[imageId]
        cell.tabTwoTeacherImage.image = image
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStudentDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let distinationController = segue.destination as! TabTwoTeacherDetailViewController
                distinationController.teacherDetail = teacherList[indexPath.row]
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { (action, sourceView, completionHandler) in
            
            //
            self.deleteTeacher()
            //
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        let swipConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipConfiguration
        
    }
    
    func findTeachers() {
        
        let teacherClass = UserDefaults.standard.string(forKey: "className")
        
        let action = GetTeacherList(action: ACTION_GET_TEACHER_LIST, Class_Name: teacherClass!)
        let econder = JSONEncoder()
        econder.outputFormatting = .init()
        guard let uploadData = try? econder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        
        communicator.doPost(url: TEACHER_LIST_SERVLET, data: uploadData) { (result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            guard let output = try? JSONDecoder().decode([TeachersFile].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
//            guard let output = try? JSONDecoder().decode([StudentsFile].self, from: result) else {
//                assertionFailure("get output fail")
//                return
//            }
            
            self.teacherList = output
            print("JSON: \(self.teacherList)")
//            self.tableView.reloadData()
            if self.teacherList.count != 0 {
                for id in 0...(self.teacherList.count - 1) {
                    self.getFriendImage(teacherID: self.teacherList[id].id!)
                    
                }
                
            }
        
        }
        
    }
    
    //取得圖片
    func getFriendImage(teacherID: Int){
        
        let action = GetImageAction(action: ACTION_GET_IMAGE, id: teacherID, imageSize: 150)
        // 準備將資料轉為JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init()
        // 轉為JSON
        guard let uploadData = try? encoder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        // 送資料 and 解析回傳的JSON資料
        communicator.doPost(url: TEACHER_LIST_SERVLET, data: uploadData) { (result) in
            
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            
            guard let image = UIImage.init(data: result) else {
                return
            }
            self.teacherImageDictionary[teacherID] = image
            
            print("圖片\(result)")
            self.tableView.reloadData()
        }
        
    }
    
    //刪除老師
    func deleteTeacher() {
        
        let studentId = UserDefaults.standard.integer(forKey: "teacherId")//還要加上第幾列的人
        
        let action = DeleteTeacher(action: ACTION_DELETE_TEACHER, teacherList: studentId)
        let econder = JSONEncoder()
        econder.outputFormatting = .init()
        guard let uploadData = try? econder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        
        communicator.doPost(url: TEACHER_LIST_SERVLET, data: uploadData) { (result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            guard let output = try? JSONDecoder().decode([TeachersFile].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            
            self.teacherList = output
            print("\(self.teacherList)")
            self.tableView.reloadData()
        }
        
    }

 
}

