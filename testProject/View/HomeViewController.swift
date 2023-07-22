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
    
    
    let data: [UserMessageProfile] = [
        UserMessageProfile(userName: "Emre", userMessage: "Merhaba nasılsın", time: "16:00", userProfile: "DefaultProfile.svg"),
        UserMessageProfile(userName: "Oğuzhan", userMessage: "Bugün ne yapacaksın", time: "15:00", userProfile: "DefaultProfile.svg"),
        UserMessageProfile(userName: "Ali Osman", userMessage: "Hadi nerdesin", time: "12:41", userProfile: "DefaultProfile.svg"),
        UserMessageProfile(userName: "Ahmet", userMessage: "Hadi hadi lol lol", time: "12:00", userProfile: "DefaultProfile.svg")
    ]
    
    let manager = SocketManager(socketURL: URL(string: "http://ec2-3-69-241-182.eu-central-1.compute.amazonaws.com:8082")!,config: [.log(true), .compress ])
    
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        chatTableView.dataSource = self
        chatTableView.delegate = self
        addUserButton()
        manager.setConfigs([.connectParams(["room": userTokenService.getLoggedUser()!.userId])])
        socket = manager.defaultSocket
        addHandler()
        socket.connect()
    }
    
    
}
//MARK: Button
extension HomeViewController{
    @IBAction func singOutButton(_ sender: UIBarButtonItem) {
        homeViewModel.logoutUser()
        // Emin misin sorusunu sor
        //        socket.disconnect()
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
        print("test")
    }
    
}

//MARK: DATA
extension HomeViewController{
    func addHandler(){
        socket.on("get_message") { (data, ack) in
            if let message = data[0] as? [String: Any], let content = message["content"] as? String {
                DispatchQueue.main.async {
                    self.sendMessage()
                    print(content)
                    //self.welcomeLabel.text = content
                }
            }
        }
    }
    
    func sendMessage() {
        let message = ["content": "Mesaj Gitti"]
        socket.emit("send_message", message)
        
    }
    
    func backLoginScreen(){
        if let loginVC = self.navigationController?.viewControllers.first as? LoginViewController{
            loginVC.passwordTextField.text = ""
            loginVC.emailTextField.text = ""
            loginVC.emailTextField.resignFirstResponder()
        }
    }
    
}


//MARK: TABLEVIEW
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userProfile = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! userTableViewCell
        cell.userNameLabel.text = userProfile.userName
        cell.userMessageLabel.text = userProfile.userMessage
        cell.userProfileImage.image = UIImage(named: userProfile.userProfile)
        cell.timeLabel.text = userProfile.time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = data[indexPath.row]
        performSegue(withIdentifier: "showMessageView", sender: nil)
        print(data.userName)
    }
}
