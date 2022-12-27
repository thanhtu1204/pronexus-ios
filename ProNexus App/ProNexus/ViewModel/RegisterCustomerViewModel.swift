//
//  RegisterCustomerViewModel.swift
//  ProNexus
//
//  Created by thanh cto on 05/11/2021.
//

import Foundation


class RegisterCustomerViewModel : ObservableObject {
    
    @Published var firstname = ""
    @Published var lastname = ""
    @Published var password = ""
    @Published var phone = ""
    @Published var username = ""
    @Published var code = ""
    @Published var referCode = ""
    @Published var userEmail = ""
    
    // DataModel For Error View...
    @Published var errorMsg = ""
    @Published var error = false
}
