//
//  GradeTableViewCell.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/7/20.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate:class {
    func change(cell:Cell,score:Int)
}

class Cell: UITableViewCell {

    weak var delegate:TableViewCellDelegate?
    
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var studentIDLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var scoreTextField: UITextField!
    
    @IBOutlet weak var studentIDLabel2: UILabel!
    
    @IBOutlet weak var studentNameLabel2: UILabel!
    
    @IBOutlet weak var scoreTextField2: UITextField!
    
    @IBAction func changeValue(_ sender: UITextField) {
        guard let text = Int(sender.text!) else {
            return
        }
        delegate?.change(cell: self, score: text)
        
    }
  
    @IBAction func changeValue2(_ sender: UITextField) {
        guard let text = Int(sender.text!) else{
            return
        }
        delegate?.change(cell: self, score: text)
    }
}







