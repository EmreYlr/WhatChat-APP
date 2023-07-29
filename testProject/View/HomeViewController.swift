//
//  HomeViewController.swift
//  testProject
//
//  Created by Emre on 12.07.2023.
//

import UIKit
import JWTDecode
import SocketIO

class HomeViewController: UIViewController {
    let userTokenService: UserTokenService = UserTokenService()
    let homeViewModel: HomeViewModel = HomeViewModel()
    @IBOutlet weak var chatTableView: UITableView!
    let addButton = UIButton()
    fileprivate let cellId = "userCell"
    var rooms = [RoomProfile]()
    var messageCounts: [Int: Int] = [:]
    var selectedRoomId: Int?
    
    let manager = SocketManager(socketURL: URL(string: "http://ec2-3-69-241-182.eu-central-1.compute.amazonaws.com:8082")!,config: [.log(true), .compress ])
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocketIO()
        self.navigationItem.setHidesBackButton(true, animated: false)
        chatTableView.dataSource = self
        chatTableView.delegate = self
        addUserButton()
        addHandler()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: Mesajları dinle
        selectedRoomId = nil
        getAllRoom()
    }
    
}
//MARK: Button
extension HomeViewController{
    @IBAction func singOutButton(_ sender: UIBarButtonItem) {
        homeViewModel.logoutUser()
        // Emin misin sorusunu sor
        backLoginScreen()
        self.navigationController?.popViewController(animated: true)
    }
    
    func addUserButton(){
        addButton.setImage(UIImage(systemName: "ellipsis.bubble"), for: .normal)
        addButton.imageView?.tintColor = .white
        addButton.backgroundColor = UIColor.systemGreen
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.layer.cornerRadius = 25
    }
    
    @objc func addButtonTapped(){
        performSegue(withIdentifier: "showContactsView", sender: nil)
    }
    
}
//MARK: SOCKET
extension HomeViewController{
    func setupSocketIO() {
        let userId = userTokenService.getLoggedUser()!.userId
        manager.setConfigs([.connectParams(["room": userId])])
        socket = manager.defaultSocket
        socket.connect()
    }
    func addHandler(){
        socket.on("get_message") { (data, ack) in
            if let message = data[0] as? [String: Any]{
                let homeGetMessage = HomeGetMessage(content:message["content"] as! String ,phoneNo:message["phoneNo"] as! String, roomId: message["roomId"] as! Int,sentAt: message["sentAt"] as! String)
                
                self.newMessage(homeGetMessage: homeGetMessage)
            }
        }
        socket.on("create_room") { (data, ack) in
            self.getAllRoom()
        }
    }
}
//MARK: DATA
extension HomeViewController{
    func backLoginScreen(){
        if let loginVC = self.navigationController?.viewControllers.first as? LoginViewController{
            loginVC.passwordTextField.text = ""
            loginVC.emailTextField.text = ""
            loginVC.emailTextField.resignFirstResponder()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessageView" {
            if let messageVC = segue.destination as? MessageViewController {
                messageVC.room =  sender as! RoomId?
            }
        }
    }
    func getAllRoom() {
        homeViewModel.getAllRooms(completion: { room in
            if let room = room{
                self.rooms = room
                self.chatTableView.reloadData()
            }
        })
    }
    
    func newMessage(homeGetMessage: HomeGetMessage) {
        if let currentCount = messageCounts[homeGetMessage.roomId] {
            messageCounts[homeGetMessage.roomId] = currentCount + 1
        } else {
            messageCounts[homeGetMessage.roomId] = 1
        }
        
        if homeGetMessage.roomId == selectedRoomId {
            messageCounts[homeGetMessage.roomId] = 0
            chatTableView.reloadData()
        } else {
            if let index = rooms.firstIndex(where: { $0.roomId == homeGetMessage.roomId }) {
                let topIndexPath = IndexPath(row: index, section: 0)
                chatTableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
                rooms[index].lastMessage = homeGetMessage.content
                rooms[index].lastMessageTime = homeGetMessage.sentAt
                let room = rooms.remove(at: index)
                rooms.insert(room, at: 0)
                chatTableView.reloadData()
            }
        }
    }
    
    
}


//MARK: TABLEVIEW
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userProfile = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! userTableViewCell
        
        let lastMessageUserPhoneNo = "\(userProfile.lastMessageUserPhoneNo ?? ""): "
        
        
        if userProfile.isGroup{
            cell.userNameLabel.text = userProfile.roomName
            cell.userMessageLabel.text = (userProfile.lastMessageUserPhoneNo != nil) ? "\(lastMessageUserPhoneNo)\(userProfile.lastMessage ?? "")" : " "
        }else{
            cell.userNameLabel.text = userProfile.userPhoneNo
            cell.userMessageLabel.text = userProfile.lastMessage
        }
        cell.userProfileImage.image = UIImage(named: userProfile.roomPhoto ?? "DefaultProfile.svg")
        cell.timeLabel.text = dateChange(date: userProfile.lastMessageTime ?? userProfile.roomCreateDate)
        if let count = messageCounts[userProfile.roomId], count > 0 {
            cell.newMessageCount.isHidden = false
            cell.newMessageCount.text = "\(count)"
        } else {
            cell.newMessageCount.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = rooms[indexPath.row]
        selectedRoomId = room.roomId
        messageCounts[selectedRoomId!] = 0
        let roomId = RoomId(roomId: room.roomId)
        performSegue(withIdentifier: "showMessageView", sender: roomId)
    }
    
}
//MARK: Date
extension HomeViewController{
    func dateChange(date: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let dateString = date, let parsedDate = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: parsedDate)
        } else {
            return ""
        }
    }
}
