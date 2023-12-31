//
//  MessageViewController.swift
//  testProject
//
//  Created by Emre on 19.07.2023.
//

import UIKit
import SocketIO
class MessageViewController: UIViewController{
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    var userTokenService: UserTokenService = UserTokenService()
    var messageViewModel: MessageViewModel = MessageViewModel()
    fileprivate let cellId = "messageCell"
    var room: RoomId?
    var isGroup: Bool?
    
    let manager = SocketManager(socketURL: URL(string: "http://3.68.83.204:8085")!,config: [.log(true), .compress ])
    var socket: SocketIOClient!
    
    var messagesFromServer = [ChatMessage]()
    
    fileprivate func attemptToAssembleGroupedMessages() {
        let groupedMessages = groupMessagesByDate(messages: messagesFromServer)
        chatMessages = groupedMessages
    }
    
    var chatMessages = [[ChatMessage]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketSetupIO()
        addHandler()
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.disconnect()
        socket.disconnect()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllMessage(roomId: room!)
    }
}

//MARK: SOCKET
extension MessageViewController{
    func socketSetupIO(){
        let roomId = room!.roomId
        manager.setConfigs([.connectParams(["room": roomId])]) //TODO: Room kontrol et ve alert ver
        socket = manager.defaultSocket
        socket.connect()
    }
    func addHandler(){
        socket.on("get_message") { (data, ack) in
            if let data = data[0] as? [String: Any],
               let message = data["message"] as? String,
               let phoneNo = data["phoneNo"] as? String,
                let sentAt = data["sentAt"] as? String{
                let newMessage = Message(message: message, phoneNo: phoneNo, sentAt: sentAt)
                DispatchQueue.main.async {
                    self.newMessage(message:newMessage, sentByMe: false)
                }
            }
        }
    }
}
//MARK: MESSAGE
extension MessageViewController{
    func getAllMessage(roomId: RoomId){
        messageViewModel.getRoomMessage(roomId: roomId) { chatMessage in
            if let chatMessage = chatMessage{
                self.messagesFromServer = chatMessage
                self.attemptToAssembleGroupedMessages()
                self.messageTableView.reloadData()
                self.scrollToBottom(animated: false)
            }else{
                print("error")
            }
        }
    }
    
    func sendMessage(content: String) {
        let message = ["userId":userTokenService.getLoggedUser()?.userId,"message": content]
        socket.emit("send_message", message)
    }
    
    func newMessage(message: Message,sentByMe: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newMessage = ChatMessage(userPhoneNo:message.phoneNo,message: message.message, sentByMe: sentByMe, sentAt: dateFormatter.string(from: Date()))
        
        let calendar = Calendar.current
        let lastMessage = chatMessages.last?.first
        
        let sameDate = calendar.isDate(Date.dateFromCustomString(customString: newMessage.sentAt), inSameDayAs: Date.dateFromCustomString(customString: lastMessage?.sentAt ?? "\(Date())"))
        
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
    
    private func scrollToBottom(animated: Bool) {
        guard !chatMessages.isEmpty else { return }
        let lastSectionIndex = chatMessages.count - 1
        let lastRowIndex = chatMessages[lastSectionIndex].count - 1
        let lastIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        messageTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
    }
    private func groupMessagesByDate(messages: [ChatMessage]) -> [[ChatMessage]] {
        let groupedMessages = Dictionary(grouping: messages) { element -> Date in
            return Date.dateFromCustomString(customString: dateChanged(sentAt: element.sentAt))
        }
        let sortedKeys = groupedMessages.keys.sorted()

        var groupedArray = [[ChatMessage]]()
        sortedKeys.forEach { key in
            let values = groupedMessages[key] ?? []
            groupedArray.append(values)
        }
        return groupedArray
    }
}


//MARK: Button
extension MessageViewController{
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let messageText = messageTextField.text, !messageText.isEmpty {
            sendMessage(content: messageText)
            let message = Message(message: messageText, phoneNo: userTokenService.getLoggedUser()!.username, sentAt: dateFormatter.string(from: Date()))
            newMessage(message:message, sentByMe: true)
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
        if let firstMessageInSection = chatMessages[section].first {
            let dateString = dateChanged(sentAt: firstMessageInSection.sentAt)
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
        cell.isGroup = isGroup ?? false
        let chatMessage = chatMessages[indexPath.section][indexPath.row]
        cell.previousPhoneNumber = indexPath.row > 0 ? chatMessages[indexPath.section][indexPath.row - 1].userPhoneNo : nil
        cell.chatMessage = chatMessage
        
        return cell
        
    }
    
    
}
//MARK: Date Changed
extension MessageViewController{
    func dateChanged(sentAt: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let originalDate = dateFormatter.date(from: sentAt) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDateString = dateFormatter.string(from: originalDate)
            return formattedDateString
        }
        return sentAt
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
