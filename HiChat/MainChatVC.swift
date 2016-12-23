//
//  ViewController.swift
//  HiChat
//
//  Created by Kashish Goel on 2016-12-18.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import UIKit

class MainChatVC: UIViewController{

    private let tableView = UITableView()
    private let newMsgTextView = UITextView()
    private var bottomConstraint:NSLayoutConstraint!
    
    var messages = [Message]()
    let cellID = "msgCell"
    
    let closeKeyBoardGesture = UITapGestureRecognizer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainChatVC.updateBottomConstraint(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainChatVC.updateBottomConstraint(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        closeKeyBoardGesture.numberOfTapsRequired = 1
        closeKeyBoardGesture.addTarget(self, action: #selector(MainChatVC.closeKeyboard))
        
        self.view.addGestureRecognizer(closeKeyBoardGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupTableView(){
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellID)
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        view.addSubview(tableView)
        
        //Area at the bottom of the screen for sending messages
        let newMsgArea = UIView()
        newMsgArea.backgroundColor = UIColor(netHex: 0xF1F1F1)
        newMsgArea.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(newMsgArea)
        

        
        newMsgTextView.translatesAutoresizingMaskIntoConstraints = false
        newMsgTextView.isScrollEnabled = false
        newMsgArea.addSubview(newMsgTextView)
        
        let sendBtn = UIButton()
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.setContentHuggingPriority(251, for: .horizontal)
        sendBtn.setContentCompressionResistancePriority(251, for: .horizontal)
        sendBtn.setTitle("Send", for: .normal)
        newMsgArea.addSubview(sendBtn)
        
        //So we can move the new message field up when typing, otherwise it is covered by keyboard
        
        bottomConstraint = newMsgArea.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        
        let newMsgConstraints:[NSLayoutConstraint] = [
            
            newMsgArea.leadingAnchor.constraint(equalTo:view.leadingAnchor),
            newMsgArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newMsgTextView.leadingAnchor.constraint(equalTo: newMsgArea.leadingAnchor, constant: 10),
            newMsgTextView.centerYAnchor.constraint(equalTo: newMsgArea.centerYAnchor),
            sendBtn.trailingAnchor.constraint(equalTo: newMsgArea.trailingAnchor, constant: -10),
            newMsgTextView.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor, constant: -10),
            sendBtn.centerYAnchor.constraint(equalTo: newMsgTextView.centerYAnchor),
            newMsgArea.heightAnchor.constraint(equalTo: newMsgTextView.heightAnchor, constant: 20)
            
        ]
        NSLayoutConstraint.activate(newMsgConstraints)
        
        let tvConstraints:[NSLayoutConstraint] = [
        
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: newMsgArea.topAnchor)
        ]
        

        
        NSLayoutConstraint.activate(tvConstraints)
        var inc = true
        
        for i in 0...10{
            let msg = Message()
            msg.text = "\(i) This is a longer message. How does it look?"
            msg.incoming = inc
            inc = !inc
            messages.append(msg)
        }
        

    
    }

    func updateBottomConstraint(notification:NSNotification){
        
        if let userInfo = notification.userInfo, let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue, let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue{
        
            let newFrame = view.convert(frame, to: (UIApplication.shared.delegate?.window)!)
            print(newFrame)
            print(newFrame.origin.y)
            print(view.frame.height)
            
            bottomConstraint.constant = newFrame.origin.y - view.frame.height
            
            UIView.animate(withDuration: animationDuration, animations: { 
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func closeKeyboard(){
    
        self.view.endEditing(true)
        
    }

}

extension MainChatVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.messageLbl.text = message.text
        cell.incoming(incoming: message.incoming)
        return cell
    }

}

extension MainChatVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}


