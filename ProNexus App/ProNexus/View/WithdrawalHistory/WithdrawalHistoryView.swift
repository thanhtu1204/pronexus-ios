//
//  WithdrawalHistoryView.swift
//  ProNexus
//
//  Created by IMAC on 11/1/21.
//

import Foundation

import Combine
import SwiftUI



struct WithdrawalHistoryView: View {
    
    @EnvironmentObject var service : ProviderApiService
    @Environment(\.presentationMode) private var presentationMode
    
    @State var expand = false
    @State var loading = true
    @State var typeFilter = ""
    @State var list: [WithdrawHistoryModel] = []
    
    
    var body: some View {
        
        
        ZStack(alignment: .top) {
            // HEADER
            
            VStack () {
                
                VStack () {
                    ZStack(alignment: .trailing) {
                        Header(title: "Lịch sử rút tiền", contentView: {
                            ButtonIcon(name: "arrow.left", onTapButton: {
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            Spacer()
                            Button {
                                self.expand.toggle()
                            } label: {
                                Image("ic_filter")
                            }
                            .frame(width: 16, height: 16)
                        }).offset(x: 0, y: -6)
                        
                        VStack {
                            if expand {
                                VStack(alignment: .center){
                                    Text("Tất cả").appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080"))
                                        .onTapGesture {
                                            self.expand.toggle()
                                            loadData(status: "")
                                        }
                                        .padding(.top, 5)
                                    
                                    Divider()
                                    
                                    Text("Đang chờ").appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080"))
                                        .onTapGesture {
                                            self.expand.toggle()
                                            loadData(status: "1")
                                        }
                                        .padding(.top, 5)
                                    
                                    Divider()
                                    
                                    Text("Đã duyệt")
                                        .padding(.bottom, 5)
                                        .appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080"))
                                        .onTapGesture {
                                            self.expand.toggle()
                                            loadData(status: "2")
                                        }
                                    
                                    Divider()
                                    
                                    Text("Đã huỷ")
                                        .padding(.bottom, 5)
                                        .appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080"))
                                        .onTapGesture {
                                            self.expand.toggle()
                                            loadData(status: "3")
                                        }
                                    
                                }
                                .padding(.horizontal, 4)
                                .background(Color.white)
                                .frame(width: 70, alignment: .center)
                                .cornerRadius(8)
                                .padding(.trailing, 37)
                                .myShadow()
                                
                            }
                        }
                        .offset(y: 70)
                        .frame(width: 70, height: 40, alignment: .trailing)
                        .zIndex(999)
                    }
                    
                }
                .zIndex(1)
                
                VStack {
                    if $loading.wrappedValue {
                        SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                    } else
                    {
                        if self.list.count > 0 {
                            ScrollView(.vertical) {
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(list) {item in
                                        RowView(item: item )
                                    }
                                }
                                .padding(.all, 30)   
                            }
                        }
                        else{
                            NoData()
                        }
                        
                    }
                }
                .padding(.top, 30)
                
                Spacer()
            }
            .onAppear {
                loadData(status: "")
            }
            
            //            Spacer()
        }
        
    }
    
    func loadData (status: String) {
        self.loading = true
        _ = service.loadListWithdrawHistory(status: status).done { rs in
            if let history = rs.payload {
                self.list = history
            }
            self.loading = false
        }
    }
}

struct WithdrawalHistoryView_Preview: PreviewProvider {
    static var previews: some View {
        WithdrawalHistoryView().environmentObject(ProviderApiService())
    }
}

