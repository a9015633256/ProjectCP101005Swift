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


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AVCC"
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
            self.title = "AVCC"
        case 1:
            classViewContainer.addSubview(teacherViewController.view)
            self.title = "AVCD"
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
            
        }
        let actionLogout = UIAlertAction(title: "登出", style: .default, handler: actionLogoutHandler)
        optionMenu.addAction(actionLogout)
        
        present(optionMenu, animated: true, completion: nil)
        
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
