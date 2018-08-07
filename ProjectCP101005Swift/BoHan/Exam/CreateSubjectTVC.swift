//
//  CreateSubjectTVC.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/7/27.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit
struct ExamSubject:Codable,CustomStringConvertible {
    var description: String{
        return "subjectt:\(subjectt),teacherr:\(teacherr),classidd:\(classidd),title:\(title),context:\(context),date:\(date)"
    }
    
    var subjectt:String = ""
    var teacherr:String = ""
    var classidd:String = ""
    var title:String = ""
    var context:String = ""
    var date:String = ""
}



class CreateSubjectTVC: UITableViewController,UITextViewDelegate {
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    let datePickerIndexPath = IndexPath(row: 0, section: 2)
    let textViewIndexPath = IndexPath(row: 0, section: 4)
    
    var subject = [Subject]()
    
    var checkDatePickerShown:Bool = false{
        didSet {
            datePicker.isHidden = !checkDatePickerShown
        }
    }
    var textViewShown:Bool = false{
        didSet {
            contentTextView.isHidden = !textViewShown
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.contentTextView.layer.borderColor = UIColor.black.cgColor
        self.contentTextView.layer.borderWidth = 2.0
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = Locale(identifier: "zh_TW")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: datePicker.date)
        self.dateLabel?.text = date
        self.contentTextView.text = "請輸入內容"
        self.contentTextView.textColor = UIColor.lightGray
        self.contentTextView.delegate = self
        
        guard let userData = UserDefaults.standard.data(forKey: "Subject") else{
            return
        }
        guard let item = try? JSONDecoder().decode([Subject].self, from: userData)else{
            return
        }
        self.subject = item
        
    }
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.contentTextView.textColor == UIColor.lightGray {
            self.contentTextView.text = ""
            self.contentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.contentTextView.text == "" {
            self.contentTextView.text = "請輸入內容"
            self.contentTextView.textColor = UIColor.lightGray
        }
    }

  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section,indexPath.row) {
        case (self.datePickerIndexPath.section,self.datePickerIndexPath.row):
            if checkDatePickerShown{
                return 216.0
            }else{
                return 0.0
            }
        case (self.textViewIndexPath.section,self.textViewIndexPath.row):
            if textViewShown{
                return 470.0
            }else{
                return 0.0
            }
        default:
            return 60.0
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section,indexPath.row) {
        case (self.datePickerIndexPath.section - 1,self.datePickerIndexPath.row):
            if checkDatePickerShown{
                checkDatePickerShown = false
            }else{
                checkDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        case (self.textViewIndexPath.section - 1, self.textViewIndexPath.row):
            if textViewShown{
                textViewShown = false
            }else{
                textViewShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
        
    }
   

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

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    

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
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDate()
    }
    func updateDate() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateLabel.text = dateFormatter.string(from: datePicker.date)

        self.datePicker.locale = Locale(identifier: "zh_TW")
    }
    
    
    @IBAction func addExamSubject(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text,title.isEmpty == false else {
            let alert = UIAlertController(title: "錯誤", message: "不允輸入空白", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        guard let text = self.contentTextView.text,text.isEmpty == false else {
            let alert = UIAlertController(title: "錯誤", message: "不允輸入空白", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            assertionFailure()
            return
        }
        
        guard let date = self.dateLabel.text else{
            return
        }
        let subjectid = self.subject[0].examsubjectid
        let teacherid = self.subject[0].teacherid
        let classid = self.subject[0].classid
        
        
        let exam = ExamSubject(subjectt: "\(subjectid)", teacherr: "\(teacherid)", classidd: "\(classid)", title: "\(title)", context: "\(text)", date: "\(date)")
        
        let dictionary: [String:Any] = ["action": "Add","Subject" : "{\(exam)}"]
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
            let alert = UIAlertController(title: "完成", message: "新增成功", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default, handler: { (status) in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(action)
            self.present(alert, animated: true)
        
            
        }
    }
}
