//
//  PopOverViewController.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/8.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createClass(_ sender: UIButton) {
        let vc = UIStoryboard(name: "BoHan", bundle: nil).instantiateViewController(withIdentifier: "createClass")
            self.presentingViewController?.show(vc, sender: self.presentingViewController)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func joinClass(_ sender: UIButton) {
        let vc = UIStoryboard(name: "BoHan", bundle: nil).instantiateViewController(withIdentifier: "joinClass")
        self.presentingViewController?.show(vc, sender: self.presentingViewController)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteClass(_ sender: UIButton) {
    }
    
    @IBAction func logOut(_ sender: UIButton) {
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
