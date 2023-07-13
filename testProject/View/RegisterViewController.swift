//
//  RegisterViewController.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import UIKit

class RegisterViewController: UIViewController {
    //MARK: VARIABLES
    var load : UIAlertController?
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
        load = nil
    }
    
    //MARK: FUNCTION
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        //emailVerifiedScreen(message: nil)
        guard let name = nameTextField.text,!name.isEmpty,let surname = surnameTextField.text, !surname.isEmpty, let password = passwordTextField.text, !password.isEmpty, let email = emailTextField.text, !email.isEmpty else{
            
            Alert(title: "Error", alertMessage: "Username or password is empty!")
            return
        }
        registerUser(name: name, surname: surname, email: email, password: password)
        load = loadingScreen()
        
    }
    
    func registerUser(name: String, surname: String, email: String, password:String){
        clientViewModel?.getClientToken { clientToken in
            if let token = clientToken{
                self.registerViewModel.registerUser(token.accessToken, name, surname, email, password) { statusCode in
                    if let statusCode = statusCode{
                        switch statusCode{
                        case 400:
                            print("Format Hatalı Eposta")
                        case 401:
                            print("Bağlantı Hatası")
                            break
                        case 409:
                            print("Bu Eposta Zaten Sistemde Kayıtlı")
                            break
                        case 201:
                            print("Kayıt Başarılı")
                            self.emailVerifiedScreen(message: nil, token: token.accessToken)
                            break
                        default:
                            print("Beklenmedik Bir Hata Oluştu. Hata kodu \(statusCode)")
                            break
                        }
                    }
                }
            }
            self.stopLoader(loader: self.load)
        }
        
    }

}

extension RegisterViewController{
    func emailVerifiedScreen(message : String?, token: String){
        let alertController = UIAlertController(title: "Email verified", message: message ?? "Please confirm your e-mail from the link sent to your e-mail.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default){_ in
            self.registerViewModel.userIsVerified(email: self.emailTextField.text!, token: token){ isVerified in
                if isVerified{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.emailVerifiedScreen(message: "Try again!", token: token)
                }
            }
        }
        let sentAgainButton = UIAlertAction(title: "Sent Again", style: .default){_ in
            self.emailVerifiedScreen(message: "Email sent again. Please check again.", token: token)
            //istek at
        }
        alertController.addAction(sentAgainButton)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
