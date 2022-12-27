//
//  ProductListView.swift
//  ProNexus
//
//  Created by Tú Dev app on 09/11/2021.
//

import SwiftUI
import SwiftyUserDefaults
import Firebase

// Tab Model...
struct TabProduct: Identifiable {
    var id = UUID().uuidString
    var tab : String
}


class SearchProductViewModel: ObservableObject {
    @Published var text: String = ""
}


struct ProductListView: View {
    
    @EnvironmentObject var service: MarketPlaceApiService
    
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var vm = SearchProductViewModel()
    
    @State var selectedTab = "1"
    @State var selections: [Int] = []
    
    @State var cates: [ProductCategory] = []
    
    @State var itemsProd: [ProductElement] = []
    @State var loading = true
    @State var reloadData = false
    @State var message = ""
    @State var isShowAlertError = false
    @State var isShowAlertSuccess = false
    @State var isSearchFromHome = false
    
    @State var itemProduct: ProductDetailModel?
    @State var cartCount = "0"
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    
    var body: some View {
        VStack () {
            VStack {
                ZStack(alignment: .center) {
                    HStack(spacing: 0) {
                        Header(title: "Danh sách sản phẩm", contentView: {
                            ButtonIcon(name: "arrow.left", onTapButton: {
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            
                            Spacer()
                            
                            VStack(alignment:.trailing,spacing: 0) {
                                NavigationLink {
                                    CartItemView(itemIdSelected: 0, itemIdPreview: 0).environmentObject(MarketPlaceApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                } label: {
                                    if Defaults.cartCount != 0 {
                                        Image(systemName: "cart.fill")
                                            .resizable()
                                            .frame(width: 22, height: 22)
                                            .foregroundColor(.white)
                                            .overlay(
                                                Text("\(Defaults.cartCount)").appFont(style: .body, size: 10, color: .white).frame(width: 15, height: 15, alignment: .center).background(Color.red).cornerRadius(50).offset(x: 10, y: -5)
                                            )
                                    } else {
                                        Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
                                    }
                                }
                            }
                        })
                    }
                }.background(
                    Image("bg_header")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth, height: 180)
                        .edgesIgnoringSafeArea(.top)
                ).offset(x: 0, y: -4)
                
                // input search
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray)
                            .frame(height: 18)
                        
                        
                        TextField("Bạn tìm sản phẩm gì?", text: $vm.text).appFont(style: .caption1, weight: .regular, size: 14)
                            .onReceive(
                                vm.$text
                                    .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                            ) {
//                                guard $0.count > 2 else { return }
                                print(">> searching for: \($0)")
                                // biến để tránh gọi api 2 lần khi truyền text từ home
                                if self.isSearchFromHome {
                                    self.isSearchFromHome = false
                                } else
                                {
                                    if self.selections.count > 0{
                                        let type = joinArray(data: self.selections)
                                        self.loadData(type:type, keyword: String(vm.text))
                                    } else{
                                        self.loadData(keyword:String(vm.text))
                                    }
                                }
                            }
                    }
                    .padding(.horizontal, 27)
                    .frame(height: 49)
                    .background(Color.white)
                    .cornerRadius(30)
                    .myShadow()
                    
                    
                }.padding(.horizontal, 37)
                    .offset(x: 0, y: 0)
            }
            
            HStack{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15){
                        if let items = self.cates{
                            ForEach(cates){item in
                                // Tab Button...
                                TabButton(title: item.name ?? "", id: String(item.productCategoryID ?? 0), selectedTab:$selectedTab, onSelectTab: {
                                    if let id = item.productCategoryID {
                                        self.loadData(type:String(id))
                                    }
                                })
                                
                            }
                        }
                        
                    }
                }
            }.padding(.horizontal, 37).padding(.bottom, 20)
                .offset(x: 0, y: 0)
            
            ScrollView (showsIndicators: false){
                Group{
                    if $loading.wrappedValue {
                        SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                    } else
                    {
                        ProductSectionView(itemsProd: $itemsProd, reloadData: $reloadData)
                        Spacer()
                    }
                }
            }
            
        }.onAppear {
            _ = service.loadCategory().done { ProductCategoryList in
                if let items = ProductCategoryList.payload {
                    self.cates = items
                }
            }
            
            if self.selections.count > 0{
                let type = joinArray(data: self.selections)
                self.loadData(type:type, keyword: String(vm.text))
            } else{
                self.loadData(keyword:String(vm.text))
            }
            
            loadCartCount()
            
        }
    }
    func loadData(type: String = "", keyword:String = ""){
        self.loading = true
        // danh sach sp
        
        _ = service.loadListProducts(categoryId:type,keyword:String(keyword)).done { ProductListModel in
            if let items  = ProductListModel.payload {
                self.itemsProd = items
            }
            self.loading = false
        }
    }
    func joinArray(data :[Int]) -> String {
        let array = data
        let stringArray = array.map { String($0) }
        let string = stringArray.joined(separator: ",")
        return string
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

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView().environmentObject(MarketPlaceApiService())
    }
}
