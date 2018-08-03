//
//  StudentInfoEditTableViewController.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/24.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class StudentInfoEditTableViewController: UITableViewController {
    
    var communicator: CommunicatorMingTa?
    var student:Student?
    var photo:UIImage?
    let datePicker = UIDatePicker()
    var jpgData: Data?


    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var studentIDTextField: UITextField!
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var dayOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
//
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 6 {
            return 0
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

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
    
    @IBAction func takePhotoBtnPressed(_ sender: Any) {
        self.launchPicker(forType: .camera)
    }
    
    @IBAction func pickPhotoBtnPressed(_ sender: Any) {
        self.launchPicker(forType: .photoLibrary)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        
        //upadate data in "student"
        if genderSegmentedControl.selectedSegmentIndex == 0 {
            student?.gender = 1
        } else {
            student?.gender = 2
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let text = dayOfBirthTextField.text, let dayOfBirth = dateFormatter.date(from: text){
            student?.dayOfBirth = dayOfBirth
        }
        student?.phoneNumber = phoneNumberTextField.text!
        student?.address = addressTextView.text
        
        //update to server
        let jsonEncoder = JSONEncoder()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter2)

        guard let student = try? jsonEncoder.encode(student) else {
            assertionFailure()
            return
        }

        guard let studentString = String(data: student, encoding: .utf8) else {
            assertionFailure()
            return
        }
        
        var dic: [String: Any] = ["action":"updateStudentInfo","student": studentString]
        
        if let jpgData = jpgData {
            let photoBase64 = jpgData.base64EncodedString()
            dic["studentPhoto"] = photoBase64
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
            assertionFailure()
            return
        }

        guard let url = URL(string: PropertyKeysForConnection.urlStudentServlet) else {
            assertionFailure()
            return
        }
        
        communicator = CommunicatorMingTa(targetURL: url)

        communicator?.download(from: data, doneHandler: { (error, data) in
            
            if let error = error {
                print("error update student info: \(error)")
                let alert = UIAlertController(title: "更新失敗", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let data = data else {
                assertionFailure()
                return
            }
            
            guard let count = String(data: data, encoding: .utf8), count == "1" else {
                
                let alert = UIAlertController(title: "更新失敗", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
                
            }
            
            let alert = UIAlertController(title: "更新成功", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func configureView(){
        
        
        //show info from previous page
        guard let student = student, let photo = photo else {
            return
        }
        
        if let id = student.id {
            self.studentIDTextField.text = String(id)
        }
        self.nameTextField.text = student.name
        if student.gender == 1 {
            self.genderSegmentedControl.selectedSegmentIndex = 0
        } else {
          self.genderSegmentedControl.selectedSegmentIndex = 1
        }
        self.addressTextView.text = student.address
        self.classNameTextField.text = student.className
        self.phoneNumberTextField.text = student.phoneNumber
        
        if let dayOfBirth = student.dayOfBirth {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dayOfBirthTextField.text = dateFormatter.string(from: dayOfBirth)
        }
       
        
        photoImageView.image = photo
        
        //ui function
        createDatePicker()
        
        addressTextView.sizeToFit()
        
    }
    
    func createDatePicker(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //set datePicker's mode and date
        datePicker.datePickerMode = .date
        if let text = dayOfBirthTextField.text, let date = dateFormatter.date(from: text) {
        datePicker.date = date
        }
        
        
        //set bar for datePicker
        let datePickerBar = UIToolbar()
        datePickerBar.sizeToFit()
        let doneBarItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickingDate))
         let cancelBarItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPickingDate))
        datePickerBar.setItems([doneBarItem, cancelBarItem], animated: true)
       
       //set inputView for textField
        dayOfBirthTextField.inputAccessoryView = datePickerBar
        
        dayOfBirthTextField.inputView = datePicker
        
        
    }
    
    @objc
    func donePickingDate(){
        
        //set result on screen
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dayOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
        
        view.endEditing(true)
        
        
    }
    
    @objc
    func cancelPickingDate(){
      
        view.endEditing(true)
        
    }
    
  
    

}

extension StudentInfoEditTableViewController: UITextFieldDelegate {
    
    //stop dayOfBirth changed by input manually
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    
}

extension StudentInfoEditTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func launchPicker(forType: UIImagePickerControllerSourceType){
        guard UIImagePickerController.isSourceTypeAvailable(forType) else {
            print("\(#function)-Picker type \(forType) not available")
            return
        }
        
        let picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeImage as String]
        picker.sourceType = forType
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let type = info[UIImagePickerControllerMediaType] as? String else {
            assertionFailure("Invalid type.")
            return
        }
        
        if type == kUTTypeImage as String {
            guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                assertionFailure("Can't fetch originalImage")
                return
            }
            
            guard let resizedImage = originalImage.resize(maxWidthHeight: photoImageView.frame.height) else {
                assertionFailure("Fail to resize image.")
                return
            }
            
            photoImageView.image = resizedImage
            
            jpgData = UIImageJPEGRepresentation(resizedImage, 1)
            
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}


