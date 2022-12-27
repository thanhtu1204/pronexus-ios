//
//  SubmitForm2View.swift
//  ProNexus
//
//  Created by Tú Dev app on 06/11/2021.
//

import SwiftUI

struct SubmitForm2View: View {
    @State var workUnit = ""
    @State var isChecked:Bool = false
    
    @EnvironmentObject var service : UserApiService
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var classificationModel: ClassificationApiService = ClassificationApiService()
    @State var classificationList: [ClassificationModel]?
    @State var selections: [Int] = []
    @State var isValidForm = false
    @State var loading = true
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Image("bg_login_regsiter").resizable().scaledToFill().offset(x: 0, y: -5).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                HeadingRegisterAdvisor(title: "Hoàn thiện hồ sơ 2/3") .padding(.top, 60)
                ScrollView(showsIndicators: false) {
                    VStack (alignment: .leading) {
                        VStack(alignment: .leading, spacing: 8, content: {
                            HStack{
                                Text("Lựa chọn chuyên môn")
                                    .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                                Text("(")
                                    .appFont(style: .title1, size: 16, color: Color(hex: "#A4A4A4"))
                                Text("*")
                                    .appFont(style: .body, size: 16, color: Color(hex: "#FF0000")).padding(-8)
                                Text(")")
                                    .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4")).padding(-8)
                            }
                        }).padding(.top, 20)
                        
                        if $loading.wrappedValue {
                            SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                        } else
                        {
                            
                            if let items = self.classificationList {
                                ScrollView(.vertical, showsIndicators: false, content: {
                                    VStack {
                                        ForEach(items) { item in
                                            CheckBoxRightView(item: item, selections: $selections.onUpdate(checkFormValid))
                                        }
                                    }
                                }).padding(.top, 10)
                            } else
                            {
                                NoData()
                            }
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            
                            MyTextField(label: "Đơn vị công tác", value: $service.dataRegisterAdvisor.company, required: false)
                            
                        }) .padding(.top,21)
                        
                        VStack(alignment: .leading, spacing: 0, content: {
                            MyTextField(label: "Năm kinh nghiệm", type: .number, value: $service.dataRegisterAdvisor.yearsExperience, required: false)
                            
                        }) .padding(.top,0)
                        
                        Spacer()
                        
                        
                        HStack (alignment: .center, spacing: 15) {
                            
                            Spacer()
                            
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Quay lại").appFont(style: .body, color: .white)
                            })
                                .buttonStyle(RoundedSilverButtonStyle())
                            
                            if $isValidForm.wrappedValue {
                                NavigationLink {
                                    SubmitForm3View()
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarHidden(true)
                                } label: {
                                    Text("Tiếp theo").appFont(style: .body, color: .white)
                                }.buttonStyle(GradientButtonStyle())
                            } else
                            {
                                Button(action: {
                                    
                                }, label: {
                                    Text("Tiếp theo").appFont(style: .body, color: .white)
                                }).buttonStyle(RoundedSilverButtonStyle())
                            }
                            
                            Spacer()
                        }.padding(.top, 30)
                        
                    }
                    .padding(.bottom, 30)
                    
                }
                .padding(.horizontal, 37)
            }
            
        }.padding(0)
            .onAppear {
                _ = classificationModel.loadClassificationList().done { rs in
                    if let items = rs.results {
                        self.classificationList = items
                    }
                    self.loading = false
                }
            }
    }
    
    func checkFormValid() {
        self.isValidForm = self.selections.count > 0
        if self.selections.count > 0 {
            self.service.dataRegisterAdvisor.classificationIDList = self.selections
        }
    }
    
}


struct SubmitForm2View_Previews: PreviewProvider {
    static var previews: some View {
        SubmitForm2View().environmentObject(UserApiService())
        
    }
}
