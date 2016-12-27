//
//  Extensions.swift
//  HiChat
//
//  Created by Kashish Goel on 2016-12-20.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


extension UITableView{
    
    func scrollToTheBottom(){
        
        if self.numberOfSections > 1{
        
            let lastSection = self.numberOfSections - 1
            let rowToScroll = IndexPath(row: self.numberOfRows(inSection: lastSection) - 1, section: lastSection)
            self.scrollToRow(at: rowToScroll, at: .bottom, animated: true)
        
        }
        
        let rows = self.numberOfRows(inSection: 0)
        if(rows > 0 && self.numberOfSections == 1){
            let row = IndexPath(row: rows - 1, section:  0)
            self.scrollToRow(at: row , at: .bottom, animated: true)
        }
    }
    
}
