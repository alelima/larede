//
//  FormUserTableViewController.swift
//  LaRede
//
//  Created by Alessandro on 09/05/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit

class FormUserTableViewController: UITableViewController, URLSessionDataDelegate {
    
    var reachability = Reachability(hostName: "https://jsonplaceholder.typicode.com")
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.isDiscretionary = true
        return URLSession(configuration: configuration,
                          delegate: self, delegateQueue: nil)
    }()
    
    var user = User(context: AppDelegate.viewContext)
    
    var activityIndicator = ActivityIndicator()
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var nomeCompanhiaTextField: UITextField!
    @IBOutlet weak var sloganTextField: UITextField!
    @IBOutlet weak var bsTextField: UITextField!
    @IBOutlet weak var cidadeTextField: UITextField!
    @IBOutlet weak var ruaTextField: UITextField!
    @IBOutlet weak var logradouroTextField: UITextField!
    @IBOutlet weak var cepTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [loginTextField, nomeTextField, emailTextField, telefoneTextField,
        siteTextField, nomeCompanhiaTextField, sloganTextField, bsTextField,
        cidadeTextField, ruaTextField, logradouroTextField, cepTextField,
        latitudeTextField, longitudeTextField].forEach({
            $0?.returnKeyType = .next
            $0?.delegate = self
        })
        
        longitudeTextField.returnKeyType = .done
    }
    
    
    fileprivate func convertUser() {
        user.id = "100"
        user.userName = loginTextField.text
        user.name = nomeTextField.text
        user.email = emailTextField.text
        user.phone = telefoneTextField.text
        user.website = siteTextField.text
        
        let company = Company(context: AppDelegate.viewContext)
        company.name = nomeCompanhiaTextField.text
        company.catchPhrase = sloganTextField.text
        company.bs = bsTextField.text
        
        let geo = Geo(context: AppDelegate.viewContext)
        geo.lat = Double(latitudeTextField.text!)!
        geo.lng = Double(longitudeTextField.text!)!
        
        let address = Address(context: AppDelegate.viewContext)
        address.city = cidadeTextField.text
        address.street = ruaTextField.text
        address.suite = logradouroTextField.text
        address.zipcode = cepTextField.text
        address.geo = geo
        
        user.company = company
        user.address = address
    }
    
    fileprivate func postNewUser() {
        if (reachability?.isReachable)! {
            let urlString = "https://jsonplaceholder.typicode.com/users"
            if let url = URL(string: urlString) {
                let encoder = JSONEncoder()
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = try! encoder.encode(user.getUserCodable())
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                let dataTask = session.dataTask(with: request)
                dataTask.resume()
            }
        }
    }
    
    @IBAction func saveUser(_ sender: UIBarButtonItem) {
        if !isFormValid() {
            return
        }
        activityIndicator.show(in: self.view)
        convertUser()
        self.save()
        postNewUser()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
       
        if let response = task.response {
            let httpResponse = response as! HTTPURLResponse
                print("HTTP status code \(httpResponse.statusCode)")
        }
        
        DispatchQueue.main.async(execute: activityIndicator.stop)
        
        if let error = error {
            fatalError(error.localizedDescription)
        } else {
            performSegue(withIdentifier: "unwindToUserTable", sender: nil)
        }
    }
    
    fileprivate func save() {
        do {
            try AppDelegate.viewContext.save()
        } catch {
            debugPrint("Error in save user")
        }
    }
    
    let invalidColor = UIColor(red: 0.9882, green: 0.6078, blue: 0.5137, alpha: 1.0)
    
    func isFormValid() -> Bool {
        var valid = true
        [loginTextField, nomeTextField, emailTextField, telefoneTextField,
         siteTextField, nomeCompanhiaTextField, sloganTextField, bsTextField,
         cidadeTextField, ruaTextField, logradouroTextField, cepTextField,
         latitudeTextField, longitudeTextField].forEach({
            if let text = $0?.text {
                if text.isEmpty {
                    $0?.backgroundColor = invalidColor
                    valid = false
                } else {
                    $0?.backgroundColor = UIColor.white
                }
            }
         })
        
        if let email = emailTextField.text {
            if !email.isValidEmail() {
                valid = false
                emailTextField.backgroundColor = invalidColor
            } else {
                emailTextField.backgroundColor = UIColor.white
            }
        }
        
        if let url = siteTextField.text {
            if !url.isValidUrl() {
                valid = false
                siteTextField.backgroundColor = invalidColor
            } else {
                siteTextField.backgroundColor = UIColor.white
            }
        }
        return valid
    }
    
    @IBAction func unWindToFormUserFromMap(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! MapViewController
        print(controller.mapAddress)
        cidadeTextField.text = controller.mapAddress?.city
        ruaTextField.text = controller.mapAddress?.street
        logradouroTextField.text = controller.mapAddress?.suite
        cepTextField.text = controller.mapAddress?.zipcode
        latitudeTextField.text = controller.mapAddress?.geo?.lat
        longitudeTextField.text = controller.mapAddress?.geo?.lng
    }

}

extension FormUserTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
            case loginTextField : nomeTextField.becomeFirstResponder()
            case nomeTextField: emailTextField.becomeFirstResponder()
            case emailTextField: telefoneTextField.becomeFirstResponder()
            case telefoneTextField: siteTextField.becomeFirstResponder()
            case siteTextField: nomeCompanhiaTextField.becomeFirstResponder()
            case nomeCompanhiaTextField: sloganTextField.becomeFirstResponder()
            case sloganTextField: bsTextField.becomeFirstResponder()
            case bsTextField: cidadeTextField.becomeFirstResponder()
            case cidadeTextField: ruaTextField.becomeFirstResponder()
            case ruaTextField: logradouroTextField.becomeFirstResponder()
            case logradouroTextField: cepTextField.becomeFirstResponder()
            case cepTextField: latitudeTextField.becomeFirstResponder()
            case latitudeTextField: longitudeTextField.becomeFirstResponder()
            case longitudeTextField: saveUser(UIBarButtonItem())
            default: break
        }
        return true
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidUrl() -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlPredicate = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return urlPredicate.evaluate(with: self)
    }
}
