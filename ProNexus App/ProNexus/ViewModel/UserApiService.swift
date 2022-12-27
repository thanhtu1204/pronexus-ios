//
//  UserApiService.swift
//  ProNexus
//
//  Created by thanh cto on 05/11/2021.
// https://github.com/3lvis/Networking

import Foundation
import SwiftUI
import SwiftyUserDefaults
import PromiseKit
import Networking

//import PromiseKit

class UserApiService: ObservableObject {
    
    let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
    let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error api"])
    
    @Published var userLogin = UserProfileModel()
    @Published var dataRegister = RegisterCustomerViewModel()
    @Published var dataRegisterAdvisor = RegisterAdvisorModel()
    @Published var dataResetPass = ForgotPasswordViewModel()
    @Published var advisorModel = AdvisorModel()
    @Published var customerModel = CustomerModel()
    
    @Published var loading = false
    @Published var isAuthentication = false
    @Published var isShowRegisterModalType = false
    @Published var isShowModalConfirmCode = false
    @Published var isCreateNewOtpResetPass = false
    
    @Published var isShowModalCreateSchedule: Bool = false // in tabview
    
    @Published var isShowAlert: Bool = false // in tabview
    @Published var alertMessage: String = "" // in tabview
    
    @Published var navProfileEdit: Bool = false
    
//    init() {
//        loading = true
//    }
    
    init() {
        loading = true
        if let token = Defaults.accessToken {
            networking.setAuthorizationHeader(token: token)
        }
    }
    
