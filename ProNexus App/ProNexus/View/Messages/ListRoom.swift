//
//  ListRoom.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import SwiftUI
import SwiftyUserDefaults
import SDWebImageSwiftUI
import Combine

class SearchRoomViewModel: ObservableObject {
    @Published var text: String = ""
}

struct ListRoom: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    
    @ObservedObject var session = SessionStore()
    @ObservedObject var viewModel = ChatroomsViewModel()
    @State var joinModal = false
    @State var keyWord = ""
    @ObservedObject private var vm = SearchRoomViewModel()
    
    init() {
        if let user = Defaults.userLogger {
            viewModel.userId = user.getIdByRole()
            viewModel.listAll(fromId: user.getIdByRole())
        }
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            VStack (alignment: .center) {
                Header(title: "Hội thoại") {
//                    ButtonIcon(name: "arrow.left", onTapButton: {
//                        self.presentationMode.wrappedValue.dismiss()
//                        
//                    })
//                    Spacer()
                }.zIndex(12)

                
                // input search
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray)
                            .frame(height: 18)
                        
                        TextField("Tìm kiếm", text: $vm.text).appFont(style: .caption1, weight: .regular, size: 14)
                            .onReceive(
                                vm.$text
                                    .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                            ) {
                                guard !$0.isEmpty else { return }
                                print(">> searching for: \($0)")
                                self.viewModel.isSearch = true
                                
                                if isAdvisorRole() {
                                    self.viewModel.searchDataFromAdvisorRole(fromId: viewModel.userId, searchKey: $0)
                                } else {
                                    self.viewModel.searchDataFromUserRole(fromId: viewModel.userId, searchKey: $0)
                                }
                                
                            }
                        
                        if self.vm.text.count > 0 {
                            Button {
                                self.vm.text = ""
                                self.viewModel.listAll(fromId: viewModel.userId)
                            } label: {
                                
                                if $viewModel.isSearch.wrappedValue {
                                    ActivityIndicator(isAnimating: true)
                                        .configure { $0.color = .gray }
                                        .padding(.trailing, -10)
                                } else {
                                    Image(systemName: "xmark.circle.fill").resizable().frame(width: 16, height: 16).foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, -10)
                                }
                            }
                        }
                    }
                    .padding(10)
                    .padding(.horizontal, 15)
                    .frame(height: 49)
                    .background(Color.white)
                    .cornerRadius(30)
                    .myShadow()
                }.padding(.horizontal, 37)
                    .padding(.top, 40)
                    .zIndex(99999)
                
                VStack {
                    if let items = viewModel.chatrooms {
                        if items.count > 0 {
                            ScrollView(.vertical, showsIndicators: false, content: {
                                ForEach(items) {item in
                                    NavigationLink {
                                        Messages(docId: item.id, chatroom: item)
                                            .environmentObject(MessagesViewModel())
                                            .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                    } label: {
                                        chatRowView(item: item)
                                    }
                                }
                            }).padding(.top, 20)
                        } else
                        {
                            NoData()
                        }
                       
                    }
                }
                Spacer()
   
            }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
//            Spacer()
        }
        //        .navigationBarHidden(true).navigationBarBackButtonHidden(true)
        .offset(x: 0, y: UIApplication.statusBarHeight)
        .edgesIgnoringSafeArea(.top)
    }
}

struct chatRowView: View {
    
    var item: Chatroom
    
    var body: some View {
        
        HStack(spacing: 15){
            if let item = item
            {
                
                // Making it as clickable Button....
                
                Button(action: {
                    withAnimation{
                        //                    profileData.selectedProfile = recent
                        //                    profileData.showProfile.toggle()
                    }
                }, label: {
                    if let user = Defaults.userLogger
                    {
                        let picture = user.getIdByRole() != item.fromUserId ? item.fromUserAvatar : item.toUserAvatar
                        
                        WebImage(url: URL(string: picture))
                            .resizable()
                            .onSuccess { image, data, cacheType in
                                // Success
                                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                            }
                            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                            .placeholder {
                                Image("ic_picture")
                            }
                            .indicator(.activity) // Activity Indicator
                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                })
                // it decreased the highlight color....
                    .buttonStyle(PlainButtonStyle())
                
                VStack{
                    
                    HStack{
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            
                            if let user = Defaults.userLogger
                            {
                                // nếu không phải tin nhắn gửi từ mình thì hiển thị avt của người nhận
                                if user.getIdByRole() != item.fromUserId {
                                    Text(item.fromUserName).myFont(style: .body, weight: .regular, size: 16, color: Color(hex: "#343434"))
                                }
                                else
                                {
                                    Text(item.toUserName).myFont(style: .body, weight: .regular, size: 16, color: Color(hex: "#343434"))
                                }
                                
//                                Text(item.toUserName).myFont(style: .body, weight: .regular, size: 8, color: Color(hex: "#343434"))
//                                Text(item.fromUserName).myFont(style: .body, weight: .regular, size: 8, color: Color(hex: "#343434"))
                            }
                            
                            Text(item.latestMessage).myFont(style: .body, color: Color(hex: "#707070"))
                                .multilineTextAlignment(.leading)
                        })
                        
                        Spacer(minLength: 10)
                        
                        Text(item.latestTime)
                            .myFont(style: .caption1)
                    }
                    
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }
}

struct Rounded : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 55, height: 55))
        return Path(path.cgPath)
    }
}


struct msgTail : Shape {
    
    var mymsg : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 25, height: 25))
        return Path(path.cgPath)
    }
}


struct msgdataType : Identifiable {
    
    var id : Int
    var msg : String
    var myMsg : Bool
}


struct ListRoom_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Message))
            ListRoom()
        }
    }
}
