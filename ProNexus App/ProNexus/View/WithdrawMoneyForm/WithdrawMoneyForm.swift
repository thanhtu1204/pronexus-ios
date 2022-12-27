//
//  WithdrawMoneyForm.swift
//  ProNexus
//
//  Created by TUYEN on 11/25/21.
//

import SwiftUI

struct WithdrawMoneyForm: View {
    
    @State var loading = true
    @State var description = ""
    @State var amount = ""
    @State var bankAccount = ""
    @State var bankFullName = ""
    @State var bankName = ""
    @State var bankId: Int? // mã bank
    @State var showListBankModal = false
    @State var isRsSuccess = false
    @State var isShowAlert = false
    
    //    @State var amount: Double = 0
    
    //
    
    @State var resultsTotalIncom: TotalProviderIncome?
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var service: ProviderApiService

    var body: some View {
        VStack {
            VStack {
                // HEADER
                ZStack(alignment: .center) {
                    Header(title: "Rút tiền", contentView: {
                        ButtonIcon(name: "arrow.left", onTapButton: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        Spacer()
                    })
                }.background(
                    Image("bg_header")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth, height: 180)
                        .edgesIgnoringSafeArea(.top)
                )
            }
            
            ZStack (alignment: .top) {
                if $loading.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                } else
                {
                    if let item = resultsTotalIncom {
                        VStack (alignment: .center, spacing: 15){
                            Text("\(String(item.totalAmount)) VNĐ")
                                .font(Font.custom("AvertaStdCY-Bold", size: 28.0))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .multilineTextAlignment(.center)
                            Text("Số dư khả dụng").appFont(style: .title1)
                        }
                        
                        .frame(width: UIScreen.screenWidth - 74, height: 115)
                        .background(Color.white)
                        .cornerRadius(15)
                        .myShadow()
                    }
                    else{
                        NoData()
                    }
                }
                ScrollView (.vertical, showsIndicators: false) {
                    VStack (alignment: .leading, spacing: 30) {
                        VStack (alignment: .center, spacing: 15){
                            
                            VStack(alignment: .center) {
                                VStack(spacing: 15){
                                    Text("Nhập số tiền cần rút")
                                        .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D"))
                                    MyTextField(placeholder: "0", type: .number, value: $amount, required: true)
                                }.padding(.bottom, 20)
                                MyTextField(label: "Tên tài khoản thụ hưởng", placeholder: "Nhập tên có dấu", value: $bankFullName, required: true, isToolsForm: true, height: 35)
                                MyTextField(label: "Số tài khoản thụ hưởng", placeholder: "Nhập số tài khoản", type: .number, value: $bankAccount, required: true, isToolsForm: true, height: 35)
                                VStack (alignment: .leading) {
                                    MyTextField(label: "Tên ngân hàng thụ hưởng",placeholder: "Chọn ngân hàng", value: $bankName, required: false, readOnly: true, isToolsForm: true, height: 35)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.showListBankModal.toggle()
                                }
                            }
                            .padding(.horizontal, 37)
                            
                        }
                        .padding(.top, 25)
                        .frame(width: UIScreen.screenWidth - 74)
                        .background(Color.white)
                        .cornerRadius(15)
                        .myShadow()
                        
                        
                        Spacer()
                        VStack(alignment: .center) {
                            
                            Button(action: {
                                requestWithdrawMoney()
                            }, label: {
                                Text("Tiếp theo").appFont(style: .body, color: .white)
                            }).buttonStyle(BlueButton(w: UIScreen.screenWidth - 74))
                            
                            VStack (alignment: .center){
                                Text("Yêu cầu rút tiền sẽ được xử lý trong vòng 03 ngày làm việc. Trong trường hợp cần hỗ trợ, vui lòng liên hệ BP CSKH theo số Hotline")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 12))
                                    .foregroundColor( Color(hex: "#999999"))
                                + Text(" 1900 633019")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                            }
                            .padding(.horizontal, 37)
                            .padding(.vertical, 18)
                        }
                    }
                    
                }
                .padding(.top, 140)
                .frame(width: UIScreen.screenWidth - 74)
                .myShadow()
                
                if $showListBankModal.wrappedValue {
                    ListBankModalView(bankId: $bankId, bankName: $bankName, show: $showListBankModal ).environmentObject(ProviderApiService())
                }
                
                if $isShowAlert.wrappedValue {
                    CustomAlertView(title: "Thông báo", msg: "Bạn cần cập nhật thông tin tài khoản ngân hàng ở hồ sơ cá nhân trước", textButton1: "Đồng ý", onPressBtn1: {
                        self.isShowAlert = false
                        self.presentationMode.wrappedValue.dismiss()
                    }, show: $isShowAlert)
                }
            }
        }.onAppear{
            loadData()
        }
        
        if $isRsSuccess.wrappedValue
        {
            NavigationLink(isActive: $isRsSuccess) {
                RevenueView().environmentObject(ProviderApiService())
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            } label: {
                EmptyView()
            }
        }
    }
    
    func requestWithdrawMoney () {
        
        if(bankAccount.isBlank || bankName.isBlank) {
            self.isShowAlert = true
        } else {
            let floatFromString = Double(amount) ?? 0
            let balance = resultsTotalIncom?.totalAmount ?? 0
            
            if (floatFromString > balance) {
                AppUtils.showAlert(text: "Số tiền muốn rút không được lớn hơn số dư khả dụng")
            } else
            {
                let data: [String: Any] = [
                    "Description": description,
                    "Amount": amount,
                    "BankId": bankId,
                    "BankAccount": bankAccount,
                    "bankFullName": bankFullName
                ]
                
                _ = service.requestWithdrawMoney(parameters: data).done { response in
                    if response.ok == true {
                        AppUtils.showAlert(text: "Tạo thông tin rút tiền thành công")
                        onSuccess()
                    } else {
                        //                self.service.isShowModalConfirmCode = true
                        // show modal confirm
                        AppUtils.showAlert(text: "Tạo thông tin rút tiền thất bại")
                    }
                }
            }
        }
    }
    
    func onSuccess() {
        onClearField()
        self.isRsSuccess = true
    }

    func onClearField () {
        self.bankName = ""
        self.amount = ""
        self.bankAccount = ""
        self.bankFullName = ""
    }
    
    func loadData(){
        self.loading = true
        
        //get tổng doanh thu của advisor đang login
        _ = service.loadTotalProviderIncome().done { response in
            if let items = response.payload {
                self.resultsTotalIncom = items
            }
            self.loading = false
        }
        if isAdvisorRole() {
            _ = service.loadProfileAdvisor().done({ rs in
                self.bankId = rs.payload?.bankID ?? 0
                self.bankName = rs.payload?.bankName ?? ""
                self.bankAccount = rs.payload?.bankAccount ?? ""
            })
        }
    }
}

struct WithdrawMoneyForm_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawMoneyForm().environmentObject(ProviderApiService())
    }
}
