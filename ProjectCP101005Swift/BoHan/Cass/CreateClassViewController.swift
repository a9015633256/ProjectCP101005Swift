//
//  CreateClassViewController.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/7/17.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit
class CreateClassViewController: UIViewController {
    
  
    var createClass = Class()

    @IBOutlet weak var classNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func configureView()  {
        guard let url = URL(string: PropertyKeysForConnection.BoHanServlet) else {
            assertionFailure()
            return
        }
        
        
        guard let text = self.classNameTextField.text, text.isEmpty == false else {
            let alert = UIAlertController(title: "錯誤", message: "不允許輸入空白字串", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        
        
        let dictionary: [String:Any] = ["action":"insertClass","ClassName": text,"ClassTeacher":"cp111@gg.com"]
        
        
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
                let create = try jsonDecoder.decode(Class.self, from: data)
                self.classNameTextField.text = create.name
                print(create.classID)
            }catch{
                print("json parse failed: \(error)")
                return
            }
        }
    }
    
    
    
    @IBAction func CreateClass(_ sender: Any) {
        configureView()
        self.classNameTextField.resignFirstResponder()
        
        let alert = UIAlertController(title: "完成", message: "建立成功", preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default) { (status) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
       
    }
    
}
