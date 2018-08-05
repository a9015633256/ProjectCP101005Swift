//
//  ClassCell.swift
//  ProjectCP101005Swift
//
//  Created by Bohan on 2018/8/2.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {

    
    @IBOutlet weak var classNameLabel: UILabel!
    
    @IBOutlet weak var teacherAccountLabel: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var classCodeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
