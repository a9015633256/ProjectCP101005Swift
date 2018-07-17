//
//  UIImage+Resize.swift
//  ChatRoomTest
//
//  Created by 楊文興 on 2018/6/29.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(maxWidthHeight: CGFloat) -> UIImage? {
        //Check if current image is already smaller than max width and height
        if self.size.width <= maxWidthHeight && self.size.height <= maxWidthHeight{
            return self
        }
        
        //Decide final size
        let finalSize: CGSize
        if self.size.width >= self.size.height{
            let ratio = self.size.width / maxWidthHeight
            finalSize = CGSize(width: maxWidthHeight, height: self.size.height / ratio)
        }else{//height > width
            let ratio = self.size.height / maxWidthHeight
            finalSize = CGSize(width: self.size.width / ratio, height: maxWidthHeight)
        }
        
        //generate
        UIGraphicsBeginImageContext(finalSize)
        let drawRect = CGRect(x: 0, y: 0, width: finalSize.width, height: finalSize.height)
        self.draw(in: drawRect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()//重要！！

        return result
    }
    
}
