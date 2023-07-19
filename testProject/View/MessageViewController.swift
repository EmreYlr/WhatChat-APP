//
//  MessageViewController.swift
//  testProject
//
//  Created by Emre on 19.07.2023.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var messageTableView: UITableView!

    fileprivate let cellId = "messageCell"
    
    var messagesFromServer = [
        ChatMessage (text: "Merhaba nasılsın", isIncoming: true, date: Date.dateFromCustomString(customString: "24/06/2023")),
        ChatMessage (text: "iyiyim sen nasılsın",isIncoming: false, date: Date.dateFromCustomString(customString: "24/06/2023")),
        ChatMessage (text: "Bugün şuraya gittim ve orda şu olayı yaşadım. Daha sonra şunları yapptım. Ama ondan sonra şunlar oldu ne yapayım.", isIncoming: true, date: Date.dateFromCustomString(customString: "25/06/2023")),
        ChatMessage (text: ":(", isIncoming: true, date: Date.dateFromCustomString(customString: "25/06/2023")),
        ChatMessage (text: "Alla alla", isIncoming: false, date: Date()),
    ]
    
    fileprivate func attemptToAssembleGroupedMessages () {
        let groupedMessages = Dictionary (grouping: messagesFromServer) { (element) -> Date in
            return element.date
        }
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessages [key]
            chatMessages.append (values ?? [])
        }
    }
    
    var chatMessages = [[ChatMessage]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        
        attemptToAssembleGroupedMessages()
        
        messageTableView.dataSource = self
        messageTableView.delegate = self
        
        messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
    }
    @objc func addTapped(){
        messageTableView.reloadData()
    }
    
    
    
}

//MARK: TABLEVIEW
extension MessageViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatMessages.count
    }
    
    class DateHeaderLabel: UILabel {
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .systemGreen
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 20, height: height)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = chatMessages [section].first {
            let dateFormatter = DateFormatter ()
            dateFormatter.dateFormat="dd/MM/yyyy"
            let dateString = dateFormatter.string (from: firstMessageInSection .date)
            let label = DateHeaderLabel ( )
            label.text = dateString
            let containerView = UIView()
            containerView.addSubview(label)
            label.centerXAnchor.constraint (equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint (equalTo: containerView.centerYAnchor).isActive = true
            return containerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageTableViewCell
        let chatMessage = chatMessages[indexPath.section][indexPath.row]
        cell.chatMessage = chatMessage
        return cell
        
    }
    
    
}
//MARK: Date
extension Date{
    static func dateFromCustomString (customString: String) -> Date {
        let dateFormatter = DateFormatter ( )
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}
