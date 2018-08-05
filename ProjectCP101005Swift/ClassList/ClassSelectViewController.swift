//
//  ClassSelectViewController.swift
//  ProjectCP101005Swift
//
//  Created by 涂文鴻 on 2018/8/1.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class ClassSelectViewController: UIViewController {

    @IBOutlet weak var classShow: UIView!
    @IBOutlet weak var classSelectSG: UISegmentedControl!
    
    
    let classMain = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ClassMain")
    let classJoin = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ClassJoin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 23.0)
        let attributes: [NSObject : AnyObject]? = [ kCTFontAttributeName : font! ]
        self.classSelectSG.setTitleTextAttributes(attributes, for: UIControlState.normal)
        self.classSelectSG.tintColor = UIColor.darkGray

        // Do any additional setup after loading the view.
        
        classShow.addSubview(classMain.view)
        classSelectSG.selectedSegmentIndex = 0
//        classSelectSG.isHidden = false
        
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

    @IBAction func classSelect(_ sender: Any) {
        
        switch classSelectSG.selectedSegmentIndex {
        case 0:
            classShow.addSubview(classMain.view)
        case 1:
            classShow.addSubview(classJoin.view)
        default:
            classShow.addSubview(classMain.view)
        }
        
    }
}
