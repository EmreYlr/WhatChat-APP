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
    let userService: UserService = UserService()
    lazy var registerViewModel: RegisterViewModel = {
        return RegisterViewModel()
    }()
    
    var clientViewModel: ClientViewModel?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //passwordTextField.isSecureTextEntry = true
        clientViewModel = ClientViewModel()
    }
    //MARK: FUNCTION
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        guard let name = nameTextField.text,!name.isEmpty,let surname = surnameTextField.text, !surname.isEmpty, let password = passwordTextField.text, !password.isEmpty, let email = emailTextField.text, !email.isEmpty else{
            Alert(title: "Error", alertMessage: "Username or password is empty!")
            return
        }
        registerUser(name: name, surname: surname, email: email, password: password)
        
    }
    
    func registerUser(name: String, surname: String, email: String, password:String){
        startLoader()
        user = User(enabled: true, firstName: name, lastName: surname, email: email, credentials: [Credential(type: "password", value: password, temporary: false)])
        self.registerViewModel.registerUser(user: user!) { statusCode in
            if let statusCode = statusCode{
                switch statusCode{
                case 400:
                    print("Format Hatalı Eposta")
                    break
                case 401:
                    print("Bağlantı Hatası")
                    break
                case 409:
                    print("Bu Eposta Zaten Sistemde Kayıtlı")
                    break
                case 201:
                    print("Kayıt Başarılı")
                    self.sendEmail()
                    self.emailVerifiedScreen(message: nil)
                    break
                default:
                    print("Beklenmedik Bir Hata Oluştu. Hata kodu \(statusCode)")
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
            self.userService.userInformation(email: self.emailTextField.text!){ registerUser in
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

