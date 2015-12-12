//
//  ViewController.swift
//  VotingApp
//
//  Created by Jill Lopez on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createProfileButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPress(sender: UIButton) {
        
        
        PFUser.logInWithUsernameInBackground(emailTextField.text!, password: passwordTextField.text!) {
            
            (user: PFUser?, error: NSError?) -> Void in
           
            if user != nil {
                print("succes!")
                let nav: HackyNavController = self.navigationController as! HackyNavController
                self.performSegueWithIdentifier("loginSegue", sender: sender)
                nav.cachedUser = user
            } else {
                print("fail")
            }
        }
        
        
    }

}

