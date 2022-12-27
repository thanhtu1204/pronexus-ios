//
//  PreviewDemo.swift
//  ProNexus
//
//  Created by thanh cto on 18/11/2021.
//

import SwiftUI

import SwiftUI

struct SampleView: View {
    
    var body: some View {
        Text("Hello World!")
    }
}

// Show just 1 iPhone
struct SampleView_Previews_iPhoneXSMax: PreviewProvider {
    static var previews: some View {
        SampleView()
            .previewDevice(PreviewDevice(rawValue: AllDeviceNames.iPhoneXsMax.rawValue))
            .previewDisplayName(AllDeviceNames.iPhoneXsMax.rawValue)
    }
}

// Show 2 iPhones
struct SampleView_Previews_iPhoneXsMaxAndXs: PreviewProvider {
    static var previews: some View {
        ForEach([AllDeviceNames.iPhoneXs.rawValue, AllDeviceNames.iPhoneXsMax.rawValue], id: \.self) { devicesName in
            SampleView()
                .previewDevice(PreviewDevice(rawValue: devicesName))
                .previewDisplayName(devicesName)
        }
    }
}

// Show an iPhone and an iPad
struct SampleView_Previews_iPhoneXsMaxAndiPad: PreviewProvider {
    static var previews: some View {
        ForEach([AllDeviceNames.iPhoneXsMax.rawValue, AllDeviceNames.iPadPro_11.rawValue], id: \.self) { devicesName in
            SampleView()
                .previewDevice(PreviewDevice(rawValue: devicesName))
                .previewDisplayName(devicesName)
        }
    }
}

// Show all iPhones
struct SampleView_Previews_AlliPhones: PreviewProvider {
    static var previews: some View {
        ForEach(iPhoneDeviceNames.all, id: \.self) { devicesName in
            SampleView()
                .previewDevice(PreviewDevice(rawValue: devicesName))
                .previewDisplayName(devicesName)
        }
    }
}

// Show all iPads
struct SampleView_Previews_AlliPads: PreviewProvider {
    static var previews: some View {
        ForEach(iPadDeviceNames.all, id: \.self) { devicesName in
            SampleView()
                .previewDevice(PreviewDevice(rawValue: devicesName))
                .previewDisplayName(devicesName)
        }
    }
}
