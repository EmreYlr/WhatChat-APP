//
//  RegisterViewController.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import UIKit

class RegisterViewController: UIViewController{
    //MARK: VARIABLES
    var user: User?
    let clientService: ClientService = ClientService()
    lazy var registerViewModel: RegisterViewModel = {
        return RegisterViewModel()
    }()
    //TODO: Alertte 3.buton olarak iptal butonunu ekle
    var clientViewModel: ClientViewModel?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //passwordTextField.isSecureTextEntry = true
        clientViewModel = ClientViewModel()
    }
    //MARK: FUNCTION
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        guard let name = nameTextField.text,!name.isEmpty,let surname = surnameTextField.text, !surname.isEmpty, let password = passwordTextField.text, !password.isEmpty, let email = emailTextField.text, !email.isEmpty, let phoneNo = phoneNoTextField.text, !phoneNo.isEmpty else{
            Alert(title: "Error", alertMessage: "Username,password,email,password or phone no is empty!")
            return
        }
        guard let phoneNo = phoneNoTextField.text, phoneNo.count == 10 else{
            Alert(title: "Error", alertMessage: "Enter your phone number as 10 digits without leading zero.")
            
            return
        }
        registerUser(name: name, surname: surname, email: email, password: password, phoneNo: phoneNo)
        
    }
    
    func registerUser(name: String, surname: String, email: String, password:String, phoneNo: String){
        startLoader()
        user = User(enabled: true, firstName: name, lastName: surname, email: email,username: phoneNo, credentials: [Credential(type: "password", value: password, temporary: false)])
        self.registerViewModel.registerUser(user: user!) { statusCode in
            if let statusCode = statusCode{
                switch statusCode{
                case 400:
                    self.Alert(title: "Error!", alertMessage: "Invalid format email!")
                    break
                case 401:
                    self.Alert(title: "Error!", alertMessage: "Connection Error!")
                    break
                case 409:
                    self.Alert(title: "Error!", alertMessage: "This email or phone no is already registered in the system")
                    break
                case 201:
                    print("Kayıt Başarılı")
                    self.sendEmail()
                    self.emailVerifiedScreen(message: nil)
                    break
                default:
                    self.Alert(title: "Error!", alertMessage: "An unexpected error has occurred. Error Code:\(statusCode)")
                    break
                }
            }
        }
        self.stopLoader()
    }
}
extension RegisterViewController{
    func emailVerifiedScreen(message : String?){
        let alertController = UIAlertController(title: "Email verified", message: message ?? "Please confirm your e-mail from the link sent to your e-mail.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default){_ in
            self.clientService.userInformation(email: self.emailTextField.text!){ registerUser in
                if let registerUser = registerUser{
                    if registerUser.emailVerified{
                        self.backLoginScreen()
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        self.emailVerifiedScreen(message: "Try again!")
                    }
                }
            }
        }
        
        let sentAgainButton = UIAlertAction(title: "Sent Again", style: .default){_ in
            self.emailVerifiedScreen(message: "Email sent again. Please check again.")
            self.sendEmail()
        }
        alertController.addAction(sentAgainButton)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func sendEmail(){
        registerViewModel.sendEmail(email: emailTextField.text!)
    }
    
    func backLoginScreen(){
        if let loginVC = self.navigationController?.viewControllers.first as? LoginViewController{
            loginVC.emailTextField.text = emailTextField.text
            loginVC.registerLabel.isHidden = false
        }
    }
}

