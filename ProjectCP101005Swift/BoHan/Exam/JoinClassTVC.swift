//
//  JoinClassTVC.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/7/26.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit
struct custom {
     static let color = UIColor(red: 30.0/255.0, green: 144.0/255.0, blue: 245.0/255.0, alpha: 1.0)
}

class JoinClassTVC: UITableViewController {

    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var cell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cell.layer.cornerRadius = 30
        self.cell.layer.borderColor = UIColor.blue.cgColor
        self.cell.backgroundColor = custom.color
        self.joinBtn.tintColor = UIColor.red
        self.joinBtn.frame.size.height = cell.frame.size.height
        self.joinBtn.frame.size.width = 100.0
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
    func joinClass() {
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            return
        }
        let dictionary: [String:Any] = ["action":"Join","ClassId":4,"TeacherId":2]
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
                let join = try jsonDecoder.decode(Class.self, from: data)
                
                
            }catch{
                
            }
        }
    }
    
    
    @IBAction func addBtn(_ sender: UIButton) {
        joinClass()
        let alert = UIAlertController(title: "完成", message: "新增成功", preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
        sender.isEnabled = false
        
    }

}
