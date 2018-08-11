//
//  StudentExamCell.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/8.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class StudentExamCell: UITableViewCell {

    var indexPath:IndexPath?
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var subjectLabel: UILabel!
   
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentID: UILabel!
    
    @IBOutlet weak var Score: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var subjectTit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
