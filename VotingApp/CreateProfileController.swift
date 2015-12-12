//
//  CreateProfileController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

class CreateProfileController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!

    
    @IBOutlet weak var lastNameTextField: UITextField!

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!

    @IBOutlet weak var zipcodeTextField: UITextField!

    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        

        let user = PFUser()
        user["firstName"] = firstNameTextField.text!
        user["lastName"] = lastNameTextField.text!
        user.email = emailTextField.text!
        user.password = passwordTextField.text!
        user["city"] = cityTextField.text!
        user["zipcode"] = zipcodeTextField.text!
        user["address"] = addressTextField.text!
        user["state"] = "Washington"
        
        user.username = emailTextField.text!
        
        if passwordTextField.text! == confirmPasswordTextField.text! {
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? String
                    NSLog(errorString!)
                } else {
                    print("success")
                    let nav: HackyNavController = self.navigationController as! HackyNavController
                    nav.cachedUser = user
                    self.performSegueWithIdentifier("createProfileToMenuSegue", sender: nil)
  
                }
            }
            
        } else {
            print("wrong password")
        }
        
        
        
        
    }
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
