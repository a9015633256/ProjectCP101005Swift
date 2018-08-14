//
//  TeacherAccountTabOneViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/7/26.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TeacherAccountTabOneViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let communicator = CommunicatorWenSing()

    var studentImageDictionary = [Int: UIImage]()

    var studentList = [StudentsFile]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        findStudents()
        
    
    }
    override func viewDidAppear(_ animated: Bool) {//新增導師或學生後reloadData
        findStudents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as? TeacherAccountTabOneTableViewCell else {
            return UITableViewCell()
        }
        
        
        let studentPhoneNumber = studentList[indexPath.row].Student_Phone
        let studentId = studentList[indexPath.row].id
        cell.tabOneStudentNameLabel.text = studentList[indexPath.row].Student_Name
        cell.tabOneStudentPhoneLabel.text = "\(studentPhoneNumber ?? 0)"
        
        //將資料存取到UserDefaults，studentList有幾列numberOfRowsInSection就會跑幾次
        UserDefaults.standard.set(studentId, forKey: "studentId\(indexPath.row)")
        print("第\(indexPath.row)存取\(UserDefaults.standard.integer(forKey: "studentId\(indexPath.row)"))")
        
        //抓圖片的部分
        let imageId = UserDefaults.standard.integer(forKey: "studentId\(indexPath.row)")
        let image = self.studentImageDictionary[imageId]
        cell.tabOneStudentImage.image = image
        
        return cell
    }
    
    //傳送資料到下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStudentDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let distinationController = segue.destination as! TabOneStudentDetailViewController
                distinationController.studentDetail = studentList[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { (action, sourceView, completionHandler) in
            
            //刪除學生
            self.deleteStudents(students: UserDefaults.standard.integer(forKey: "studentId\(indexPath.row)"))
            print("\(UserDefaults.standard.integer(forKey: "studentId\(indexPath.row)"))")
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        let swipConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipConfiguration
        
    }
    
    //顯示學生清單
    func findStudents() {
        
        let studentClass = UserDefaults.standard.string(forKey: "className")
        let action = GetStudentList(action: ACTION_GET_STUDENT_LIST, Class_Name: studentClass!)
        let econder = JSONEncoder()
        econder.outputFormatting = .init()
        guard let uploadData = try? econder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        
        communicator.doPost(url: STUDENT_SERVLET, data: uploadData) { (result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            guard let output = try? JSONDecoder().decode([StudentsFile].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            
            self.studentList = output
            print("JSON: \(self.studentList)")
//            self.tableView.reloadData()
            if self.studentList.count != 0 {
                for id in 0...(self.studentList.count - 1) {
                    self.getFriendImage(studentID: self.studentList[id].id!)//這行導致沒有照片會閃退，找時間修改
                }
            }
//            self.tableView.reloadData()

        }
        
    }
    
    //如果沒有圖片就抓不到資料
    //傳送圖片
    func getFriendImage(studentID: Int){
     
        let action = GetImageAction(action: ACTION_GET_IMAGE, id: studentID, imageSize: 150)
        // 準備將資料轉為JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init()
        // 轉為JSON
        guard let uploadData = try? encoder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        // 送資料 and 解析回傳的JSON資料
        communicator.doPost(url: STUDENT_SERVLET, data: uploadData) { (result) in
     
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
     
            guard let image = UIImage.init(data: result) else {
                return
            }
            
            //Thread 1: Fatal error: Index out of range
            self.studentImageDictionary[studentID] = image
            self.tableView.reloadData()
            print("圖片\(result)")
        }
     
    }
    
    //刪除學生之後未能reloadData
    //刪除學生
    func deleteStudents(students: Int) {
        
        let action = DeleteStudent(action: ACTION_DELETE_STUDENT, students: students)
        let econder = JSONEncoder()
        econder.outputFormatting = .init()
        guard let uploadData = try? econder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        
        communicator.doPost(url: STUDENT_SERVLET, data: uploadData) { (result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            //            guard let output = try? JSONDecoder().decode([StudentsFile].self, from: result) else {
            //                assertionFailure("get output fail")
            //                return
            //            }
            guard let output = String(data: result, encoding: .utf8) else {
                assertionFailure("to string fail")
                return
            }
            print(output)
            //            self.studentList = output
            //            print("\(self.studentList)")
            self.findStudents()
        }
        
        //刪除學生成功之後，顯示alert
        
    }
    
}
