//
//  ResetPasswordViewController.swift
//  testProject
//
//  Created by Emre on 14.07.2023.
//

import UIKit

class ResetPasswordViewController: UIViewController {
//MARK: VARIABLES
    var resetPassawordViewModel: ResetPasswordViewModel!
    var clientViewModel: ClientViewModel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        submitButton.isEnabled = false
    }
}
//MARK: Button
extension ResetPasswordViewController{
    @IBAction func submitButtonPressed(_ sender: Any) {
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            let containsAtSymbol = text.contains("@")
            submitButton.isEnabled = containsAtSymbol
        }
    }
}
//MARK: Data
extension ResetPasswordViewController{
    func getClientToken(competion: @escaping(RegisterUser?)->Void){
        clientViewModel.getClientToken { clientToken in
            if let clientToken = clientToken{
                self.resetPassawordViewModel.userInformation(email: self.emailTextField.text!, token: clientToken.accessToken) { user in
                    if let user = user{
                        competion(user)
                    }else{
                        competion(nil)
                    }
                }
            }
        }
    }
    
    func backLoginScreen(){
        if let loginVC = self.navigationController?.viewControllers.first as? LoginViewController{
            loginVC.emailTextField.text = emailTextField.text
            loginVC.registerLabel.isHidden = false
            
        }
    }
}
