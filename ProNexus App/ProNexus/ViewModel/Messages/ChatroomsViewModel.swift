//
//  ChatroomsViewModel.swift
//  ProNexus
//
//  Created by thanh cto on 20/11/2021.
//

import Foundation
import Firebase
import Combine

struct Chatroom: Codable, Identifiable {
    var id: String
    var latestMessage: String
    var latestTime: String
    var fromUserId: String
    var fromUserAvatar: String
    var fromUserName: String
    var toUserName: String
    var toUserAvatar: String
    var toUserId: String
    var latestMessageId: String?
}


class ChatroomsViewModel: ObservableObject {
    
    @Published var chatrooms = [Chatroom]()
    private let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    @Published var userId = ""
    
    private var disposeBag = Set<AnyCancellable>()
    
    @Published var text: String = ""
    @Published var isSearch: Bool = false
    
    func searchDataFromUserRole(fromId: String, searchKey: String) {
        if (user != nil && !fromId.isBlank) {
            db.collection("chatrooms")
                .whereField("tags", arrayContains: searchKey.convertToKey)
//                .whereField("users", arrayContains: fromId)
                .whereField("fromUserId", isEqualTo: fromId)
//                .whereField("roomId", isLessThan: fromId + "~")
                .addSnapshotListener({(snapshot, error) in
                    guard let documents = snapshot?.documents else {
                        print ("no docs returned!")
                        self.isSearch.toggle()
                        return
                    }
                    self.isSearch.toggle()
                    self.chatrooms = documents.map({docSnapshot -> Chatroom in
                        let data = docSnapshot.data()
                        let docId = docSnapshot.documentID
                        return self.mapData(docId: docId, data: data)
                    })
                })
        } else {
            self.isSearch.toggle()
            print("không get được thông tin user firebase")
        }
    }
    
    func searchDataFromAdvisorRole(fromId: String, searchKey: String) {
        if (user != nil && !fromId.isBlank) {
            db.collection("chatrooms")
                .whereField("tags", arrayContains: searchKey.convertToKey)
//                .whereField("users", arrayContains: fromId)
                .whereField("toUserId", isEqualTo: fromId)
//                .whereField("roomId", isLessThan: fromId + "~")
                .addSnapshotListener({(snapshot, error) in
                    guard let documents = snapshot?.documents else {
                        print ("no docs returned!")
                        return
                    }
                    
                    self.chatrooms = documents.map({docSnapshot -> Chatroom in
                        let data = docSnapshot.data()
                        let docId = docSnapshot.documentID
                        return self.mapData(docId: docId, data: data)
                    })
                })
        } else {
            print("không get được thông tin user firebase")
        }
    }
    

    func listAll(fromId: String) {
        if (user != nil) {
            db.collection("chatrooms")
                .whereField("users", arrayContains: fromId)
                .addSnapshotListener({(snapshot, error) in
                    guard let documents = snapshot?.documents else {
                        print ("no docs returned!")
                        return
                    }
                    
                    self.chatrooms = documents.map({docSnapshot -> Chatroom in
                        let data = docSnapshot.data()
                        let docId = docSnapshot.documentID
                        return self.mapData(docId: docId, data: data)
                    })
                })
        } else {
            print("không get được thông tin user firebase")
        }
    }
    
    func mapData(docId: String, data: [String: Any]) -> Chatroom {
        let latestMsg = data["latestMessage"] as? String ?? ""
        
        let fromUserId = data["fromUserId"] as? String ?? ""
        let fromUserAvatar = data["fromUserAvatar"] as? String ?? ""
        let fromUserName = data["fromUserName"] as? String ?? ""
        
        let toUserName = data["toUserName"] as? String ?? ""
        let toUserAvatar = data["toUserAvatar"] as? String ?? ""
        let toUserId = data["toUserId"] as? String ?? ""
        
        let latestTimeStr = String((data["latestTime"] as? Int64 ?? 0) * 1000)
        
        let latestTime = Date(fromString: "/Date(\(latestTimeStr))/", format: .dotNet) ?? Date()
        
        return Chatroom(id: docId,
                        latestMessage: latestMsg,
                        latestTime: latestTime.getTimeAgo(),
                        fromUserId: fromUserId,
                        fromUserAvatar: fromUserAvatar,
                        fromUserName: fromUserName,
                        toUserName: toUserName,
                        toUserAvatar: toUserAvatar,
                        toUserId: toUserId
        )
    }
    
