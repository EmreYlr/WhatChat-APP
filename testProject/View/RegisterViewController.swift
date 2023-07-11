//
//  RegisterViewController.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import UIKit

class RegisterViewController: UIViewController {
    //MARK: VARIABLES
    var registerViewModel: RegisterViewModel!
    var clientViewModel: ClientViewModel?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewModel = RegisterViewModel()
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
        clientViewModel?.getClientToken { token in
            if let token = token?.accessToken{
                self.registerViewModel.registerUser(token, name, surname, email, password) { statusCode in
                    if let statusCode = statusCode{
                        switch statusCode{
                        case 401:
                            print("Bağlantı Hatası")
                            break
                        case 201:
                            print("Kayıt Başarılı")
                            break
                        default:
                            print("Beklenmedik Bir Hata Oluştu")
                            break
                        }
                    }
                }
            }
        }
        
    }
    
    func Alert(title: String, alertMessage: String){
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    
}
