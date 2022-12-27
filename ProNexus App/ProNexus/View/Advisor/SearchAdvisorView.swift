//
//  SearchAdvisorView.swift
//  ProNexus
//
//  Created by Tú Dev app on 07/11/2021.
//

import SwiftUI
// Tab Model...
struct TabAdivisor: Identifiable {
    var id = UUID().uuidString
    var tab : String
}

class SearchAdvisorViewModel: ObservableObject {
    @Published var text: String = ""
}


struct SearchAdvisorView: View {
    
    @ObservedObject var vm = SearchAdvisorViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @State var selectedTab = "0"
    @EnvironmentObject var service: ProviderApiService
    @EnvironmentObject var serviceClassificationList: ClassificationApiService
    @State var classificationList = [ClassificationModel]()
    @State var selections: [Int] = []
    @State var results: [AdvisorModel] = []
    @State var featureLists: [AdvisorModel] = []
    @State private var showingSheet = false
    @State var loading = true
    @State var loadingMore = false
    @State var navAdvisorDetail = false
    @State var advisorId: String = ""
    
    @State var provinceId: Int?
    @State var isSelectedStar:String = ""
    @State var isSelectedPrice:String = ""
    @State var starSelections : [String] = []
    
    @State var page: Int = 1
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    Header(title: "Danh sách cố vấn", contentView: {
                        ButtonIcon(name: "arrow.left", onTapButton: {
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
                            
                            TextField("Bạn đang tìm ai?", text: $vm.text).appFont(style: .caption1, weight: .regular, size: 14)
                                .onReceive(
                                    vm.$text
                                        .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                                ) {
//                                    guard $0.count > 2 else { return }
                                    print(">> searching for: \($0)")
                                    self.page = 1
                                    if self.selections.count > 0{
                                        let type = joinArray(data: self.selections)
                                        self.loadData(type: type)
                                    }else{
                                        self.loadData()
                                    }
                                }
                            Spacer()
                            
                            Button(action: {
                                showingSheet.toggle()
                                
                            }, label: {
                                Image(systemName: "slider.vertical.3")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.gray)
                                    .frame(height: 14)
                            })
                        }
                        //                    .padding(10)
                        .padding(.horizontal, 27)
                        .frame(height: 49)
                        .background(Color.white)
                        .cornerRadius(30)
                        .myShadow()
                        
                        
                    }.padding(.horizontal, 37)
                        .offset(x: 0, y: -3)
                        .zIndex(12)
                    
                    // menu filter
                    HStack{
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 15){
                                if let items = self.classificationList{
                                    ForEach(items){item in
                                        TabButton(title: item.name ?? "", id: String(item.id!), selectedTab:$selectedTab, onSelectTab: {
                                            if let id = item.id {
                                                self.page = 1
                                                if id == 0 {
                                                    self.loadData()
                                                } else{
                                                    self.loadData(type:String(id))
                                                }
                                            }
                                        })
                                    }
                                }
                                
                            }
                        }.padding(.leading, 37)
                            .padding(.vertical, 10)
                    }
                    
                    ScrollView (.vertical, showsIndicators: false) {
                        VStack {
                            if $loading.wrappedValue {
                                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                            } else
                            {
                                if let items = results {
                                    if items.count == 0 {
                                        NoData()
                                    }
                                    ScrollView(.vertical, showsIndicators: false, content: {
                                        VStack(spacing: 15){
                                            if let results = results {
                                                
                                                ForEach(results) {item in
                                                    AdvisorItemRowView(item: item, advisorId: $advisorId.onUpdate {
                                                        self.navAdvisorDetail = true
                                                    })
                                                }
                                            }
                                            
                                        }
                                        .padding(.horizontal, 37)
                                        .padding(.top, 10)
                                        .padding(.bottom, 30)
                                    }).frame( height: 510)
                                    
                                    if $navAdvisorDetail.wrappedValue {
                                        NavigationLink(destination:
                                                        AdvisorDetailView(id: advisorId).environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true), isActive: $navAdvisorDetail)
                                        {
                                            EmptyView()
                                        }
                                    }
                                    
                                    
                                    HStack(spacing: 0) {
                                        Spacer()
                                        if $loadingMore.wrappedValue {
                                            SectionLoader().frame(width: screenWidth() - 74, height: 20, alignment: .center)
                                        } else
                                        {
                                            Button(action: {
                                                self.page += 1
                                                if self.selections.count > 0{
                                                    let type = joinArray(data: self.selections)
                                                    self.loadMoreData(type: type, page:self.page)
                                                } else{
                                                    self.loadMoreData(page:self.page)
                                                }
                                            }, label: {
                                                Image(systemName: "chevron.down")
                                                    .foregroundColor(Color(hex: "#B3B3B3")
                                                    )
                                            }).frame(width: screenWidth() - 74, height: 20, alignment: .center)
                                        }
                                        Spacer()
                                    }.padding(.vertical, 0)
                                    
                                }
                            }
                            
                            // danh sách cố vấn noi bat
                            AdvisorSectionListView(type: 2, title: "Cố vấn được đề xuất").environmentObject(ProviderApiService())
                                .padding(.top, 10)
                            
                            // Cố vấn yêu thích
                            AdvisorFavoriteView( title: "Cố vấn yêu thích").environmentObject(ProviderApiService())
                                .padding(.top, 10)
                            
                            // danh sách advisor đã kết nối
                            AdvisorSectionListView(type: 3, title: "Cố vấn đã kết nối").environmentObject(ProviderApiService())
                                .padding(.top, 10)
                            
                            Spacer()
                        }.padding(.bottom, 5)
                            .onAppear{
                                // load danh mục
                                serviceClassificationList.loadClassificationList().done { response in
                                    if let items = response.results {
                                        let itemAll = ClassificationModel(id:0,name:"Tất Cả")
                                        self.classificationList = items
                                        self.classificationList.insert(itemAll, at: 0)
                                    }
                                }
                                
                                // load danh sách cô vấn
                                if self.selections.count > 0{
                                    let type = joinArray(data: self.selections)
                                    self.loadData(type: type)
                                } else{
                                    self.loadData()
                                }
                                
                            }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    }.edgesIgnoringSafeArea(.bottom)
                }
                if $showingSheet.wrappedValue {
                    VStack(alignment: .leading, spacing: 0, content: {
                        EmptyView()
                    })
                    // background dim...
                    .frame(maxWidth: screenWidth(), maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                }
                
                BottomSheetView(isOpen: $showingSheet, maxHeight: getRect().height - 60) {
                    FilterAdvisorView(show: $showingSheet.onUpdate {
                        let type = joinArray(data: self.selections)
                        self.loadData(type: type)
                    }, provinceId: $provinceId, isSelectedStar: $isSelectedStar, isSelectedPrice: $isSelectedPrice, selections: $selections) .environmentObject(ClassificationApiService()).zIndex(999)
                }.edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    
    func loadData(type: String = ""){
        self.loading = true
        // danh sach co van
        _ = service.loadListAdvisor(type: type, keyword: vm.text, selectedRating: isSelectedStar, priceHour: isSelectedPrice, provinceId: provinceId ?? 0).done { ProviderListModel in
            if let items = ProviderListModel.results {
                results = items
            }
            self.loading = false
        }
    }
    
    func loadMoreData(type: String = "", page:Int = 1){
        self.loadingMore = true
        // danh sach co van
        _ = service.loadListAdvisor(page: page, type: type, keyword: vm.text).done { ProviderListModel in
            if let items = ProviderListModel.results {
                results.append(contentsOf:items)
            }
            self.loadingMore = false
        }
    }
    
    
    func joinArray(data :[Int]) -> String {
        let array = data
        let stringArray = array.map { String($0) }
        let string = stringArray.joined(separator: ",")
        return string
    }
    
}


struct SearchAdvisorView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAdvisorView().environmentObject(ProviderApiService()).environmentObject(ClassificationApiService())
    }
}
