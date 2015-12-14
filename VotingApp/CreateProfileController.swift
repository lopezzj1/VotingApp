//
//  CreateProfileController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

class CreateProfileController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!

    @IBOutlet weak var zipcodeTextField: UITextField!

    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    
    var picker = UIPickerView()
    
    var state: String = states[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.hidden = true;
        stateTextField.inputView = picker
        
        picker = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        picker.backgroundColor = .whiteColor()
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        cityTextField.delegate = self
        zipcodeTextField.delegate = self
        stateTextField.delegate = self
        
        zipcodeTextField.returnKeyType = UIReturnKeyType.Next
        
        let zipToolbar = UIToolbar()
        zipToolbar.barStyle = UIBarStyle.Default
        zipToolbar.translucent = true
        zipToolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        zipToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "hidePicker:")
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "nextHandler:")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

        let stateToolbar = UIToolbar()
        stateToolbar.barStyle = UIBarStyle.Default
        stateToolbar.translucent = true
        stateToolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        stateToolbar.sizeToFit()
        
        stateToolbar.setItems([spaceButton, doneButton], animated: false)
        stateToolbar.userInteractionEnabled = true
        
        zipToolbar.setItems([nextButton, spaceButton], animated: false)
        zipToolbar.userInteractionEnabled = true
        
        stateTextField.inputView = picker
        stateTextField.inputAccessoryView = stateToolbar
        
        zipcodeTextField.inputAccessoryView = zipToolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hidePicker(sender: UIBarButtonItem) -> Bool {
        self.stateTextField.resignFirstResponder()
        self.stateTextField.text = self.state
        return true
    }
    
    func nextHandler(sender: UIBarButtonItem) -> Bool {
        self.textFieldShouldReturn(zipcodeTextField)
        return true
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
        user["state"] = self.state
        
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
    
    // For text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let signUpOrder = [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField, addressTextField, cityTextField, zipcodeTextField, stateTextField]
        let matchedFieldNum = signUpOrder.indexOf { (tf) -> Bool in
            return tf == textField
        }

        let matchedField = signUpOrder[matchedFieldNum!]
        let nextField = signUpOrder[matchedFieldNum! + 1]
        

        matchedField.resignFirstResponder()
        nextField.becomeFirstResponder()

        return false
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
    
    
    //for UIPickerViewDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let state = states[row]
        stateTextField.text = state
        self.state = state
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
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
