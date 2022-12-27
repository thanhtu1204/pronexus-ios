//
//  LoggerModel.swift
//  ProNexus
//
//  Created by thanh cto on 03/12/2021.
//

import Foundation
import Firebase
import Combine

struct LoggerModel: Codable, Identifiable {
    var id = UUID()
    var name: String
    var platform: String?
    var message: String?
    var createAt: String?
    var userId: String?
}


class LoggerModelViewModel: ObservableObject {
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    
    // save Log
    func saveLog(userId: String, name: String, message: String, handler: @escaping () -> Void) {
        if (user != nil) {
            //check exist room
            //create new
            self.db.collection("AppLogs").addDocument(data: [
                "userId": userId,
                "name": name,
                "message": message,
                "createAt" : Date().toString(format: .custom("dd MM yyyy HH:mm:ss"))
                ]) { err in
                    if let err = err {
                        print("error adding document! \(err)")
                    } else {
                       handler()
                    }
                }
        }
    }
    
    
    //    func searchData(fromId: String, searchKey: String) {
    //        if (user != nil) {
    //            db.collection("chatrooms")
    //                .whereField("users", arrayContains: fromId)
    //                .whereField("title", isGreaterThanOrEqualTo: searchKey)
    //                .whereField("title", isLessThan: searchKey + "~")
    //                .addSnapshotListener({(snapshot, error) in
    //                    guard let documents = snapshot?.documents else {
    //                        print ("no docs returned!")
    //                        return
    //                    }
    //
    //                    self.chatrooms = documents.map({docSnapshot -> Chatroom in
    //                        let data = docSnapshot.data()
    //                        let docId = docSnapshot.documentID
    //                        let title = data["title"] as? String ?? ""
    //                        let latestMsg = data["latestMessage"] as? String ?? ""
    //                        let toUserAvatar = data["toUserAvatar"] as? String ?? ""
    //                        let fromUserAvatar = data["fromUserAvatar"] as? String ?? ""
    //                        let fromUserName = data["fromUserName"] as? String ?? ""
    //
    //                        let latestTimeStr = String((data["latestTime"] as? Int64 ?? 0) * 1000)
    //
    //                        let latestTime = Date(fromString: "/Date(\(latestTimeStr))/", format: .dotNet) ?? Date()
    //                        return Chatroom(id: docId, title: title, latestMessage: latestMsg, latestTime: latestTime.toString(format: .custom("h:mm a")), toUserAvatar: toUserAvatar, fromUserAvatar: fromUserAvatar, fromUserName: fromUserName)
    //                    })
    //                })
    //        }
    //    }
    
}
