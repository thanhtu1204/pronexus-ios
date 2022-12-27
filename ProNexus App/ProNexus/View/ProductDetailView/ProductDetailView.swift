//
//  ProductDetailView.swift
//  ProNexus
//
//  Created by Tú Dev app on 10/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftyUserDefaults

struct ProductDetailView: View {
    
    @State var message = ""
    @State var isShowAlertError = false
    @State var isShowAlertSuccess = false
    
    
    @State var favorite = false
    @State var itemProduct: ProductDetailModel?
    @EnvironmentObject var service: MarketPlaceApiService
    
    @Environment(\.isPreview) var isPreview
    @Environment(\.presentationMode) private var presentationMode
    @State var loading = true
    @State var navToCart = false
    
    var productId: Int
    
    var body: some View {
        ZStack (alignment: .top) {
            VStack {
                Header(title: "Chi tiết sản phẩm", contentView: {
                    ButtonIcon(name: "arrow.left", onTapButton: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    Spacer()
                    NavigationLink {
                        CartItemView(itemIdSelected: 0).environmentObject(MarketPlaceApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    } label: {
                        if Defaults.cartCount != 0 {
                            Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
                                .overlay(
                                    Text("\(Defaults.cartCount)").appFont(style: .body, size: 10, color: .white).frame(width: 15, height: 15, alignment: .center).background(Color.red).cornerRadius(50).offset(x: 10, y: -5)
                                )
                        } else {
                            Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
                        }

                    }
                    
                })
            }.zIndex(99999)
            
            VStack () {
                ContainerView (loading: $loading) {
                    
                    if let itemProduct = itemProduct {
                        ScrollView (showsIndicators: false) {
                            VStack {
                                HStack{
                                    VStack{
                                        WebImage(url: URL(string: itemProduct.productImage())).resizable()
                                            .scaledToFill()
                                            .foregroundColor(.white)
                                            .frame(width: screenWidth(),height: 215)
                                            .padding(.trailing,0)
                                    }
                                }.padding(.top)
                                HStack{
                                    VStack (alignment: .leading){
                                        HStack (alignment: .center, spacing: 0.0) {
                                            HStack{
                                                Text("\(itemProduct.productCategoryName ?? (itemProduct.organizationName ?? ""))").font(.system(size: 12))
                                                    .padding(.horizontal, 10)
                                                    .foregroundColor(Color(hex: "#1D74FE"))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(Color(hex: "#1D74FE"), lineWidth: 1))
                                            }.padding(0)
                                            Spacer()
                                            HStack{
                                                Button(action: {
                                                    if(self.favorite){
                                                        self.favorite = false
                                                        if let id = itemProduct.productID {
                                                            _ = service.removeFavoriteProduct(id: String(id))
                                                        }
                                                    }else{
                                                        self.favorite = true
                                                        if let id = itemProduct.productID {
                                                            let data: [String: Any] = [
                                                                "ProductId": id
                                                            ]
                                                            _ = service.addFavoriteProduct(parameters: data)
                                                        }
                                                    } }) {
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
                                            }.padding(.trailing,10)
                                        }.padding(.top,10)
                                        
                                        VStack (alignment: .leading, spacing: 0.0){
                                            Text((itemProduct.name ?? "")).appFont(style: .body,weight: .bold, size: 12).lineLimit(2).frame(alignment: .leading)
                                            
                                        }
                                        
                                        
                                        HStack{
                                            Text(itemProduct.priceNew()).font(.system(size: 16))
                                                .appFont(style: .title1, weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                                            
                                            Text(itemProduct.priceOld()).font(.system(size: 12))
                                                .appFont(style: .title1, size: 16, color: Color(hex: "#4D4D4D"))
                                            
                                            Text("-\(itemProduct.pricePercentDiscount ?? 0)%").font(.system(size: 12))
                                                .padding(.trailing, 10)
                                                .foregroundColor(.white)
                                                .background(Color(.red))
                                                .cornerRadius(12)
                                            
                                            Spacer()
                                        }.padding(.top,8)
                                        
                                        Divider()
                                        
                                        Group {
                                            HStack{
                                                VStack {
                                                    Image(systemName: "eye")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .foregroundColor(Color(hex: "#4C99F8"))
                                                        .frame(width: 8, height: 8)
                                                }
                                                .frame(width: 25, height: 25)
                                                .background(Color(hex: "#E3F2FF"))
                                                .cornerRadius(30)
                                                .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 5)
                                                VStack{
                                                    Text("\(itemProduct.viewCount ?? 0) đã xem").appFont(style: .body, size: 12, color: Color(hex: "#808080"))
                                                }.padding(.trailing,10)
                                                
                                                HStack{
                                                    VStack {
                                                        Image(systemName: "cart")
                                                            .resizable()
                                                            .scaledToFill()
                                                            .foregroundColor(Color(hex: "#4C99F8"))
                                                            .frame(width: 8, height: 8)
                                                    }
                                                    .frame(width: 25, height: 25)
                                                    .background(Color(hex: "#E3F2FF"))
                                                    .cornerRadius(30)
                                                    .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 5)
                                                    VStack{
                                                        Text("\(itemProduct.buyCount ?? 0) Người mua")
                                                            .appFont(style: .body, size: 12, color: Color(hex: "#808080"))
                                                    }
                                                }
                                                
                                                HStack{
                                                    HStack{Image(systemName: "star.fill").resizable().frame(width: 8, height: 8).foregroundColor(Color(hex: "#FFC700"))
                                                        Text(String(itemProduct.rating ?? 0)).appFont(style: .body,weight: .bold, color: .black)}.frame(width:45,height: 25 )
                                                    
                                                }.background(Color("button"))
                                                    .cornerRadius(30)
                                                    .myShadow()
                                            }.padding(.top,12)
                                        }
                                    }
                                }.padding(.horizontal,20)
                                    .padding(.bottom,16)
                                    .frame(width: screenWidth()-37,height: 185)
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .myShadow().padding(.top,-25)
                                
                                ProductDescriptionView(itemProduct: itemProduct)
                                
                                HStack{
                                    Button(action: {addProductToCart()}, label: {
                                        Text("Thêm vào giỏ").appFont(style: .body, color: Color(hex: "#4C99F8"))
                                    })
                                        .buttonStyle(BlueButtonBorder(w: halfWidth() - 30))
                                    Spacer()
                                    Button(action: {
                                        onBuyNow()
                                    }, label: {
                                        Text("Mua ngay").appFont(style: .body, color: .white)
                                    })
                                        .buttonStyle(BlueButton(w: halfWidth() - 30))
                                }.padding(.top, 20).frame(width: containerWidth())
                                
                                Spacer()
                                
                                NavigationLink (isActive: $navToCart, destination: {
                                    CartItemView(itemIdSelected: 0).environmentObject(MarketPlaceApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                }, label: {
                                    EmptyView()
                                })
                            }.padding(.bottom, 5)
                            
                        }.navigationBarHidden(true).navigationBarHidden(true)
                        
                    }
                }
                
                Spacer()
                
            }.onAppear () {
                self.favorite = itemProduct?.isFavorite ?? false
                loadData()
                
            }.padding(.bottom, 30)
                .edgesIgnoringSafeArea(.bottom)
            
            
            if $isShowAlertError.wrappedValue {
                
                AlertView(msg: message, show: $isShowAlertError)
            }
            
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    
    func loadData(){
        _ = service.loadProductDetail(id: isPreview ? "115" : "\(productId)").done { rs in
            if let item  = rs.payload {
                self.itemProduct = item
            }
            self.loading = false
        }
    }
    
    func addProductToCart() {
        let data: [String: Any] = [
            "productId": String(self.itemProduct?.productID ?? 0),
        ]
        _ = service.addToCart(parameters: data).done { response in
            if response.ok {
                if response.message == "Success" {
                    showAlert(text: "Sản phẩm đã được thêm vào giỏ hàng thành công")
                }
                if response.message == "Exist" {
                    showAlert(text: "Sản phẩm đã tồn tại trong giỏ. Vui lòng kiểm tra lại")
                }
                _ = service.loadCart()
            } else {
                showAlert(text: "Có lỗi xảy ra vui lòng kiểm tra dữ liệu")
                // show modal confirm
            }
        }
        
        //check product is favorite
        _ = service.checkProductFavorite(id: String(self.itemProduct?.productID ?? 0)).done { CommonResponseModel in
            self.favorite = CommonResponseModel.ok
        }
    }
    
    func onBuyNow() {
        let data: [String: Any] = [
            "productId": String(self.itemProduct?.productID ?? 0),
        ]
        _ = service.addToCart(parameters: data).done { response in
            if response.ok {
                self.navToCart = true
            } else {
                showAlert(text: "Có lỗi xảy ra vui lòng kiểm tra dữ liệu")
                // show modal confirm
            }
        }
    }
    
    func showAlert(text: String) {
        self.isShowAlertError = true
        self.message = text
    }
    
}


struct ProductDescriptionView: View {
    
    var itemProduct: ProductDetailModel?
    
    var body: some View {
        if let item  = itemProduct {
            Group {
                HStack{
                    VStack(alignment: .leading, spacing: 0.0){
                        HStack{
                            Text("Mô tả").appFont(style: .body,weight: .bold, size: 14, color: Color(hex: "#4D4D4D"))
                            Spacer()
                        }
                        if let des = item.description{
                            VStack{
                                Text(des.htmlStripped).appFont(style: .body, size: 12, color: Color(hex: "#808080"))
                            }.padding(.top,8)
                        }
                        
                        
                        HStack{
                            Text("Nhà cung cấp").appFont(style: .body,weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).padding(.top,8)
                            Spacer()
                        }
                        VStack{
                            Text(item.organizationName ?? "").appFont(style: .body, size: 12, color: Color(hex: "#808080"))
                        }.padding(.top,8)
                    }
                }.padding(.horizontal,20)
                    .padding(.bottom,16)
                    .frame(width: screenWidth()-37,height: 206)
                    .background(Color.white)
                    .cornerRadius(15)
                    .myShadow()
            }
        }
    }
}

struct CircleButtonProductDetail: View {
    
    var icon = "person.crop.circle"
    var color = Color("button")
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(color)
        }
        .frame(width: 25, height: 25)
        .background(Color("button"))
        .cornerRadius(30)
        .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 5)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(productId: 115).environmentObject(MarketPlaceApiService())
    }
}
