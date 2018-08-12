//
//  ChatSelectTableViewCell.swift
//  ProjectCP101005Swift
//
//  Created by 林沂諺 on 2018/8/10.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class ChatSelectTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var receiverTitle: UILabel!
    @IBOutlet weak var receiverName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
