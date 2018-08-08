//
//  StudentInfoTableViewController.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/23.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit

class StudentInfoTableViewController: UITableViewController {
    
    var communicator: CommunicatorMingTa?
    var student: Student?
    var photo: UIImage?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var studentIDTextField: UITextField!
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var dayOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
        
        if let controller = segue.destination as? StudentInfoEditTableViewController {
            
            controller.student = self.student
            controller.photo = self.photo
        }
        
        if segue.identifier == "ShowPopOver" {
            let controller = segue.destination.popoverPresentationController
            controller?.delegate = self
            
        }
        
        
    }
    
    
    func configureView(){
        
        //get data from db
        guard let url = URL(string: PropertyKeysForConnection.urlStudentServlet) else {
            assertionFailure()
            return
        }
        
        var dictionary: [String: Any] = ["action": "findStudentById", "studentId": 2]
        
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            assertionFailure()
            return
        }
        
        let communicator = CommunicatorMingTa(targetURL: url)
        communicator.download(from: data) { (error, data) in
            if let error = error {
                print("error finding studentInfo: \(error)")
                return
            }
            
            guard let data = data else {
                assertionFailure()
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do{
                let student = try jsonDecoder.decode(Student.self, from: data)
                
                if let id = student.id {
                    self.studentIDTextField.text = String(id)
                }
                self.nameTextField.text = student.name
                if student.gender == 1 {
                    self.genderSegmentedControl.selectedSegmentIndex = 0
                } else {
                    self.genderSegmentedControl.selectedSegmentIndex = 1
                }
                self.addressTextField.text = student.address
                self.classNameTextField.text = student.className
                self.phoneNumberTextField.text = student.phoneNumber
                if let dayOfBirth = student.dayOfBirth {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    self.dayOfBirthTextField.text = dateFormatter.string(from: dayOfBirth)
                }
                
                self.student = student
                
            } catch {
                
                print("json parse failed: \(error)")
                return
            }
        }
        
        dictionary = ["action": "getImage", "id": 2, "imageSize": photoImageView.frame.height]
        
        guard let photoData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            assertionFailure()
            return
        }
        
        communicator.download(from: photoData) { (error, data) in
            
            if let error = error {
                print("error finding studentInfo: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                assertionFailure()
                return
            }
            
            self.photoImageView.image = image
            
            self.photo = image
            
        }
        
        
    }
    
}

extension StudentInfoTableViewController: UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}



