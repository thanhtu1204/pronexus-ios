//
//  FormDataViewController.swift
//  Demo Forms
//
//  Created by Borinschi Ivan on 12.04.2021.
//

import UIKit
import DSKit

class FormDataViewController: UIViewController {
    
    var formData: FormData? = nil
    
    @IBOutlet weak var formDataLabel: UILabel!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let formData = formData else {
            return
        }
        
        formDataLabel.text = "Name: \(formData.name)\nEmail:\(formData.email)\nPassword:\(formData.password)\nRepeat password: \(formData.repeatPassword)"
    }
}
