//
//  ViewController.swift
//  HiChat
//
//  Created by Kashish Goel on 2016-12-18.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import UIKit

class MainChatVC: UIViewController {

    private let tableView = UITableView()
    var messages = [Message]()
    let cellID = "msgCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setupTableView(){
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
        
        let tvConstraints:[NSLayoutConstraint] = [
        
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(tvConstraints)
        
        for i in 0...10{
            let msg = Message()
            msg.text = String(i)
            messages.append(msg)
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension MainChatVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessageCell
        let message = messages[indexPath.row].text
        cell.messageLbl.text = message
        return cell
    }

}

extension MainChatVC:UITableViewDelegate{

}
