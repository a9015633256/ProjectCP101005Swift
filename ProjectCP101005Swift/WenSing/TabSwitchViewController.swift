//
//  TabSwitchViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/7/26.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TabSwitchViewController: UIViewController {
    
    @IBOutlet weak var switchViewSegment: UISegmentedControl!
    
    @IBOutlet weak var classViewContainer: UIView!
    
    let studentViewController = UIStoryboard(name: "TeacherAccountClassDetail", bundle: nil).instantiateViewController(withIdentifier: "studentList")
    let teacherViewController = UIStoryboard(name: "TeacherAccountClassDetail", bundle: nil).instantiateViewController(withIdentifier: "teacherList")
    let teacherReplaceFileController = UIStoryboard(name: "TeacherAccountClassDetail", bundle: nil).instantiateViewController(withIdentifier: "profileReplacePage")
    let transToLoginPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainLoginStoryboard")
    let addStudentMemberViewController = UIStoryboard(name: "TeacherAccountClassDetail", bundle: nil).instantiateViewController(withIdentifier: "addStudentViewController")
    let addTeacherMemberViewController = UIStoryboard(name: "TeacherAccountClassDetail", bundle: nil).instantiateViewController(withIdentifier: "addTeacherViewController")


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.items![3].title = "聯絡家長"
        self.title = "班級學生資料"
        tabBarController?.tabBar.items![0].image = UIImage(named: "baseline_assessment_black_24dp.png")
        classViewContainer.addSubview(studentViewController.view)
        
        switchViewSegment.selectedSegmentIndex = 0
        switchViewSegment.isHidden = false
        
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
    
    @IBAction func switchViewSegmentControl(_ sender: UISegmentedControl) {
        switch switchViewSegment.selectedSegmentIndex{
        case 0:
            classViewContainer.addSubview(studentViewController.view)
            self.title = "班級學生資料"
        case 1:
            classViewContainer.addSubview(teacherViewController.view)
            self.title = "科任老師資料"
        default:
            classViewContainer.addSubview(studentViewController.view)
//            classViewContainer.addSubview(navController.view)

        }
        
    }
    
    @IBAction func setObjects(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionProfileReplaceHandler = {(action: UIAlertAction!) -> Void in
//            self.classViewContainer.addSubview(self.teacherReplaceFileController.view)
            self.present(self.teacherReplaceFileController, animated: true, completion: nil)
        }
        let actionProfileReplace = UIAlertAction(title: "修改個人檔案", style: .default, handler: actionProfileReplaceHandler)
        optionMenu.addAction(actionProfileReplace)
        
        let actionCancel = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        optionMenu.addAction(actionCancel)
        
        let actionLogoutHandler = {(action: UIAlertAction!) -> Void in
            let alartLogoutMenu = UIAlertController(title: "確定要登出嗎？", message: nil, preferredStyle: .alert)
            let logoutCancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
            alartLogoutMenu.addAction(logoutCancelAction)
            let logoutHandler = {(action: UIAlertAction!) -> Void in
                
                self.present(self.transToLoginPage, animated: true, completion: nil)
            }
            let logout = UIAlertAction(title: "確定", style: .default, handler: logoutHandler)
            alartLogoutMenu.addAction(logout)
            self.present(alartLogoutMenu, animated: true, completion: nil)
        }
        let actionLogout = UIAlertAction(title: "登出", style: .default, handler: actionLogoutHandler)
        optionMenu.addAction(actionLogout)
        
        present(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func addMemberBtn(_ sender: Any) {
        let memberMenu = UIAlertController(title: "新增成員", message: nil, preferredStyle: .actionSheet)
        let addStudentHandler = {(action: UIAlertAction) -> Void in//跳轉頁面
            self.present(self.addStudentMemberViewController, animated: true, completion: nil)
        }
        let actionAddStudent = UIAlertAction(title: "新增班級學生", style: .default, handler: addStudentHandler)
        memberMenu.addAction(actionAddStudent)
        let addTeacherHandler = {(action: UIAlertAction) -> Void in//跳轉頁面
            self.present(self.addTeacherMemberViewController, animated: true, completion: nil)
        }
        let actionAddTeacher = UIAlertAction(title: "新增科任老師", style: .default, handler: addTeacherHandler)
        memberMenu.addAction(actionAddTeacher)
        
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        memberMenu.addAction(cancelAction)
        
        present(memberMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        
        dismiss(animated: false, completion: nil)
        
    }
    
}
