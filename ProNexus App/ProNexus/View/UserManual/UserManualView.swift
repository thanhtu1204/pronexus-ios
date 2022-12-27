//
//  UserManualView.swift
//  ProNexus
//
//  Created by IMAC on 11/10/21.
//

import SwiftUI

struct UserManualView: View {
    
    @State var keyWord: String = "" //create State
    @Environment(\.presentationMode) private var presentationMode
    
    let places: [Place]
    let list2: [AppointmentSchedule]
    let list3: [MarketPlace]
    
    @State private var selection: Set<Place> = []
    @State private var selection2: Set<AppointmentSchedule> = []
    @State private var selection3: Set<MarketPlace> = []
    
    var body: some View {
        
        ZStack(alignment: .top) {
            // header
            VStack {
                ZStack(alignment: .center) {
                    Header(title: "Hướng dẫn sử dụng", contentView: {
                        ButtonIcon(name: "arrow.left", onTapButton: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        
                        Spacer()
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
                        
                        TextField("Gõ từ khoá bạn muốn tìm", text: $keyWord).appFont(style: .caption1, weight: .regular, size: 14)
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
            //
            
            ScrollView() {
                VStack(alignment: .leading, spacing: 25) {
                    registerAccount
                    appointmentSchedule
                    marketPlace
                }.padding(.horizontal, 37)
                    .offset(x: 0, y: -5)
                
            }
            .offset(y: 90)
        }
    }
    
    
    var registerAccount: some View {
        ScrollView {
            ForEach(places) { place in
                PlaceView(place: place, isExpanded: self.selection.contains(place))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect(place) }
//                    .animation(.linear(duration: 0.3))
            }
        }
        .frame(width: UIScreen.screenWidth - 76)
        .background(Color.white)
        .cornerRadius(25)
        .myShadow()
        .offset(y: 30)
    }
    
    var appointmentSchedule: some View {
        ScrollView {
            ForEach(list2) { item in
                AppointmentScheduleView(item: item, isExpanded: self.selection2.contains(item))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect2(item) }
//                    .animation(.linear(duration: 0.3))
            }
        }
        .frame(width: UIScreen.screenWidth - 76)
        .background(Color.white)
        .cornerRadius(25)
        .myShadow()
        .offset(y: 30)
    }
    
    var marketPlace: some View {
        ScrollView {
            ForEach(list3) { market in
                MarketPlaceView(market: market, isExpanded: self.selection3.contains(market))
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect3(market) }
//                    .animation(.linear(duration: 0.3))
            }
        }
        .frame(width: UIScreen.screenWidth - 76)
        .background(Color.white)
        .cornerRadius(25)
        .myShadow()
        .offset(y: 30)
    }
    
    private func selectDeselect(_ place: Place) {
        if selection.contains(place) {
            selection.remove(place)
        } else {
            selection.insert(place)
        }
    }
    
    private func selectDeselect2(_ item: AppointmentSchedule) {
        if selection2.contains(item) {
            selection2.remove(item)
        } else {
            selection2.insert(item)
        }
    }
    
    private func selectDeselect3(_ market: MarketPlace) {
        if selection3.contains(market) {
            selection3.remove(market)
        } else {
            selection3.insert(market)
        }
    }
    
    
}

struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack() {
            Group {
                content
            }
        }
    }
}

struct UserManualView_Previews: PreviewProvider {
    static var previews: some View {
        UserManualView(places: Place.samples(), list2: AppointmentSchedule.lists(), list3: MarketPlace.lists3())
    }
}
