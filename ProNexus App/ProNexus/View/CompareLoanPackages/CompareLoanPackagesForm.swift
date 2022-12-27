//
//  CompareLoanPackagesForm.swift
//  ProNexus
//
//  Created by TUYEN on 12/8/21.
//

import SwiftUI

struct CompareLoanPackagesForm: View {

    @State var pack1: [Pack1]
    @State var pack2: [Pack2]
    @State var pack3: [Pack3]
    @State private var selection: Set<Pack1> = []
    @State private var selection2: Set<Pack2> = []
    @State private var selection3: Set<Pack3> = []
    
    @State var loan1: [Loan] = []
    @State var loan2: [Loan] = []
    @State var loan3: [Loan] = []
    
    @State var amountLoan = ""
    @State var months = ""
    @State var realInterest = ""
    @State var nominalInterest = ""
    @State private var checked = false
    @State var isValidForm = false
    @State var navToResponseTable = false
    @State var model: LoanPackage?
    
    @EnvironmentObject var service: UserApiService
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack () {
            Header(title: "So sánh gói vay tiêu dùng", contentView: {
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
                            MyTextField(label: "Số tiền vay", placeholder: "VNĐ", type: .money, value: $amountLoan.onUpdate {
                                checkFormValid()
                            }, required: true, isToolsForm: true , height: 35)
                            MyTextField(label: "Kỳ hạn vay", placeholder: "tháng", type: .number ,value: $months.onUpdate {
                                checkFormValid()
                            }, required: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Lãi suất vay/năm - Lãi suất trên dư nợ thực tế", placeholder: "%", type: .decimal, value: $realInterest.onUpdate {
                                checkFormValid()
                            }, required: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Lãi suất vay/năm - Lãi suất danh nghĩa (quy đổi)", placeholder: "%", type: .decimal, value: $nominalInterest.onUpdate {
                                checkFormValid()
                            }, required: true, isToolsForm: true, height: 35)
                        })
                    }
                    
                    
                }
                .padding(.all, 15)
                .frame(width: UIScreen.screenWidth - 76)
                .background(Color.white)
                .cornerRadius(15)
                .myShadow()
                
                
                
                VStack(alignment: .leading, spacing: 25) {
                    package1
                    package2
                    package3
                }
                .padding(.horizontal, 37)
                .padding(.bottom, 25)
                
                
                if $isValidForm.wrappedValue {
                    Button(action: {
                        onSubmit()
                    }, label: {
                        Text("Xem chi tiết").appFont(style: .body, color: .white)
                    })
                        .buttonStyle(BlueButton())
                        .padding(.top,30)
                } else
                {
                    Button(action: {
                        
                    }, label: {
                        Text("Xem chi tiết").appFont(style: .body, color: .white)
                    })
                        .buttonStyle(SilverButton())
                        .padding(.top,30)
                }

                NavigationLink (isActive: $navToResponseTable, destination: {
                    LoanPackageTable(loan1: loan1, loan2: loan2, loan3: loan3, model: model).environmentObject(UserApiService())
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }, label: {
                    EmptyView()
                })
            }.padding(0)
        }.onAppear() {
            self.pack1 = Pack1.samples()
            self.pack2 = Pack2.samples()
            self.pack3 = Pack3.samples()
        }
        
    }
    
    var package1: some View {
        VStack {
            ForEach(pack1) { place in
                Package1(place: place, isExpanded: self.selection.contains(place))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect(place) }
//                    .animation(.linear(duration: 0.3))
            }
        }
        .frame(width: UIScreen.screenWidth - 76)
        .background(Color.white)
        .cornerRadius(25)
        .myShadow()
        .offset(y: 30)
    }
    
    var package2: some View {
        VStack {
            ForEach(pack2) { item in
                Package2(item: item, isExpanded: self.selection2.contains(item))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect2(item) }
//                    .animation(.linear(duration: 0.3))
            }
        }
        .frame(width: UIScreen.screenWidth - 76)
        .background(Color.white)
        .cornerRadius(25)
        .myShadow()
        .offset(y: 30)
    }
    
    var package3: some View {
        VStack {
            ForEach(pack3) { item in
                Package3(item: item, isExpanded: self.selection3.contains(item))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect3(item) }
//                    .animation(.linear(duration: 0.3))
            }
        }
        .frame(width: UIScreen.screenWidth - 76)
        .background(Color.white)
        .cornerRadius(25)
        .myShadow()
        .offset(y: 30)
    }
    
    private func selectDeselect(_ place: Pack1) {
        if selection.contains(place) {
            selection.remove(place)
        } else {
            selection.insert(place)
        }
    }
    
    private func selectDeselect2(_ item: Pack2) {
        if selection2.contains(item) {
            selection2.remove(item)
        } else {
            selection2.insert(item)
        }
    }
    
    private func selectDeselect3(_ item: Pack3) {
        if selection3.contains(item) {
            selection3.remove(item)
        } else {
            selection3.insert(item)
        }
    }
    
    func checkFormValid() {
        self.isValidForm = !self.amountLoan.isBlank
        && !self.months.isBlank
        && !self.realInterest.isBlank
        && !self.nominalInterest.isBlank
    }
    
    func onSubmit() {

        let data: [String: Any] = [
            "AmountLoan": amountLoan.numberValue,
            "Months": months.intValue,
            "RealInterest": realInterest.percentValue,
            "NominalInterest": nominalInterest.percentValue
        ]
        _ = service.postFormToGetLoanPackage(parameters: data).done { response in
            if let rs = response.payload {
                self.model = response.payload
                if rs.loan1?.count ?? 0 > 0 {
                    self.loan1 = rs.loan1 ?? []
                    self.loan2 = rs.loan2 ?? []
                    self.loan3 = rs.loan3 ?? []
                }
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
        self.amountLoan = ""
        self.months = ""
        self.realInterest = ""
        self.nominalInterest = ""
    }
}

struct CompareLoanPackagesForm_Previews: PreviewProvider {
    static var previews: some View {
        CompareLoanPackagesForm(pack1: Pack1.samples(), pack2: Pack2.samples(), pack3: Pack3.samples())
    }
}
