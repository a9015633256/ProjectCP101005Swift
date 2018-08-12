//
//  TeacherHomeworkCheckTableViewController.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/27.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit
import Charts

class TeacherHomeworkCheckTableViewController: UITableViewController {
    
    var homework:HomeworkIsDone?

    var homeworkCheckList = [HomeworkCheck]()
    var homeworkCheckListToUpdate = [HomeworkCheck]()
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        configureView()
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        guard let parent = parent else {
            return
        }
        configureView(with: parent)
        
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
        return homeworkCheckList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HomeworkCheckTableViewCell else {
            return UITableViewCell()
        }
        
        let student = homeworkCheckList[indexPath.row]
        print(student)
        cell.controller = self
        cell.tag = indexPath.row
        cell.studentNumberLabel.text = student.studentNumber
        cell.nameLabel.text = student.studentName
        guard let isHomeworkDone = student.isHomeworkDone else {
            assertionFailure()
            return cell
        }
        cell.switchButton.isSelected = !isHomeworkDone

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

    // MARK: - ConfigureView
    
    func configureView(with parent: UIViewController){
        
        let saveBtn = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(checkComplete))
        
        parent.navigationItem.rightBarButtonItems = []
        parent.navigationItem.rightBarButtonItems?.append(saveBtn)
        
    }
    
    func configureView() {
        
        //get data from DB
        guard let url = URL(string: PropertyKeysForConnection.urlHomeworkServlet) else {
            assertionFailure()
            return
        }
        
        guard let homework = homework, let id = homework.id else {
            assertionFailure("Can't find homework")
            return
        }
        
        let dictionary: [String: Any] = ["action": "findHomeworkCheckByHomeworkId", "homeworkId": id]
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
            else {
                assertionFailure("fail to create JsonObject")
                return
        }
        
        let communicator = CommunicatorMingTa(targetURL: url)
        communicator.download(from: data) { (error, data) in
            
            if let error = error {
                print("\(#function) error: \(error)")
                return
            }
            
            guard let data = data else {
                assertionFailure()
                return
            }
            
            let jsonDeconder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            jsonDeconder.dateDecodingStrategy = .formatted(dateFormatter)
            
            var homeworkCheckList = [HomeworkCheck]()
            
            
            do{
                try homeworkCheckList = jsonDeconder.decode([HomeworkCheck].self, from: data)
                
            } catch {
                assertionFailure("json parse fail: \(error)")
                return
            }
            
            self.homeworkCheckList = homeworkCheckList
            
            //show data  on tableview
            self.tableView.reloadData()
            
            self.setupChart()
        }
        
        
    }
    
    // MARK: - SaveChanges
    func saveChanges(for row:Int, isHomeworkDone: Bool){
        homeworkCheckList[row].isHomeworkDone = isHomeworkDone
        homeworkCheckListToUpdate.append(homeworkCheckList[row])

    }
    
    
    // MARK: - ConnectServer
    @objc
    func checkComplete(){
        
        //make jsonObject
        guard let homework = homework, let id = homework.id else {
            assertionFailure("no homework in field")
            return
        }
        
        let jsonEncoder = JSONEncoder()
        
        guard let homeworkCheckListData = try? jsonEncoder.encode(homeworkCheckListToUpdate) else {
            assertionFailure("fail to encode new homework")
            return
        }
        
        guard let jsonString = String(data: homeworkCheckListData, encoding: .utf8) else {
            assertionFailure("fail to creat jsonString")
            return
        }
        
        
        let dic:[String: Any] = ["action": "updateHomeworkCheck",
                                 "homeworkId": id,
                                 "homeworkCheckList": jsonString
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
            assertionFailure("fail to create jsonObject")
            return
        }
        
        //connect server
        guard let url = URL(string: PropertyKeysForConnection.urlHomeworkServlet) else {
            assertionFailure()
            return
            
        }
        
        let communicator = CommunicatorMingTa(targetURL: url)
        
        communicator.download(from: data) { (error, data) in
            if let error = error {
                print("error: \(error)")
                
                showSimpleAlert(title: "儲存失敗", "確定", sender: self, completion: nil)
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
                showSimpleAlert(title: "儲存成功", "確定", sender: self, completion: { (ok) in
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                showSimpleAlert(title: "儲存失敗", "確定", sender: self, completion: nil)
            }
        }
    }
    
    
    // MARK: - Charts
    func setupChart(){
        
        pieChartView.legend.enabled = false
        pieChartView.animate(xAxisDuration: 1)
        pieChartView.animate(yAxisDuration: 1)
        
        let pieEntries = getChartEntries()
        let pieChartDataSet = PieChartDataSet(values: pieEntries, label: "繳交情況")
        pieChartDataSet.valueTextColor = UIColor.white
        pieChartDataSet.sliceSpace = 2
        let red = #colorLiteral(red: 0.8784313725, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        let green = #colorLiteral(red: 0.2705882353, green: 0.8784313725, blue: 0.07450980392, alpha: 1)
        var colors = [UIColor]()
        colors.append(green)
        colors.append(red)
        pieChartDataSet.colors = colors
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.notifyDataSetChanged()
        
    }
  
    func getChartEntries() -> [PieChartDataEntry]{
        
        //sort data
        var undoneCount = 0
        var doneCount = 0
        
        for homeworkCheck in homeworkCheckList {
            if let isDone = homeworkCheck.isHomeworkDone, isDone{
                doneCount += 1
            }else {
                undoneCount += 1
            }
        }
        
        //set entries
        var entries = [PieChartDataEntry]()
        entries.append(PieChartDataEntry(value: Double(doneCount), label: "已繳交"))
        entries.append(PieChartDataEntry(value: Double(undoneCount) , label: "未繳交"))
        print(doneCount)
        print(undoneCount)
        
        return entries
        
    }
    
}
