//
//  ProviderApiService.swift
//  ProNexus
//
//  Created by Tú Dev app on 29/10/2021.
//
import Foundation
import SwiftUI
import SwiftyUserDefaults
import Networking
import PromiseKit

class ProviderApiService: ObservableObject {
    
    let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
    let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error api"])
    
//    @Published var providerList = ProviderListModel(results: []) // danh sách advisor
    @Published var advisorModel = AdvisorModel() // model khi xem chi tiết advisor
    @Published var loading = false
    @Published var providerId:String = ""
    
    @Published var createScheduleModelResponse = CreateScheduleModelResponse() // model tạo lịch trống
    
    @Published var scheduleProviderEmpty = ScheduleListEmptyModel()
    
    @Published var scheduleCustomerAdvisor = ScheduleCustomerResponseModel() // danh sách lịch book của tài khoản đang đăng nhập
    @Published var scheduleAdvisor = ScheduleCustomerResponseModel() // danh sách lịch book của tài khoản đang đăng nhập
    
    @Published var selectionsClassficationBooking: [Int] = []
    @Published var pushedPayment = false
    
    
    init() {
        loading = true
        if let token = Defaults.accessToken {
            networking.setAuthorizationHeader(token: token)
        }
        
//        networking.setAuthorizationHeader(token: "2r9ZXPuAZh9qjuXuK-PyO4XEknrDsVxm7ocyhofd_FgBx-dtu6JEHcvhm8bHX1H2hF8ABZ3K2XBt9Bofheg3ixpe-4jJWHW9L6MXwrAJJ0WzJZM3AzoJWY6rhuWaGvHvkwhVbJhIg3qAlyvkja2bKYsmxxNiSQbsorYfb8cygpLs_RGBoO33fLf5Rqtd20Pg8p1Sikt4hAasVkYObMFrjiq2oVFHy5mdmeqdNimO3FUGxyuNh1kqPQBfccxqIp_u7FfmKPjy1kEiG2NNOgWadI5WZtkIvQUuFooDl0hChCigKlFXzmITzHzYweFQdybgSidGIO5h1QQRaMfjcqBvzMOs5ybBHbQcZLNqcFLLjyhHtusu58qyqwbWW4XSE1XNg8BInGLVhy0zpvaLvfbbxBijD-QaEw0MJ2kt5z1gZJkqo4HbelbdD7gIjp6G8UndKD_-YlQU_u6M9mpGkc43EElUxW_ozjS_J3pkxOefGcIcyb11cjC3MFIYwWh2bbPKjJ9TQwEmdFxUyIe2fRBxlqpPr7SgwL4nlCV7Yn-6EfUDcIUNa1jel92tIzIWlhPwBh3h3w0z0QguDuPDIOEFmBn2IcIEHZg7hFhwIlmnRx3QiUEu-UtouF1mk72fJORDulbbbZpLnBcTQ711VHtVXsMx4Q5yjVSuyRyJFvgLb5A")
    }
    
