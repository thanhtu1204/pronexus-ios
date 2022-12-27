//
//  OnBoarding.swift
//  OnBoarding
//
//  Created by Balaji on 27/08/21.
//

import SwiftUI
import SwiftyUserDefaults

struct OnBoarding: View {
    @State var offset: CGFloat = 0
    var body: some View {
        
        // Custom Pager View...
        OffsetPageTabView(offset: $offset) {
            HStack(spacing: 0){
                ForEach(boardingScreens){screen in
                    VStack(alignment: .center, spacing: 15){
                        
                        //                        Image(screen.image)
                        //                            .resizable()
                        //                            .aspectRatio(contentMode: .fit)
                        //                            .frame(width: getScreenBounds().width - 100, height: getScreenBounds().width - 100)
                        //                        // small screen Adoption...
                        //                            .scaleEffect(getScreenBounds().height < 750 ? 0.9 : 1)
                        //                            .offset(y: getScreenBounds().height < 750 ? -100 : -120)
                        
                        VStack(alignment: .center, spacing: 12) {
                            
                            Text(screen.title).regular(size: 20, color: Color(hex: "#0049C3"))
                            
                            Text(screen.description).regular(size: 14, color: Color(hex: "#0049C3"))
                        }
                        .frame(maxWidth: .infinity,alignment: .center)
                        .padding(.top, 100)
                    }
                    .padding(.horizontal, 50)
                    .background(
                        Image(screen.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: getScreenBounds().width, height: getScreenBounds().height)
                    )
                    .frame(width: getScreenBounds().width)
                    .frame(maxHeight: .infinity)
                    .animation(.linear(duration: 0.3))
                }
            }
        }
        // Animation...
        //        .background(
        //
        //            RoundedRectangle(cornerRadius: 50)
        //                .fill(.white)
        //            // Size as image size...
        //                .frame(width: getScreenBounds().width - 100,height: getScreenBounds().width - 100)
        //                .scaleEffect(2)
        //                .rotationEffect(.init(degrees: 25))
        //                .rotationEffect(.init(degrees: getRotation()))
        //                .offset(y: -getScreenBounds().width + 20)
        //
        //            ,alignment: .leading
        //        )
        //        .background(
        //                                    Image(screen.image)
        //                                        .resizable()
        //                                        .aspectRatio(contentMode: .fit)
        //                                        .frame(width: getScreenBounds().width - 100, height: getScreenBounds().width - 100)
        //        )
        // animating...
        .ignoresSafeArea(.container, edges: .all)
        .overlay(
            
            VStack{
                
                // Indicators...
                HStack(spacing: 8){
                    ForEach(boardingScreens.indices,id: \.self){index in
                        Circle()
                            .fill(Color(hex: "#0049C3"))
                            .opacity(index == getIndex() ? 1 : 0.4)
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == (getIndex()) ? 1.3 : 0.85)
                            .animation(.easeInOut, value: getIndex())
                    }
                }
                .frame(maxWidth: .infinity)
                
                HStack{
                    
                    if getIndex() < 2 {
                        Button {
                            Defaults.onBoarding = 1
                            let vc = UIHostingController(rootView: TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home)))
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                        } label: {
                            Text("Bỏ qua").regular(size: 14, color: Color(hex: "#0049C3")).fixedSize(horizontal: true, vertical: false)
                        }
                    }
                    
                    Button {
                        
                        if getIndex() == 2 {
                            Defaults.onBoarding = 1
                            let vc = UIHostingController(rootView: TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home)))
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                        } else if getIndex() < 2 {
                            // Setting Mac Offset...
                            // max 4 screens so max will be 3*width....
                            offset = min(offset + getScreenBounds().width,getScreenBounds().width * CGFloat(boardingScreens.count))
                        }
                    } label: {
                        HStack (alignment: .center, spacing: 0)
                        {
                            if getIndex() == 2 {
                                Text("BẮT ĐẦU").regular(size: 14, color: Color(hex: "#0049C3")).padding(.leading, 30)
                            } else {
                                Text("TIẾP THEO").regular(size: 14, color: Color(hex: "#0049C3")).padding(.leading, 30)
                            }
                            
                            Spacer()
                            Image("button-next")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 44, height: 44, alignment: .center)
                        }
                        .padding(.horizontal, 5)
                        .frame(width: 250, height: 55)
                            .background(Color.white)
                            .cornerRadius(100)
                            .animation(.linear(duration: 0.3))
                        .myShadow()
                    }
                    
                }
                .padding(.top, 0)
                .offset(x: 0, y: 150)
                
            }.padding(.horizontal, 20)
                .offset(x: 0, y: 150)
            
            ,alignment: .center
        )
    }
    
    // getting Rotation...
    func getRotation()->Double{
        
        let progress = offset / (getScreenBounds().width * 3)
        
        // Doing one full rotation...
        let rotation = Double(progress) * 360
        
        return rotation
    }
    
    // Changing BG Color based on offset...
    func getIndex()->Int{
        let progress = (offset / getScreenBounds().width).rounded()
        
        return Int(progress)
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding()
    }
}

// Extending View to get Screen Bounds...
extension View{
    func getScreenBounds()->CGRect{
        return UIScreen.main.bounds
    }
}
