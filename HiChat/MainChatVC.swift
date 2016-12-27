//
//  ViewController.swift
//  HiChat
//
//  Created by Kashish Goel on 2016-12-18.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import UIKit

class MainChatVC: UIViewController{

    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let newMsgTextView = UITextView()
    private var bottomConstraint:NSLayoutConstraint!
    
    private var sections = [Date:[Message]]()
    var dates = [Date]()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.scrollToTheBottom()
    }
    
    func setupTableView(){
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellID)
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor(netHex: 0xF1F1F1)
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
        sendBtn.addTarget(self, action: #selector(MainChatVC.sendBtnPressed), for: .touchUpInside)
        sendBtn.setTitleColor(UIColor.white, for: .normal)
        sendBtn.backgroundColor = UIColor(netHex: 0x28B894)
        newMsgArea.addSubview(sendBtn)
        newMsgArea.layer.cornerRadius = 5
        newMsgArea.layer.shadowRadius = 5
        newMsgArea.layer.shadowColor = UIColor(netHex: 0x8e8e93).cgColor
        newMsgArea.layer.shadowOffset = CGSize(width: 2, height: 4)
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
        var date = Date(timeIntervalSince1970: 10000000)
        for i in 0...10{
            let msg = Message()
            msg.text = "\(i) This is a longer message. How does it look?"
            msg.incoming = inc
            msg.timestamp = date
            inc = !inc
            if i%2 == 0 {
            date = Date(timeInterval: 60*60*24, since: date)
            }
            addMessages(message: msg)
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
        tableView.scrollToTheBottom()
    }
    
    
    func sendBtnPressed(){
        
        guard let text = newMsgTextView.text,text.characters.count > 0 else{return}
        let message = Message()
        message.text = text
        message.incoming = false
        message.timestamp = Date()
        addMessages(message: message)
        newMsgTextView.text = ""
        tableView.reloadData()
        tableView.scrollToTheBottom()
    }
    
    
    func closeKeyboard(){
    
        self.view.endEditing(true)
        
    }
    
    func addMessages(message:Message){
        guard let date = message.timestamp else{return}
        
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        
        var msgs = sections[start]
        
        if (msgs?.count == 0 || msgs == nil){
            dates.append(start)
            msgs = [Message]()
        }
        
        msgs?.append(message)
        
        sections[start] = msgs

    }
    
    func retrieveMessages(section:Int)->[Message]{
        let date = dates[section]
        return sections[date]!
    }
    

}

extension MainChatVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrieveMessages(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessageCell
        let message = retrieveMessages(section: indexPath.section)[indexPath.row]
        cell.messageLbl.text = message.text
        cell.incoming(incoming: message.incoming)
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let paddingView = UIView()
        view.addSubview(paddingView)
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        let dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textColor = UIColor(netHex: 0xF1F1F1)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        
        let day = formatter.string(from: dates[section])
        
        dayLabel.text = day
        
        paddingView.addSubview(dayLabel)
        paddingView.layer.cornerRadius = 10
        paddingView.layer.masksToBounds = true
        paddingView.backgroundColor = UIColor(netHex: 0x4682b4)
        
        let constraints:[NSLayoutConstraint] = [
            paddingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paddingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            paddingView.heightAnchor.constraint(equalTo: dayLabel.heightAnchor, constant: -5),
            paddingView.widthAnchor.constraint(equalTo: dayLabel.widthAnchor, constant: 10),
            
            dayLabel.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),

            view.heightAnchor.constraint(equalTo: paddingView.heightAnchor)
            ]
        
        NSLayoutConstraint.activate(constraints)
        

        
        
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
}

extension MainChatVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}


