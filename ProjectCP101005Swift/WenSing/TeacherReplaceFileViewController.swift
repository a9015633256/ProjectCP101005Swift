//
//  TeacherReplaceFileViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/8/6.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class TeacherReplaceFileViewController: UIViewController{
   
    var communicator = CommunicatorWenSing()
    
    var communicator2: CommunicatorMingTa?
    
    var teacherFile = [TeachersFile2]()
    
    var teacherUploadFile = TeachersFile()
    
    var jpgData: Data?
    
    let datepicker = UIDatePicker()
    
    var date = "1990-01-01"
    
    let dateformater = DateFormatter()
    
    var pickerLabel : UILabel!
    
    var teacherImageDictionary = UIImage()
    
    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var accountInputText: UITextField!
    @IBOutlet weak var nameInputText: UITextField!
    @IBOutlet weak var genderInputText: UISegmentedControl!
    @IBOutlet weak var birthInputText: UITextField!
    @IBOutlet weak var phoneNumberInputText: UITextField!
    
    //學號，班級，姓名，性別，生日，電話
    //"UPDATE Teachers SET Teacher_Account = ?,Teacher_Email= ?,Teacher_Gender = ? ,Teacher_Phone = ?,Teacher_TakeOfficeDate = ?, Teacher_Photo = ? WHERE id = ?;";
    
    private let picker = UIImagePickerController()
    private let cropper = UIImageCropper(cropRatio: 1/1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        //假資料
        let teacherId = UserDefaults.standard.string(forKey: "account")
        getTeacherFile(teacherId: teacherId!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //拍照按鈕
    @IBAction func takePhotoShotBtn(_ sender: Any) {
        takePhotoWithCamara()
    }
    
    //選照按鈕
    @IBAction func pickNewPhotoBtn(_ sender: Any) {
        pickPhotoWithFileHolder()
    }
    
    //確認更改按鈕
    @IBAction func replaceConformBtn(_ sender: Any) {
        conformToReplaceFile()
    }
    
    func takePhotoWithCamara() {
        self.launchPicker(forType: .camera)
    }
    
    func pickPhotoWithFileHolder() {
        self.launchPicker(forType: .photoLibrary)
    }
    
    //更改檔案內容
    func conformToReplaceFile() {
        //getTeacher_Account getTeacher_Email getTeacher_Gender getTeacher_Phone getTeacher_TakeOfficeDate   getId
        //ACTION_UPDATE_PROFILE上傳的action
        
        //抓取輸入資料
        teacherUploadFile.Teacher_Account = accountInputText.text
        teacherUploadFile.Teacher_Email = nameInputText.text
        
        if genderInputText.selectedSegmentIndex == 0 {
            teacherUploadFile.Teacher_Gender = 1
        }else {
            teacherUploadFile.Teacher_Gender = 2
        }
        
        teacherUploadFile.Teacher_Phone = phoneNumberInputText.text
        
        teacherUploadFile.id = UserDefaults.standard.integer(forKey: "uploadThisOne")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        teacherUploadFile.Teacher_TakeOfficeDate = birthInputText.text
        
        let jsonEncoder = JSONEncoder()
        
        guard let teacher = try? jsonEncoder.encode(teacherUploadFile) else {
            assertionFailure()
            return
        }
        
        guard let teacherString = String(data: teacher, encoding: .utf8) else {
            assertionFailure()
            return
        }
        
        var dic: [String: Any] = ["action" : ACTION_UPDATE_PROFILE, "teacherList" : teacherString]
        
        if let jpgData = jpgData {
            let photoBase64 = jpgData.base64EncodedString()
            dic["Teacher_Photo"] = photoBase64
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
            assertionFailure()
            return
        }
        
        guard let url = URL(string:TEACHER_LIST_SERVLET ) else {
            assertionFailure()
            return
        }
        
        
        communicator2 = CommunicatorMingTa(targetURL: url)
        
        communicator2?.download(from: data, doneHandler: { (error, data) in
            
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
    
    
    //output[{"id":2,"Teacher_Account":"cp102@hotmail.com","Teacher_Password":"22222","Teacher_Email":"Bob","Teacher_Gender":1,"Teacher_Phone":"0987654322","Teacher_TakeOfficeDate":"2018-04-02"}]

    func getTeacherFile(teacherId: String){
        let action = FindTeacherFile(action: ACTION_GET_TEACHER_FILE, Teacher_Account: teacherId)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init()
        guard let uploadData = try? encoder.encode(action) else {
            assertionFailure("JSON encode fail")
            return
        }
        communicator.doPost(url: TEACHER_LIST_SERVLET, data: uploadData) { (result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            
            //等待求救，無法output
            guard let output = try? JSONDecoder().decode([TeachersFile2].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            
            self.teacherFile = output
            print("JSON: \(self.teacherFile)")
            
            //將文字匯入edittext
            self.accountInputText.text = self.teacherFile[0].Teacher_Account
            self.birthInputText.text = self.teacherFile[0].Teacher_TakeOfficeDate
            self.phoneNumberInputText.text = self.teacherFile[0].Teacher_Phone
            self.nameInputText.text = self.teacherFile[0].Teacher_Email
            switch self.teacherFile[0].Teacher_Gender {
            case 1:
                self.genderInputText.selectedSegmentIndex = 0
            case 2:
                self.genderInputText.selectedSegmentIndex = 1
            default:
                self.genderInputText.selectedSegmentIndex = 0
            }
            //取得圖片
            let teacherId2 = self.teacherFile[0].id
            UserDefaults.standard.set(teacherId2, forKey: "uploadThisOne")
            self.getFriendImage(teacherId: teacherId2!)
            
        }
        
    }
    
    func getFriendImage(teacherId: Int){
        
        let action = GetImageAction(action: ACTION_GET_IMAGE, id: teacherId, imageSize: 150)
        // 準備將資料轉為JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init()
        // 轉為JSON
        guard let uploadData = try? encoder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        // 送資料 and 解析回傳的JSON資料
        communicator.doPost(url: TEACHER_LIST_SERVLET, data: uploadData) { (result) in
            
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            
            guard let image = UIImage.init(data: result) else {
                return
            }
            
            self.teacherImageDictionary = image
            print("搜尋圖片\(result)")
            self.teacherImageView.image = image
        }
        
    }
    
    //返回鍵
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //模組化時鐘，只需要修改IBoutlet
    func createDatePicker(){
        dateformater.dateFormat = "YYYY-MM-dd"
        let newdate = dateformater.date(from: date)
        datepicker.datePickerMode = .date
        datepicker.setDate(newdate!, animated: true)
        datepicker.locale = Locale(identifier: "zh_TW")
        
        birthInputText.inputView = datepicker
        datepicktoolbar()
    }
    
    func datepicktoolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(happybirthdayclicker))
        toolbar.setItems([doneButton], animated: false)
        birthInputText.inputAccessoryView = toolbar
        
    }
    
    @objc//人數#selector
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc
    func happybirthdayclicker() {
        dateformater.dateFormat = "YYYY-MM-dd"
        
        birthInputText.text = dateformater.string(from: datepicker.date)
        self.view.endEditing(true)
    }
    
}

extension TeacherReplaceFileViewController: UITextFieldDelegate {
    
    //stop dayOfBirth changed by input manually
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}

extension TeacherReplaceFileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
            
            guard let resizedImage = originalImage.resize(maxWidthHeight: teacherImageView.frame.height) else {
                assertionFailure("Fail to resize image.")
                return
            }
            
            teacherImageView.image = resizedImage
            
            guard let uploadImage = originalImage.resize(maxWidthHeight: self.view.frame.height) else {
                assertionFailure("Fail to resize image.")
                return
            }
            
            jpgData = UIImageJPEGRepresentation(uploadImage, 1)
            
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
//    var datePicker : UIDatePicker!
//    var pickerLabel : UILabel!
    func dataPicker() {
        datepicker.datePickerMode = .date
        datepicker.date = NSDate() as Date
        datepicker.addTarget(self, action: #selector(show(datePicker:)), for: .valueChanged)
        birthInputText.inputView = datepicker
        
    }
    
    @objc
    func show(datePicker:UIDatePicker){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        birthInputText.text = dateFormater.string(from: datePicker.date)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}




