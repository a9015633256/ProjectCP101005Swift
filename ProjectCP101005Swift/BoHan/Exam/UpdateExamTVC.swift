//
//  UpdateExamTableViewController.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/1.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit
struct fetchExamSubject:Codable,CustomDebugStringConvertible {
    var debugDescription: String{
        return "id:\(id),title:\(title),date:\(date),context:\(context)"
    }
    
    var id:Int?
    var title,date,context:String?
}

class UpdateExamTVC: UITableViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    let datePickerIndexPath = IndexPath(row: 0, section: 2)
    let textViewIndexPath = IndexPath(row: 0, section: 4)
    
    var subject = Subject()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = Locale(identifier: "zh_TW")
        self.contentTextView.layer.borderColor = UIColor.black.cgColor
        self.contentTextView.layer.borderWidth = 2.0
        fetchContent()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
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
    


    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDate()
    }
    func updateDate() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateLabel.text = dateFormatter.string(from: datePicker.date)
        
        self.datePicker.locale = Locale(identifier: "zh_TW")
    }

    // MARK: - Table view data source

    func fetchContent() {
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            assertionFailure()
            return
        }
        let examSubjectID = self.subject.subjectid
        let dictionary: [String:Any] = ["action":"findByitem","item": examSubjectID]
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
            do{
            let content = try jsonDecoder.decode(fetchExamSubject.self, from: data)
                self.titleTextField.text = content.title
                self.dateLabel.text = content.date
                self.contentTextView.text = content.context
                
            }catch{
                print("error: \(error)")
            }
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

    @IBAction func didDpdate(_ sender: UIBarButtonItem) {
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            assertionFailure()
            return
        }
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
        guard let date = self.dateLabel.text else{
            return
        }
        
        let sujectID = self.subject.subjectid
        let dictionary: [String:Any] = ["action":"update","ID":sujectID,"Title":title,"Date":date,"Content":text]
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
        let alert = UIAlertController(title: "完成", message: "修改成功", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default, handler: { (status) in
                self.navigationController?.popViewController(animated: true)
            })
        alert.addAction(action)
        self.present(alert, animated: true)
        
       }
    }
}
