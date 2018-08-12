//
//  StudentExamQueryScore.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/8.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class StudentExamQueryScore: UITableViewController {
    @IBOutlet weak var subjectTitle: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var className: UILabel!
    
    
    
    var subject = Subject()
    var mainSubject = [Exam]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let userData = UserDefaults.standard.data(forKey: "mainSubject") else{
            return
        }
        guard let item = try? JSONDecoder().decode([Exam].self, from: userData)else{
            return
        }
        self.mainSubject = item
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.mainSubject.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentExamCell
        let row = self.mainSubject[indexPath.row]
        cell.Score.text = "\(row.score)"
        cell.studentName.text = row.name
        cell.studentID.text = row.studentid
        subjectTitle.text = row.title
        teacherName.text = row.teachername
        className.text = row.classname

        tableView.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0)
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.mainSubject.removeAll()
        getScoreList()
    }
    
    func getScoreList(){
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            assertionFailure()
            return
        }
        let examSubjectID = self.subject.subjectid
        let dictionary: [String:Any] = ["action": "id","ExamSubjectID" : examSubjectID]
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
            let jsonDecodee = JSONDecoder()
            do {
                let examsubject = try jsonDecodee.decode([Exam].self, from: data)
                for sum in examsubject{
                    self.mainSubject.append(sum)
                }
                
                self.tableView.reloadData()
            }
            catch{
                print("json parse fail: \(error)")
                return
            }
        }
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
