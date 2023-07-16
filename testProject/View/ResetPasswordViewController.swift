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
    var resetPasswordViewModel : ResetPasswordViewModel = ResetPasswordViewModel()
    
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
        resetPassword()
        resetPasswordAlert(message: nil)
        
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
    func resetPassword(){
        resetPasswordViewModel.resetPassword(email: emailTextField.text!)
    }
    
    func backLoginScreen(){
        if let loginVC = self.navigationController?.viewControllers.first as? LoginViewController{
            loginVC.emailTextField.text = emailTextField.text
        }
    }
}

//MARK: Alert
extension ResetPasswordViewController{
    func resetPasswordAlert(message: String?){
        let alertController = UIAlertController(title: "Reset Password", message: message ?? "Please update your password from the link sent to your email.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default){_ in
            self.backLoginScreen()
            self.navigationController?.popViewController(animated: true)
        }
        let sentAgainButton = UIAlertAction(title: "Sent Again", style: .default){_ in
            self.resetPassword()
            self.resetPasswordAlert(message: "Email sent again. Please check again.")
        }
        alertController.addAction(sentAgainButton)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
