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
    @State var results: [ProductElement] = []
    @State var reloadData = false
    @State var loading = true
    
    @EnvironmentObject var service : MarketPlaceApiService
    
    var body: some View {
        VStack {
            HStack{
                
                if type == 1 {
                    SectionTitleView(title: self.title, nextView:
                                        ProductListView().environmentObject(MarketPlaceApiService())
                                        .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                     
                    ).padding(.leading, 27)
                } else {
                    SectionTitleView(title: self.title, nextView:
                                        FavoriteProductsView().environmentObject(MarketPlaceApiService())
                                        .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                     
                    ).padding(.leading, 27)
                }
                
            }.padding(.trailing, 37).padding(.leading, 10)
            
            if $loading.wrappedValue {
                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
            } else
            {
                
                if let items = results {
                    if items.count > 0 {
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            HStack(){
                                ForEach(items){item in
                                    NavigationLink {
                                        ProductDetailView(productId: item.productID ?? 0).navigationBarHidden(true).navigationBarHidden(true).environmentObject(MarketPlaceApiService())
                                    } label: {
                                        ProductItemMarket(type: type, item:item, reloadData: $reloadData).padding(.all, 4)
                                    }
                                }
                            }.padding(.leading, 33)
                            
                        })
                    } else{
                        NoData()
                    }
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
            _ = service.loadListProducts(buyCount:"DESC").done { ProductListModel in
                if let items = ProductListModel.payload {
                    self.results = items
                }
                self.loading = false
            }
        }
        
        
        if self.type == 2 {
            // yêu thích
            _ = service.loadFavoriteProducts().done { ProductListModel in
                if let items = ProductListModel.payload {
                    self.results = items
                }
                self.loading = false
            }
        }
        
        if self.type == 3 {
            // ưu đãi mới
            _ = service.loadListProducts(buyCount:"DESC", isPromote: true).done { ProductListModel in
                if let items = ProductListModel.payload {
                    self.results = items
                }
                self.loading = false
            }
        }
        
    }
    
    
}

struct ProductItemMarket :View{
    
    var type: Int
    
    var item: ProductElement
    @State var favorite = false
    @Binding var reloadData: Bool
    @ObservedObject var service = MarketPlaceApiService()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            VStack{
                ZStack(alignment: .top) {
                    VStack {
                        HStack{
                            HStack{
                                HStack{Image(systemName: "star.fill").resizable().frame(width: 8, height: 8).foregroundColor(Color(hex: "#FFC700"))
                                    Text(String(item.rating ?? 0) ).appFont(style: .body,weight: .bold, color: .black)}.frame(width:45,height: 25 )
                                
                            }.background(Color("button"))
                                .cornerRadius(30)
                                .myShadow()
                                .padding(18)
                            
                            Spacer()
                            
                            HStack{
                                Button(action: {
                                    if(self.favorite){
                                        self.favorite = false
                                        self.reloadData = true
                                        if let id = item.productID {
                                            _ = service.removeFavoriteProduct(id: String(id))
                                        }
                                    } else{
                                        self.favorite = true
                                        if let id = item.productID {
                                            let data: [String: Any] = [
                                                "ProductId": String(id)
                                            ]
                                            _ = service.addFavoriteProduct(parameters: data)
                                        }
                                    }
                                }) {
                                    
                                    VStack {
                                        Image(systemName: favorite ? "heart.fill" : "heart").resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color.gray)
                                            .frame(width:17, height: 15).padding(.leading,0)
                                            .foregroundColor(Color("button"))
                                    }
                                    .frame(width: 25, height: 25)
                                    .background(Color("button"))
                                    .cornerRadius(30)
                                    .myShadow()
                                    
                                }
                                
                                Button(action: { addProductToCart() }) {
                                    CircleButtonProduct(icon: "cart", color: Color(hex: "#808080"))
                                }
                            }
                            .padding(.trailing, 17)
                        }
                        Spacer()
                    }
                }.background(
                    WebImage(url: URL(string: item.productImage()))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 260, height: 131)
                        .clipped()
                )
            }.frame(width: 260, height: 131)
//            Spacer()
            VStack (alignment: .leading) {
                HStack (alignment: .center, spacing: 0.0) {
                    Text("\(item.productCategoryName ?? "")")
                        .appFont(style: .body, weight: .regular, size: 10, color: Color(hex: "#1D74FE"))
                        .padding(.horizontal, 10)
                        .foregroundColor(Color(hex: "#1D74FE"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#1D74FE"), lineWidth: 1))
                    Spacer()
                    HStack{
                        Text("\(item.price ?? 0) đ")
                            .appFont(style: .body, weight: .bold, size: 12, color: Color(hex: "#4D4D4D"))
                        
                        Text("- \(item.pricePercentDiscount ?? 0) %")
                            .appFont(style: .body, size: 12, color: .white)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color(.red))
                        .cornerRadius(12)}
                    
                    
                }.padding(.horizontal, 15.0)
                VStack(alignment: .leading, spacing: 8) {
                    //                if let des = item.title {
                    Text("\(item.name ?? "")"[0..<60]).appFont(style: .body, size: 12).multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    //                }
                }
                .padding(.horizontal, 15.0)
                .offset(x: 0, y: 14)
            }.offset(x: 0, y: 20)
            Spacer()
        }
        .frame(width: 260,height: 229)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
        .onAppear() {
            if type == 2 {
                self.favorite = item.isFavorite
            }
            //check product is favorite
            _ = service.checkProductFavorite(id: String(self.item.productID ?? 0)).done { CommonResponseModel in
                self.favorite = CommonResponseModel.ok
            }
        }
    }
    
    func addProductToCart() {
        let data: [String: Any] = [
            "productId": self.item.productID ?? 0,
        ]
        _ = service.addToCart(parameters: data).done { response in
            if response.ok {
                if response.message == "Success" {
                    AppUtils.showAlert(text: "Sản phẩm đã được thêm vào giỏ hàng thành công")
                }
                if response.message == "Exist" {
                    AppUtils.showAlert(text: "Sản phẩm đã tồn tại trong giỏ. Vui lòng kiểm tra lại")
                }
                _ = service.loadCart()
            } else {
                AppUtils.showAlert(text: "Có lỗi xảy ra vui lòng kiểm tra dữ liệu")
                // show modal confirm
            }
        }
    }
}

struct BuyAlotSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductItems().environmentObject(MarketPlaceApiService())
    }
}
