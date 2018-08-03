//
//  HomeworkCheckTableViewCell.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/8/1.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit

class HomeworkCheckTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var studentNumberLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    var controller: TeacherHomeworkCheckTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //configure switchBtn
        switchButton.setImage(#imageLiteral(resourceName: "cross_red"), for: .selected)
        switchButton.setImage(#imageLiteral(resourceName: "cross_grey"), for: .normal)
        switchButton.setTitle("", for: .selected)
        switchButton.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    @IBAction func switchBtnPressed(_ sender: Any) {
        switchButton.isSelected = !switchButton.isSelected
        controller?.saveChanges(for: self.tag, isHomeworkDone: !switchButton.isSelected)
    }
    
}
