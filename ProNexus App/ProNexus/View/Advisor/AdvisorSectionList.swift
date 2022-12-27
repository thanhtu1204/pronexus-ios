//
//  AdvisorSectionList.swift
//  ProNexus
//
//  Created by Tú Dev app on 07/11/2021.
// TODO: Chua dung toi, co the bo qua, muc dich su dung cho search list

import SwiftUI

struct AdvisorSectionList :View{
    

    @Binding var results: [AdvisorModel]
    @Binding var advisorId: String

    //danh sách bài viết nổi bật
    var body: some View {
        Group
        {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 15){
                    if let results = results {
                        
                        ForEach(results) {item in
                            NavigationLink {
                                AdvisorDetailView(id: "\(item.id ?? 0)").navigationBarHidden(true).navigationBarBackButtonHidden(true)
                            } label: {
                                AdvisorItemRowView(item: item, advisorId: $advisorId)
                            }           
                        }
                    }
                    
                }
                .padding(.horizontal, 37)
                .padding(.top, 0)
                .padding(.bottom, 50)
            })
        }.padding(.leading, 0.0)
    }
}
