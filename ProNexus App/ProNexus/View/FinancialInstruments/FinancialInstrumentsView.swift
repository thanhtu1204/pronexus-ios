//
//  FinancialInstrumentsView.swift
//  ProNexus
//
//  Created by TUYEN on 11/10/21.
//

import SwiftUI

struct FinancialInstrumentsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView() {
            ZStack (alignment: .top) {
                VStack {
                    ZStack(alignment: .center) {
                        Header(title: "Công cụ tài chính", contentView: {
                            ButtonIcon(name: "arrow.left", onTapButton: {
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            Spacer()
                        })
                    }
                }
                .zIndex(99)
                
                ScrollView() {
                    VStack() {
                        NavigationLink("", tag: "tietkiem", selection: $selection) {
                            SavingsPlanView().environmentObject(ProviderApiService())
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                        }
                        NavigationLink("", tag: "nghihuu", selection: $selection) {
                            RetirementPlanView().environmentObject(ProviderApiService())
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                        }
                        NavigationLink("", tag: "sosanhgoivay", selection: $selection) {
                            CompareLoanPackagesView().environmentObject(ProviderApiService())
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                        }
                        NavigationLink("", tag: "thuenha", selection: $selection) {
                            BuyRentHouseView().environmentObject(ProviderApiService())
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                        }
                        NavigationLink("", tag: "muasam", selection: $selection) {
                            ShoppingPlanView().environmentObject(ProviderApiService())
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                        }
                        
                        ForEach(listData) {item in
                            Button(action: {
                                selection = item.screenName
                            }, label:{
                                HStack (alignment: .center, spacing: 12) {
                                    Image(item.icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 55, height: 55)
                                    
                                    VStack (alignment: .leading, spacing: 5) {
                                        HStack() {
                                            Text(item.title)
                                                .appFont(style: .title1, size: 14, color: Color(hex: "#4D4D4D"))
                                                .multilineTextAlignment(.leading)
                                            Image("icon_info")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 12, height: 12)
                                        }
                                        Text(item.subTitle)
                                            .appFont(style: .title1, weight: .light, size: 12)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    Spacer()
                                    
                                    Image("ic_chevron_right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 6, height: 12)
                                }
                                
                            })
                                .padding(.all, 15)
                                .frame(width: UIScreen.screenWidth - 76)
                                .background(Color.white)
                                .cornerRadius(15)
                                .myShadow()
                                .padding(.horizontal, 2)
                                .offset(y: 30)
                            
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationBarHidden(true).navigationBarBackButtonHidden(true)
        }
    }
}

struct FinancialInstrumentsView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialInstrumentsView()
    }
}
