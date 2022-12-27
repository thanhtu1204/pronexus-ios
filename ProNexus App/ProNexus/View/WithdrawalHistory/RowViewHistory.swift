//
//  RowView.swift
//  ProNexus
//
//  Created by IMAC on 11/1/21.
//

import SwiftUI

struct RowView: View {
    
    @State var item: WithdrawHistoryModel
    @State var createdOn = ""
    
    var body: some View {

        
        HStack(alignment: .center, spacing: 15){
            
            // Making it as clickable Button....
            
            Image("ic_money").resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack {
                HStack{
                    
                    VStack(alignment: .leading, spacing: 10, content: {
                        
                        Text("Rút tiền")
                            .appFont(style: .body, size: 14, color: Color(hex: "#4D4D4D"))
                        
                        Text("\(createdOn ?? "")")
                            .appFont(style: .body, size: 12, color: Color(hex: "#B3B3B3"))
                            .foregroundColor(.gray)
                    })
                    
                    Spacer(minLength: 10)
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        
                        Text("- \(String(item.amount).convertDoubleToCurrency())")
                            .appFont(style: .body, size: 14, color: Color(hex: "#4D4D4D"))
                            .foregroundColor(.gray)
                        
                        if item.status == 1 {
                            Text("Đang chờ duyệt").italic()
                                .appFont(style: .body, size: 12, color: Color(hex: "#FFC700"))
                                .foregroundColor(.gray)
                            
                        }
                        if item.status == 2 {
                            Text("Đã duyệt").italic()
                                .appFont(style: .body, size: 12, color: Color(hex: "#4C99F8"))
                                .foregroundColor(.gray)
                            
                        }
                        if item.status == 3 {
                            Text("Từ chối").italic()
                                .appFont(style: .body, size: 12, color: Color(hex: "#Từ chối"))
                                .foregroundColor(.gray)
                            
                        }
                        
                        
                    }
                }
                
            }.padding(.vertical, 33)
            
        }
        .padding(.horizontal, 33)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
        
        .onAppear() {
            
            if !item.createdOn.isBlank {
                self.createdOn = (Date(fromString: item.createdOn?[0..<11] ?? "", format: .isoDate)?.toString(format: .custom("dd/M/yyyy  HH:mm"))) as! String
            }
        }
        
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalHistoryView().environmentObject(ProviderApiService())
    }
}
