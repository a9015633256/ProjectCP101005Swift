//
//  HomeworkDetailTableViewCell.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/6/6.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit

class HomeworkDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var completionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
