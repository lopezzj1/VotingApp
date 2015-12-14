//
//  CreateProfileController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

class CreateProfileController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!

    @IBOutlet weak var zipcodeTextField: UITextField!

    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        if (addressTextField.text != "" || cityTextField.text != "" || zipcodeTextField.text != "") {
            if passwordTextField.text! == confirmPasswordTextField.text! {

                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo["error"] as? String
                        if (errorString == "invalid email address") {
                            
                            let alertController = UIAlertController(title: "Email Incorrect", message: "You entered an invalid email address.", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    } else {
                        print("success")
                        let nav: HackyNavController = self.navigationController as! HackyNavController
                        nav.cachedUser = user
                        self.performSegueWithIdentifier("createProfileToMenuSegue", sender: nil)
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Password Incorrect", message: "Password and Confirm Password does not match.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Missing Fields", message: "Please make sure that all fields are completed.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
     }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
            
        } else if textField == lastNameTextField {
            lastNameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            
        } else if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
            
        } else if textField == confirmPasswordTextField {
            confirmPasswordTextField.resignFirstResponder()
            addressTextField.becomeFirstResponder()
            
        } else if textField == addressTextField {
            addressTextField.resignFirstResponder()
            cityTextField.becomeFirstResponder()
            
        } else if textField == cityTextField {
            cityTextField.resignFirstResponder()
        }
        
        
        if textField == zipcodeTextField {
            zipcodeTextField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == addressTextField || textField == cityTextField || textField == zipcodeTextField) {
            scrollView.setContentOffset(CGPointMake(0, 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField : UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.scrollView.endEditing(true)
        print("touchesBegan worked")
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
