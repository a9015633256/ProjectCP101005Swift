//
//  RegisterViewController.swift
//  ProjectCP101005Swift
//
//  Created by 涂文鴻 on 2018/8/2.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var subjectTF: UITextField!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    let subjects = ["JAVA","Android_Studio","Math","English","Chinese"]
    
    let communicator = Communicator()
    
    
    var selectSubject : String?
    
    let datepicker = UIDatePicker()
    
    var date = "1990-01-01"
    let dateformater = DateFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createsubjectPiceker()
        createDatePicker()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDatePicker(){
        dateformater.dateFormat = "YYYY-MM-dd"
        let newdate = dateformater.date(from: date)
        datepicker.datePickerMode = .date
        datepicker.setDate(newdate!, animated: true)
        datepicker.locale = Locale(identifier: "zh_TW")
        
        birthday.inputView = datepicker
        datepicktoolbar()
    }
    
    func createsubjectPiceker() {
        let subjectPicker = UIPickerView()
        subjectPicker.delegate = self
        subjectPicker.backgroundColor = UIColor.white
        subjectTF.inputView = subjectPicker
        creatToolbar()
    }
    
    
     func creatToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        subjectTF.inputAccessoryView = toolbar
        
        
    }
    func datepicktoolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(happybirthdayclicker))
        toolbar.setItems([doneButton], animated: false)
        birthday.inputAccessoryView = toolbar
        
        
    }
    
    @objc//人數#selector
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc
    func happybirthdayclicker() {
        dateformater.dateFormat = "YYYY-MM-dd"
        
         birthday.text = dateformater.string(from: datepicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func registerButton(_ sender: Any) {

      let encoder = JSONEncoder()
        encoder.outputFormatting = .init()
        
        guard password.text == password2.text else {
            let alert = UIAlertController(title: "密碼你媽打錯", message: "錯誤", preferredStyle: .alert)
            let action = UIAlertAction(title: "worong", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true, completion: nil)
            return
        }
        var gender = sex.selectedSegmentIndex
        if gender == 0{
            gender = 1
        }else if gender == 1 {
            gender = 2
        }
        
        guard let account = account.text, let password = password.text, let name = name.text, let phone = phoneNumber.text,  let birthday = birthday.text, let subject = subjectTF.text  else {
            assertionFailure("有空")
            return
        }
        
        let action = Register(action: "insert", account: account, password: password, name: name, phone: phone, gender: gender, birthday: birthday, subject: subject)
        
        guard let uploadData = try? encoder.encode(action) else {
            assertionFailure("endcode fail")
            return
        }
        communicator.dopost(url: LOGIN_URL, data: uploadData) { (error, result) in
            guard let result = result, let dataString = String(data: result, encoding: .utf8) else {
                assertionFailure("get data fail")
                return
            }
            if dataString == "1" {
                self.navigationController?.popViewController(animated: true)
            }else {
                let alert = UIAlertController(title: "註冊失敗", message: "錯誤", preferredStyle: .alert)
                let action = UIAlertAction(title: "確認", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true, completion: nil)
                
            }
            
        }
        
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //人數picket 設置選擇框列數為1列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjects[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectSubject = subjects[row]
        subjectTF.text = selectSubject
//        person = numberOfTextField.text!
        
}
}
