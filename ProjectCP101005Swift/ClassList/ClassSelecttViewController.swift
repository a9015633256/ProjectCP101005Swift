//
//  ClassSelecttViewController.swift
//  ProjectCP101005Swift
//
//  Created by 涂文鴻 on 2018/8/2.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class ClassSelecttViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    
    let communicator = Communicator()
    
    var classJoin = [ClassJoin]()
   
   
    @IBOutlet weak var classSelectSG: UISegmentedControl!
    
    @IBOutlet weak var classTableview: UITableView!
    
    var teacherName:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teacherName = UserDefaults.standard.string(forKey: "account")
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowPopOver"{
                let controller = segue.destination
                let delegate = self as UIPopoverPresentationControllerDelegate
//                controller.popoverPresentationController?.delegate = delegate
            }
            func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
                return UIModalPresentationStyle.none
            }
            
        }
        classTableview.delegate = self
        classTableview.dataSource = self
        getMainClass()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMainClass()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func classSelect(_ sender: Any) {
        
        switch classSelectSG.selectedSegmentIndex {
        case 0 :
            getMainClass()
            
        case 1 :
            getJoinClass()
           
        default:
            getMainClass()
        
           
            
        
    }
}
    
    func getMainClass() {
        
        let action = GetClass(action: "getAll", name: teacherName)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init()
        guard let uploadData = try? encoder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        communicator.dopost(url: LOGIN_URL, data: uploadData) { (error, result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            guard let output = try? JSONDecoder().decode([ClassJoin].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            self.classJoin = output
            
            print("\(self.classJoin)")
            self.classTableview.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPopOver"{
            let controller = segue.destination.popoverPresentationController
            controller?.delegate = self
            
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    
    func getJoinClass() {
        let action = GetClass(action: "getJoin", name: teacherName)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init()
        guard let uploadData = try? encoder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        communicator.dopost(url: LOGIN_URL, data: uploadData) { (error, result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            guard let output = try? JSONDecoder().decode([ClassJoin].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            
            self.classJoin = output
            if let item = try? JSONEncoder().encode(self.classJoin){
            UserDefaults.standard.set(item, forKey: "JoinList")
            }
            
            self.classTableview.reloadData()
        }
        
    }
}




extension ClassSelecttViewController: UITableViewDataSource{
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classJoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CoolCellTableViewCell
        
       cell.className.text = classJoin[indexPath.row].classes
        if let id = classJoin[indexPath.row].id{
            cell.id.text = ("\(id)")
        }
        cell.teachName.text = classJoin[indexPath.row].teacher
        
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .init()
        
        let deleteaction = deleteClass(action: "delete", classname: classJoin[indexPath.row].classes, teachername: teacherName)
        guard  let data = try? encoder.encode(deleteaction) else {
            assertionFailure("endcode fail")
            return
        }
        communicator.dopost(url: LOGIN_URL, data: data) { (error, result) in
            guard let result = result, let dataString = String(data: result, encoding: .utf8) else {
                assertionFailure("get data fail")
                return
            }
            if dataString == "1" {
                self.classJoin.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }else{
                let alert = UIAlertController(title: "錯誤", message: "非導師班無法刪除", preferredStyle: .alert)
                let action = UIAlertAction(title: "確認", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true, completion: nil)
            }
            
        }
    }
    
    //資料存入偏好設定
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userDefaults = UserDefaults.standard
        let classID = classJoin[indexPath.row].id
        let className = classJoin[indexPath.row].classes
        userDefaults.set(classID, forKey: "classId")
        userDefaults.set(className, forKey: "className")
        
    }
    
   
}

extension ClassSelecttViewController: UITableViewDelegate{
    
}
