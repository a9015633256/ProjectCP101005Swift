//
//  TeacherHomeworkUpdateTableViewController.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/27.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit


class TeacherHomeworkUpdateTableViewController: UITableViewController {
    
    var homework:HomeworkIsDone?
    
    @IBOutlet weak var subjectNavigationItem: UINavigationItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        guard let parent = parent else {
            return
        }
        configureView(with: parent)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    public func trashBtnPressed(){
        
        let alert = UIAlertController(title: "刪除作業", message: "確定要刪除嗎? 此動作無法恢復!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "刪除", style: .default) { (_) in
            self.deleteHomework()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction public func doneBtnPressed(_ sender: Any) {
        updateHomework()
    }
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - ConfigureView
    
    func configureView(with parent: UIViewController){
                subjectNavigationItem.title = homework?.subject
                titleTextField.text = homework?.title
                contentTextView.text = homework?.content
     
        let updateBtn = UIBarButtonItem(title: "更新", style: .done, target: self, action: #selector(doneBtnPressed(_:)))
        let trashBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBtnPressed))
        
        parent.navigationItem.rightBarButtonItems = []
        parent.navigationItem.rightBarButtonItems?.append(updateBtn)
        parent.navigationItem.rightBarButtonItems?.append(trashBtn)
        
        
    }
    
    // MARK: - ServerConnection
    
    func updateHomework() {
        
        //check format
        guard titleTextField.text != "" else {
            
            showSimpleAlert(title: "作業標題不得為空", "確定", sender: self, completion: nil)
            return
        }
        
        //make jsonObject
        guard let homework = homework, let id = homework.id else {
            assertionFailure("no homework in field")
            return
        }
        
        let dic:[String: Any] = ["action": "updateHomework",
                                 "homeworkId": id,
                                 "homeworkTitle": titleTextField.text!,
                                 "homeworkContent": contentTextView.text
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
            assertionFailure("fail to create jsonObject")
            return
        }
        
        //connect server
        guard let url = URL(string: PropertyKeysForConnection.urlHomeworkServlet) else {
            assertionFailure()
            return
            
        }
        
        let communicator = CommunicatorMingTa(targetURL: url)
        
        communicator.download(from: data) { (error, data) in
            if let error = error {
                print("error: \(error)")
                
                 showSimpleAlert(title: "作業更新失敗", "確定", sender: self, completion: nil)
                return
            }
            
            guard let data = data else {
                assertionFailure("data is nil")
                return
            }
            
            guard let count = String(data: data, encoding: .utf8) else {
                assertionFailure()
                return
            }
            
            if count != "0" {
                showSimpleAlert(title: "作業更新成功", "確定", sender: self, completion: { (ok) in
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                showSimpleAlert(title: "作業更新失敗", "確定", sender: self, completion: nil)
            }
        }
    }
    
    func deleteHomework(){
        
        guard let homework = homework, let id = homework.id else {
            assertionFailure("no homework in field")
            return
        }
        
        let dic:[String: Any] = ["action": "deleteHomework",
                                 "homeworkId": id]
        
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
            assertionFailure("fail to create jsonObject")
            return
        }
        
        guard let url = URL(string: PropertyKeysForConnection.urlHomeworkServlet) else {
            assertionFailure()
            return
            
        }
        
        let communicator = CommunicatorMingTa(targetURL: url)
        
        communicator.download(from: data) { (error, data) in
            if let error = error {
                print("error: \(error)")
                
                showSimpleAlert(title: "作業刪除失敗", "確定", sender: self, completion: nil)
                return
            }
            
            guard let data = data else {
                assertionFailure("data is nil")
                return
            }
            
            guard let count = String(data: data, encoding: .utf8) else {
                assertionFailure()
                return
            }
            
            if count != "0" {
                showSimpleAlert(title: "作業刪除成功", "確定", sender: self, completion: { (ok) in
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                showSimpleAlert(title: "作業刪除失敗", "確定", sender: self, completion: nil)
            }
        }
        
        
        
    }
   
    
    
}
