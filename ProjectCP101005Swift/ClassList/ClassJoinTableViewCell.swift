//
//  ClassJoinTableViewCell.swift
//  ProjectCP101005Swift
//
//  Created by 涂文鴻 on 2018/8/1.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class ClassJoinTableViewCell: UITableViewCell {

    @IBOutlet weak var className: UILabel!
    
    @IBOutlet weak var classTeacher: UILabel!
    
    @IBOutlet weak var classID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
