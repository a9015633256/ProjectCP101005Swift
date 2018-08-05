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

    
    var subject = [Subject]()
    var mainClass = Classes()
    var name:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action:#selector(back(_:)) )
        
     
       
       
        print(self.mainClass)
    }
   
    @objc func back(_ sender:Any){
        navigationController?.popViewController(animated: true)
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
            let classID = self.mainClass.id
            let dictionary: [String:Any] = ["action":"Exam","id": classID]
            
            
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
            self.subject.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
                assertionFailure()
                return
            }
            let subject = self.subject[0].subjectid

            let dictionary: [String:Any] = ["action":"deleteSubject","subject": subject]
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
       
    }
   }



