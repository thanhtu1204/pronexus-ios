//
//  CouponsListView.swift
//  ProNexus
//
//  Created by Tú Dev app on 10/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI


// Tab Model...
struct TabCoupons: Identifiable {
    var id = UUID().uuidString
    var tab : String
}

// Tab Items...
var tabsItemsCoupons = [
    
    TabCoupons(id: "1", tab: "Từ Pronexus"),
    TabCoupons(id: "2", tab: "Từ đối tác"),
]

struct CouponsListView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var keyWord: String = "" //create State
    @State var selectedTab = "1"
    @State var expand = false
    
    var body: some View {
        VStack{
            
            Header(title: "Danh sách ưu đãi", contentView: {
                ButtonIcon(name: "xmark", onTapButton: {
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
                    
                    TextField("Gõ từ khoá bạn muốn tìm?", text: $keyWord).appFont(style: .caption1, weight: .regular, size: 14)
                }
                .padding(10)
                .padding(.horizontal, 27)
                .frame(height: 49)
                .background(Color.white)
                .cornerRadius(30)
                .myShadow()
                
                
            }.padding(.horizontal, 37)
                .offset(x: 0, y: 0)
                .zIndex(11)
            
            
            PromoteView(viewTitle:false).environmentObject(BannerService()).padding(.vertical,25)
            
            
            // menu tab
            ZStack(alignment: .topTrailing) {
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 15){
                        
                        ForEach(tabsItemsCoupons){tab in
                            
                            // Tab Button...
                            TabButton(title: tab.tab, id: tab.id, selectedTab: $selectedTab)
                        }
                        
                    }
                }
                VStack{
                    
                    HStack {
                        Text( "Khoá học").appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080")).frame(width: 80)
                        
                        Image( "arrowtriangle.down.fill").resizable().frame(width: 8, height: 6).foregroundColor(.gray)
                    }.onTapGesture{
                        self.expand.toggle()
                    }
                    //                                if expand {
                    //                                    ForEach(results) { item in
                    //                                        Text(item.name ?? "").appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080")).onTapGesture {
                    //                                              selectCatName = item.name ?? ""
                    //                                              self.expand.toggle()
                    //                                            if let catId = item.id
                    //                                            {
                    //                                                newsService.loadNewsByCatID(id: "\(catId)")
                    //                                            }
                    //                                        }.padding(.all, 5)
                    //                                    }
                    //                            }
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
                .padding(.bottom, 10)
            
            
            ScrollView (showsIndicators: false) {
                VStack{
                    Group{
                        
                        //banner
                        
                        //                    BannerSection()
                        
                        
                        
                        ScrollView(.vertical){
                            VStack{
                                CouponsItem()
                                CouponsItem()
                                CouponsItem()
                                
                            }
                        }
                        
                        Spacer()
                    }.padding(.bottom, 5)
                }
                
            }
            Spacer()
        }
    }
    
}


struct CouponsListView_Previews: PreviewProvider {
    static var previews: some View {
        CouponsListView().environmentObject(BannerService())
    }
}
