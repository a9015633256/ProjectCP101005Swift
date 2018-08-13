//
//  TeacherHomeworkTableViewController.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/26.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit

class TeacherHomeworkTableViewController: UITableViewController {
    
        class sectionData {
            var isOpen = false
            var title = ""
            var cellDataList = [HomeworkIsDone]()
            
            init(isOpen: Bool,title: String, cellDataList:[HomeworkIsDone] ) {
                self.isOpen = isOpen
                self.title = title
                self.cellDataList = cellDataList
            }
        }
        
        var sectionDataList = [sectionData]()
    
        let teacherReplaceFileController = UIStoryboard(name: "TeacherAccountClassDetail", bundle: nil).instantiateViewController(withIdentifier: "profileReplacePage")
        let transToLoginPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainLoginStoryboard")
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
       
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
            
//            let backButton = UIBarButtonItem(title: "返回班級選擇", style: .done, target: self, action: #selector())
//            navigationItem.leftBarButtonItems?.append(<#T##newElement: UIBarButtonItem##UIBarButtonItem#>)
            
        }
    
 
    
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            //抓取db資料並顯示在畫面上
            configureView()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return sectionDataList.count
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if sectionDataList[section].isOpen{
                return sectionDataList[section].cellDataList.count + 1
            } else {
                return 1
            }
            
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if indexPath.row == 0 { //假如是section的第一行->作header
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? HomeworkSectionHeaderCell else {
                    assertionFailure("can't find cell")
                    return UITableViewCell()
                }
                cell.dateLabel.text = sectionDataList[indexPath.section].title
                
                return cell
                
            } else { //其他作成作業列表
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? HomeworkDetailTableViewCell else {
                    assertionFailure("can't find cell")
                    return UITableViewCell()
                }
                
                let homeworkList = sectionDataList[indexPath.section].cellDataList
                
                let homework = homeworkList[indexPath.row-1]
                
                cell.subjectLabel.text = homework.subject
                cell.titleLabel.text = homework.title
                
                return cell
                
            }
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if indexPath.row == 0 {
                
                sectionDataList[indexPath.section].isOpen = !sectionDataList[indexPath.section].isOpen
                
                self.tableView.reloadSections([indexPath.section], with: .none)
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
        
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
            
            if let controller = segue.destination as? TeacherHomeworkContainerViewController{
                
                if let indexPath = tableView.indexPathForSelectedRow{
                    controller.homework = sectionDataList[indexPath.section].cellDataList[indexPath.row-1]
                }
            }
        }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        
           dismiss(animated: false, completion: nil)
        
    }
    
    
    
    
    // MARK: - ConfigureView
        
        func configureView() {
            
            //get data from DB
            guard let url = URL(string: PropertyKeysForConnection.urlHomeworkServlet) else {
                assertionFailure()
                return
            }
            
            let dictionary: [String: Any] = ["action": "findHomeworkByClassIdAndTeacherId", "classId": 1, "teacherId": 2]
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
                
                var homeworkIsDoneList = [HomeworkIsDone]()
                
                
                do{
                    try homeworkIsDoneList = jsonDeconder.decode([HomeworkIsDone].self, from: data)
                    
                } catch {
                    assertionFailure("json parse fail: \(error)")
                    return
                }
                
                //把資料按照日期分類
                let calendar = Calendar.current
                var titles = [String]()
                self.sectionDataList.removeAll()
                for homeworkIsDone in homeworkIsDoneList {
                    
                    guard let date = homeworkIsDone.date else {
                        print("homeworkIsDone.date is nil : \(homeworkIsDone)")
                        continue
                    }
                    
                    var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                    
                    guard let originalYear = dateComponents.year else{
                        print("Fail to get originalYear")
                        continue
                    }
                    dateComponents.year = originalYear - 1911
                    
                    guard let chineseDate = calendar.date(from: dateComponents) else {
                        print("Fail to form chinese date")
                        return
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyy年M月d日"
                    let title = dateFormatter.string(from: chineseDate)
                    
                    if titles.contains(title){
                        var sectionData = self.sectionDataList.filter({ (sectionData) -> Bool in
                            if sectionData.title == title{
                                return true
                            } else {
                                return false
                            }
                        })
                        
                        sectionData[0].cellDataList.append(homeworkIsDone)
                        
                    } else {
                        titles.append(title)
                        self.sectionDataList.append(sectionData(isOpen: false, title: title, cellDataList: [homeworkIsDone]))
                    }
                    
                }
                
                //show data  on tableview
                self.tableView.reloadData()
            }
            
            
        }
        
    @IBAction func setObjects(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionProfileReplaceHandler = {(action: UIAlertAction!) -> Void in
            //            self.classViewContainer.addSubview(self.teacherReplaceFileController.view)
            self.present(self.teacherReplaceFileController, animated: true, completion: nil)
        }
        let actionProfileReplace = UIAlertAction(title: "修改個人檔案", style: .default, handler: actionProfileReplaceHandler)
        optionMenu.addAction(actionProfileReplace)
        
        let actionCancel = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        optionMenu.addAction(actionCancel)
        
        let actionLogoutHandler = {(action: UIAlertAction!) -> Void in
            let alartLogoutMenu = UIAlertController(title: "確定要登出嗎？", message: nil, preferredStyle: .alert)
            let logoutCancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
            alartLogoutMenu.addAction(logoutCancelAction)
            let logoutHandler = {(action: UIAlertAction!) -> Void in
                
                self.present(self.transToLoginPage, animated: true, completion: nil)
            }
            let logout = UIAlertAction(title: "確定", style: .default, handler: logoutHandler)
            alartLogoutMenu.addAction(logout)
            self.present(alartLogoutMenu, animated: true, completion: nil)
        }
        let actionLogout = UIAlertAction(title: "登出", style: .default, handler: actionLogoutHandler)
        optionMenu.addAction(actionLogout)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
}
