//
//  ViewController.swift
//  testProject
//
//  Created by Emre on 9.07.2023.
//

import UIKit
import Alamofire
import JWTDecode

class LoginViewController: UIViewController{
    //MARK: VARIABLES
    var name: String?
    var loginViewModel: LoginViewModel!
    var load : UIAlertController?
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = "yeleremre@hotmail.com"
        passwordTextField.text = "12345"
        loginViewModel = LoginViewModel()
        load = nil
    }
}
//MARK: Extension-BUTTON
extension LoginViewController{
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text,!username.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
            Alert(title: "Error", alertMessage: "Username or password is empty!")
            return
        }
        
        fetchToken(username: username, password: password) { token in
            if let token = token{
                do{
                    let jwt = try decode(jwt: token.accessToken)
                    self.name = jwt.name! + " " + jwt.surname!
                    //self.stopLoader(loader: self.load)
                    self.performSegue(withIdentifier: "ShowHomeView", sender: nil)
                }catch let error{
                    print(error.localizedDescription)
                }
            }
        }
        //load = loadingScreen()
    }
}

//MARK: GETDATA
extension LoginViewController{
    func fetchToken(username: String, password: String, completion: @escaping (Token?) -> Void) {
        loginViewModel.getUserToken(username, password) { [self] token in
            if let token = token {
                print("Token: (token)")
                completion(token)
            } else {
                print("Token alınamadı.")
                completion(nil)
            }
        }
    }
}
//MARK: Seque
extension LoginViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHomeView"{
            let destinationVC = segue.destination as! HomeViewController
            destinationVC.name = "Hoşgeldin " + (name ?? " ")
        }
    }
}


