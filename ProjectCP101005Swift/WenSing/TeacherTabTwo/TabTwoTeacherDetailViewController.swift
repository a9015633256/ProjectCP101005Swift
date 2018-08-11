//
//  TabTwoTeacherDetailViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/8/6.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TabTwoTeacherDetailViewController: UIViewController {
    
//    let communicator = Communicator()
    
    var teacherDetail = TeachersFile()
    
    let teacherList : TeachersFile = TeachersFile()
    
//    var teacherImageDictionary = [Int:UIImage]()

    
    @IBOutlet weak var teacherImage: UIImageView!
    @IBOutlet weak var teacherAccountLabel: UILabel!
    @IBOutlet weak var teacherNameLable: UILabel!
    @IBOutlet weak var teacherGenderLabel: UILabel!
    @IBOutlet weak var teacherBirthLabel: UILabel!
    @IBOutlet weak var teacherPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //缺圖大頭照
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
//        teacherImage.image = teacherDetail
        
        // Do any additional setup after loading the view.
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
    
    //簡易的返回上一頁
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
