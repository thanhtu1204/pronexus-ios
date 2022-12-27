//
//  BankModalView.swift
//  ProNexus
//
//  Created by TUYEN on 11/28/21.
//

import SwiftUI

struct ListBankModalView: View {
    
    @EnvironmentObject var service: ProviderApiService
    @State var bankList: [ListBankModel] = []
    
    @State var loading = true
    @Binding var bankId: Int?
    @Binding var bankName: String
    @Binding var show: Bool
    
    var body: some View {
        
        VStack(spacing: 15, content: {
            
            HStack {
                Spacer()
                Button {
                    self.show.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill").resizable().frame(width: 20, height: 20).foregroundColor(.gray)
//                        .padding(.trailing, -10)
                }
            }
            
            ScrollView (showsIndicators: false) {
                if $loading.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                } else {
                    VStack(alignment: .leading) {
                        if let items = bankList {
                            ForEach(items) { item in
                                Button(action: {
                                    self.show.toggle()
                                    self.bankId = item.bankID
                                    self.bankName = item.name ?? ""
                                }, label: {
                                    Text("\(item.name ?? "")")
                                        .appFont(style: .body, color: Color(hex: "#999999"))
                                })
                                Divider()
                            }
                        }
                        else{
                            NoData()
                        }
                    }
                }
            }
            .frame(minWidth: 300,  maxWidth: screenWidth() - 74, maxHeight: 500)
        })
            .padding(20)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal,15)
            .frame(minWidth: 300,  maxWidth: screenWidth(), maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
        
            .onAppear() {
                self.loading = true
                _ = service.loadListBank().done { response in
                    if let data = response.payload {
                        self.bankList = data
                    }
                    self.loading = false
                }
            }
        
    }
    
    
}
