//
//  ForgotPasswordViewModel.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import Foundation

class ForgotPasswordViewModel : ObservableObject {
        
    @Published var phone = ""
    @Published var password = ""
    @Published var confirmPass = ""
    @Published var code = ""
    
    // DataModel For Error View...
    @Published var errorMsg = ""
    @Published var error = false
}
