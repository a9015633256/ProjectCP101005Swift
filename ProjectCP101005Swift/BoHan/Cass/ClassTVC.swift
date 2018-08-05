//
//  ClassTVC.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/2.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit
struct Classes:Codable,CustomStringConvertible {
    var description: String{
        return "className: \(classes),teacherAccount: \(teacher),classID: \(id),teacherID: \(teacherid)"
    }
    var classes:String = ""
    var teacher:String = ""
    var id:Int = 0
    var teacherid:Int = 0
    
    static let Gray = UIColor(red: 205.0/255.0, green: 201.0/255.0, blue: 201.0/255.0, alpha: 1.0)
}

class ClassTVC: UITableViewController {

    
    var mainClass = [Classes]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getAllClass()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getAllClass() {
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            return
        }
        let dictionary: [String:Any] = ["action":"getAll","name":"cp104@hotmail.com"]
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
                let classes = try jsonDecoder.decode([Classes].self, from: data)
                for item in classes {
                    self.mainClass.append(item)
                    
                }
                self.tableView.reloadData()
            }catch{
                print("error:\(error)")
            }
        }
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mainClass.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClassCell
        let row = self.mainClass[indexPath.row]
        cell.classNameLabel.text = row.classes
        cell.teacherAccountLabel.text = row.teacher
        cell.classCodeLabel.text = "\(row.id)"
        cell.cellView.backgroundColor = Classes.Gray
        cell.cellView.layer.cornerRadius = 8
        cell.cellView.layer.shadowOpacity = 0.3
        cell.cellView.layer.shadowRadius = 8
        cell.cellView.layer.shadowColor = UIColor.black.cgColor
        cell.cellView.layer.shadowOffset = .zero
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
        if segue.identifier == "Exam" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let controller = segue.destination as! ExamSubjectTVC
                controller.mainClass = self.mainClass[indexPath.row]
            }
        }
    }
    

}
