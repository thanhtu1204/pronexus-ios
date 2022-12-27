//
//  NewsHomeView.swift
//  ProNexus
//
//  Created by thanh cto on 01/11/2021.
//

import SwiftUI

// Tab Model...
struct Tab: Identifiable {
    var id = UUID().uuidString
    var tab : String
}

// Tab Items...
var tabsItems = [

    Tab(id: "1", tab: "Bài mới"),
    Tab(id: "2", tab: "Cố vấn viết"),
]


struct NewsHomeView: View {
    
    
    @State var selectedTab = "1"
    @State var keyWord: String = "" //create State
    @State var selectCatId = ""
    @State var selectCatName = ""
    @State var navToDetail = false
    @State var slug = ""
    @State var expand = false
    
    @EnvironmentObject var newsService: NewsApiService
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        
        NavigationView {
        
            VStack {
                VStack {
                    VStack {
                        HeaderView(onTapButtonLeft: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, titleHeader: "Danh sách bài viết") {
                            
                        }.padding(.horizontal, 22)
                        
                        // end header
                        
                        // input search
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.gray)
                                    .frame(height: 18)
                                
                                TextField("Gõ từ khoá bạn muốn tìm", text: $keyWord).appFont(style: .caption1, weight: .regular, size: 14)
                            }
                            .padding(10)
                            .padding(.horizontal, 27)
                            .frame(height: 49)
                            .background(Color.white)
                            .cornerRadius(30)
                            .myShadow()
                            
                            
                        }.padding(.horizontal, 37)
                        .offset(x: 0, y: -5)
                        .zIndex(12)
                        
                    }.padding(.bottom, 5)
                    
                    ScrollView {
                        HStack{
                            
                            Text("Bài viết nổi bật").appFont(style: .title1, weight: .bold)
                            
                            Spacer()
                            
                            Button(action: {}, label: {
                                
                                HStack(spacing: 6){
                                    
                                    Text("Xem tất cả").appFont(style: .caption2).onTapGesture {
                                        
                                    }
                                }
                            })
                        }
                        .padding(.horizontal, 37)
                        .padding(.top , 25)
                        
                        //danh sách bài viết nổi bật
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            HStack(spacing: 15){
                                if let results = newsService.newsListFeature.data {
                                    
                                    ForEach(results) {item in
                                        
                                        NewsItemRowView(item: item).onTapGesture {
                                            self.slug = item.slug ?? ""
                                            self.navToDetail = true
                                        }                                       
                                        
                                    }
                                }
                            }
                            .padding(.horizontal, 26)
                            .padding(.leading,10)
                            .padding(.top, 0)
                            .padding(.bottom,10)
                        })
                        
                        // menu tab
                        ZStack(alignment: .topTrailing) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 15){
                                    
                                    ForEach(tabsItems){tab in
                                        
                                        // Tab Button...
                                        TabButton(title: tab.tab, id: tab.id, selectedTab: $selectedTab)
                                    }
                                }
                                
                            }
       
                            //content tab 1
                            
                            VStack(spacing: 15){
                                if selectedTab == "1" {
                                    if let results = newsService.newsList.data {
                                        
                                        ForEach(results) {item in
                                            NewsItemCardView(item: item).onTapGesture {
                                                self.slug = item.slug ?? ""
                                                self.navToDetail = true
                                            }
                                        }
                                    } else
                                    {
                                        NoData()
                                    }
                                }
                                if selectedTab == "2" {
                                    if let results = newsService.newsListAdvisor.data {
                                        
                                        ForEach(results) {item in
                                            NewsItemCardView(item: item).onTapGesture {
                                                self.slug = item.slug ?? ""
                                                self.navToDetail = true
                                            }
                                        }
                                    } else
                                    {
                                        NoData()
                                    }
                                }
                                
                            }.offset(x: 0, y: 60)
                            
                            //end content tab 1
                            
                            
                            VStack{
                                if let results = newsService.newsCategories.data {
                                    HStack {
                                        Text(selectCatName == "" ? "Danh mục" : selectCatName).appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080")).frame(width: 80)
                                        
                                        Image(systemName: expand ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill").resizable().frame(width: 8, height: 6).foregroundColor(.gray)
                                    }.onTapGesture{
                                        self.expand.toggle()
                                    }
                                    if expand {
                                        ForEach(results) { item in
                                            Text(item.name ?? "").appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080")).onTapGesture {
                                                  selectCatName = item.name ?? ""
                                                  self.expand.toggle()
                                                if let catId = item.id
                                                {
                                                    newsService.loadNewsByCatID(id: "\(catId)")
                                                }
                                            }.padding(.all, 5)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .cornerRadius(15)
                            .myShadow()
    //                        .animation(.spring())
                            .alignmentGuide(VerticalAlignment.firstTextBaseline) { $0[.top] }    // << here !!
                            
                            
                        }.offset(y: 10)
                            .padding(.horizontal, 37)
                            .padding(.top, 0)
                            .padding(.bottom, 90)
                        
                        
                    }
                    .offset(x: 0, y: -15)
                    
                   
                    
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .padding(0.0)
                
                NavigationLink(isActive: $navToDetail, destination: {
                    NewsDetailView(slug: self.slug).environmentObject(NewsApiService())
                }) {
                   EmptyView()
                }
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.leading, 0.0).onAppear {
                newsService.loadNewsByCatID(id: "")
                newsService.loadNewsFeature() // call api load tin noi bat
                newsService.loadNewsAdvisor() // call api load tin cua advisor
                newsService.loadCategories() // call api load danh muc tin tuc
            }
        }
    }
}



struct NewsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewsHomeView().environmentObject(NewsApiService())
    }
}
