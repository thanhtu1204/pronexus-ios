//
//  ConsultingFieldSection.swift
//  ProNexus
//
//  Created by Tú Dev app on 04/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ConsultingFieldSection: View {
    
    @EnvironmentObject var service: ClassificationApiService
    @State var results: [ClassificationModel]?
    @State var loading = true
    
    init() {
        self.loading = true
    }
    
    var body: some View {
        VStack { // boc trong group thi se trinh bay duoc > 10 view
            
            HStack{
                SectionTitleView(title: "Lĩnh vực tư vấn", nextView:
                                    CategoriesSelectionListView().environmentObject(ClassificationApiService()).navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true))
            }.padding(.horizontal, 37).padding(.bottom, 0)
                        
            if $loading.wrappedValue {
                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
            } else
            {
                if let items = results {
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack {
                            ForEach(items) { item in
                                ConsultingFieldItem(item: item)
                                
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
            _ = service.loadClassificationList().done { ClassificationListModel in
                if let items = ClassificationListModel.results
                {
                    self.results = items
                }
                self.loading = false
            }
        }
    }
    
    
}

struct ConsultingFieldItem: View {
    let item: ClassificationModel
    var body: some View {
        
        VStack(spacing: 8) {
            WebImage(url: URL(string: item.iconUrl ?? "")).resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 31, height: 31)
                .padding(0)
            Text(item.name ?? "").appFont(style: .body, weight: .regular, size: 12, color: .white)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        //            .padding(.bottom, 0)
        .background(
            WebImage(url: URL(string: item.backgroundUrl ?? "")).resizable()
        )
        // shadows..
        .cornerRadius(15)
        .frame(width: 82, height: 82)
    }
}


struct ConsultingFieldSection_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserApiService()).environmentObject(ProviderApiService())
    }
}
