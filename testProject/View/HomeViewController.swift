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
    var name : String?
    var userToken: UserToken?
    var mSocket = SocketHandler.sharedInstance.getSocket()
    var manager : SocketManager?
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userIdlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        //welcomeLabel.text = name
        manager = SocketManager(socketURL: URL(string: "http://ec2-3-69-241-182.eu-central-1.compute.amazonaws.com:8082?room=room1")!, config: [.log(true), .compress, .forceWebsockets(true)])
        let socketIOClient = manager!.defaultSocket
        
        socketIOClient.on(clientEvent: .connect) {data, ack in
            print(data)
            print("socket connected")
            let myJSON = ["content":"Test123"]
            socketIOClient.emit("send_message", myJSON)
            
        }
        
        socketIOClient.on("get_message") { (dataArray, socketAck) -> Void in
            print(dataArray)
        }
        
        socketIOClient.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
        }
        
        socketIOClient.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
        }
        
        socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
            print(data)
            print("socket reconnect")
        }
        socketIOClient.connect()
        
        
        //        SocketHandler.sharedInstance.establishConnection()
        //        mSocket.on(clientEvent: .connect) {data, ack in
        //            print("socket connected")
        //            self.welcomeLabel.text = "Test"
        //        }
        //
        //        mSocket.on("get_message") { ( dataArray, ack) -> Void in
        //            debugPrint(dataArray)
        //            let dataReceived = dataArray[0]
        //            self.welcomeLabel.text = "\(dataReceived)"
        //        }
        
    }
    @IBAction func singOutButton(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func testPressed(_ sender: Any) {
        mSocket.emit("send_message", "test")
        /*
         
         do{
         let jwt = try decode(jwt: userToken!.accessToken)
         welcomeLabel.text = jwt.name! + " " + jwt.surname!
         userIdlabel.text = jwt.userId
         }catch let error{
         print(error.localizedDescription)
         }
         */
    }
    
}
extension HomeViewController{
    
}

