//
//  SavingsPlanForm.swift
//  ProNexus
//
//  Created by TUYEN on 12/6/21.
//

import SwiftUI

struct SavingsPlanForm: View {
    
    @State var income = ""
    @State var interest = ""
    @State var years = ""
    
    @State var isValidForm = false
    @State private var checked = false
    @State var navToResponseTable = false
    
    @State var data: SavingPlanResponseModel?
    @State var values: [BarChartData2] = []
    
    @EnvironmentObject var service: UserApiService
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        
        VStack () {
            Header(title: "Kế hoạch tiết kiệm", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                Spacer()
            })
            
            ScrollView() {
                Text("Vui lòng nhập đủ các giá trị, hệ thống sẽ tính toán ra kết quả còn lại.")
                    .appFont(style: .body, size: 14, color: Color(hex: "#A4A4A4"))
                    .padding(.horizontal, 38)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 15) {
                    Group{
                        VStack(alignment: .leading, spacing: 6, content: {
                            MyTextField(label: "Mục tiêu tiết kiệm", placeholder: "VNĐ",type: .money, value: $income.onUpdate {
                                checkFormValid()
                            }, required: true, isToolsForm: true, height: 35)
                        })
                        
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 6, content: {
                                MyTextField(label: "Lãi suất hàng năm", placeholder: "%", type: .decimal,value: $interest.onUpdate {
                                    checkFormValid()
                                }, required: true, isToolsForm: true,height: 35)
                            })
                            VStack(alignment: .leading, spacing: 6, content: {
                                MyTextField(label: "Thời gian tiết kiệm", placeholder: "năm",type: .number, value: $years.onUpdate {
                                    checkFormValid()
                                }, required: true, isToolsForm: true,height: 35)
                            })
                            
                        }
                    }
                    
                    
                }
                .padding(.all, 15)
                .frame(width: UIScreen.screenWidth - 76)
                .background(Color.white)
                .cornerRadius(15)
                .myShadow()
                
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
                    SavingsPlan_TableAndChartView(model: data).environmentObject(MarketPlaceApiService())
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }, label: {
                    EmptyView()
                })
            }.padding(0)
        }
    }
    
    
    func checkFormValid() {
        self.isValidForm = !self.income.isBlank
        && !self.interest.isBlank
        && !self.years.isBlank
    }
    
    
    func onSubmit() {
        let data: [String: Any] = [
            "Income": income.numberValue,
            "Interest": interest.percentValue,
            "Years": years.intValue
        ]
        _ = service.postFormToGetSavingPlan(parameters: data).done { response in
            if let rs = response.payload {
                self.data = response
                
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
        self.income = ""
        self.interest = ""
        self.years = ""
    }
}

struct SavingsPlanForm_Previews: PreviewProvider {
    static var previews: some View {
        SavingsPlanForm()
    }
}
