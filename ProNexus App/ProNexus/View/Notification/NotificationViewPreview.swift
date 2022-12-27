//
//  NotificationViewPreview.swift
//  ProNexus
//
//  Created by IMAC on 10/31/21.
//

import Foundation
import SwiftUI

struct NotificationViewPreview: View {
        
    // StateObject...
    @StateObject var profileData = ProfileDetailModel()
    
    var body: some View {

        NotificationView().environmentObject(UserApiService())
        // setting Environment Object...
            .environmentObject(profileData)
    }
}

struct NotificationViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        NotificationViewPreview()
    }
}
