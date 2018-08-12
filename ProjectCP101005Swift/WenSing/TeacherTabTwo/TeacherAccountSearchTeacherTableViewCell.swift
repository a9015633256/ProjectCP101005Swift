//
//  TeacherAccountSearchTeacherTableViewCell.swift
//  ProjectCP101005Swift
//
//  Created by 楊文興 on 2018/8/8.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class TeacherAccountSearchTeacherTableViewCell: UITableViewCell {

    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var teacherPhoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
