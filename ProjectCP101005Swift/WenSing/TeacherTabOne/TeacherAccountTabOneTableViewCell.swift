//
//  TeacherAccountTabOneTableViewCell.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/7/30.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TeacherAccountTabOneTableViewCell: UITableViewCell {
    @IBOutlet weak var tabOneStudentImage: UIImageView!
    @IBOutlet weak var tabOneStudentNameLabel: UILabel!
    @IBOutlet weak var tabOneStudentPhoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
