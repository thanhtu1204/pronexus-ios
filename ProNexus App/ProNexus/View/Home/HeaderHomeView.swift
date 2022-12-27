//
//  HeaderHome.swift
//  ProNexus
//
//  Created by thanh cto on 04/11/2021.
//

import SwiftUI
import SwiftyUserDefaults
import SDWebImageSwiftUI

struct HeaderHomeView: View {
    
    @State var imageName: String = "ic_on"
    @State var isEditProfile = false
    @State var navCart = false
    @State var navNotification = false
    @Binding var isOn: Bool
    @Binding var rating: Double
    @Binding var unReadCount: Int
    
    var body: some View {
        // HEADER
        VStack (alignment: .leading) {
            HStack(alignment: .top, spacing: 0) {
                HStack(alignment: .top, spacing: 15) {
                    WebImage(url: URL(string: Defaults.userPicture ?? ""))
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
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    //Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Xin chào").appFont(style: .body, color: .white)
                            Text(Defaults.userFullName ?? "").appFont(style: .title1, weight: .bold, color: .white)
                            if let user = Defaults.userLogger
                            {
                                if user.role == UserRole.advisor.rawValue {
                                    if let rating = self.rating {
                                        StarsView(rating: Float(rating))
                                    }
                                }
                            }
                        }
                        
                    }.padding(.leading, 5)
                }.onTapGesture {
                    self.isEditProfile = true
                }
                
                NavigationLink (isActive: $isEditProfile) {
                    if let user = Defaults.userLogger {
                        if user.role == UserRole.advisor.rawValue {
                            ProfileAdvisorFormEdit().environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                        } else {
                            ProfileUserFormEdit(id: user.customerID ?? "").environmentObject(UserApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                        }
                    }
                } label: {
                    EmptyView()
                }
                
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack (spacing: 16) {
                        VStack {
                            if Defaults.cartCount != 0 {
                                Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
                                    .overlay(
                                        Text("\(Defaults.cartCount)").appFont(style: .body, size: 10, color: .white).frame(width: 15, height: 15, alignment: .center).background(Color.red).cornerRadius(50).offset(x: 10, y: -5)
                                    )
                            } else {
                                Image(systemName: "cart.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
                            }
                        }.onTapGesture {
                            self.navCart = true
                        }
                        
                        VStack {
                            if self.unReadCount != 0 {
                                Image(systemName: "bell.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white).overlay(
                                    Text("\(unReadCount)").appFont(style: .body, size: 10, color: .white).frame(width: 15, height: 15, alignment: .center).background(Color.red).cornerRadius(50).offset(x: 10, y: -5)
                                )
                            } else {
                                Image(systemName: "bell.fill").resizable().frame(width: 22, height: 22).foregroundColor(.white)
                            }
                        }.onTapGesture {
                            self.navNotification = true
                        }
                        
                    }.padding(.bottom, 8)
                    
                    if let user = Defaults.userLogger
                    {
                        if user.role == UserRole.advisor.rawValue {
                            Button(action: {
                                self.isOn.toggle()
                            }) {
                                Image(self.isOn == true ? "ic_on" : "ic_off")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 18)
                            }.zIndex(20)
                        }
                    }
                    
                }
            }.background(
                Image("bg_header_home")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth(), height: 197)
                    .offset(x: 0, y: 0)
                    .edgesIgnoringSafeArea(.top)
            ).padding(.horizontal, 37)
                .frame(width: screenWidth(), height: 197)
                .offset(x: 0, y: -10)
            // HEADER
            //            Spacer()
            
            
            NavigationLink(isActive: $navCart) {
                CartItemView(itemIdSelected: 0).environmentObject(MarketPlaceApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
            } label: {
                EmptyView()
            }
            
            NavigationLink(isActive: $navNotification) {
                NotificationViewPreview().navigationBarHidden(true).navigationBarBackButtonHidden(true).environmentObject(ProviderApiService())
            } label: {
                EmptyView()
            }
        }.edgesIgnoringSafeArea(.top)
            
    }
}



struct HeaderHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderHomeView(isOn: .constant(false), rating: .constant(0), unReadCount: .constant(0))
        //        HomeView()
    }
}
