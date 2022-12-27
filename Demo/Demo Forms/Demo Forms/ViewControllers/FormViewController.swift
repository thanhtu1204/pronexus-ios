//
//  FormViewController.swift
//  Demo Forms
//
//  Created by Borinschi Ivan on 12.04.2021.
//

import UIKit
import DSKit

class FormViewController: DSViewController {
    
    // Form values
    var userName: String = ""
    var userEmail: String = ""
    var userPassword: String = ""
    var userRepeatPassword: String = ""

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show form section
        show(content: formSection())
    }
    
    /// Form section
    /// - Returns: DSSection
    func formSection() -> DSSection {
        
        // Name
        let name = DSTextFieldVM.name(text: "John Doe", placeholder: "Full Name")
        name.didUpdate = { model in
            self.userName = model.text ?? "No value"
        }
        
        // Email
        let email = DSTextFieldVM.email(placeholder: "Email")
        email.didUpdate = { model in
            self.userEmail = model.text ?? "No value"
        }
        
        // Password
        let password = DSTextFieldVM.password(placeholder: "Password")
        password.didUpdate = { model in
            self.userPassword = model.text ?? "No value"
        }
        
        // Repeat password
        let repeatPassword = DSTextFieldVM.password(placeholder: "Repeat password")
        repeatPassword.didUpdate = { model in
            self.userRepeatPassword = model.text ?? "No value"
        }
        
        // Custom validation, compare userPassword with userRepeatPassword
        repeatPassword.handleValidation = { repeatPasswordText in
            self.userRepeatPassword = repeatPasswordText ?? "No value"
            return self.userPassword == self.userRepeatPassword
        }
        
        // Register button / handle tap on button action
        let registerButton = DSButtonVM(title: "Register") { [unowned self] (_: DSButtonVM)  in
            
            // Check form validation
            self.isCurrentFormValid { isValid in
                
                // If our form pass validation
                if isValid {
                    
                    let data = FormData(name: userName,
                                        email: userEmail,
                                        password: userPassword,
                                        repeatPassword: userRepeatPassword)
                    
                    // formData segue is set in storyboard
                    self.performSegue(withIdentifier: "formData", sender: data)
                    
                } else {
                    
                    // Show invalid message
                    self.show(message: "Form is invalid",
                              type: .error,
                              icon: UIImage(systemName: "xmark.octagon.fill"))
                }
            }
        }
        
        // Form section
        let space = DSSpaceVM(type: .custom(30))
        let section = [space, name, email, password, repeatPassword, registerButton].list()
        
        return section
    }
    
    /// Prepare segue
    /// - Parameters:
    ///   - segue: UIStoryboardSegue
    ///   - sender: Any?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Data sent from self.performSegue(withIdentifier: "formData", sender: data)
        guard let data = sender as? FormData else {
            return
        }
        
        // Get destination
        guard let formDataViewController = segue.destination as? FormDataViewController else {
            return
        }
        
        formDataViewController.formData = data
    }
}
