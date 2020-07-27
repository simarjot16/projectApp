//
//  ViewController.swift
//  projectApp
//
//  Created by Simarjot Singh on 27/07/20.
//  Copyright © 2020 Simarjot Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: "session") != nil){
            LoginDone()
        }
        else{
            LoginToDo()
        }
    }
    
    @IBOutlet weak var id: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginDidTapped(_ sender: Any) {
        let username = id.text
        let pass = password.text
        if (username == "" || pass == ""){
            return
        }
        
        DidLogin(username!, pass!)
    }
    
    func DidLogin(_ user: String,_ pass: String){
        guard let url = URL(string: "https://reqres.in/api/login") else { return  }
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let dataToSend = user + ":" + pass
        request.httpBody = dataToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
            guard let _:Data = data else
            { return }
            let json:Any?
            do{
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch{
                return
            }
            guard let serverResp = json as? NSDictionary else { return }
            
            if let dataBlock = serverResp["data"] as? NSDictionary{
                if let sessionData = dataBlock["session"] as? String{
                    let preferences = UserDefaults.standard
                    preferences.set(sessionData, forKey: "session")
                    DispatchQueue.main.async {
                        self.LoginDone()
                    }
                }
            }
        })
        task.resume()
        
    }
    
    func LoginDone(){
        id.isEnabled = false
        password.isEnabled = false
        
    }
    func LoginToDo(){
        id.isEnabled = true
        password.isEnabled = true
        loginButton.setTitle("Try Again", for: .normal)
    }
}



