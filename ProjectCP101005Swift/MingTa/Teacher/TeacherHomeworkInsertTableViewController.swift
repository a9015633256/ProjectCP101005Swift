//
//  TeacherHomeworkUpdateTableViewController.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/26.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit

import UIKit

class TeacherHomeworkInsertTableViewController: UITableViewController {
    
    var classID = 0
    var subjectID = 0
    var teacherID = 0
    
    
    @IBOutlet weak var subjectNavigationItem: UINavigationItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromPref()
        
        configureView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        
        //check format
        guard titleTextField.text != "" else {
            
            let alert = UIAlertController(title: "作業標題不得為空", message: "", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard subjectID != 0, classID != 0, teacherID != 0 else{
            assertionFailure()
            return
        }
        let homework = Homework(id: 0, subjectId: subjectID, teacherId: teacherID, classId: classID, subject: "", teacher: "", title: titleTextField.text, content: contentTextView.text, date: Date())
        
        let jsonEncoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        guard let homeworkData = try? jsonEncoder.encode(homework) else {
            assertionFailure("fail to encode new homework")
            return
        }
        
        guard let jsonString = String(data: homeworkData, encoding: .utf8) else {
            assertionFailure("fail to creat jsonString")
            return
        }
        
        let dic:[String: Any] = ["action": "insertHomework", "homework": jsonString]
        
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
                let alert = UIAlertController(title: "新增作業失敗", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
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
                let alert = UIAlertController(title: "新增作業成功", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "確定", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "新增作業失敗", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Table view data source
    
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
    func configureView(){
//        subjectNavigationItem.title = homework?.subject
//        titleTextField.text = homework?.title
//        contentTextView.text = homework?.content
    }
    
    func getDataFromPref(){
        
        let userDefaults = UserDefaults.standard
        
        classID = userDefaults.integer(forKey: "classId")
        teacherID = userDefaults.integer(forKey: "teacherId")
        subjectID = userDefaults.integer(forKey: "subjectId")

        
    }
    
}
