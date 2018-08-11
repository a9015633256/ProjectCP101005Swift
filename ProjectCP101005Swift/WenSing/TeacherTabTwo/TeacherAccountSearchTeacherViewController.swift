//
//  TeacherAccountSearchTeacherViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/8/6.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TeacherAccountSearchTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let communicator = CommunicatorWenSing()
    
    let teacherList = [TeachersFile]()
    
    @IBOutlet weak var searchTeacherBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        return cell
        
    }
    //新增老師
    //要傳出去的資料 Class_Name(id)  Class_SubjectTeacher(id)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: "nil", message: nil, preferredStyle: .alert)//記得要調整文字
        let cancelAciton = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAciton)
        
        let addTeacherActionHandler = {(action : UIAlertAction!) -> Void in
            //加入老師的動作
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
    
    @IBAction func backBtnPressed(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
}
