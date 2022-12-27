//
//  ProductSectionView.swift
//  ProNexus
//
//  Created by Tú Dev app on 10/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductSectionView: View {
    
    
    @Binding var itemsProd: [ProductElement]
    @Binding var reloadData: Bool
    var type = 0
    
    var body: some View {
        VStack {
            if let items = itemsProd {
                if !items.isEmpty && items.count > 0 {
                    ScrollView(.vertical, showsIndicators: false, content: {
                        ForEach (items){ item in
                            VStack(){
                                //                        ProductItem(item: item).padding(.all,9)
                                NavigationLink {
                                    ProductDetailView(productId: item.productID ?? 0)
                                        .navigationBarHidden(true).navigationBarHidden(true).environmentObject(MarketPlaceApiService())
                                } label: {
                                    ProductItem(item: item, type: type, reloadData: $reloadData)
                                        .padding(.horizontal, 37)
                                        .padding(.bottom, 15)
                                }
                            }
                        }
                    })
                }
                else
                {
                    NoData()
                }
                
            }
        }
        
    }
}


struct ProductItem :View {
    
    var item: ProductElement?
    var type: Int
    
    @State var favorite = false
    @Binding var reloadData: Bool
    @ObservedObject var service = MarketPlaceApiService()
    
    var body: some View {
        if let item = item {
            HStack{
                VStack{
                    WebImage(url: URL(string: item.productImage())).resizable()
                        .scaledToFill()
                        .foregroundColor(.white)
                        .frame(width: 112)
                        .clipped()
                }.frame(width: 90)
                
                
                VStack (alignment: .leading, spacing: 12){
                    HStack (alignment: .center, spacing: 0.0) {
                        Text("\(item.productCategoryName ?? (item.organizationName ?? ""))").font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .foregroundColor(Color(hex: "#1D74FE"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "#1D74FE"), lineWidth: 1))
                        
                        Spacer()
                        HStack{
                            HStack{Image(systemName: "star.fill").resizable().frame(width: 8, height: 8).foregroundColor(Color(hex: "#FFC700"))
                                Text("\(item.rating ?? 0)").appFont(style: .body,weight: .bold, color: .black)}.frame(width:45,height: 25 )
                            
                        }
                        .background(Color("button"))
                        .cornerRadius(30)
                        .myShadow()
                        //                            .padding(18)
                    }
                    .padding(.horizontal, 17)
                    
                    Text("\(item.name ?? "")"[0..<60])
                        .appFont(style: .body)
                        .padding(.horizontal, 17)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(height: 50)
                    //                    Spacer()
                    HStack{
                        Text("\(item.price ?? 0) đ")
                            .appFont(style: .title1, weight: .bold, size: 12, color: Color(hex: "#4D4D4D"))
                        
                        Text("\(item.pricePercentDiscount ?? 0) %").font(.system(size: 12))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .foregroundColor(.white)
                            .background(Color(.red))
                            .cornerRadius(15)
                        
                        Spacer()
                        
                        HStack{
                            Button(action: {
                                if(self.favorite){
                                    self.favorite = false
                                    self.reloadData = true
                                    if let id = item.productID {
                                        _ = service.removeFavoriteProduct(id: String(id)).done({ _ in
                                            
                                        })
                                    }
                                }else{
                                    self.favorite = true
                                    if let id = item.productID {
                                        let data: [String: Any] = [
                                            "ProductId": id
                                        ]
                                        _ = service.addFavoriteProduct(parameters: data).done({ _ in
                                            
                                        })
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
                    }
                    .padding(.horizontal, 17)
                    
                }
                .padding(.vertical, 17)
                
                .onAppear() {
                    if type == 2 {
                        self.favorite = item.isFavorite
                    }
                    //check product is favorite
                    _ = service.checkProductFavorite(id: String(self.item?.productID ?? 0)).done { CommonResponseModel in
                        self.favorite = CommonResponseModel.ok
                    }
                }
            }
            .frame(height: 152)
            .background(Color.white)
            .cornerRadius(15)
            .myShadow()
        }
    }
    
    func addProductToCart() {
        let data: [String: Any] = [
            "productId": self.item?.productID ?? 0,
        ]
        _ = service.addToCart(parameters: data).done { response in
            if response.ok {
                if response.message == "Success" {
                    AppUtils.showAlert(text: "Sản phẩm đã được thêm vào giỏ hàng thành công")
                }
                if response.message == "Exist" {
                    AppUtils.showAlert(text: "Sản phẩm đã tồn tại trong giỏ. Vui lòng kiểm tra lại")
                }
                _ = service.loadCart().done({ _ in
                    
                })
            } else {
                AppUtils.showAlert(text: "Có lỗi xảy ra vui lòng kiểm tra dữ liệu")
                // show modal confirm
            }
        }
    }
}

struct CircleButtonProduct: View {
    
    var icon = "person.crop.circle"
    var color = Color("button")
    
    var body: some View {
        return VStack {
            Image(systemName: icon)
                .foregroundColor(color)
        }
        .frame(width: 25, height: 25)
        .background(Color("button"))
        .cornerRadius(30)
        .myShadow()
    }
}

struct ProductSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView().environmentObject(MarketPlaceApiService())
    }
}
