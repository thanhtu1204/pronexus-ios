//
//  AdvisorSectionListView.swift
//  ProNexus
//
//  Created by Tú Dev app on 05/11/2021.
//

import SwiftUI

struct AdvisorSectionListView: View {
    
    @State var type = 1 // 1 danh sach co van, 2 co van noi bat, 3 danh sách advisor đã kết nối
    @State var title = ""
    
    // khai bao service
    @EnvironmentObject var service: ProviderApiService
    @State var results: [AdvisorModel] = []
    @State var loading = true
    
    var body: some View {
        VStack{
            HStack{
                
                if type == 3 {
                    // link toi xem tat ca co van da ket noi
                    SectionTitleView(title: self.title, nextView:
                                        AdvisorConectedView().environmentObject(ProviderApiService())
                                        .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    ).padding(.leading, 27)
                    
                } else {
                    // link toi xem tat ca advisor
                    SectionTitleView(title: self.title, nextView:
                                        SearchAdvisorView().environmentObject(ProviderApiService())
                                        .environmentObject(ClassificationApiService())
                                        .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    ).padding(.leading, 27)
                }
                
                
            }.padding(.trailing, 37).padding(.leading, 10)
            
            if $loading.wrappedValue {
                SectionLoader().frame(width: screenWidth() - 74, height: 160, alignment: .center)
            } else
            {
                if let items = self.results {
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack {
                            ForEach(items) { item in
                                NavigationLink {
                                    AdvisorDetailView(id: "\(item.id ?? 0)").navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                } label: {
                                    Advisoritem(model: item).padding(.trailing, 5).padding(.vertical, 5)
                                }
                                
                            }
                        }.padding(.horizontal, 37)
                        
                    })
                }
                else
                {
                    NoData()
                }
            }
        }.onAppear {
            loadData()
        }
    }
    
    func loadData(type: String = ""){
        self.loading = true
        if self.type == 1 {
            // danh sach co van
            _ = service.loadListAdvisor(size: 10, type: type).done { ProviderListModel in
                if let items = ProviderListModel.results {
                    self.results = items
                }
                self.loading = false
            }
        }
        
        if self.type == 2 {
            // danh sach co van de xuat
            _ = service.loadListAdvisor(size: 10, type: type, isFeature: true).done { ProviderListModel in
                if let items = ProviderListModel.results {
                    self.results = items
                }
                self.loading = false
            }
        }
        
        if self.type == 3 {
            // danh sach co van de xuat
            _ = service.loadListProviderConected().done { ProviderListModel in
                if let items = ProviderListModel.results {
                    self.results = items
                }
                self.loading = false
            }
        }
    }
}

struct AdvisorSectionListView_Previews: PreviewProvider {
    static var previews: some View {
        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
    }
}
