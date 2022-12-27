//
//  RegisterAdvisorModal.swift
//  ProNexus
//
//  Created by TUYEN on 11/11/21.
//

import Foundation

class RegisterAdvisorModel : ObservableObject {
    
    @Published var dob = ""
    @Published var gender = ""
    @Published var company = ""
    @Published var aboutMe = ""
    @Published var linkUrl = ""
    @Published var jobTitle = ""
    @Published var MediaUrl = ""
    @Published var userName = ""
    @Published var lastname = ""
    @Published var password = ""
    @Published var referCode = ""
    @Published var userEmail = ""
    @Published var firstname = ""
    @Published var identityNumber = ""
    @Published var yearsExperience = ""
    @Published var classificationIDList: [Int]?
    @Published var certificateMediaList: [String]?
    @Published var type: Int?
    @Published var priceHours: Int?
    @Published var backMediaURL: String?
    @Published var forthMediaURL: String?
    @Published var dobDate: Date = Date()
    

    // DataModel For Error View...
    
    @Published var errorMsg = ""
    @Published var error = false
}

