//
//  Messages.swift
//  ProNexus
//
//  Created by thanh cto on 20/11/2021.
//

import SwiftUI
import SwiftyUserDefaults
import Firebase
import SDWebImageSwiftUI

class SearchMessageViewModel: ObservableObject {
    @Published var text: String = ""
}

struct Messages: View {
    
    @State var docId: String
    @State var chatroom: Chatroom?
    @State var messages = [Message]()
    @EnvironmentObject var viewModel : MessagesViewModel
    @State var messageField = ""
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var chatSession = SessionStore()
    @Environment(\.isPreview) var isPreview
    @State var scrolled = false
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    @State var isSearch = false
    @ObservedObject private var vm = SearchMessageViewModel()
    @State var loading = false
    
    
    var body: some View {
        VStack {
            VStack {
                ZStack(alignment: .top) {
                    Image("bg_header_chat")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.screenWidth, height: 216)
                        .edgesIgnoringSafeArea(.top)
                    HStack(spacing: 0) {
                        //button left
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                        }).frame(width: 50, alignment: .center)
                        
                        Spacer()
                    }.frame(height: 60, alignment: .center)
                    HStack(alignment: .center, spacing: 15) {
                        
                        if let user = Defaults.userLogger
                        {
                            if let chatroom = chatroom {
                                let picture = user.getIdByRole() != chatroom.fromUserId ? chatroom.fromUserAvatar : chatroom.toUserAvatar
                                
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
                                //                                .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                let roomName = user.getIdByRole() != chatroom.fromUserId ? chatroom.fromUserName : chatroom.toUserName
                                Text(roomName).appFont(style: .body,weight: .regular, size: 20, color: Color(hex: "#4d4d4d")).frame(height: 25, alignment: .center)
                            }
                        }
                    }
                    
                    // input search
                    VStack(alignment: .leading) {
                        HStack {
                            Button(action: {
                                
                            }, label: {
                                
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.gray)
                                    .frame(height: 18)
                            })
                            
                            TextField("Tìm kiếm", text: $vm.text).appFont(style: .caption1, weight: .regular, size: 14)
                                .onReceive(
                                    vm.$text
                                        .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                                ) {
                                    print(">> searching for: \($0)")
                                    self.viewModel.isSearch = true
                                    searchMsg()
                                }
                            
                            if self.vm.text.count > 0 {
                                Button {
                                    self.vm.text = ""
                                    searchMsg()
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
                        //                    .padding(10)
                        .padding(.horizontal, 27)
                        .frame(height: 49)
                        .background(Color.white)
                        .cornerRadius(30)
                        .myShadow()
                        
                        
                    }.padding(.horizontal, 37)
                        .padding(.top, 55)
                    
                }
                
                if $loading.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                    Spacer()
                } else
                {
                    if self.messages.count > 0 {
                        if #available(iOS 14.0, *) {
                            ScrollViewReader{reader in
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack{
                                        ForEach(self.messages) { msg in
                                            HStack{
                                                //
                                                //                                    Text("\(self.user.customerID ?? "")")
                                                if Defaults.userLogger?.getIdByRole() == msg.sender {
                                                    Spacer()
                                                    Text(msg.content)
                                                        .appFont(style: .body, color: Color(hex: "#fff"))
                                                        .padding()
                                                        .background(Color(hex: "#50A0FC"))
                                                    //                                            .clipShape(msgTail(mymsg: true))
                                                        .cornerRadius(15)
                                                    //
                                                }
                                                else {
                                                    Text(msg.content)
                                                        .appFont(style: .body, color: Color(hex: "#343434"))
                                                        .padding()
                                                        .background(Color(hex: "#F5FAFF"))
                                                        .cornerRadius(15)
                                                        .overlay(
                                                                RoundedRectangle(cornerRadius: 15)
                                                                    .stroke(Color(hex: "#50A0FC"), lineWidth: 0.5)
                                                         )
                                                    Spacer()
                                                }
                                                Text(msg.sentAt)
                                                    .appFont(style: .body, size: 12, color: Color(hex: "#707070"))
                                            }
                                            .padding(.horizontal, 2)
                                            .padding(.bottom, 10)
                                            //                                .padding(true ? .leading : .trailing, 55)
                                            .id(msg.msgId)

                                        }
                                    }.id("ChatScrollView")

                                }.padding(.horizontal, 15)
                                    .background(Color.white)
                                    .onChange(of: self.messages, perform: { value in

                                        // You can restrict only for current user scroll....
                                        withAnimation {
                                            reader.scrollTo("ChatScrollView", anchor: .bottom)
                                        }
                                    })
                                    .onAppear{
                                        // First Time Scroll
                                        reader.scrollTo("ChatScrollView", anchor: .bottom)
                                    }
                                    .padding(.top, -80)
                                
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    } else {
                        NoData(text: "Không có tin nhắn")
                        Spacer()
                    }
    
                }
                
               
                HStack{
                    VStack {
                        Divider()
                        HStack {
                            HStack(spacing : 8){
                                
                                //                      Button(action: {
                                //
                                //                      }) {
                                //
                                //                          Image("emoji").resizable().frame(width: 20, height: 20)
                                //
                                //                      }.foregroundColor(.gray)
                                
                                TextField("Nhập tin nhắn", text: $messageField).appFont(style: .body).frame(height: 38)
                                
                                //                      Button(action: {
                                //
                                //                      }) {
                                //
                                //                          Image(systemName: "camera.fill").font(.body)
                                //
                                //                      }.foregroundColor(.gray)
                                
                                //                                Button(action: {
                                //
                                //                                }) {
                                //
                                //                                    Image(systemName: "paperclip").font(.body)
                                //
                                //                                }.foregroundColor(.gray)
                                
                            }.frame(height: 38)
                                .padding(.horizontal, 15)
                                .foregroundColor(Color(hex: "#0974DF"))
                                .background(RoundedRectangle(cornerRadius: 30).style(
                                    withStroke: Color(hex: "#0974DF"),
                                    lineWidth: 0.5,
                                    fill: .white
                                ))
                            
                            if !messageField.isBlank {
                                Button(action: {
                                    if let user = Defaults.userLogger {
                                        if !messageField.isBlank {
                                            viewModel.sendMessage(fromId: user.getIdByRole(), message: messageField, docId: self.docId)
                                            self.messageField = ""
                                        }
                                    }
                                    
                                }) {
                                    
                                    Text("Gửi").myFont(style: .body, color: .white)
                                    
                                }.buttonStyle(GradientButtonStyleChat(w: 87.0, h: 38.0))
                            } else
                            {
                                Button(action: {
                                    
                                    
                                }) {
                                    
                                    Text("Gửi").myFont(style: .body, color: Color(hex: "#4d4d4d"))
                                    
                                }.buttonStyle(SilverButton(w: 87.0, h: 38.0))
                            }
                        }.padding(.horizontal, 15)
                            .padding(.bottom, 20)
                            .animation(.default)
                    }
                    
                }
                .padding(.top, 15)
                .background(Color.white)
            }
            .onAppear(){
                if !isPreview {
                    self.fetchData(docId: self.docId)
                    //
                    //                    viewModel.fetchData(docId: chatroom.id, searchKey: "").done { rs in
                    //                        self.messages = rs
                    //                    }
                    //                    self.viewModel.docId = chatroom.id
                    _ = viewModel.getRoomDetail(docId: self.docId).done { Chatroom in
                        self.chatroom = Chatroom
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func searchMsg(){
        self.loading = true
        _ = viewModel.fetchData(docId: self.docId, searchKey: vm.text).done { rs in
            self.messages = rs
            self.loading = false
        }
    }
    
    func fetchData(docId: String) {
        if (user != nil) {
            db.collection("chatrooms").document(docId).collection("messages").order(by: "sentAt", descending: false).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no documents")
                    return
                }
                
                self.messages = documents.map { docSnapshot -> Message in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let msgId = data["msgId"] as? Int64 ?? 0
                    let content = data["content"] as? String ?? ""
                    let displayName = data["displayName"] as? String ?? ""
                    let sender = data["sender"] as? String ?? ""
                    let sentAtStr = String((data["sentAt"] as? Int64 ?? 0) * 1000)
                    let sentAt = Date(fromString: "/Date(\(sentAtStr))/", format: .dotNet) ?? Date()
                    return Message(id: docId, msgId: String(msgId), content: content, name: displayName, sentAt: sentAt.getTimeAgo(), sender: sender)
                }
            })
        }
    }
}

//struct Messages_Previews: PreviewProvider {
//
//    static var previews: some View {
//        Group {
//            //            TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
//            Messages(chatroom: Chatroom(id: "458SnHH2vzHtoz3CLkqc", title: "Thanh Ngo!"))
//        }
//    }
//}
