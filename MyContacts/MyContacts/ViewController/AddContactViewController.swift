//
//  AddContactViewController.swift
//  MyContacts
//
//  Created by Sujananth on 10/28/18.
//  Copyright © 2018 sujananth. All rights reserved.
//

import UIKit

typealias contactDetails = (firstName: String, lastName: String, emailId: String, mobile: Int64, countryCode: String)
//App is crashing crashes when I run using creating instance of autocreated model class. This issue is specific to xcode 10. https://stackoverflow.com/questions/50718018/xcode-10-error-multiple-commands-produce So created a tuple to send data between view controllers.

protocol AddContactViewDelegate: class {
    func addContact(_ contactDetails: contactDetails)
}

class AddContactViewController: UIViewController {

    weak var delegate: AddContactViewDelegate?
    
    @IBOutlet weak var contactProfileImage: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var addContactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.contactProfileImage.image = UIImage(named: "ContactProfilePlaceHolder")
        self.navigationController?.title = "Add Contact"
    }
    
    
    
    @IBAction func onTappingAddContactButton(_ sender: Any) {
        
        guard let firstName = self.firstNameTextField.text, let lastName = self.lastNameTextField.text, let email = self.emailTextField.text, let mobileNumber = Int64(self.mobileNumberTextField.text!), let countryCode = self.countryCodeTextField.text else {
            //Throw error invalid input
            return
        }
        
        if(!isValidEmail(emailID: email)) {
            //Throw error with message"Enter a valid email ID"
        }
        
        let contact = (firstName: firstName, lastName: lastName, emailId: email, mobile: mobileNumber, countryCode: countryCode)
        self.delegate?.addContact(contact)
        self.navigationController?.popViewController(animated: true)
    }
    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
}