    // tao rom chat
    func createChatroom(fromUserId: String,
                        fromUserName: String,
                        fromUserAvatar:String,
                        toUserName: String,
                        toUserId: String,
                        toUserAvatar: String, handler: @escaping (String) -> Void) {
        
        let arr1 = fromUserName.components(separatedBy: " ")
        let arr2 = toUserName.components(separatedBy: " ")
        
        var tags: [String] = []
        
        for i in arr1 {
            tags.append(i.convertToKey)
        }
        
        for y in arr2 {
            tags.append(y.convertToKey)
        }

        
        
        self.user = Auth.auth().currentUser
        if (user != nil) {
            //check exist room
            let roomId = fromUserId + "_" + toUserId
            var docId = ""
            let docRef = db.collection("chatrooms").whereField("roomId", isEqualTo: roomId).limit(to: 1)
            docRef.getDocuments { (querysnapshot, error) in
                if error != nil {
                    print("Document Error: ", error!)
                } else {
                    //update
                    if let doc = querysnapshot?.documents, !doc.isEmpty {
                        docId = doc.first?.documentID ?? ""
                        self.db.collection("chatrooms").document(docId).updateData([
                            "tags": tags,
//                            "latestTime" : Date.currentTimeStamp,
//                            "toUserAvatar": toUserAvatar,
//                            "fromUserName": fromUserName,
//                            "fromUserAvatar": fromUserAvatar,
                        ]) { _ in
                            handler(docId)
                        }
                        handler(docId)
                        
                    } else {
                        self.db.collection("chatrooms").addDocument(data: [
                            "tags": tags,
                            "joinCode": Date.currentTimeStamp,
                            "roomId": roomId,
                            "lastMessage": "",
                            "latestTime" : Date.currentTimeStamp,
                            "toUserId": toUserId,
                            "toUserName": toUserName,
                            "toUserAvatar": toUserAvatar, 
                            "fromUserId": fromUserId,
                            "fromUserName": fromUserName,
                            "fromUserAvatar": fromUserAvatar,
                            "users": [fromUserId, toUserId]]) { err in
                                if let err = err {
                                    print("error adding document! \(err)")
                                } else {
                                    //lay id sau khi tao document
                                    let docRef = self.db.collection("chatrooms").whereField("roomId", isEqualTo: roomId).limit(to: 1)
                                    docRef.getDocuments { (querysnapshot, error) in
                                        if error != nil {
                                            print("Document Error: ", error!)
                                        } else {
                                            if let doc = querysnapshot?.documents, !doc.isEmpty {
                                                print("Document is present.", doc.first?.documentID)
                                                docId = doc.first?.documentID ?? ""
                                                handler(docId)
                                            }
                                        }
                                    }
                                }
                            }
                    }
                }
            }
        } else {
            print("user firebase is null")
        }
    }
    
    func joinChatroom(userId: String, code: String, handler: @escaping () -> Void) {
        if (user != nil) {
            db.collection("chatrooms").whereField("joinCode", isEqualTo: Int(code)).getDocuments() { (snapshot, error) in
                if let error = error {
                    print("error getting documents! \(error)")
                } else {
                    for document in snapshot!.documents {
                        self.db.collection("chatrooms").document(document.documentID).updateData([
                            "users": FieldValue.arrayUnion([userId])])
                        handler()
                    }
                }
                
            }
        }
    }
    
}
