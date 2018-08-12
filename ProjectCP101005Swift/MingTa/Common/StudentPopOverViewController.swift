//
//  StudentPopOverViewController.swift
//  ProjectCP101005Swift
//
//  Created by Ming-Ta Yang on 2018/8/8.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class StudentPopOverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
  
    @IBAction func logOut(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "登出", message: "確定要登出嗎?\n所有未儲存的資訊將會流失!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "登出", style: .default) { (_) in
            
            self.dismiss(animated: true, completion: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
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