    // post login
    func postLogin(parameters: [String: Any]) -> Promise<UserProfileModel> {
        return Promise { seal in
            let networking = Networking(baseURL: "\(Production.BASE_URL)")
            networking.post("\(ApiRouter.POST_LOGIN)", parameterType: .formURLEncoded, parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(UserProfileModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        self.userLogin = rs
                        
                        Defaults.userLogger = rs // gán vào localstorage với trường hợp login
                        Defaults.accessToken = rs.accessToken
                        Defaults.userFullName = rs.fullName
                        Defaults.userPicture = rs.profileImageURL
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(UserProfileModel())
                    }
                case .failure(let response):
//                    seal.reject(response.error)
                    let rs = try! JSONDecoder().decode(UserProfileModel.self, from: response.data)
                    seal.fulfill(rs)
                    // Handle error
                }
            }
        }
    }
    
    // post login to firebase
    func postLoginFirebase(parameters: [String: Any]) -> Promise<Any> {
        return Promise { seal in
            let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
            networking.post("\(ApiRouter.POST_REGISTER_FIREBASE)", parameterType: .json, parameters: parameters) { result in
                switch result {
                case .success(let response):
                    seal.fulfill(response.arrayBody)
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }

        }
    }
    
    // post reset password by phone
    func postResetPassByPhone(parameters: [String: Any]) -> Promise<Int> {
        return Promise { seal in
//            let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
            networking.post("\(ApiRouter.POST_RESET_PASS)", parameterType: .json, parameters: parameters) { result in
                switch result {
                case .success(let response):
                    seal.fulfill(response.statusCode)
                case .failure(let response):
                    seal.fulfill(response.statusCode)
                    // Handle error
                }
            }
            
        }
    }
    
    // post register
    func postRegisterCustomer(parameters: [String: Any]) -> Promise<RegisterResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_REGISTER)", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(RegisterResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(RegisterResponse())
                    }
                case .failure(let response):
                    let json = response.dictionaryBody
                    let rs = try! JSONDecoder().decode(RegisterResponse.self, from: response.data)
                    seal.fulfill(rs)
                    // Handle error
                }
            }
        }
    }
    
    // post register advisor
    func postRegisterAdvisor(parameters: [String: Any]) -> Promise<RegisterResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_REGISTER_PROVIDER)", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(RegisterResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(RegisterResponse())
                    }
                case .failure(let response):
                    let json = response.dictionaryBody
                    let rs = try! JSONDecoder().decode(RegisterResponse.self, from: response.data)
                    seal.fulfill(rs)
                    // Handle error
                }
            }
        }
    }
    
    // post confirm register
    func postConfirmOtp(parameters: [String: Any]) -> Promise<ConfirmOtpModel> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_CONFIRM)", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ConfirmOtpModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ConfirmOtpModel())
                    }
                case .failure(let response):
                    
                    let json = response.dictionaryBody
                    let rs = try! JSONDecoder().decode(ConfirmOtpModel.self, from: response.data)
                    seal.fulfill(rs)
                    // Handle error
                }
            }
            
        }
    }
    
    // post create OTP exist account
    func postCreateOtp(parameters: [String: Any]) -> Promise<ConfirmOtpModel> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_GENERATE_OTP)", parameterType: .formURLEncoded, parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ConfirmOtpModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ConfirmOtpModel())
                    }
                case .failure(let response):
                    
                    let json = response.dictionaryBody
                    let rs = try! JSONDecoder().decode(ConfirmOtpModel.self, from: response.data)
                    seal.fulfill(rs)
                    // Handle error
                }
            }
            
        }
    }
    
    /**
     đăng xuất
     */
    func postLogout() -> Promise<CommonResponseModel> {
        return Promise { seal in
            networking.post("Logout/username", parameterType: .json, parameters: nil) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CommonResponseModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }

    func loadProfileCustomer() -> Promise<CustomerModelResponse> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_USER_CUSTOMER)")
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    do {
                        let rs = try! JSONDecoder().decode(CustomerModelResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        if let obj = rs.payload {
                            self.customerModel = obj
                            Defaults.userFullName = obj.fullName
                            Defaults.userPicture = obj.mediaUrl
                        }
                        seal.fulfill(rs)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    func updateProfileCustomer(parameters: [String: Any]) -> Promise<CommonResponseModel> {
        return Promise { seal in
            //            let networking = Networking(baseURL: "\(Production.BASE_URL)")
            networking.put("\(ApiRouter.GET_USER_CUSTOMER)", parameterType: .json, parameters: parameters) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                        
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CommonResponseModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    func saveTokenFirebase(token: String)  -> Promise<CommonResponseModel> {
//        let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
        let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error save token firebase"])
        let parameters: [String: Any] = [
            "GUID": token
        ]
        return Promise { seal in
            networking.post("\(ApiRouter.DEVICE_TOKEN)", parameterType: .json, parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                            let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                            seal.fulfill(rs)
                        } catch {
                            seal.reject(error)
                        }
                    } else
                    {
                        seal.reject(error)
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    func updateTokenFirebase(token: String)  -> Promise<CommonResponseModel> {
//        let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
        let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error save token firebase"])
        let parameters: [String: Any] = [
            "GUID": token
        ]
        return Promise { seal in
            networking.put("\(ApiRouter.DEVICE_TOKEN)", parameterType: .json, parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                            let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                            seal.fulfill(rs)
                        } catch {
                            seal.reject(error)
                        }
                    } else
                    {
                        seal.reject(error)
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    // notification
    
    func loadNotification(type: String = "") -> Promise<NotificationList> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_NOTIFICATION)?type=\(type)")
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(NotificationList.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(NotificationList(payload: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    
    //update read notificcation
    func updateReadNotificationById(id:String = "") -> Promise<CommonResponseModel> {
        return Promise { seal in
            //            let networking = Networking(baseURL: "\(Production.BASE_URL)")
            networking.put("\(ApiRouter.GET_NOTIFICATION)/\(id)", parameters: ["isRead": true]) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                        
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CommonResponseModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    // nghỉ hưu
    func postFormToGetRetirementPlan(parameters: [String: Any]) -> Promise<RetiementPlanResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.GET_RETIEMENT)", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(RetiementPlanResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(RetiementPlanResponse())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
        }
    }
    
    // tiết kiệm
    func postFormToGetSavingPlan(parameters: [String: Any]) -> Promise<SavingPlanResponseModel> {
        return Promise { seal in
            networking.post("\(ApiRouter.GET_SAVING_PLAN)", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(SavingPlanResponseModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(SavingPlanResponseModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
        }
    }
    
    // Gói vay
    func postFormToGetLoanPackage(parameters: [String: Any]) -> Promise<LoanPackageModelResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.GET_LOAN_1)", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(LoanPackageModelResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(LoanPackageModelResponse())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
        }
    }
    
    /**
     so sánh gói vay
     */
    func postCompareBuySell(parameters: [String: Any]) -> Promise<CompareBuySellToolResponse> {
        return Promise { seal in
            networking.post("BuyOrRentHouse", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CompareBuySellToolResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CompareBuySellToolResponse())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
        }
    }
}

