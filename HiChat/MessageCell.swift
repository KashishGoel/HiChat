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
    
    private var outgoingConstraints = [NSLayoutConstraint]()
    private var incomingConstraints = [NSLayoutConstraint]()
    
    
    var incoming:Bool?
    
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //constraints ensure that the message label is dead centre of the chat icon and the bubble is the size of the msg
        messageLbl.translatesAutoresizingMaskIntoConstraints = false
        chatIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chatIcon)
        chatIcon.addSubview(messageLbl)
        
        messageLbl.centerXAnchor.constraint(equalTo: chatIcon.centerXAnchor).isActive = true
        messageLbl.centerYAnchor.constraint(equalTo: chatIcon.centerYAnchor).isActive = true
        
        chatIcon.widthAnchor.constraint(equalTo: messageLbl.widthAnchor, constant: 30).isActive = true
        chatIcon.heightAnchor.constraint(equalTo: messageLbl.heightAnchor,constant:20).isActive = true
        
        outgoingConstraints = [
        
            chatIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chatIcon.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor)
            
        ]

        incomingConstraints = [
        
            chatIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chatIcon.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor)
        
        ]
        
        chatIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        chatIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        
        messageLbl.numberOfLines = 0
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func incoming(incoming:Bool){
        let chatBubble = makeChatBubble()
        
        //Incoming has leading constraints while outgoing has a trailing constraint to content view
        if(incoming){
            NSLayoutConstraint.deactivate(outgoingConstraints)
            NSLayoutConstraint.activate(incomingConstraints)
            chatIcon.image = chatBubble.incoming
            messageLbl.textAlignment = .right
        }else{
            NSLayoutConstraint.deactivate(incomingConstraints)
            NSLayoutConstraint.activate(outgoingConstraints)
            chatIcon.image = chatBubble.outgoing
            messageLbl.textAlignment = .left
        }
    }
    
    //Creates two different colored bubbles according to the message type
    func makeChatBubble() ->(incoming:UIImage, outgoing:UIImage){
        
        let image = UIImage(named: "MessageBubble")
        
        //insets ensure the messages stretch properly and dont distort. Insets keep the bubble within row height size
        let insetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
        let insetsOugoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)
        
        let outgoing = coloredImage(image: image!, red: 229/255, green: 229/255, blue: 229/255).resizableImage(withCapInsets: insetsOugoing)
        let flippedImg = UIImage(cgImage: (image?.cgImage)!, scale: (image?.scale)!, orientation: UIImageOrientation.upMirrored)
        
        let incoming = coloredImage(image: flippedImg, red: 40/255, green: 184/255, blue: 148/255).resizableImage(withCapInsets: insetsIncoming)
        
        return (incoming,outgoing)
        
    }
    
    func coloredImage(image:UIImage, red:CGFloat,green:CGFloat,blue:CGFloat)->UIImage{
        
        /*
         
         Coloring in the bubbles according to their type
         If there was just one bubble we could have done:
         
         let image = UIImage(named:"").imageWithRenderingMode(.AlwaysTemplate) -> This ignores the colours in the image
         imageView.image = image
         imageView.tintColor = UIColor.blue -> tints the image blue
         
         */
        
        let rect = CGRect(origin: .zero, size: image.size)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        image.draw(in: rect)
        context!.setFillColor(red: red,green: green,blue: blue,alpha: 1)
        context?.setBlendMode(.sourceAtop)
        context?.fill(rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
        
    }
    
}
