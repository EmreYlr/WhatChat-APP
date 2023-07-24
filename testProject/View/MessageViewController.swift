//
//  MessageViewController.swift
//  testProject
//
//  Created by Emre on 19.07.2023.
//

import UIKit
import SocketIO
class MessageViewController: UIViewController,UINavigationControllerDelegate{
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    fileprivate let cellId = "messageCell"
    var room: RoomProfile?
    
    let manager = SocketManager(socketURL: URL(string: "http://ec2-3-69-241-182.eu-central-1.compute.amazonaws.com:8082")!,config: [.log(true), .compress ])
    var socket: SocketIOClient!
    
    var messagesFromServer = [ChatMessage]()
    //ChatMessage (userId: "1",content: "Merhaba nasılsın", isIncoming: true, date: Date.dateFromCustomString(customString: "24/06/2023")),
//    ChatMessage (content: "iyiyim sen nasılsın",isIncoming: false, date: Date.dateFromCustomString(customString: "24/06/2023")),
//    ChatMessage (content: "Bugün şuraya gittim ve orda şu olayı yaşadım. Daha sonra şunları yapptım. Ama ondan sonra şunlar oldu ne yapayım.", isIncoming: true, date: Date.dateFromCustomString(customString: "25/06/2023")),
//    ChatMessage (content: ":(", isIncoming: true, date: Date.dateFromCustomString(customString: "25/06/2023")),
//    ChatMessage (content: "Alla alla Alla alla Alla alla Alla alla Alla alla Alla alla Alla alla Alla alla  Alla alla alla", isIncoming: false, date: Date.dateFromCustomString(customString: "25/06/2023")),
    
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
        manager.setConfigs([.connectParams(["room": room!.roomId])]) //TODO: Room kontrol et ve alert ver
        
        socket = manager.defaultSocket
        addHandler()
        socket.connect()

        attemptToAssembleGroupedMessages()
        navigationController?.delegate = self
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is HomeViewController {
            DispatchQueue.main.async {
                self.socket.disconnect()
            }
            
        }
    }
    
    func addHandler(){
        socket.on("get_message") { (data, ack) in
            if let message = data[0] as? [String: Any],
               let content = message["content"] as? String,
               let userId = message["userId"] as? String {
                DispatchQueue.main.async {
                    self.newMessage(userId: userId, text: content, isIncoming: true)
                }
            }
        }
    }
    
    func sendMessage(content: String) {
        let message = ["userId":"1","content": content]
        socket.emit("send_message", message)
    }
    
    
    
    func newMessage(userId: String,text: String, isIncoming: Bool) {
        let newMessage = ChatMessage(userId: userId,content: text, isIncoming: isIncoming, date: Date())
        
        let calendar = Calendar.current
        let lastMessage = chatMessages.last?.first
        let sameDate = calendar.isDate(newMessage.date, inSameDayAs: lastMessage?.date ?? Date())

        if chatMessages.isEmpty || !sameDate {
            chatMessages.append([newMessage])
            let newSectionIndex = chatMessages.count - 1
            messageTableView.insertSections([newSectionIndex], with: .automatic)
        } else {
            let lastSectionIndex = chatMessages.count - 1
            chatMessages[lastSectionIndex].append(newMessage)
            let lastRowIndex = chatMessages[lastSectionIndex].count - 1
            let indexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
            messageTableView.insertRows(at: [indexPath], with: .automatic)
        }
        // Aşağı scrol atıyor
        let lastSectionIndex = chatMessages.count - 1
        let lastRowIndex = chatMessages[lastSectionIndex].count - 1
        let lastIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        messageTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
    
}

//MARK: Button
extension MessageViewController{
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let messageText = messageTextField.text, !messageText.isEmpty {
            sendMessage(content: messageText)
            newMessage(userId: "1",text: messageText, isIncoming: false)
            messageTextField.text = ""
        }
    }
}

//MARK: TABLEVIEW
extension MessageViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatMessages.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = chatMessages [section].first {
            let dateFormatter = DateFormatter ()
            dateFormatter.dateFormat="dd/MM/yyyy"
            let dateString = dateFormatter.string (from: firstMessageInSection.date)
            let label = DateHeaderLabel()
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

//MARK: DATAHEADER

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
