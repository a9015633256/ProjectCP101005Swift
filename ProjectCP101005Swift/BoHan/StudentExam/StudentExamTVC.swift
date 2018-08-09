//
//  StudentExamTVC.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/8.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class DataList {
    var isOpen:Bool?
    var title = Int()
    var sectionData = [Subject]()
    
    init(isOpen: Bool,title: Int, sectionData:[Subject] ) {
        self.isOpen = isOpen
        self.title = title
        self.sectionData = sectionData
        
    }
}
class StudentExamTVC: UITableViewController {
    
    var mainClass = ClassJoin()
    var tableViewData = [DataList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        guard let teacherAccountStr = UserDefaults.standard.value(forKey: "account")else{
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
        self.tableViewData.removeAll()
        getSubject()
    }
    func getSubject()  {
        var examSubjectID = [Int]()
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
                  let examSubjectId = item.examsubjectid
                    
                    if examSubjectID.contains(examSubjectId){
                        var sectionData = self.tableViewData.filter({ (sections) -> Bool in
                            if sections.title == examSubjectId{
                                return true
                            }else{
                                return false
                            }
                        })
                        sectionData[0].sectionData.append(item)
                    }
                    else{
                       examSubjectID.append(examSubjectId)
                        self.tableViewData.append(DataList(isOpen: false, title: examSubjectId, sectionData: [item]))
                    }
                }
                
                self.tableView.reloadData()
            }catch{
                print("json parse failed: \(error)")
                return
                
                }
                
            
        
    }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
//        return 1
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].isOpen == true{
            return tableViewData[section].sectionData.count + 1
        }else{
            return 1
        }
//        return self.subject.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentExamCell
//        let examSubject = subject[indexPath.row]
//        let title = examSubject.examtitle
//        cell.tag = indexPath.row
//        cell.subjectLabel.text = "考試科目: " + title
//        cell.scoreBtn.backgroundColor = Color.LightSlateBlue
//        cell.scoreBtn.layer.cornerRadius = 10
//        cell.cellView.layer.cornerRadius = 10
//        cell.cellView.backgroundColor = Color.DeepSkyBlue
//        cell.scoreBtn.tag = indexPath.row
//        tableView.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0)
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as? StudentExamCell else{return UITableViewCell()}
            
            switch tableViewData[indexPath.section].title{
            case 6:
                cell.subjectTit.text = "JAVA"
            case 7:
                cell.subjectTit.text = "Android_Studio"
            case 8:
                cell.subjectTit.text = "Math"
            case 9:
                cell.subjectTit.text = "English"
            case 10:
                cell.subjectTit.text = "Chinese"
            default:
                cell.subjectTit.text = ""
            }
            cell.titleView.backgroundColor = Color.SteelBlue1
            cell.titleView.layer.cornerRadius = 15
            cell.titleView.layer.shadowColor = UIColor.gray.cgColor
            cell.tag = indexPath.row
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? StudentExamCell else{return UITableViewCell()}
            let examList = tableViewData[indexPath.section].sectionData
            let exam = examList[indexPath.row - 1]
            cell.tag = indexPath.row - 1
            cell.scoreBtn.backgroundColor = Color.LightSlateBlue
            cell.scoreBtn.layer.cornerRadius = 15
            cell.cellView.layer.cornerRadius = 15
            cell.cellView.backgroundColor = Color.DeepSkyBlue
            cell.scoreBtn.tag = indexPath.row
            cell.indexPath = indexPath
            tableView.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0)
            cell.subjectLabel.text = "考試科目" + exam.examtitle
            return cell
        }
      

//        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData[indexPath.section].isOpen == true{
            tableViewData[indexPath.section].isOpen = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }else{
            tableViewData[indexPath.section].isOpen = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "QueryExam"{
            if let indexPath = tableView.indexPathForSelectedRow{
            let contoller = segue.destination as? StudentExamQuery
            contoller?.subject = self.tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            }
        }
        else if segue.identifier == "QueryExamScore"{
            guard let button = sender as? UIButton else{
                return
            }
            guard let cell = button.superview?.superview as? StudentExamCell,let indexPath = tableView.indexPath(for: cell) else{
                return
            }
            let contoller = segue.destination as? StudentExamQueryScore
            contoller?.subject = self.tableViewData[indexPath.section].sectionData[indexPath.row - 1]
        }
    }

}
