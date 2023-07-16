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
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    var name: String?
    var loginViewModel: LoginViewModel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    lazy var clientTokenServices : ClientTokenService = {
        return ClientTokenService()
    }()

    //MARK: FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        //usernameTextField.text = "yeleremre@hotmail.com"
        //passwordTextField.text = "12345"
        forgotPasswordRecognizer()
        loginViewModel = LoginViewModel()
        
    }
}
//MARK: Extension-BUTTON
extension LoginViewController{
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,!email.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
            Alert(title: "Error", alertMessage: "Username or password is empty!")
            return
        }
        
        fetchToken(username: email, password: password) { token in
            if let token = token{
                do{
                    let jwt = try decode(jwt: token.accessToken)
                    self.name = jwt.name! + " " + jwt.surname!
                    self.performSegue(withIdentifier: "ShowHomeView", sender: nil)
                }catch let error{
                    print(error.localizedDescription)
                }
            }
        }
        startLoader()
        
    }
}

//MARK: GETDATA
extension LoginViewController{
    func fetchToken(username: String, password: String, completion: @escaping (UserToken?) -> Void) {
        loginViewModel.getUserToken(username, password) {token in
            if let token = token {
                self.stopLoader()
                completion(token)
            } else {
                self.stopLoader()
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

//MARK: GestureRecognizer
extension LoginViewController{
    func forgotPasswordRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(tap)
    }
    @objc func tapFunction(sender:UITapGestureRecognizer){
        forgotPasswordLabel.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.forgotPasswordLabel.alpha = 1.0
        }
        self.performSegue(withIdentifier: "showResetPassword", sender: nil)
    }    
}


