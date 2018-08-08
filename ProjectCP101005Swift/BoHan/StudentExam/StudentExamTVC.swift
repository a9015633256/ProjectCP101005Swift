//
//  StudentExamTVC.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/8.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class StudentExamTVC: UITableViewController {
    var subject = [Subject]()
    var mainClass = ClassJoin()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let teacherAccountStr = UserDefaults.standard.value(forKey: "name")else{
            return
        }
        guard let teacherAccount = teacherAccountStr as? String else{
            return
        }
        guard let classNameStr = UserDefaults.standard.value(forKey: "className") else{
            return
        }
        
        guard let className = classNameStr as? String else{
            return
        }
        guard let teacherIDInt = UserDefaults.standard.value(forKey: "teacherId")else{
            return
        }
        guard let teacherID = teacherIDInt as? Int else{
            return
        }
        guard let classIDInt = UserDefaults.standard.value(forKey: "classId")else{
            return
        }
        guard let classID = classIDInt as? Int else{
            return
        }
        self.mainClass = ClassJoin(id: classID, classes: className, teacher: teacherAccount ,teacherID:teacherID)
        
        
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
        guard let classID = self.mainClass.id else{
            return
        }
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
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.subject.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentExamCell
        let examSubject = subject[indexPath.row]
        let title = examSubject.examtitle
        cell.tag = indexPath.row
        cell.subjectLabel.text = "考試科目: " + title
        cell.scoreBtn.backgroundColor = Color.LightSlateBlue
        cell.scoreBtn.layer.cornerRadius = 10
        cell.cellView.layer.cornerRadius = 10
        cell.cellView.backgroundColor = Color.DeepSkyBlue
        cell.scoreBtn.tag = indexPath.row
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "QueryExam"{
            if let indexPath = tableView.indexPathForSelectedRow{
            let contoller = segue.destination as? StudentExamQuery
            contoller?.subject = self.subject[indexPath.row]
            }
        }
        else if segue.identifier == "QueryExamScore"{
            guard let indexPath = sender as? UIButton else{
                return
            }
            let contoller = segue.destination as? StudentExamQueryScore
            contoller?.subject = self.subject[indexPath.tag]
        }
    }

}
