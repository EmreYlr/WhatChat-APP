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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userTokenService: UserTokenService = UserTokenService()
    var loginViewModel: LoginViewModel = LoginViewModel()
    lazy var clientTokenServices : ClientTokenService = {
        return ClientTokenService()
    }()
    
    //MARK: FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        if userTokenService.getUserTokenFromUserDefaults() != nil{
            self.performSegue(withIdentifier: "ShowHomeView", sender: nil)
        }
        passwordTextField.isSecureTextEntry = true
        forgotPasswordRecognizer()
    }
}
//MARK: BUTTON
extension LoginViewController{
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,!email.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
            Alert(title: "Error", alertMessage: "Username or password is empty!")
            return
        }
        checkUser(username: email, password: password) { check in
            if check == true{
                self.performSegue(withIdentifier: "ShowHomeView", sender: nil)
            }
            else{
                self.Alert(title: "Error!", alertMessage: "Username or password wrong!")
                return
            }
        }
        //startLoader()
    }
}

//MARK: GETDATA
extension LoginViewController{
    func checkUser(username: String, password: String, completion: @escaping (Bool?) -> Void) {
        loginViewModel.checkUser(username, password) {check in
            //self.stopLoader()
            completion(check)
        }
    }
}
//MARK: Seque
extension LoginViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHomeView"{
            //let destinationVC = segue.destination as! HomeViewController
            //destinationVC.name = "Hoşgeldin " + (name ?? " ")
            //destinationVC.userToken = userTokenService.getUserTokenFromUserDefaults()
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


