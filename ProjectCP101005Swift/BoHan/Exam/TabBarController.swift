//
//  TabBarController.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/2.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var mainClass = Classes()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(mainClass)
        
        if let encoded = try? JSONEncoder().encode(mainClass){
            UserDefaults.standard.set(encoded, forKey: "Class")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print(segue.identifier)
//    }
//

}
