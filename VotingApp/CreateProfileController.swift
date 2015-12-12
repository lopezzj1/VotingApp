//
//  CreateProfileController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit

class CreateProfileController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    var firstName = ""
    
    @IBOutlet weak var lastNameTextField: UITextField!
    var lastName = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    var email = ""
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    var city = ""
    
    @IBOutlet weak var zipcodeTextField: UITextField!
    var zipcode = ""
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        firstName = firstNameTextField.text!
        lastName = lastNameTextField.text!
        email = emailTextField.text!
        city = cityTextField.text!
        zipcode = zipcodeTextField.text!


        
        
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
