//
//  ProductItems.swift
//  ProNexus
//
//  Created by Tú Dev app on 09/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductItems: View {
    @State var type = 1 // mua nhiều
    @State var title = ""
    
    @State var loading = true
    @EnvironmentObject var service : MarketPlaceApiService
    var body: some View {
        VStack { // boc trong group thi se trinh bay duoc > 10 view
            HStack{
                SectionTitleView(title: self.title, nextView: SearchAdvisorView().environmentObject(ProviderApiService())
                                    .environmentObject(ClassificationApiService())
                                    .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                 
                ).padding(.leading, 27)
            }.padding(.trailing, 37).padding(.leading, 10)
            
            if $loading.wrappedValue {
                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
            } else
            {
                
                if let items = service.productList.payload {
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack(){
                            ForEach(items){item in
                                NavigationLink {
                                    ProductDetailView(productId: 115).navigationBarHidden(true).navigationBarHidden(true).environmentObject(MarketPlaceApiService())
                                } label: {
                                    ProductItemMarket(item:item).padding(.all,9)
                                }
                            }
                        }
                        
                    })
                }
                else{
                    NoData()
                }
            }
        }.onAppear{
            loadData()
        }
    }
    
    func loadData(){
        self.loading = true
        if self.type == 1 {
            // mua nhieu
            service.loadListProducts(buyCount:"DESC").done { ProductListModel in
                self.loading = false
            }
        }
        
        //        if self.type == 2 {
        //            // danh sach co van de xuat
        //            service.loadListAdvisor(type: type, isFeature: true).done { ProviderListModel in
        //                if let items = ProviderListModel.results {
        //                    self.results = items
        //                }
        //                self.loading = false
        //            }
        //        }
        
    }
    
    
}

struct ProductItemMarket :View{
    var item: ProductElement
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            VStack{
                ZStack(alignment: .center) {
                    HStack{
                        HStack{
                            HStack{Image(systemName: "star.fill").resizable().frame(width: 8, height: 8).foregroundColor(Color(hex: "#FFC700"))
                                Text(String(item.rating ?? 0) ).appFont(style: .body,weight: .bold, color: .black)}.frame(width:45,height: 25 )
                            
                        }.background(Color("button"))
                            .cornerRadius(30)
                            .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 5)
                            .padding(18)
                        
                        
                        Spacer()
                        Button(action: {  }) {
                            CircleButton(icon: "heart", color: Color(hex: "#808080"))
                            //                            .sheet(isPresented: self.$showUpdate) {
                            //                                //                      UpdateList()
                            //
                            //                            }
                        }
                        
                        Button(action: {  }) {
                            CircleButton(icon: "cart", color: Color(hex: "#808080"))
                            //                            .sheet(isPresented: self.$showUpdate) {
                            //                                //                      UpdateList()
                            //
                            //                            }
                        }.padding(.trailing,10)
                    }
                    
                    
                }.background(
                    WebImage(url: URL(string: item.mediaURL ?? ""))
                        .resizable()
                        .frame(width:UIScreen.screenWidth, height: 180)
                        .scaledToFit()
                )
            }
            Spacer()
            VStack{
                HStack (alignment: .center, spacing: 0.0) {
                    Text("Đầu tư").font(.system(size: 12))
                        .padding(.horizontal, 10)
                        .foregroundColor(Color(hex: "#1D74FE"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#1D74FE"), lineWidth: 1))
                    Spacer()
                    HStack{
                        Text("275.000 d").font(.system(size: 16))
                            .appFont(style: .title1, weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                        
                        Text("-45%").font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color(.red))
                        .cornerRadius(12)}
                    
                    
                }.padding(.horizontal, 15.0)
                VStack(alignment: .leading, spacing: 8) {
                    //                if let des = item.title {
                    Text("Khoá học bảo hiểm nhân thọ từA - Z cho người mới bắt đầu Khoá học bảo hiểm nhân thọ từA - Z cho người mới bắt đầu Khoá học bảo hiểm nhân thọ từA - Z cho người mới bắt đầu").appFont(style: .body, size: 12).lineLimit(2)
                    //                }
                }
                .padding(.horizontal, 15.0)
                .offset(x: 0, y: 14)
            }.offset(x: 0, y: 20)
            Spacer()
        }
        .frame(width: screenWidth() / 1.5,height: 227)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
    }
}

struct BuyAlotSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BuyAlotSectionView()
    }
}
