//
//  ImagePickerExampleView.swift
//  ProNexus
//
//  Created by thanh cto on 15/11/2021.
//

import SwiftUI

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    public func toBase64(format: ImageFormat = .jpeg(1)) -> String? {
        var imageData: Data?

        switch format {
        case .png:
            imageData = self.pngData()
        case .jpeg(let compression):
            imageData = self.jpegData(compressionQuality: compression)
        }

        return imageData?.base64EncodedString()
    }
}

extension Data {
    var fileExtension: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)

        let ext: String
        switch (values[0]) {
        case 0xFF:
            ext = ".jpg"
        case 0x89:
            ext = ".png"
        case 0x47:
            ext = ".gif"
        case 0x49, 0x4D :
            ext = ".tiff"
        default:
            ext = ".png"
        }
        return ext
    }
}

struct ImagePickerExampleView: View {
    
    @State var showImagePicker: Bool = false
    @State var imagePreview: UIImage?
    @State var base64: String = ""

        var body: some View {
            VStack {
                if imagePreview != nil {
                    Image(uiImage: imagePreview!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                Button("Pick image") {
                    self.showImagePicker.toggle()
                }
                
                Text(base64)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(sourceType: .photoLibrary) { image in
                    imagePreview = image
                    base64 = imagePreview?.toBase64(format: .jpeg(1)) ?? ""
                }
            }
        }
}


struct ImagePickerExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerExampleView()
    }
}
