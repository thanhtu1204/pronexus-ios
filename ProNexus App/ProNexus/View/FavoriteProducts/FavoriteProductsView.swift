//
//  FavoriteProductsView.swift
//  ProNexus
//
//  Created by TUYEN on 11/29/21.
//

import SwiftUI
import SwiftyUserDefaults

struct FavoriteProductsView: View {
    
    @EnvironmentObject var service: MarketPlaceApiService
    
    
    @State var keyWord: String = "" //create State
    @Environment(\.presentationMode) private var presentationMode
    
    @State var message = ""
    @State var loading = true
    @State var reloadData = false
    @State var isShowAlertError = false
    @State var isShowAlertSuccess = false
    @State var selections: [Int] = []
    @State var cates: [ProductCategory] = []
    @State var itemsProd: [ProductElement] = []
    @State var itemProduct: ProductDetailModel?
    
    var body: some View {
        VStack () {
            VStack {
                
                // header
                VStack {
                    ZStack(alignment: .center) {
                        Header(title: "Sản phẩm yêu thích", contentView: {
                            ButtonIcon(name: "arrow.left", onTapButton: {
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            Spacer()
                            
                            VStack(alignment:.trailing,spacing: 0) {
                                NavigationLink {
                                    CartItemView(itemIdSelected: 0).environmentObject(MarketPlaceApiService())
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarHidden(true)
                                } label: {
                                    if Defaults.cartCount != 0 {
                                        Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
                                            .overlay(
                                                Text("\(Defaults.cartCount)").appFont(style: .body, size: 10, color: .white).frame(width: 15, height: 15, alignment: .center).background(Color.red).cornerRadius(50).offset(x: 10, y: -5)
                                            )
                                    } else {
                                        Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
                                    }
                                
                                }.frame(width: 24, alignment: .trailing)
                            }
                        })
                    }.background(
                        Image("bg_header")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.screenWidth, height: 180)
                            .edgesIgnoringSafeArea(.top)
                    )
                }
                .zIndex(99)
                .padding(.bottom, 43)
                //
            }
            
            ScrollView (showsIndicators: false){
                Group{
                    if $loading.wrappedValue {
                        SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                    } else
                    {
                        ProductSectionView(itemsProd: $itemsProd, reloadData: $reloadData.onUpdate {
                            if reloadData {loadData()}
                        }, type: 2)
                        Spacer()
                    }
                }
            }
            
        }.onAppear {
            loadData()
        }
    }
    
    func loadData(){
        self.loading = true
        _ = service.loadFavoriteProducts().done { ProductListModel in
            if let items  = ProductListModel.payload {
                self.itemsProd = items
            }
            self.loading = false
            self.reloadData = false
        }
    }
}

struct FavoriteProductsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteProductsView().environmentObject(MarketPlaceApiService())
    }
}
