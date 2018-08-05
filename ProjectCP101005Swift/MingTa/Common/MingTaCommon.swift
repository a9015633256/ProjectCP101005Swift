//
//  Common.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/26.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name{
    
    
}

func showSimpleAlert(title message:String, _ confirm: String, sender: UIViewController, completion: ((UIAlertAction) -> Void)? ){
    
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    let ok = UIAlertAction(title: confirm, style: .default, handler: completion)
    alert.addAction(ok)
    sender.present(alert, animated: true, completion: nil)
    
}

