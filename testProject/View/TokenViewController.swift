//
//  ViewController.swift
//  testProject
//
//  Created by Emre on 9.07.2023.
//

import UIKit
import Alamofire

class TokenViewController: UIViewController{
    
    var viewModel: TokenViewModel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TokenViewModel()
        
        //getClientToken()
        //getTokenAlamofire()
        //registerUser()
        //register()
        
    }
    //MARK: FUNCTION
    
    
    /*
    func getClientToken(){
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "grant_type":"client_credentials",
            "client_id":"ios-test",
            "client_secret":"7KeVk6d08bomnt8omhcE9y5zTdSzpFi0"
        ]
        let url = URL(string:    "https://testkeycloak.azurewebsites.net/realms/test_realm/protocol/openid-connect/token/")!
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: ClientToken.self){ response in
            print(response.value!.accessToken)
        }
    }
    */
    /*
     func getUserToken(){
     let headers: HTTPHeaders = [
     "Content-Type": "application/x-www-form-urlencoded"
     ]
     let parameters = [
     "grant_type":"password",
     "username":"admin@admin.com",
     "password":"123789",
     "client_id":"ios-test",
     "client_secret":"7KeVk6d08bomnt8omhcE9y5zTdSzpFi0"
     ]
     let url = URL(string: "https://testkeycloak.azurewebsites.net/realms/test_realm/protocol/openid-connect/token/")!
     AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: Token.self){ response in
     print(response.value!.accessToken)
     }
     }
     */
    
    /*
    func registerUser(){
        let credential = Credential(type: "password", value: "1234567", temporary: false)
        let user = User(enabled: true, firstName: "Emre", lastName: "Yeler", email: "yeleremre14@hotmail.com", credentials: [credential])
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJhQV9lbHBjMjhXcE9UQXpnNDhoT1pPZldWT09rN1E2Mk9GZkhGMjZmS0JJIn0.eyJleHAiOjE2ODkwODQyODIsImlhdCI6MTY4OTA4Mzk4MiwianRpIjoiNzVjNmRmNjMtMjliOC00OTkzLWIyODUtMTNmYjIwYTM3MDViIiwiaXNzIjoiaHR0cHM6Ly90ZXN0a2V5Y2xvYWsuYXp1cmV3ZWJzaXRlcy5uZXQvcmVhbG1zL3Rlc3RfcmVhbG0iLCJhdWQiOlsicmVhbG0tbWFuYWdlbWVudCIsImFjY291bnQiXSwic3ViIjoiMGRmMjNjMjItZmJmMi00NjNjLTljMDgtNDAwMzI3NjhlNmY5IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW9zLXRlc3QiLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbIioiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwiZGVmYXVsdC1yb2xlcy10ZXN0X3JlYWxtIiwidW1hX2F1dGhvcml6YXRpb24iLCJBZG1pbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7InJlYWxtLW1hbmFnZW1lbnQiOnsicm9sZXMiOlsibWFuYWdlLXVzZXJzIl19LCJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6InByb2ZpbGUgZW1haWwiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImNsaWVudEhvc3QiOiI0Ni4xOTYuMTQ0LjIwMiIsInByZWZlcnJlZF91c2VybmFtZSI6InNlcnZpY2UtYWNjb3VudC1pb3MtdGVzdCIsImNsaWVudEFkZHJlc3MiOiI0Ni4xOTYuMTQ0LjIwMiIsImNsaWVudF9pZCI6Imlvcy10ZXN0In0.MCyK5OxbLLMzgnxYGuppG68Epx9ued0FcjLgf8DKisHN83GfgNl-GwgK1ELVNdLj7RzYMUoJtpbarXiHGl_2NlIC_xQw9cCvPop2AZ9LOLRxAmVNtcfuqkmhlpO1AmCRxEGAXyEnYvKL9wGuJS4C0NkSoZrXbo-PXF7pKGprvC7UYXYP8a9MFadRZugdRiqkEqeiyq0460ZCNFdkbycu4fVSbD2oI8IjT-TkeTm95hYrUHGoyScvMEDY0co_jNzMxWfcsIkXSnugr9iuTb8DZxP_bT-Fa1qtcKEujSMMyl--4QMXzRrRlWag8unCTW8KFHtHXVRJAPu6QoeEjFb1Zg",
            "Content-Type": "application/json"
        ]
        let url = URL(string: "https://testkeycloak.azurewebsites.net/admin/realms/test_realm/users")!
        AF.request(url, method: .post, parameters: user,encoder: JSONParameterEncoder.default, headers: headers).responseData{ response in
            debugPrint(response)
        }
    }
     
     */
    
    
    func test(){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJhQV9lbHBjMjhXcE9UQXpnNDhoT1pPZldWT09rN1E2Mk9GZkhGMjZmS0JJIn0.eyJleHAiOjE2ODg5MjU4NDQsImlhdCI6MTY4ODkyNTU0NCwianRpIjoiMzFhMWVmMjItYjcwYS00ZGRiLWI4ZTktZmQ4YTc3NDUzZWNiIiwiaXNzIjoiaHR0cHM6Ly90ZXN0a2V5Y2xvYWsuYXp1cmV3ZWJzaXRlcy5uZXQvcmVhbG1zL3Rlc3RfcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiNDc0ODc4ZGQtMzhmZi00MDAyLTg3ZDAtNDdhOTM0ODcyNmJmIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW9zLXRlc3QiLCJzZXNzaW9uX3N0YXRlIjoiNjg3NDg1MTAtZDRmOC00ZGI0LTlkYzgtOWVjZGRjN2EyYmM3IiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyIqIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsImRlZmF1bHQtcm9sZXMtdGVzdF9yZWFsbSIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiNjg3NDg1MTAtZDRmOC00ZGI0LTlkYzgtOWVjZGRjN2EyYmM3IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiT8SfdXpoYW4gRHV5bWF6IiwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiZ2l2ZW5fbmFtZSI6Ik_En3V6aGFuIiwiZmFtaWx5X25hbWUiOiJEdXltYXoiLCJlbWFpbCI6ImFkbWluQGFkbWluLmNvbSJ9.PpxlnFI0PbMPGbg8CV4i1EiEgjb0BdigQV7CIGeeRdMu0PEA3IWsdV4X704U8poUVDJqb13y2tZMzdJtcjqxIUx_KNEBzsWGkDRrzSWGn7gKvzSmJBiay0kNR57fTKEU_7TUZ_q-uXNQYVxdHJ6_IYgyM0EKncFxnhcZT2JHdp5CeO3sSDcNuL88MQODJ4tbVYBO076aSi9hzYsRoHKAISBs_0W_RVWTXTRGeExyg7UxuwoF8AVRZ7cqLuw8F77IUKipaobzKKdVd7sWvVsYOru0A29Zj_AA9llsXMLjFxETnvIZ5bFTetlzH6uqTp_rFmQ5QSk4OLI94TGw0XfdRA"
        ]
        let url = URL(string: "https://testsprng.azurewebsites.net/api/v1/test")!
        AF.request(url, method: .get, headers: headers).responseString{ response in
            print(response.value!)
        }
        
    }
}
//MARK: Extension-BUTTON
extension TokenViewController{
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text,!username.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
            
            Alert(title: "Error", alertMessage: "Username or password is empty!")
            return
        }
        fetchToken(username: username, password: password)
    }
    
    
    func Alert(title: String, alertMessage: String){
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

//MARK: GETDATA
extension TokenViewController{
    func fetchToken(username: String, password: String){
        viewModel.getUserToken(username,password) { token in
            if let token = token {
                print("Token: \(token)")
            } else {
                print("Token alınamadı.")
            }
        }
    }
    
    
}

