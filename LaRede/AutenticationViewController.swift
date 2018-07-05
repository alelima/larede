//
//  AutenticationViewController.swift
//  LaRede
//
//  Created by Alessandro on 06/06/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit
import TwitterKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class AutenticationViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginTextFiedl: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            let alert = UIAlertController(title: "Erro?", message: "Não foi possível fazer o logout.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        let logInFBKBUtton = FBSDKLoginButton()
        logInFBKBUtton.delegate = self
        logInFBKBUtton.center = CGPoint(x:self.view.center.x, y:self.view.center.y + 100)
        self.view.addSubview(logInFBKBUtton)
        loginTextFiedl.returnKeyType = .next
        passwordTextField.returnKeyType = .done
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "autenticated", sender: nil)
        }
        if (FBSDKAccessToken.current() != nil) {
            self.performSegue(withIdentifier: "autenticated", sender: nil)
        }
    }   
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

        Auth.auth().signIn(with: credential) {[unowned self] (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Erro?", message: "Não foi possível fazer sua autenticação.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            print("AUTENTICADO")
            self.performSegue(withIdentifier: "autenticated", sender: nil)
        }
    }
    
    @IBAction func autenticateByEmail(_ sender: Any) {
        guard let email = loginTextFiedl.text else {
            //alert
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { [unowned self] (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Erro?", message: "Não foi possível criar seu usuário.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            print("AUTENTICADO")
            self.performSegue(withIdentifier: "autenticated", sender: nil)
            })
        
    }
}

extension AutenticationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
            case loginTextFiedl: passwordTextField.becomeFirstResponder()
            case passwordTextField: autenticateByEmail(passwordTextField)
            default: break
        }
    return true
    }
}
