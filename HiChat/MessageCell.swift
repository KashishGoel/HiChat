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
        
        messageLbl.translatesAutoresizingMaskIntoConstraints = false
        chatIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chatIcon)
        chatIcon.addSubview(messageLbl)
        
        messageLbl.centerXAnchor.constraint(equalTo: chatIcon.centerXAnchor).isActive = true
        messageLbl.centerYAnchor.constraint(equalTo: chatIcon.centerYAnchor).isActive = true
        
        chatIcon.widthAnchor.constraint(equalTo: messageLbl.widthAnchor, constant: 50).isActive = true
        chatIcon.heightAnchor.constraint(equalTo: messageLbl.heightAnchor).isActive = true
        
        chatIcon.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        chatIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        messageLbl.textAlignment = .center
        messageLbl.numberOfLines = 0

        let image = UIImage(named: "MessageBubble")?.withRenderingMode(.alwaysTemplate)
        
        chatIcon.tintColor = UIColor.init(netHex: 0x28B894)
        chatIcon.image = image
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
