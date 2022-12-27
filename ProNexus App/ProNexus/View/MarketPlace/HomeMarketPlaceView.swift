//
//  HomeMarketPlaceView.swift
//  ProNexus
//
//  Created by Tú Dev app on 08/11/2021.
//

import SwiftUI
import SwiftyUserDefaults
import Firebase

struct HomeMarketPlaceView: View {
    @State var keyWord: String = "" //create State
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var vm = SearchProductViewModel()
    @State var cartCount = "0"
    @State var isSearch = false
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .top) {
                VStack {
                    ZStack(alignment: .center) {
                        Header(title: "MarketPlace", contentView: {
                            ButtonIcon(name: "arrow.left", onTapButton: {
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            
                            Spacer()
                            
                            NavigationLink {
                                CartItemView(itemIdSelected: 0).environmentObject(MarketPlaceApiService())
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarHidden(true)
                            } label: {
//                                if cartCount != "0" {
//                                    Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
//                                        .overlay(
//                                            Text("\(cartCount)").appFont(style: .body, size: 10, color: .white).frame(width: 15, height: 15, alignment: .center).background(Color.red).cornerRadius(50).offset(x: 10, y: -5)
//                                        )
//                                } else {
//                                    Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
//                                }
                                
                                Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
                                    .overlay(
                                        Text("\(cartCount)").appFont(style: .body, size: 10, color: cartCount != "0" ? Color.white : Color.white.opacity(0)).frame(width: 15, height: 15, alignment: .center).background(cartCount != "0" ? Color.red : Color.red.opacity(0)).cornerRadius(50).offset(x: 10, y: -5)
                                    )
                                
                            }.frame(width: 24, alignment: .trailing)
                        })
                    }.background(
                        Image("bg_header")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.screenWidth, height: 180)
                            .edgesIgnoringSafeArea(.top)
                    )
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.gray)
                                .frame(height: 18)
                            
                            TextField("Bạn cần tìm sản phẩm?", text: $vm.text).appFont(style: .caption1, weight: .regular, size: 14)
                                .onReceive(
                                    vm.$text
                                        .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                                ) {
                                    guard !$0.isEmpty else { return }
                                    print(">> searching for: \($0)")
                                    self.isSearch = true
                                    
                                }
                            NavigationLink(isActive: $isSearch) {
                                ProductListView(vm: self.vm, isSearchFromHome: true).environmentObject(MarketPlaceApiService())
                                .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                            } label: {
                                EmptyView()
                            }

                            
                        }
                        .padding(10)
                        .padding(.horizontal, 27)
                        .frame(height: 49)
                        .background(Color.white)
                        .cornerRadius(30)
                        .myShadow()
                        
                        
                    }.padding(.horizontal, 37)
                        .offset(x: 0, y: 0)
                }
                .zIndex(99)

                
                ScrollView (showsIndicators: false) {
                    VStack{
                        Group{
                            BannerSection()
                            CategoryButtonCircleSection()
                                .padding(.leading, 37)
                                .padding(.top, 20)
                                .environmentObject(MarketPlaceApiService())
                            
                            ProductItems(type:1,title:"Mua nhiều").environmentObject(MarketPlaceApiService())
                            
                            ProductItems(type:2,title:"Yêu thích").environmentObject(MarketPlaceApiService())
                            
                            ProductItems(type:3,title:"Ưu đãi mới").environmentObject(MarketPlaceApiService())
                            
//                            NewOfferSectionList().padding(.leading, 37)
                            Spacer()
                        }.padding(.bottom, 5)
                    }
                    
                }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    .onAppear() {
                        loadCartCount()
                    }
                    .padding(.top, 100)
            }
           
        }
    }
    
    func loadCartCount() {
        if (user != nil) {
            db.collection("shoppingCarts").whereField("uuid", isEqualTo: user?.uid).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no documents")
                    return
                }
                
                documents.map { docSnapshot -> String in
                    let data = docSnapshot.data()
                    self.cartCount = data["count"] as? String ?? ""
                    return self.cartCount
                }
            })
        }
    }
}

struct HomeMarketPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMarketPlaceView().environmentObject(BannerService()).environmentObject(ClassificationApiService())
    }
}
