//
//  ExpertiseArticleSectionList.swift
//  ProNexus
//
//  Created by Tú Dev app on 05/11/2021.
//
import SwiftUI

struct ExpertiseArticleSectionList :View{
    
    var title : String = "Kiến thức"
    @EnvironmentObject var serivce: NewsApiService
    
    
    //danh sách bài viết nổi bật
    var body: some View {
        VStack
        {
            SectionTitleView(title: title, nextView: NewsHomeView().environmentObject(NewsApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true))
                .padding(.horizontal, 37)
            
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack(spacing: 15){
                    if let results = serivce.expertiseArticleList.data {
                        ForEach(results) {item in
                            NavigationLink(destination: {
                                NewsDetailView(slug: item.slug ?? "").environmentObject(NewsApiService())
                            }) {
//                                ExpertiseArticleItemRowView(item: item)
                                NewsItemRowView(item: item)
                            }
                        }
                    } else {
                        NoData()
                    }
                }
                .padding(.leading, 37)
                .padding(.top, 5)
                .padding(.bottom,10)
            })
        }.onAppear {
            serivce.loadExpertiseArticleList()
            
        }
    }
}

struct ExpertiseArticleSectionList_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserApiService()).environmentObject(ProviderApiService())
    }
}
