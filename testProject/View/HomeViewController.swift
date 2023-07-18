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
    
    let manager = SocketManager(socketURL: URL(string: "http://ec2-3-69-241-182.eu-central-1.compute.amazonaws.com:8082")!,config: [.log(true), .compress, .connectParams(["room": "room1"]) ])
    let manager2 = SocketManager(socketURL: URL(string: "http://ec2-3-69-241-182.eu-central-1.compute.amazonaws.com:8082")!,config: [.log(true), .compress, .connectParams(["room": "room2"]) ])
    var socket: SocketIOClient!
    var socket2: SocketIOClient!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userIdlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        socket = manager.defaultSocket
        socket2 = manager2.defaultSocket
        addHandler()
        socket.connect()
        socket2.connect()
    }
}
//MARK: Button
extension HomeViewController{
    @IBAction func singOutButton(_ sender: UIBarButtonItem) {
        homeViewModel.logoutUser()
        // Emin misin sorusunu sor
        socket.disconnect()
        backLoginScreen()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func testPressed(_ sender: Any) {
        sendMessage()
    }
}


//MARK: DATA
extension HomeViewController{
    func addHandler(){
//        socket.on(clientEvent: .connect) { (data, ack) in
//            self.sendMessage()
//        }
        socket.on("get_message") { (data, ack) in
            if let message = data[0] as? [String: Any], let content = message["content"] as? String {
                DispatchQueue.main.async {
                    print(content)
                    self.welcomeLabel.text = content
                }
            }
        }
        
        socket2.on("get_message") { (data, ack) in
            if let message = data[0] as? [String: Any], let content = message["content"] as? String {
                DispatchQueue.main.async {
                    print(content)
                    self.welcomeLabel.text = content
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
        }
    }
}

