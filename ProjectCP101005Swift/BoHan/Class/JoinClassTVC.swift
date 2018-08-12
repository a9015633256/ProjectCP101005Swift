//
//  JoinClassTVC.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/7/26.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit
struct custom:Codable,CustomStringConvertible {
    var description: String{
        return "classid:\(id),teacherid:\(teacherid),className:\(name)"
    }

    var id:Int?
    var teacherid:Int?
    var name:String?
     static let color = UIColor(red: 135.0/255.0, green: 206.0/255.0, blue: 240.0/255.0, alpha: 1.0)
}

class JoinClassTVC: UITableViewController {

    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var serachTextField: UITextField!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var cell: UITableViewCell!
    
    var classID: Int?
    var teacherID: Int?
    var JoinList = [ClassJoin]()
    var totalID = [Int]()
    var totalId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cell.layer.cornerRadius = 30
        self.cell.layer.borderColor = UIColor.blue.cgColor
        self.cell.backgroundColor = custom.color
        tableView.separatorInset = UIEdgeInsetsMake(0.0,   cell.bounds.size.width, 0.0, 0.0)
        self.joinBtn.tintColor = UIColor.red
        self.joinBtn.frame.size.height = cell.frame.size.height
        self.joinBtn.frame.size.width = 100
        
        
       
        guard let teacherIDAny = UserDefaults.standard.value(forKey: "teacherId")else{
            return
        }
        guard let teacherID = teacherIDAny as? Int else{
            return
        }
        guard let data = UserDefaults.standard.data(forKey: "JoinList") else {
            return
        }
        guard let joinList = try? JSONDecoder().decode([ClassJoin].self, from: data) else{
            return
        }
      
       self.teacherID = teacherID
       self.JoinList = joinList
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
    

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
    @IBAction func searchClass(_ sender: UIButton) {
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            return
        }
        guard let classID = Int(self.serachTextField.text!) else {
            return
        }
        self.classID = classID
        let dictionary: [String:Any] = ["action":"findByClass","id": classID]
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
            guard let data = data else{
                return
            }
            let jsonDecoder = JSONDecoder()
            do{
                
            let classDetail = try jsonDecoder.decode(custom.self, from: data)
            self.cell.isHidden = false
               
            self.classNameLabel.text = "班級名稱: " + classDetail.name!
            }catch{
                print("error: \(error)")
                let alert = UIAlertController(title: "錯誤", message: "查無此代碼\n請重新查詢", preferredStyle: .alert)
                let action = UIAlertAction(title: "確認", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    func joinClass() {
        
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            return
        }
        guard let teacherID = self.teacherID else {
            return
        }
        guard let classID = self.classID else {
            return
        }

        for JoinID in self.JoinList{
            guard let id = JoinID.id else{
                return
            }
            self.totalID.append(id)
        }
      
        
     
        if self.totalID.contains(classID){
            let alert = UIAlertController(title: "錯誤", message: "重複加入此班級", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            self.serachTextField.text = ""
        }
        else{
            let dictionary: [String:Any] = ["action":"Join","ClassId":classID,"TeacherId":teacherID]
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
            }


    }
}
    
    
    @IBAction func addBtn(_ sender: UIButton) {
        joinClass()
        let alert = UIAlertController(title: "完成", message: "新增成功", preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default) { (status) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }

}
