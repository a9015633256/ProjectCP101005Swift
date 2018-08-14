//
//  ExamSubjectTableViewController.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/7/17.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit
struct Subject:Codable,CustomStringConvertible {
    var description: String{
        return "classid:\(classid),subjectid:\(subjectid),teacherid:\(teacherid),examsubjectid:\(examsubjectid),examtitle:\(examtitle)"
    }
    
    var classid:Int = 0
    var subjectid:Int = 0
    var teacherid:Int = 0
    var examsubjectid:Int = 0
    var examtitle:String = ""
}


class ExamSubjectTVC: UITableViewController {
    
    let teacherReplaceFileController = UIStoryboard(name: "TeacherAccountClassDetail", bundle: nil).instantiateViewController(withIdentifier: "profileReplacePage")
    let transToLoginPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainLoginStoryboard")

    
    var subject = [Subject]()
    var mainClass = ClassJoin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        guard let teacherAccountStr = UserDefaults.standard.value(forKey: "account")else{
            return
        }
        guard let teacherAccount = teacherAccountStr as? String else{
            return
        }
        guard let classNameStr = UserDefaults.standard.value(forKey: "className") else{
            return
        }

        guard let className = classNameStr as? String else{
            return
        }
        guard let teacherIDInt = UserDefaults.standard.value(forKey: "teacherId")else{
            return
        }
        guard let teacherID = teacherIDInt as? Int else{
            return
        }
        guard let classIDInt = UserDefaults.standard.value(forKey: "classId")else{
            return
        }
        guard let classID = classIDInt as? Int else{
            return
        }
        self.mainClass = ClassJoin(id: classID, classes: className, teacher: teacherAccount ,teacherID:teacherID)
        
       
        
    }
   
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.subject.removeAll()
        getSubject()
        
    }
    

    func getSubject()  {
            guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
                assertionFailure()
                return
            }
            guard let classID = self.mainClass.id else{
                return
            }
        guard let teacherID = self.mainClass.teacherID else {
            return
            }
        let dictionary: [String:Any] = ["action":"Exam","id": classID,"teacherid": teacherID]
            
            
            guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
                assertionFailure()
                return
            }
            
            
            let communicator = CommunicatorMingTa(targetURL: url)
            communicator.download(from: data) { (error, data) in
                if let error = error {
                    print("error: \(error)")
                    return
                }
                guard let data = data else {
                    assertionFailure()
                    return
                }
                let jsonDecoder = JSONDecoder()
                do {
                    let subject = try jsonDecoder.decode([Subject].self, from: data)
                    for item in subject {
                        self.subject.append(item)
                    }
                    if let encoded = try? JSONEncoder().encode(self.subject){
                        UserDefaults.standard.set(encoded, forKey: "Subject")
                    }
                    self.tableView.reloadData()
                }catch{
                    print("json parse failed: \(error)")
                    return
                
            }
        }
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
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subject.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        let examSubject = subject[indexPath.row]
        let title = examSubject.examtitle
        cell.subjectLabel.text = "考試科目: " + title
        cell.scoreBtn.backgroundColor = Color.LightSlateBlue
        cell.scoreBtn.layer.cornerRadius = 10
        cell.cellView.layer.cornerRadius = 10
        cell.cellView.backgroundColor = Color.DeepSkyBlue
        cell.scoreBtn.tag = indexPath.row
        cell.updateScore.tag = indexPath.row
        tableView.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0)

        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
                assertionFailure()
                return
            }
            let subject = self.subject[indexPath.row].subjectid
            

            let dictionary: [String:Any] = ["action":"deleteSubject","subject": subject]
            guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
                assertionFailure()
                return
            }
            self.subject.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)


            let communicator = CommunicatorMingTa(targetURL: url)
            communicator.download(from: data) { (error, data) in
                if let error = error {
                    print("error: \(error)")
                    return
                }
            }
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "UpdateScore"{
            guard let indexPath = sender as? UIButton else{
                return
            }
            let contoller = segue.destination as? UpdateScoreTVC
            contoller?.subject = self.subject[indexPath.tag]
        }
        else if segue.identifier == "LoginScore"{
            guard let indexPath = sender as? UIButton else{
                return
            }
            let contoller = segue.destination as? UpdateScoreTVC
            contoller?.subject = self.subject[indexPath.tag]
        }
        else if segue.identifier == "UpdateSubject"{
            if let indexPath = tableView.indexPathForSelectedRow{
            let contoller = segue.destination as? UpdateExamTVC
                contoller?.subject = self.subject[indexPath.row]
            }
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
    
    
}



