//
//  CartHeaderModel.swift
//  ProNexus
//
//  Created by thanh cto on 30/11/2021.
//

import Foundation
import Firebase

class CartHeaderModel: ObservableObject {
    
    @Published var cartCount = 0
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    // tao rom chat
    func saveCartCount(value: String, handler: @escaping (String) -> Void) {
        if (user != nil) {
            let docRef = db.collection("shoppingCarts").whereField("uuid", isEqualTo: user?.uid).limit(to: 1)
            docRef.getDocuments { (querysnapshot, error) in
                if error != nil {
                    print("Document Error: ", error!)
                } else {
                    //update
                    if let doc = querysnapshot?.documents, !doc.isEmpty {
                        let docId = doc.first?.documentID ?? ""
                        self.db.collection("shoppingCarts").document(docId).updateData([
                            "count" : value,
                        ]) { _ in
                            handler(docId)
                        }
                        
                    } else {
                        //create new
                        self.db.collection("shoppingCarts").addDocument(data: [
                            "uuid": self.user?.uid,
                            "count": 0
                        ]) { err in
                            if let err = err {
                                print("error adding document! \(err)")
                            } else {
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
}