    func loadProviderDetail(key: String) -> Promise<AdvisorDetailModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_ADVISER)/\(key)")
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    do {
                        let rs = try! JSONDecoder().decode(AdvisorDetailModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        if let obj = rs.payload {
                            self.advisorModel = obj
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
    
    
    // load danh sach provider
    func loadListAdvisor(page: Int = 1, size: Int = 8, type: String = "" ,keyword:String = "",selectedRating:String = "",priceHour:String="", provinceId: Int = 0, isFeature: Bool = false) -> Promise<ProviderListModel> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_ADVISER)?Type=2&UserProfileStatus=1&SelectedClassList=\(type)&IsAvaiable=true")
        urlBuilder?.appendQueryItem(name: "PageNumber", value: "\(page)")
        urlBuilder?.appendQueryItem(name: "PageSize", value: "\(size)")
        urlBuilder?.appendQueryItem(name: "Keyword", value: "\(keyword)")
        urlBuilder?.appendQueryItem(name: "SelectedRating", value: "\(selectedRating)")
        urlBuilder?.appendQueryItem(name: "PriceHour", value: "\(priceHour)")
        if provinceId > 0 {
            urlBuilder?.appendQueryItem(name: "ProvinceId", value: "\(provinceId)")
        }
        if isFeature {
            urlBuilder?.appendQueryItem(name: "isFeature", value: "\(isFeature)")
        }
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProviderListModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
//                        self.providerList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProviderListModel(results: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    // get danh sách lịch trống
    func loadListScheduleEmptyById(advisorId: String, status: String = "", startTime: String = "", endTime: String = "") -> Promise<ScheduleListEmptyModel> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_SCHEDULE_EMPTY_ADVISOR_BY_ID)/\(advisorId)")
        urlBuilder?.appendQueryItem(name: "status", value: status)
        
        if (startTime == "") {
            urlBuilder?.appendQueryItem(name: "startTime", value: Date().adjust(.day, offset: -30).toString(format: .custom("yyyy/M/dd")))
        }
        if (endTime == "") {
            urlBuilder?.appendQueryItem(name: "endTime", value: Date().adjust(.day, offset: 90).toString(format: .custom("yyyy/M/dd")))
        }
        
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ScheduleListEmptyModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        self.scheduleProviderEmpty = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ScheduleListEmptyModel())
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    // advisor tạo lịch trống
    func postAdvisorCreateSchedule(parameters: [String: Any]) -> Promise<CreateScheduleModelResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_CREATE_SCHEDULE_EMPTY_ADVISOR)", parameterType: .json, parameters: parameters) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                            let rs = try! JSONDecoder().decode(CreateScheduleModelResponse.self, from: response.data)
                            self.createScheduleModelResponse = rs
                            seal.fulfill(rs)
                        } catch {
                            seal.reject(error)
                        }
                    } else
                    {
                        seal.reject(self.error)
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    
    // advisor sửa lịch trống
    func postAdvisorEditSchedule(id:String, parameters: [String: Any]) -> Promise<CreateScheduleModelResponse> {
        return Promise { seal in
            networking.put("\(ApiRouter.POST_CREATE_SCHEDULE_EMPTY_ADVISOR)/\(id)", parameterType: .json, parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                            let rs = try! JSONDecoder().decode(CreateScheduleModelResponse.self, from: response.data)
                            self.createScheduleModelResponse = rs
                            seal.fulfill(rs)
                        } catch {
                            seal.reject(error)
                        }
                    } else
                    {
                        seal.reject(self.error)
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    
    //Load danh sách lịch customer
    func loadListScheduleCustomer(scheduleType: String = "", startDate: String = "", endDate: String = "", keyword: String = "") -> Promise<ScheduleCustomerResponseModel> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_SCHEDULE_CUSTOMER)")
        urlBuilder?.appendQueryItem(name: "ScheduleTypeList", value: scheduleType)
        urlBuilder?.appendQueryItem(name: "Status", value: "2")
        urlBuilder?.appendQueryItem(name: "Keyword", value: keyword)
        if (startDate == "") {
            urlBuilder?.appendQueryItem(name: "startDate", value: Date().adjust(.day, offset: -30).toString(format: .custom("yyyy/M/dd")))
        }
        if (endDate == "") {
            urlBuilder?.appendQueryItem(name: "endDate", value: Date().adjust(.day, offset: 90).toString(format: .custom("yyyy/M/dd")))
        }
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ScheduleCustomerResponseModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        self.scheduleCustomerAdvisor = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ScheduleCustomerResponseModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    //Load danh sách lịch advisor
    
    func loadListScheduleAdvisor(scheduleType: String = "", startDate: String = "", endDate: String = "", keyword: String = "") -> Promise<ScheduleCustomerResponseModel> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_SCHEDULE_ADVISOR)")
        urlBuilder?.appendQueryItem(name: "ScheduleTypeList", value: scheduleType)
        urlBuilder?.appendQueryItem(name: "Status", value: "2")
        urlBuilder?.appendQueryItem(name: "Keyword", value: keyword)
        if (startDate == "") {
            urlBuilder?.appendQueryItem(name: "startDate", value: Date().adjust(.day, offset: -30).toString(format: .custom("yyyy/M/dd")))
        }
        if (endDate == "") {
            urlBuilder?.appendQueryItem(name: "endDate", value: Date().adjust(.day, offset: 90).toString(format: .custom("yyyy/M/dd")))
        }
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ScheduleCustomerResponseModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        self.scheduleCustomerAdvisor = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ScheduleCustomerResponseModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    // customer đặt lịch hẹn
    func postCustomerCreateSchedule(parameters: [String: Any]) -> Promise<CustomerCreateScheduleModelResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_CREATE_SCHEDULE_EMPTY_ADVISOR)", parameterType: .json, parameters: parameters) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                            let rs = try! JSONDecoder().decode(CustomerCreateScheduleModelResponse.self, from: response.data)
                            seal.fulfill(rs)
                        } catch {
                            seal.reject(error)
                        }
                    } else
                    {
                        seal.reject(self.error)
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    //update profile
    func updateProfileAdvisor(parameters: [String: Any]) -> Promise<CommonResponseModel> {
        return Promise { seal in
            //            let networking = Networking(baseURL: "\(Production.BASE_URL)")
            networking.put("\(ApiRouter.GET_USER_PROVIDER)", parameterType: .json, parameters: parameters) { result in
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
    
    
    // đặt lịch hẹn với advisor
    func postBookSchedule(parameters: [String: Any]) -> Promise<CustomerCreateScheduleModelResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_SCHEDULE_TO_ADVISOR)", parameters: parameters) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CustomerCreateScheduleModelResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CustomerCreateScheduleModelResponse())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    // tao thanh toán vnpay
    func postCreatePaymentVnPay(parameters: [String: Any]) -> Promise<CreatePaymentVnPayResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_CREATE_PAYMENT_VNPAY)", parameters: parameters) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CreatePaymentVnPayResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CreatePaymentVnPayResponse())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    //update trạng thái lịch hẹn chi tiết
    func changeStatusAppointment(id: Int?, status: AppointmentStatus) -> Promise<CommonResponseModel> {
        return Promise { seal in
            //            let networking = Networking(baseURL: "\(Production.BASE_URL)")
            networking.put("CustomerSchedule/customer/\(id as! Int)/update?status=\(status)", parameterType: .json) { result in
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
    
    func deleteAppointment(id: String) -> Promise<CommonResponseModel> {
        return Promise { seal in
            networking.delete("schedule/\(id)") { result in
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
    
    //load profile user advisor
    
    func loadProfileAdvisor() -> Promise<AdvisorDetailModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_USER_PROVIDER)")
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    do {
                        let rs = try! JSONDecoder().decode(AdvisorDetailModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        if let obj = rs.payload {
                            self.advisorModel = obj
                            Defaults.userFullName = obj.fullName()
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
    
    // GET PROVINCE IN COUNTRY
    func loadProvinceById() -> Promise<ProvinceListModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_PROVINCE_BY_ID)")
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProvinceListModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProvinceListModel(results: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    // GET DISTRICT INPROVICE
    
    func loadDistrictByProvinceId(id: Int = 0) -> Promise<ProvinceListModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_DISTRICT_BY_PROVINCE_ID)/\(id)")
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProvinceListModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProvinceListModel(results: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }

        // get danh sách lịch trống
    func loadCustomerScheduleById(id: Int) -> Promise<ScheduleCustomerDetailResponseModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_SCHEDULE_BY_ID)/\(id)")

        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ScheduleCustomerDetailResponseModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ScheduleCustomerDetailResponseModel())
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    // lấy tổng doanh thu user đang online ProviderIncome
    
    func loadTotalProviderIncome(startDate: String = "", endDate: String = "") -> Promise<TotalProviderIncomeList> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_TOTAL_INCOME_PROVIDER)")
        if (startDate != "") {
            urlBuilder?.appendQueryItem(name: "startDate", value: startDate)
        }
        if (endDate != "") {
            urlBuilder?.appendQueryItem(name: "endDate", value: endDate)
        }
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(TotalProviderIncomeList.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
//                        self.providerList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(TotalProviderIncomeList())
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    
    func loadListProviderConected() -> Promise<ProviderListModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_PROVIDER_CONNECTED)")
       
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProviderListModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
//                        self.providerList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProviderListModel(results: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }

    func requestWithdrawMoney(parameters: [String: Any]) -> Promise<WithdrawMoneyModelResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.REQUEST_WITHDRAW_MONEY)", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(WithdrawMoneyModelResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(WithdrawMoneyModelResponse())
                    }
                case .failure(let response):
                    let rs = try! JSONDecoder().decode(WithdrawMoneyModelResponse.self, from: response.data)
                    seal.fulfill(rs)
                    // Handle error
                }
            }
        }
    }
    
    func loadListProviderIncome(startDate: String = "", endDate: String = "") -> Promise<ProviderIncomeList> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_INCOME_PROVIDER)")
        if (startDate == "") {
            urlBuilder?.appendQueryItem(name: "startDate", value: Date().adjust(.day, offset: -30).toString(format: .custom("yyyy/M/dd")))
        }else{
            urlBuilder?.appendQueryItem(name: "startDate", value: startDate)
        }
        if (endDate == "") {
            urlBuilder?.appendQueryItem(name: "endDate", value: Date().adjust(.day, offset: 90).toString(format: .custom("yyyy/M/dd")))
        }else{
            urlBuilder?.appendQueryItem(name: "endDate", value: endDate)
        }
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProviderIncomeList.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
//                        self.providerList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProviderIncomeList(payload: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    // biểu đồ doanh thu theo quãng thời gian
    func loadListProviderIncomeByDone(startDate: String = "", endDate: String = "") -> Promise<ProviderIncomeList> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_CHART_INCOME_PROVIDER)")
        if (startDate == "") {
            // đầu tháng
            urlBuilder?.appendQueryItem(name: "startDate", value: Date().dateFor(.startOfMonth).toString(format: .custom("yyyy/M/dd")))
        }else{
            urlBuilder?.appendQueryItem(name: "startDate", value: startDate)
        }
        if (endDate == "") {
            // cuối tháng hiện tại
            urlBuilder?.appendQueryItem(name: "endDate", value: Date().dateFor(.endOfMonth).toString(format: .custom("yyyy/M/dd")))
        }else{
            urlBuilder?.appendQueryItem(name: "endDate", value: endDate)
        }
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProviderIncomeList.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
//                        self.providerList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProviderIncomeList(payload: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    // Danh sách customer đã tư vấn
    
    func loadListCustomerConected() -> Promise<CustomerConnectedList> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_CUSTOMER_CONNECTED)")
       
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CustomerConnectedList.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
//                        self.providerList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CustomerConnectedList(payload: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    // yêu thích cố  vấn nào đó
    func advisorFavorite(parameters: [String: Any]) -> Promise<CommonResponseModel> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_FAVORITE_ADVISOR)", parameterType: .json, parameters: parameters) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                            // base respon co van de

