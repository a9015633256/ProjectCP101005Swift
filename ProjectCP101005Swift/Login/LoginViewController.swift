//
//  LoginViewController.swift
//  ProjectCP101005Swift
//
//  Created by 涂文鴻 on 2018/7/27.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let userDefault = UserDefaults.standard
    
    
    @IBOutlet weak var account: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    let communicator = Communicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func LoginBtn(_ sender: Any) {
        
        guard let password = password.text, let account = account.text else {
            assertionFailure("inputEmail's is nil")
            return
        }
        
        
        let action = Action(action: "findByName", name: account, password: password)
        
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
            guard let output = try? JSONDecoder().decode(IsUserValid.self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            
            if output.isUserValid {
                let loginsb = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "classList")
                
                
//                guard let controller = loginsb.instantiateViewController() else {
//                    assertionFailure("aaaaa")
//                    return
//                }
                self.present(loginsb, animated: true)
                
                self.userDefault.set(account, forKey: "account")
                
                
                
                
            }else{
                let alert = UIAlertController(title: "錯誤", message: "錯誤", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
}
