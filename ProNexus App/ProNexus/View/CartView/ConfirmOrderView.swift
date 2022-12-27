//
//  ConfirmOrderView.swift
//  ProNexus
//
//  Created by Tú Dev app on 11/11/2021.
//

import SwiftUI
import SwiftyUserDefaults
import Combine

struct ConfirmOrderView: View {
    
    
    @State var data: [ProductElement] = []
    
    
    @EnvironmentObject var service: MarketPlaceApiService
    @EnvironmentObject var serviceUser: UserApiService
    @ObservedObject var viewModel = ViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var logger = LoggerModelViewModel()
    
    @State var isChecked:Bool = false
    @State var isCheckedValue = 1
    @State var firstName = ""
    @State var lastName = ""
    @State var phoneNumber = ""
    @State var birthDay = ""
    @State var sex = 0
    @State var email = ""
    @State var cmt = ""
    @State var isShowPaymentForm = false
    @State var urlAddress = "http://sandbox.vnpayment.vn/tryitnow/Home/CreateOrder"
    
    @State var message = ""
    @State var isShowAlertError = false
    @State var isShowAlertSuccess = false
    @State var isChooseBank = false
    @State var isErrorShow = false
    @State var errorMessage = ""
    @State var paymentOk = false
    @State var paymentFail = false
    @State var selectedBankCode: String?
    @State var loading = true
    @State var showLoader = false
    @State var showsDatePicker = false
    @State var totalPrice: Int = 0
    @State var isValidForm = false
    
    
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .top) {
                VStack{
                    VStack {
                        Header(title: "Xác nhận thông tin", contentView: {
                            ButtonIcon(name: "arrow.left", onTapButton: {
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            Spacer()
                            //                        ButtonIcon(name: "cart.fill", onTapButton: {
                            //
                            //                        })
                        })
                        
                    }.zIndex(9999)
                    
                    ScrollView (showsIndicators: false) {
                        VStack{
                            Group{
                                VStack(alignment:.leading){
                                    HStack{
                                        Text("Thông tin cá nhân thụ hưởng")
                                            .appFont(style: .body,weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                                        Spacer()
                                    }
                                }.padding(.horizontal, 37).padding(.top,60)
                                
                                VStack(alignment:.leading, spacing: 25){
                                    HStack{
                                        Toggle(isOn: $isChecked.onUpdate(checkedOnchange)) {
                                            
                                        }.padding(.all, 0).padding(.trailing,12)
                                            .toggleStyle(CheckboxSquareStyle())
                                        Text("Mua hộ cho người khác")
                                            .appFont(style: .body,weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                                        
                                    }.padding(.vertical,25)
                                    
                                    Group {
                                        HStack(content: {
                                            MyTextField(placeholder: "Họ Đệm", value: $firstName.onUpdate(checkFormValid), required: true)
                                            MyTextField(placeholder: "Tên", value: $lastName.onUpdate(checkFormValid), required: true)
                                        })
                                    }
                                    MyTextField(placeholder: "Số điện thoại", type: .phone, value: $phoneNumber.onUpdate(checkFormValid), required: true)
                                    
                                    HStack {
                                        VStack (alignment: .leading) {
                                            MyTextField(placeholder: "Ngày sinh", value: $birthDay.onUpdate(checkFormValid), required: false, readOnly: true)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            self.showsDatePicker.toggle()
                                        }
                                        VStack (alignment: .leading, content: {
                                            Group {
                                                DropdownSelector(
                                                    placeholder: (self.sex == 0) ? "Giới tính" : (self.sex == 2 ? "Nam" : "Nữ"),
                                                    required: true,
                                                    options: [
                                                        DropdownOption(key: UUID().uuidString, value: "Nam"),
                                                        DropdownOption(key: UUID().uuidString, value: "Nữ")
                                                    ],
                                                    onOptionSelected: { option in
                                                        if (option.value == "Nam") {
                                                            sex = 2
                                                        } else {
                                                            sex = 1
                                                        }
                                                    })
                                                    .background(Color.white)
                                                    .zIndex(999)
                                            }
                                            
                                        }).padding(.vertical, -5)
                                    }
                                    
                                    MyTextField(placeholder: "Email", value: $email.onUpdate(checkFormValid), required: true)
                                    MyTextField(placeholder: "Số CMTND/CCCD/HC", value: $cmt.onUpdate(checkFormValid), required: true)
                                }
                                .padding(.bottom, 20)
                                .padding(.horizontal,37)
                                .frame(width: screenWidth()-74)
                                .background(Color.white)
                                .cornerRadius(15)
                                .myShadow()
                                
                                VStack(alignment:.leading){
                                    HStack{
                                        Text("Thông tin đơn hàng")
                                            .appFont(style: .body,weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                                        Spacer()
                                    }
                                }.padding(.horizontal, 37).padding(.top,20)
                                
                                
                                if let arr = data {
                                    if (arr.count > 0 ) {
                                        ForEach(arr.filter({ $0.isChecked ?? false })) {prod in
                                            HStack{
                                                ItemConfirmOrderView(item: prod).environmentObject(MarketPlaceApiService())
                                            }
                                            .padding(.vertical,5)
                                        }
                                    } else {
                                        NoData()
                                    }
                                }
                                
                                Spacer()
                            }.padding(.bottom, 5)
                        }
                    }
                    VStack{
                        Divider()
                        HStack{
                            VStack{
                                Text("Tổng thanh toán").appFont(style: .body, weight: .bold, size:14,color: Color(hex:"#4D4D4D"))
                                Text("\(self.totalPrice)").appFont(style: .body,weight: .bold,size: 20, color: Color(hex:"#4C99F8"))
                            }
                            Spacer()
                            VStack{
                                if $isValidForm.wrappedValue {
                                    Button(action: {
                                        self.isChooseBank = true
                                    }, label: {
                                        Text("Tiếp tục").appFont(style: .body, color: .white)
                                    })
                                        .buttonStyle(GradientButtonStyle())
                                } else
                                {
                                    Button(action: {
                                        
                                    }, label: {
                                        Text("Tiếp tục").appFont(style: .body, color: .white)
                                    })
                                        .buttonStyle(RoundedSilverButtonStyle())
                                }
                                
                            }
                        }.padding(.horizontal,37).padding(.top,18)
                        
                    }.frame(width: screenWidth(), height: 80)
                    
                }
                
                if $showsDatePicker.wrappedValue {
                    MyDatePicker(show: $showsDatePicker, dateString: $birthDay)
                }
                
                if $isShowPaymentForm.wrappedValue {
                    VStack(spacing: 0) {
                        VStack {
                            ZStack(alignment: .center) {
                                HStack(spacing: 0) {
                                    //button left
                                    Button(action: {
                                        self.isShowPaymentForm.toggle()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                    }).frame(width: 50, alignment: .center)
                                    
                                    Spacer()
                                    HStack(alignment: .center, spacing: 0) {
                                        Text("Thanh toán      ")
                                            .appFont(style: .body,weight: .regular, size: 20, color: Color(.white)).padding(.trailing,40)
                                    }
                                    
                                    Spacer()
                                    
                                }
                                
                            }.background(
                                Image("bg_header")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.screenWidth, height: 180)
                            )
                        }
                        .padding(.bottom, 40)
                        .zIndex(9999)
                        WebView(url: .publicUrl, urlAddress: urlAddress, viewModel: viewModel)
                        
                    }
                    .background(Color(hex: "#FFFFFF"))
                    .onReceive(self.viewModel.showLoader.receive(on: RunLoop.main)) { value in
                        self.showLoader = value
                    }.onReceive(self.viewModel.lastUrlRequest.receive(on: RunLoop.main)) { value in
                        print("Last URL Request =>> ", value)
                        logger.saveLog(userId: getIdByRole(), name: "Thanh toán market", message: value) {
                            
                        }
                        if let responseCode = getQueryStringParameter(url: value, param: "vnp_ResponseCode")
                        {
                            self.showLoader = false
                            self.isShowPaymentForm.toggle()
                            
                            if responseCode == "00" {
                                print("responseCode", responseCode)
                                self.paymentOk = true
                            } else
                            {
                                self.paymentFail = true
                                self.showLoader = false
                            }
                        }
                    }.zIndex(9998)
                }
                
                // A simple loader that is shown when WebView is loading any page and hides when loading is finished.
                if showLoader {
                    Loader().zIndex(9999).padding(.top, 100)
                }
                
                if $paymentOk.wrappedValue {
                    CustomAlertView(title: "Hoàn tất", msg: "Đặt hàng thành công.", textButton1: "Xem chi tiết", textButton2: "Về trang chủ", icon: "ic_complate", show: $paymentOk)
                }
                
                if $paymentFail.wrappedValue {
                    CustomAlertView(title: "Chưa hoàn tất", msg: "Đặt hàng thất bại", textButton1: "Thử lại", textButton2: "Để sau", icon: "ic_un_complate", show: $paymentFail)
                }
                
                
                NavigationLink (isActive: $isChooseBank) {
                    BankListView(selectedBankCode: $selectedBankCode.onUpdate(onCallBackSelectedBank), isNavigationView: true).environmentObject(BankListApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                } label: {
                    EmptyView()
                }
                
                if $isErrorShow.wrappedValue
                {
                    CustomAlertView(title: "Thông báo", msg: errorMessage,  textButton2: "Đóng", icon: "ic_un_complate", show: $isErrorShow)
                }
                
            }.onAppear() {
                //            loadCarts()
                checkedOnchange()
            }.navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
        }
    }
    
    func checkFormValid() {
        self.isValidForm = !self.email.isBlank
        && !self.firstName.isBlank
        && !self.lastName.isBlank
        && !self.phoneNumber.isBlank
        && !self.cmt.isBlank
        && !self.birthDay.isBlank
        && !(self.sex == 0)
    }
    
    func checkedOnchange() {
        if (isChecked) {
            isCheckedValue = isChecked ? 2 : 1
            self.email =  ""
            self.lastName =  ""
            self.firstName =  ""
            self.phoneNumber = ""
            self.cmt = ""
            self.sex = 0
            self.birthDay = ""
            self.selectedBankCode = ""
            self.checkFormValid()
        } else {
            // nếu chưa chọn bank thì mới load lại
            // TODO: đối với role advisor
            if self.isValidForm == false {
                serviceUser.loadProfileCustomer().done { response in
                    self.loading = false
                    if let obj = response.payload {
                        self.firstName = obj.firstName ?? ""
                        self.lastName = obj.lastName ?? ""
                        self.sex = obj.gender ?? 0
                        self.phoneNumber = obj.phone ?? ""
                        self.email = obj.userEmail ?? ""
                        self.cmt = obj.identityNumber ?? ""
                        //                    self.sex = obj.provinceID ?? 0
                        if !obj.dob.isBlank && obj.dob.count >= 10 {
                            self.birthDay = (Date(fromString: obj.dob[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yyyy"))) as! String
                        }
                        checkFormValid()
                    }
                }
            }
        }
    }
    
    func onCallBackSelectedBank() {
        print(">> selectedBankCode:", selectedBankCode)
        if let bankCode = selectedBankCode {
            createOrder(bankCode: bankCode)
            self.selectedBankCode = nil
        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func createOrder(bankCode: String) {
        
        var dob: Int64 = 0
        if let birthday = Date(fromString: birthDay, format: .custom("dd/M/yyyy")) {
            dob = Int64(birthday.timeIntervalSince1970)
        }
        
        let idArray = data.map({ (item: ProductElement) -> Int in
            item.productID ?? 0
        })
        
        let data: [String: Any] = [
            "BenefitName": lastName,
            "BenefitPhone": phoneNumber,
            "BenefitDob": dob,
            "BenefitType": isCheckedValue, //1. Mua cho user đang login 2. Mua hộ
            "BenefitSex":  sex, // 1. Nữ, 2.Nam
            "BenefitEmail": email,
            "BenefitIdentityNumber": cmt, // CMND/CCCD
            "ProductIdList": idArray,
            "Quantity": 1
        ]
        
        
        service.createOrder(parameters: data).done { response in
            
            if let rs = response.payload {
                //                AppUtils.showAlert(text: "Tạo thành công Order \(rs.orderID ?? 0)")
                //create payment VNPAY
                if let vnpTxnRef = rs.vnpTxnRef
                {
                    requestCreatePaymentVnpay(VnpTxnRef: vnpTxnRef, selectedBankCode: bankCode)
                }
            }
            
            else {
                self.paymentFail = true
            }
        }
    }
    
    func requestCreatePaymentVnpay(VnpTxnRef: String, selectedBankCode: String) {
        
        // OTP register
        let data: [String: Any] = [
            "OrderInfo": "Thanh toan san pham/Khoa hoc",
            "VnpTxnRef": VnpTxnRef,
            "Type": 2, // mua hàng
            "bankCode": selectedBankCode ?? "" // đặt lịch
        ]
        
        service.postCreatePaymentVnPay(parameters: data).done { response in
            if response.message != "Success" {
                showAlert(text: "Có lỗi xảy ra, không thể tạo thanh toán")
            } else {
                //create payment VNPAY
                if let url = response.payload
                {
                    //                    if let selectedBankCode = self.selectedBankCode
                    //                    {
                    //                        self.urlAddress = url + "&vnp_BankCode=" + selectedBankCode
                    //                    } else
                    //                    {
                    //                        self.urlAddress = url
                    //                    }
                    self.urlAddress = url
                    self.isShowPaymentForm = true
                    self.isChooseBank = false
                }
            }
        }
        
    }
    
    func showAlert(text: String) {
        self.isErrorShow = true
        self.errorMessage = text
    }
    
}

struct ConfirmOrderView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmOrderView().environmentObject(MarketPlaceApiService()).environmentObject(UserApiService())
    }
}
