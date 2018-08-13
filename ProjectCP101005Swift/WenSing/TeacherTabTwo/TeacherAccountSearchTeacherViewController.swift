//
//  TeacherAccountSearchTeacherViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/8/6.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TeacherAccountSearchTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let communicator = CommunicatorWenSing()
    
    var teacherList = [TeachersFile]()
    
    var teacherImageDictionary = [Int: UIImage]()
    
    @IBOutlet weak var searchTeacherBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchTeacherBar.delegate = self
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? TeacherAccountSearchTeacherTableViewCell else {
            return UITableViewCell()
        }
        
        cell.teacherNameLabel.text = teacherList[indexPath.row].Teacher_Email
        cell.teacherPhoneLabel.text = teacherList[indexPath.row].Teacher_Phone
        
        //抓不太到圖片，之後再抓bug
        let image = teacherImageDictionary[indexPath.row]
        cell.teacherImageView.image = image
        
        return cell
        
    }
    
    //新增老師
    //要傳出去的資料 Class_Name(id)  Class_SubjectTeacher(id)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: "確定加入為科任老師？", message: nil, preferredStyle: .alert)//記得要調整文字
        let cancelAciton = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAciton)
        
        let addTeacherActionHandler = {(action : UIAlertAction!) -> Void in
            
            //抓ＩＤ？
            let teacherId = self.teacherList[indexPath.row].id
            let classId = UserDefaults.standard.integer(forKey: "classId")
            print("老師ID:\(teacherId ?? 0)，班級ID:\(classId)")
            self.addTeacherToClass(classId: classId, teacherId: teacherId!)
            
        }
        let addTeacherAction = UIAlertAction(title: "確定加入", style: .default, handler: addTeacherActionHandler)
        optionMenu.addAction(addTeacherAction)
        
        present(optionMenu, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    // MARK: - Navigation
    //我想不會用到
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //UISearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchString = searchTeacherBar.text
        
        if searchString != nil {
            findTeachers(teacherAccount: searchString!)
        }else {
            let nilAlerthandlert = UIAlertController(title: "請輸入欲搜尋的", message: nil, preferredStyle: .alert)
            let ActionCancel = UIAlertAction(title: "確定", style: .destructive, handler: nil)
            nilAlerthandlert.addAction(ActionCancel)
            present(nilAlerthandlert, animated: true, completion: nil)
        }
        
    }
    
    //找到老師的動作
    func findTeachers(teacherAccount: String) {
        
        //仍須優化
        let action = FindTeacherFile(action: ACTION_GET_TEACHER_FILE, Teacher_Account: teacherAccount)
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
            self.tableView.reloadData()
            if self.teacherList.count != 0 {
                for id in 0...(self.teacherList.count - 1) {
                    self.getFriendImage(teacherId: self.teacherList[id].id!)
                    
                }
                
            }

        }
        
    }
    
    func getFriendImage(teacherId: Int){
        
        let action = GetImageAction(action: ACTION_GET_IMAGE, id: teacherId, imageSize: 150)
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
            
            self.teacherImageDictionary[teacherId] = image
            print("搜尋圖片\(result)")
            self.tableView.reloadData()
        }
        
    }
    
    //getClass_Name id   getClass_SubjectTeacher id
    func addTeacherToClass(classId: Int, teacherId: Int) {
        //利用alert顯示是否成功
//        let action = JoinTeacherToClass(action: ACTION_JOIN_TEACHER_TO_CLASS, getClass_Name: classId, getClass_SubjectTeacher: teacherId)
        let action = JoinTeacherToClass(action: ACTION_JOIN_TEACHER_TO_CLASS, Class_Name: classId, Class_SubjectTeacher: teacherId)
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
            print("\(result)")
//            guard let output = try? JSONDecoder().decode([TeachersFile].self, from: result) else {
//                assertionFailure("get output fail")
//                return
//            }
            let successhandler = UIAlertController(title: "新增成功！", message: nil, preferredStyle: .alert)
            let actionConformHandler = {(action: UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            let actionConform = UIAlertAction(title: "確定", style: .cancel, handler: actionConformHandler)
            successhandler.addAction(actionConform)
            
            self.present(successhandler, animated: true, completion: nil)
        
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
}
