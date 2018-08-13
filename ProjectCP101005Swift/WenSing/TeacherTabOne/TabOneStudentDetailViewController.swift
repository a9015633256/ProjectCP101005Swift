//
//  TabOneStudentDetailViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/8/6.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TabOneStudentDetailViewController: UIViewController {
    
    let conmmuncator = CommunicatorWenSing()
    
    var studentDetail = StudentsFile()
    
    var studentList : StudentsFile = StudentsFile()
    
    var studentImageDictionary = UIImage()
    
    @IBOutlet weak var studnetImage: UIImageView!
    @IBOutlet weak var studentAccountLable: UILabel!
    @IBOutlet weak var studentClassLable: UILabel!
    @IBOutlet weak var studentNameLable: UILabel!
    @IBOutlet weak var studentGenderLable: UILabel!
    @IBOutlet weak var studentBirthLable: UILabel!
    @IBOutlet weak var studentPhoneLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let studentId = studentDetail.id
        findStudentsById(studentId: studentId!)
        
        getFriendImage(studentID: studentId!)
        
        //尚未取得名稱
        studentClassLable.text = UserDefaults.standard.string(forKey: "className") ?? "nil"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //載入學生詳細資料
    func findStudentsById(studentId : Int) {
        
//        let studentId = 1//利用userDefault載入資料
        let action = FindStudentById(action: ACTION_FIND_STUDENT_BY_ID, id: studentId)
        let econder = JSONEncoder()
        econder.outputFormatting = .init()
        guard let uploadData = try? econder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        
        conmmuncator.doPost(url: STUDENT_SERVLET, data: uploadData) { (result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            guard let output = try? JSONDecoder().decode(StudentsFile.self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            
            self.studentDetail = output
            print("JSON: \(self.studentDetail)")
            
            self.studentNameLable.text = self.studentDetail.Student_Name
            self.studentAccountLable.text = self.studentDetail.Student_ID
            let gender = self.studentDetail.Student_Gender
            if gender == 1 {
                self.studentGenderLable.text = "男"
            } else {
                self.studentGenderLable.text = "女"
            }
            self.studentBirthLable.text = self.studentDetail.Student_Birthday
            let phoneNumber = "\(self.studentDetail.Student_Phone ?? 0)"
            self.studentPhoneLable.text = phoneNumber
            
            //明天再來問怎麼下載圖片
            let getImageID = self.studentDetail.id
//            print("\(getImageID)")
            self.getFriendImage(studentID: getImageID!)
            
        }
        
        
    }
    
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
        conmmuncator.doPost(url: STUDENT_SERVLET, data: uploadData) { (result) in
            
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            
            guard let image = UIImage.init(data: result) else {
                return
            }
            
            self.studentImageDictionary = image
            print("圖片\(result)")
            self.studnetImage.image = image//得到的圖片直接指定顯示
            
        }
        
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        

    }
    
}
