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
   
    let communicator = CommunicatorWenSing()
    
    var teacherFile = [TeachersFile2]()
    
    var jpgData: Data?
    
    var datePicker : UIDatePicker!
    
    var pickerLabel : UILabel!
    
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
        
        //假資料
        let teacherId = UserDefaults.standard.string(forKey: "account")
        getTeacherFile(teacherId: teacherId!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //選擇生日
    @IBAction func birthdayPicker(_ sender: UITextField) {
        dataPicker()
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
            
        }
        
    }
    
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
            
            jpgData = UIImageJPEGRepresentation(resizedImage, 1)
            
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
//    var datePicker : UIDatePicker!
//    var pickerLabel : UILabel!
    func dataPicker() {
        datePicker.datePickerMode = .date
        datePicker.date = NSDate() as Date
        datePicker.addTarget(self, action: #selector(show(datePicker:)), for: .valueChanged)
        birthInputText.inputView = datePicker
        
        
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




