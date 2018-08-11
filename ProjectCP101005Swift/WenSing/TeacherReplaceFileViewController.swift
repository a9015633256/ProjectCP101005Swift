//
//  TeacherReplaceFileViewController.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/8/6.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TeacherReplaceFileViewController: UIViewController{
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var teacherImageView: UIImageView!
    
    //學號，班級，姓名，性別，生日，電話
    //"UPDATE Teachers SET Teacher_Account = ?,Teacher_Email= ?,Teacher_Gender = ? ,Teacher_Phone = ?,Teacher_TakeOfficeDate = ?, Teacher_Photo = ? WHERE id = ?;";
    
    private let picker = UIImagePickerController()
    private let cropper = UIImageCropper(cropRatio: 1/1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
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
    
    //確認更改
    @IBAction func replaceConformBtn(_ sender: Any) {
        conformToReplaceFile()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func takePhotoWithCamara() {
        
    }
    
    func pickPhotoWithFileHolder() {
        
    }
    
    func conformToReplaceFile() {
//        let ownerId = UserDefaults.standard.integer(forKey: "ownerId")
//
//        guard let name = nameInputText.text,
//            let gender = genderInputText.text,
//            let birthday = birthdayInputText.text,
//            let variety = varietyInputText.text,
//            let ageText = ageInputText.text,
//            let age = Int(ageText) else {
//                return
//        }
//
//        let dog = Dog(ownerId: ownerId, dogId: nil, name: name, gender: gender, variety: variety, birthday: birthday, age: age)
//
//        guard let uploadData = try? JSONEncoder().encode(dog) else {
//            return
//        }
//
//        communicator.doPost(url: DogServlet, data: uploadData, status: ADD_DOG, kind: "dog") { (result) in
//
//            guard let result = result,let jsonIn = (try? JSONSerialization.jsonObject(with: result, options: [] )) as? [String:Int] else {
//                return
//            }
//
//            guard let dogId = jsonIn["dogId"] else {
//                return
//            }
//
//            UserDefaults.standard.set(dogId, forKey: "dogId")
//            self.sendImage(dogId: dogId)
//        }

//    }
    
//    func sendImage(dogId:Int){
//        guard let image = postImage, let imageData = UIImagePNGRepresentation(image) else {
//            print("image cast to data fail")
//            return
//        }
//        let base64String = imageData.base64EncodedString()
//
//        var data = [String:Any]()
//        data["status"] = SET_PROFILE_PHOTO
//        data["dogId"] = dogId
//        data["media"] = base64String
//        data["type"] = 1
//        communicator.doPost(url: MediaServlet, data: data) { (result) in
//            guard let result = result else {
//                return
//            }
//            print("status: \(result)")
//        }
//    }
    
}

//extension TeacherReplaceFileViewController : UIImageCropperProtocol,UIPickerViewDelegate,UIPickerViewDataSource {
//
//    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
//        print("hello")
//        postImage = croppedImage
//        profileImageView.image = croppedImage
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if whichInput == "gender" {
//            return gender.count
//        } else {
//            return variety.count
//        }
//
//    }
//
//    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if whichInput == "gender" {
//            return gender[row]
//        } else {
//            return variety[row]
//        }
//    }
//
//    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if whichInput == "gender" {
//            genderInputText.text = gender[row]
//        } else {
//            varietyInputText.text = variety[row]
//        }
//
//    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
