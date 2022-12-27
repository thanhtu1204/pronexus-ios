//
//  RetirementPlanForm.swift
//  ProNexus
//
//  Created by TUYEN on 11/11/21.
//

import SwiftUI

struct RetirementPlanForm: View {
    
    @EnvironmentObject var service: UserApiService
    
    @State var data: RetiementPlan?
    @State var values: [BarChartData2] = []
    
    @State var isValidForm = false
    @State var annualIncome = ""
    @State var currentSavings = ""
    @State var desired = ""
    @State var currentAge = ""
    @State var retirementAge = ""
    @State var longevity = ""
    @State var beforeRetirement = ""
    @State var afterRetirement = ""
    @State private var checked = false
    @State var navToResponseTable = false
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        
        VStack () {
            Header(title: "Kế hoạch nghỉ hưu", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                Spacer()
            })
            
            ScrollView() {
                Text("Vui lòng nhập đủ các giá trị, hệ thống sẽ tính toán ra kết quả còn lại.")
                    .appFont(style: .body, size: 14, color: Color(hex: "#A4A4A4"))
                    .padding(.horizontal, 38)
                    .offset(y: 30)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 15) {
                    Group{
                        MyTextField(label: "Thu nhập hằng năm hiện tại", placeholder: "VNĐ", type: .money, value: $annualIncome.onUpdate(checkFormValid), required: true, isToolsForm: true, height: 35)
                        MyTextField(label: "Tiết kiệm hiện tại", placeholder: "VNĐ", type: .money,value: $currentSavings.onUpdate(checkFormValid), required: true, isToolsForm: true, height: 35)
                        MyTextField(label: "Thu nhập hàng năm mong muốn sau khi nghỉ hưu", placeholder: "VNĐ", type: .money,value: $desired.onUpdate(checkFormValid), required: true, isToolsForm: true, height: 35)
                        
                        HStack{
                            MyTextField(label: "Tuổi hiện tại", type: .number,value: $currentAge.onUpdate(checkFormValid), required: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Tuổi nghỉ hưu", type: .number,value: $retirementAge.onUpdate(checkFormValid), required: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Tuổi thọ", type: .number,value: $longevity.onUpdate(checkFormValid), required: true, isToolsForm: true, height: 35)
                        }
                        
                        HStack() {
                            Text("Lãi suất đầu tư dự kiến (năm)")
                                .appFont(style: .title1, size: 12, color: Color(hex: "#4D4D4D"))
                            Text("(")
                                .appFont(style: .title1, size: 12, color: Color(hex: "#A4A4A4"))
                            Text("*")
                                .appFont(style: .body, size: 12, color: Color(hex: "#FF0000")).padding(-8)
                            Text(")")
                                .appFont(style: .body, size: 12, color: Color(hex: "#A4A4A4")).padding(-8)
                        }
                        HStack{
                            MyTextField(label: "Trước nghỉ hưu", placeholder: "%", type: .number, value: $beforeRetirement.onUpdate(checkFormValid), isToolsForm: true, height: 35)
                            MyTextField(label: "Sau nghỉ hưu",  placeholder: "%", type: .number, value: $afterRetirement.onUpdate(checkFormValid), isToolsForm: true, height: 35)
                        }
                        
                    }
                    
                    
                }
                .padding(.all, 15)
                .frame(width: UIScreen.screenWidth - 76)
                .background(Color.white)
                .cornerRadius(15)
                .myShadow()
                .offset(y: 30)
                
                if $isValidForm.wrappedValue {
                    Button(action: {
                        onSubmit()
                    }, label: {
                        Text("Xem chi tiết").appFont(style: .body, color: .white)
                    })
                        .buttonStyle(BlueButton())
                        .padding(.top,50)
                } else
                {
                    Button(action: {
                        
                    }, label: {
                        Text("Xem chi tiết").appFont(style: .body, color: .white)
                    })
                        .buttonStyle(SilverButton())
                        .padding(.top,50)
                }
                
                NavigationLink (isActive: $navToResponseTable, destination: {
                    RetiremantPlan_TableAndChartView(model: data).environmentObject(MarketPlaceApiService())
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }, label: {
                    EmptyView()
                })
            }.padding(0)
        }
    }
    
    func checkFormValid() {
//        self.isValidForm = true //TODO:
        self.isValidForm = !self.annualIncome.isBlank
        && !self.currentSavings.isBlank
        && !self.desired.isBlank
        && !self.currentAge.isBlank
        && !self.retirementAge.isBlank
        && !self.longevity.isBlank
        && !self.beforeRetirement.isBlank
        && !self.afterRetirement.isBlank
    }
    
    func onSubmit() {
                
        //TODO:
        let data: [String: Any] = [
            "Income": annualIncome.numberValue,
            "Ns": currentAge.intValue,
            "Nr": retirementAge.intValue,
            "Nd": longevity.intValue,
            "R1": beforeRetirement.percentValue,
            "R2": afterRetirement.percentValue,
            "I": currentSavings.numberValue,
            "H": desired.numberValue

        ]
        
//        let data: [String: Any] = [
//            "Income": 300000000,
//            "H": 500000000,
//            "Nd": 85,
//            "R2": 0.06,
//            "R1": 0.1,
//            "Ns": 30,
//            "I": 100000000,
//            "Nr": 65
//
//        ]
        
        _ = service.postFormToGetRetirementPlan(parameters: data).done { response in
            if response.payload != nil {
                self.data = response.payload
            }
            if response.ok == true {
//                clearForm()
                self.navToResponseTable = true
            } else {
                AppUtils.showAlert(text: "Lỗi dữ liệu, vui lòng kiểm tra lại")
            }
        }
        
    }
    
    func clearForm () {
        self.annualIncome = ""
        self.currentSavings = ""
        self.desired = ""
        self.currentAge = ""
        self.retirementAge = ""
        self.longevity = ""
        self.beforeRetirement = ""
        self.afterRetirement = ""
    }
}

struct RetirementPlanForm_Previews: PreviewProvider {
    static var previews: some View {
        RetirementPlanForm().environmentObject(UserApiService())
    }
}
