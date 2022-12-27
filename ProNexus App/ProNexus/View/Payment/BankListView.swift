//
//  BankListView.swift
//  ProNexus
//
//  Created by Tú Dev app on 07/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI

class SearchBankListViewModel: ObservableObject {
    @Published var text: String = ""
}


struct BankListView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var keyWord: String = "" //create State
    @EnvironmentObject var service: BankListApiService
    @Binding var selectedBankCode: String?
    @State var isNavigationView = false
    @State var bankList : [BankVnpayModel]?
    @ObservedObject var vm = SearchBankListViewModel()
    @State var showLoader = false
    
    var body: some View {
        ZStack {
            VStack {
                // HEADER
                Header(title: "Thẻ ATM Nội địa", contentView: {
                    ButtonIcon(name: "arrow.left", onTapButton: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    Spacer()
                })
                
                // input search
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray)
                            .frame(height: 18)

                        TextField("Tìm kiếm", text: $vm.text).appFont(style: .caption1, weight: .regular, size: 14)
                            .onReceive(
                                vm.$text
                                    .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                            ) {
    //                            guard !$0.isEmpty else { return }
                                print(">> searching for: \($0)")
                                searchBankList(key: $0)
                            }
                        
                        if self.vm.text.count > 0 {
                            Button {
                                self.vm.text = ""
                                loadData()
                            } label: {
                                Image(systemName: "xmark.circle.fill").resizable().frame(width: 16, height: 16).foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, -10)
                            }
                        }
                    }
                    .padding(10)
                    .padding(.horizontal, 27)
                    .frame(height: 49)
                    .background(Color.white)
                    .cornerRadius(30)
                    .myShadow()


                }.padding(.horizontal, 37)
                    .offset(x: 0, y: 0)
                    .zIndex(12)
                
                VStack {
                    Group{
                        if let items = self.bankList {
                            GridStack(minCellWidth: 100, spacing: 0, numItems: items.count) { index, cellWidth in
                                
                                if  let item = items[index]
                                {
                                    Button(action: {
                                        self.selectedBankCode = item.code
                                        self.service.selectedBankCode = item.code
                                        self.showLoader.toggle()
                                        if isNavigationView {
//                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }, label:{
                                        
                                        WebImage(url: URL(string:item.logo ?? ""))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 90, height: 90, alignment: .center)
                                        
                                    }).padding(0)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .myShadow()
                                        .padding(.bottom, 15)
                                }
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 37)
                .padding(.top, 30)
                .offset(x: 0, y: 0)
                
                Spacer()
            }
            
            if $showLoader.wrappedValue {
                Loader()
            }
            
        }.onAppear{
            loadData()
        }
    }
    
    func loadData()
    {
        self.showLoader = true
        service.loadBanks().done { rs in
            self.showLoader = false
            if let items = rs.data {
                self.bankList = items
            }
        }
    }
    
    func searchBankList(key: String?) {
        if !key.isBlank {
            self.bankList = self.bankList?.filter { $0.code!.range(of: key!, options: .caseInsensitive) != nil }
        } else
        {
            loadData()
        }
    }
}

struct BankListContentPreview: View {
    @State var selectedBankCode: String?
    var body: some View {
        BankListView(selectedBankCode: $selectedBankCode).environmentObject(BankListApiService())
    }
}

struct BankListView_Previews: PreviewProvider {
    static var previews: some View {
        BankListContentPreview()
    }
}
