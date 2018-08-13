//
//  TabTwoTeacherDetailViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/8/6.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TabTwoTeacherDetailViewController: UIViewController {
    
    let communicator = CommunicatorWenSing()
    
    var teacherDetail = TeachersFile()
    
    let teacherList : TeachersFile = TeachersFile()
    
    var teacherImageDictionary = UIImage()
    
//    var teacherImageDictionary = [Int:UIImage]()

    
    @IBOutlet weak var teacherImage: UIImageView!
    @IBOutlet weak var teacherAccountLabel: UILabel!
    @IBOutlet weak var teacherNameLable: UILabel!
    @IBOutlet weak var teacherGenderLabel: UILabel!
    @IBOutlet weak var teacherBirthLabel: UILabel!
    @IBOutlet weak var teacherPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teacherAccountLabel.text = teacherDetail.Teacher_Account
        teacherNameLable.text = teacherDetail.Teacher_Email
        let gender = teacherDetail.Teacher_Gender
        if gender == 1 {
            teacherGenderLabel.text = "男"
        }else {
            teacherGenderLabel.text = "女"
        }
        teacherBirthLabel.text = teacherDetail.Teacher_TakeOfficeDate
        teacherPhoneLabel.text = teacherDetail.Teacher_Phone

        let teacherId = teacherDetail.id
        //還需要修飾
        getFriendImage(teacherId: teacherId!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            
            self.teacherImageDictionary = image
            print("圖片\(result)")
            self.teacherImage.image = image//得到的圖片直接指定顯示
            
        }
        
    }
    
    //簡易的返回上一頁
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
