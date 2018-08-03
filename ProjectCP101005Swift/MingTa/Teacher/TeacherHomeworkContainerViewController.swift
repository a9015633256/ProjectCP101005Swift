//
//  TeacherHomeworkContainerViewController.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/27.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit

class TeacherHomeworkContainerViewController: UIViewController {
    var homework:HomeworkIsDone?
    var selectedViewController:UIViewController? {
        willSet{
            selectedViewController?.willMove(toParentViewController: nil)
            selectedViewController?.view.removeFromSuperview()
            selectedViewController?.removeFromParentViewController()
        }
        didSet{
            
            guard let selectedViewController = selectedViewController else {
                assertionFailure()
                return
            }
            
            //transfer data and configure motherView
            if let selectedViewController = selectedViewController as? TeacherHomeworkUpdateTableViewController{
                selectedViewController.homework = self.homework!
                
            } else if let selectedViewController = selectedViewController as?  TeacherHomeworkCheckTableViewController{
                selectedViewController.homework = self.homework!
            }
            
            //show view in container
            guard let view = selectedViewController.view else {
                assertionFailure("can't find view for containerView")
                return
            }
            containerView.addSubview(view)
            view.frame = containerView.frame
            selectedViewController.willMove(toParentViewController: self)
            self.addChildViewController(selectedViewController)
        }
    }

    @IBOutlet weak var toggleViewSegmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("homework: \(homework)")
        // Do any additional setup after loading the view.
        
        configureView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentValueDidChanged(_ sender: Any) {
        if toggleViewSegmentedControl.selectedSegmentIndex == 0 {
            selectedViewController = UIStoryboard(name: "MingTaStoryboard", bundle: nil).instantiateViewController(withIdentifier: "updateHomework")
        } else if toggleViewSegmentedControl.selectedSegmentIndex == 1 {
            selectedViewController = UIStoryboard(name: "MingTaStoryboard", bundle: nil).instantiateViewController(withIdentifier: "checkHomework")
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func configureView(){
        segmentValueDidChanged(self)
       
    }
    
    
    
    

}
