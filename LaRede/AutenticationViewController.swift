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
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    

    override func viewDidLoad() {
        let logInTWTButton = TWTRLogInButton(logInCompletion: { [unowned self] session, error in
            if (session != nil) {
                let authToken = session?.authToken
                let authTokenSecret = session?.authTokenSecret
                let credential = TwitterAuthProvider.credential(withToken: authToken!, secret: authTokenSecret!)
                var email : String?
                Auth.auth().signIn(with: credential) { [unowned self] (user, error) in
                    if let error = error {
                        // ...
                        print("ERRO")
                        return
                    }
                    // User is signed in
                    // ...
                    email = user?.email
                    print("AUTENTICADO")
                    self.performSegue(withIdentifier: "autenticated", sender: nil)
                }
                if let email = email {
                    Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                        if let error = error {
                            // ...
                            print("ERRO NO EMAIL")
                            return
                        }
                    }
                }
                
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        logInTWTButton.center = self.view.center
        self.view.addSubview(logInTWTButton)
        
        let logInFBKBUtton = FBSDKLoginButton()
        logInFBKBUtton.delegate = self
        logInFBKBUtton.center = CGPoint(x:self.view.center.x, y:self.view.center.y + 20)
        self.view.addSubview(logInFBKBUtton)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            print("AUTENTICADO")
            self.performSegue(withIdentifier: "autenticated", sender: nil)
        }
    }
}
