//
//  ProvinceModalView.swift
//  ProNexus
//
//  Created by TUYEN on 11/27/21.
//

import SwiftUI

struct ProvinceModalView: View {
    
    @EnvironmentObject var service: ProviderApiService
    @State var dataProvice: [ProvinceModel] = []
    
    @Binding var show: Bool
    @State var loading = true
    @Binding var provinceId: Int?
    @Binding var provinceName: String
    @Binding var onChangeProvince: Bool
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15, content: {
            
            HStack {
                Spacer()
                Button {
                    self.show.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill").resizable().frame(width: 20, height: 20).foregroundColor(.gray)
                }
            }
            
            ScrollView (showsIndicators: false) {
                if $loading.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                } else {
                    VStack(alignment: .leading) {
                        if let items = dataProvice {
                            ForEach(items) { item in
                                Button(action: {
                                    self.show.toggle()
                                    self.provinceId = item.provinceId
                                    self.provinceName = item.name ?? ""
                                    self.onChangeProvince = true
                                }, label: {
                                    Text("\(item.name ?? "")")
                                        .appFont(style: .body, color: Color(hex: "#999999"))
                                })
                                Divider()
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 300,  maxWidth: screenWidth(), maxHeight: 500)
            
            
            
        })
            .padding(20)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal, 15)
            .frame(minWidth: 300,  maxWidth: screenWidth(), maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
        
            .onAppear() {
                self.loading = true
                _ = service.loadProvinceById().done { response in
                    if let data = response.results {
                        self.dataProvice = data
                    }
                    self.loading = false
                }
            }
        
    }
    
    
}


struct ProvinceModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProvinceModalView(show: .constant(true), provinceId: .constant(0), provinceName: .constant(""),  onChangeProvince: .constant(true) ).environmentObject(ProviderApiService())
    }
}
