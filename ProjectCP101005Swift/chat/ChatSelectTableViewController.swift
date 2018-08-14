//
//  ChatSelectTableViewController.swift
//  ProjectCP101005Swift
//
//  Created by 林沂諺 on 2018/8/10.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class ChatSelectTableViewController: UITableViewController {
    
    var sender:String?
    let communicator = Communicator()
    let encoder = JSONEncoder()
    var chatList = [ReceiverList]()
    var chataction: String?
    var id: String?
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    let teacherReplaceFileController = UIStoryboard(name: "TeacherAccountClassDetail", bundle: nil).instantiateViewController(withIdentifier: "profileReplacePage")
    let transToLoginPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainLoginStoryboard")

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        

        
        sender = UserDefaults.standard.string(forKey: "account")
        chataction = UserDefaults.standard.string(forKey: "chatlistfound")
        id = UserDefaults.standard.string(forKey: "classId")

        print("classid ===== \(id)")
        
        let action = findchat(action: chataction, senderte: sender,id: id)
        guard let uploadData = try? encoder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        communicator.dopost(url: LOGIN_URL, data: uploadData) { (error, result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            guard let output = try? JSONDecoder().decode([ReceiverList].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            self.chatList = output
            print(self.chatList)
            self.tableView.reloadData()
        }
        
        if chataction == "getmotherlist" {
            navigationItem.leftBarButtonItems = nil
        }
        
     
    }
    
    
    @IBAction func logoutPop(_ sender: Any) {
       

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
//
//        
    }
    
    
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        
        dismiss(animated: false, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatList.count
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath) as? ChatSelectTableViewCell else {
            return UITableViewCell()
        }

        // Configure the cell...
        let newItem = chatList[indexPath.row]
        cell.receiverName.text = newItem.receiver
        if chataction == "getmotherlist" {
            cell.receiverTitle.text = "老師："
        }else {
            cell.receiverTitle.text = "學生："
        }
        
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? ChatViewController{
            guard let index = tableView.indexPathForSelectedRow else {
                return
            }
            controller.receiver = chatList[index.row].receiver
            
        }
       
        if segue.identifier == "ShowPopOver"{
            let controller = segue.destination.popoverPresentationController
            controller?.delegate = self
        }
       
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "ShowPopOver"{
            
            let userDefaults = UserDefaults.standard
            if userDefaults.integer(forKey: "teacherId") != 0 {
                
                callUpTeacherMenu(self)
                
                return false
                
            }
            
        }
        
        return true
        
    }
    
    func callUpTeacherMenu(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        guard userDefaults.integer(forKey: "teacherId") != 0  else {
            
            return
        }
        

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

extension ChatSelectTableViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
        
    }
}
