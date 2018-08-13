//
//  SetTitleTeacherTabBarViewController.swift
//  ProjectCP101005Swift
//
//  Created by 林沂諺 on 2018/8/13.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class SetTitleTeacherTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()

//        tabBar.items![2].title = "42424"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    func setUp() {
        
        
        
        
        //configure the view controllers here...
        

        tabBar.items?[2].title = "rfjiwer"
    
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
