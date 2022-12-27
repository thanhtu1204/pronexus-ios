//
//  MarketPlaceView.swift
//  ProNexus
//
//  Created by IMAC on 11/10/21.
//

import SwiftUI

struct MarketPlaceView: View {
    let market: MarketPlace
    let isExpanded: Bool
    
    var body: some View {
        ScrollView (.vertical) {
            VStack(alignment: .leading, spacing: 10) {
                HStack() {
                    Text(market.labelMarketPlace).appFont(style: .caption1, weight: .bold, size: 16, color: Color(hex: "#4C99F8"))
                    Spacer()
                    Image(isExpanded ? "arrow_down" : "ic_arrow_right_blue")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                }
                .padding(.all, 15)
                .background(RoundedRectangle(cornerRadius: 30).style(
                    withStroke: Color(hex: "#4C99F8"),
                    lineWidth: 0.5,
                    fill: .white
                ))
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(hex: "#4C99F8"))
                if isExpanded {
                    VStack(alignment: .leading, spacing: 15) {
                        Text(market.fieldMarketPlace1).appFont(style: .caption1, weight: .regular, size: 14)
                        Divider()
                        Text(market.fieldMarketPlace2).appFont(style: .caption1, weight: .regular, size: 14)
                        Divider()
                        Text(market.fieldMarketPlace3).appFont(style: .caption1, weight: .regular, size: 14)
                    }
                    .padding(.bottom, 20)
                    .padding(.top, 15)
                    .padding(.horizontal, 30)
                }
            }
            
        }
    }
    
}

struct MarketPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        UserManualView(places: Place.samples(), list2: AppointmentSchedule.lists(), list3: MarketPlace.lists3())
    }
}