//                            let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
////                            self.createScheduleModelResponse = rs
//                            seal.fulfill(rs)
                        } catch {
                            seal.reject(error)
                        }
                    } else
                    {
                        seal.reject(self.error)
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    // xoá cố vấn  yêu thích
    func deleteAdvisorFavorite(id: String) -> Promise<CommonResponseModel> {
        return Promise { seal in
            networking.delete("\(ApiRouter.POST_FAVORITE_ADVISOR)/\(id)") { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        // base respon co van de
//                        let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
//                        
//                        seal.fulfill(rs)
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
    
    // cố vấn yêu thích
    func loadListProviderFavorite(page: Int = 1, size: Int = 4, type: String = "" ,keyword:String = "", selectedRating:String = "",city:String="", isFeature: Bool = false) -> Promise<AdvisorFavoriteList> {
        var urlBuilder = URL(string: "\(ApiRouter.POST_FAVORITE_ADVISOR)")
        urlBuilder?.appendQueryItem(name: "PageNumber", value: "\(page)")
        urlBuilder?.appendQueryItem(name: "PageSize", value: "\(size)")
        urlBuilder?.appendQueryItem(name: "Keyword", value: "\(keyword)")
        urlBuilder?.appendQueryItem(name: "SelectedRating", value: "\(selectedRating)")
        // chưa sử dụng nên để trống
        urlBuilder?.appendQueryItem(name: "UserProfileStatus", value: "")
        urlBuilder?.appendQueryItem(name: "Rating", value: "")
        urlBuilder?.appendQueryItem(name: "SelectedClassList", value: "")
        urlBuilder?.appendQueryItem(name: "IsAvaiable", value: "")

        if isFeature {
            urlBuilder?.appendQueryItem(name: "isFeature", value: "\(isFeature)")
        }
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(AdvisorFavoriteList.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
//                        self.providerList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(AdvisorFavoriteList(payload: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }

    func loadListWithdrawHistory(status: String = "") -> Promise<WithdrawHistoryModelResponse> {
        return Promise { seal in
            networking.get("\(ApiRouter.GET_WITHDRAW_HISTORY)?Status=\(status)") { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(WithdrawHistoryModelResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(WithdrawHistoryModelResponse())
                    }
                case .failure(let response):
                    let rs = try! JSONDecoder().decode(WithdrawHistoryModelResponse.self, from: response.data)
                    seal.fulfill(rs)
                    // Handle error
                }
            }
        }
    }
    
    func loadListBank() -> Promise<ListBankModelResponse> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_LIST_BANK)")
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ListBankModelResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ListBankModelResponse(payload: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }

        // feedback Advisor
    func postAdvisorFeedBack(parameters: [String: Any]) -> Promise<AdvisorFeedback> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_FEEDBACK_ADVISOR)", parameterType: .json, parameters: parameters) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                            let rs = try! JSONDecoder().decode(AdvisorFeedback.self, from: response.data)
//                            self.createScheduleModelResponse = rs
                            seal.fulfill(rs)
                        } catch {
                            seal.reject(error)
                        }
                    } else
                    {
                        seal.reject(self.error)
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
        
    // kiểm tra xem advisor này đã nằm trong list yêu thích hay chưa
    func checkAdvisorFavorite(id: String) -> Promise<CommonResponseModel> {
        let urlBuilder = URL(string: "AdvisorFavorite/\(id)/username")
        let url = urlBuilder?.absoluteString ?? ""
        
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
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
}
