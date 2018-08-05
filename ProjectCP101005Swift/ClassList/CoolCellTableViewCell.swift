//
//  CoolCellTableViewCell.swift
//  ProjectCP101005Swift
//
//  Created by 涂文鴻 on 2018/8/2.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class CoolCellTableViewCell: UITableViewCell {

    @IBOutlet weak var view: RoundedPassCodeView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var teachName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
