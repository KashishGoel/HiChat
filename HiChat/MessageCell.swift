//
//  MessageCell.swift
//  HiChat
//
//  Created by Kashish Goel on 2016-12-18.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    let messageLbl = UILabel()
    private let chatIcon = UIImageView()

    override init(style:UITableViewCellStyle, reuseIdentifier:String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
