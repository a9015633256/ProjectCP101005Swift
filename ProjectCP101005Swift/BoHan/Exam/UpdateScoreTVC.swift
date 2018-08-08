//
//  UpdateScoreTVC.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/3.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class UpdateScoreTVC: UITableViewController,TableViewCellDelegate {
    func change(cell: Cell, score: Int) {
        mainSubject[cell.tag].score = score
    }
    

    @IBOutlet weak var subjectTitle: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var className: UILabel!
    
    
    var subject = Subject()
    var mainSubject = [Exam]()
    var exam = [Exam]()
    var mainCell:Cell?
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainSubject.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        let row = self.mainSubject[indexPath.row]
        cell.tag = indexPath.row
        cell.scoreTextField2.text = "\(row.score)"
        cell.studentNameLabel2.text = row.name
        cell.studentIDLabel2.text = row.studentid
        subjectTitle.text = row.title
        teacherName.text = row.teachername
        className.text = row.classname
        self.mainCell = cell
        cell.delegate = self

        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    
    
    
    
    func updateScore() {
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            assertionFailure()
            return
        }
        for item in self.mainSubject{
            let scoreID = item.AchievementID
            let examsubjectid = self.subject.subjectid
            let examstudent = item.examstudent
            let subject = self.subject.examsubjectid
            let studentid = item.studentid
            let name = item.name
            let classid = item.classid
            let classname = item.classname
            let teacherid = item.teacherid
            let teacheraccount = item.teacheraccount
            let teachername = item.teachername
            let score = item.score
            let title = item.title
            let exam = Exam(AchievementID: scoreID, examsubjectid: examsubjectid, examstudent: examstudent, subject: subject, studentid: studentid, name: name, classid: classid, classname: classname, teacherid: teacherid, teacheraccount: teacheraccount, teachername: teachername, score: score, title: title)
            
            
            self.exam.append(exam)
        }
        let jsonEncoder = JSONEncoder()
        guard let item = try? jsonEncoder.encode(self.exam) else {
            assertionFailure()
            return
        }
        
        guard let jsonString = String(data: item, encoding: .utf8) else {
            assertionFailure()
            return
        }
        
        guard let Score = self.mainCell?.scoreTextField2.text else{
            return
        }
        
        
        let scoreID = self.exam.last?.AchievementID ?? 0
        let dictionary: [String:Any] = ["action": "insertAchievement","AchievementID":scoreID,"score":Score,"scores": jsonString]
        
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
    
    @IBAction func updateScore(_ sender: UIBarButtonItem) {
        updateScore()
        let alert = UIAlertController(title: "完成", message: "新增成功", preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default) { (status) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
