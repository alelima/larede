//
//  UserTabViewControllerTableViewController.swift
//  LaRede
//
//  Created by Alessandro on 02/05/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit
import CoreData

class UserTableViewController: UITableViewController, URLSessionDataDelegate {

    //var reachability = Reachability.networkReachabilityForInternetConnection()
    var reachability = Reachability(hostName: "https://jsonplaceholder.typicode.com")
    
    var activityIndicator = ActivityIndicator()
    
    var users: [User]? {
        didSet {
            DispatchQueue.main.async(execute: tableView.reloadData)
        }
    }
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.isDiscretionary = true
        return URLSession(configuration: configuration,
                          delegate: self, delegateQueue: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        
        _ = reachability?.startNotifier()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //checkReachability()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        cell.configure(with: users![indexPath.row])
        return cell
    }
    
    // MARK: - SessionDataDelegate metods
       
    fileprivate func save() {
        do {
            try AppDelegate.viewContext.save()
        } catch {
            debugPrint("Error in save Category")
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let usersCodable = try! JSONDecoder().decode([UserCodable].self, from: data)
        var users = [User]()
        for userCodable in usersCodable {
            if let user = User.getUser(from: userCodable, with: AppDelegate.viewContext) {
                users.append(user)
                self.save()
            }
        }
        self.users = users
        activityIndicator.stop()
    }
    
    // MARK: - Reachability
    
    func checkReachability() {
        
        guard let r = reachability else { return }
        if users != nil && !(users?.isEmpty)! {
            return
        }        
        
//        if r.isReachable  {
            let urlString = "https://jsonplaceholder.typicode.com/users"
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                let dataTask = session.dataTask(with: request)
                dataTask.resume()
            }
            activityIndicator.show(in: self.view)
//        } else {
//            let request: NSFetchRequest<User> = User.fetchRequest()
//            do {
//                self.users = try AppDelegate.viewContext.fetch(request)
//            } catch {
//                debugPrint("Error in load Users")
//            }
//        }
    }
    
    @objc func reachabilityDidChange(_ notification: Notification) {
        checkReachability()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }
    
    //MARK: - Unwind
    
    @IBAction func unWindToUserTableWithSave(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unWindToUserTableWithCancel(_ segue: UIStoryboardSegue) {
        
    }
    
}
