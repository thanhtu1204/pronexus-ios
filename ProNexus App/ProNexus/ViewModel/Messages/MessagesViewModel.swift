//
//  MessagesViewModel.swift
//  ProNexus
//
//  Created by thanh cto on 20/11/2021.
//

import Foundation
import Firebase
import PromiseKit
import Combine

struct Message: Codable, Identifiable, Hashable {
    var id: String?
    var msgId: String
    var content: String
    var name: String
    var sentAt: String
    var sender: String
}

class MessagesViewModel: ObservableObject {
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    @Published var isSearch: Bool = false
    
    let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error firebase"])
    
    func sendMessage(fromId: String, message: String, docId: String) {
        if (user != nil) {
            
            let arr1 = message.components(separatedBy: " ")
            
            var tags: [String] = []
            
            for i in arr1 {
                tags.append(i.convertToKey)
            }
            
            
            let msgId = Date.currentTimeInMilliSeconds
            db.collection("chatrooms").document(docId).collection("messages").addDocument(data: [
                "sentAt": Date.currentTimeStamp,
                "msgId": msgId,
//                "displayName": user!.email,
                "tags": tags,
                "content": message,
                "sender": fromId])
            
            db.collection("chatrooms").document(docId).updateData([
                "latestMessage" : message,
                "latestMessageId" : msgId,
                "latestTime" : Date.currentTimeStamp,
//                "toUserAvatar": //TODO: cap nhat avt khi sent msg
            ])
//            self.latestMessageId = String(msgId)
        }
    }
    
    func getRoomDetail(docId: String) -> Promise<Chatroom> {
        return Promise { promise in
            if (user != nil) {
                db.collection("chatrooms").document(docId).getDocument { (document, error) in
                    if let data = document?.data()
                    {
                        let chatRoom = self.mapData(docId: docId, data: data)
                        
                        promise.fulfill(chatRoom)
                    }
                }
            } else
            {
                promise.reject(error)
            }
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
    
    func fetchData(docId: String, searchKey: String) -> Promise<[Message]> {
        if searchKey.count > 0 {
            return Promise { promise in
                if (user != nil) {
                    db.collection("chatrooms").document(docId).collection("messages")
                        .whereField("tags", arrayContains: searchKey.convertToKey)
    //                    .order(by: "sentAt", descending: false)
    //                    .whereField("content", isGreaterThanOrEqualTo: searchKey)
    //                    .whereField("content", isLessThan: searchKey + "~")
                        .addSnapshotListener({(snapshot, error) in
                        guard let documents = snapshot?.documents else {
                            print("no documents")
                            self.isSearch.toggle()
                            promise.fulfill([Message]())
                            return
                        }
                            self.isSearch.toggle()
                            let messages = documents.map { docSnapshot -> Message in
                            let data = docSnapshot.data()
                            let docId = docSnapshot.documentID
                            let msgId = data["msgId"] as? Int64 ?? 0
                            let content = data["content"] as? String ?? ""
                            let displayName = data["displayName"] as? String ?? ""
                            let sender = data["sender"] as? String ?? ""
                            let sentAtStr = String((data["sentAt"] as? Int64 ?? 0) * 1000)
    //                        print("sendAtStr", sentAtStr)
                            let sentAt = Date(fromString: "/Date(\(sentAtStr))/", format: .dotNet) ?? Date()
    //                        print("/Date(\(sentAtStr))/")
                            return Message(id: docId, msgId: String(msgId), content: content, name: displayName, sentAt: sentAt.getTimeAgo(), sender: sender)
                        }
                            promise.fulfill(messages)
                    })
                }
                else
                {
                    promise.reject(error)
                }
            }
        } else {
            return Promise { promise in
                if (user != nil) {
                    db.collection("chatrooms").document(docId).collection("messages")
//                        .whereField("tags", arrayContains: searchKey.convertToKey)
                        .order(by: "sentAt", descending: false)
    //                    .whereField("content", isGreaterThanOrEqualTo: searchKey)
    //                    .whereField("content", isLessThan: searchKey + "~")
                        .addSnapshotListener({(snapshot, error) in
                        guard let documents = snapshot?.documents else {
                            print("no documents")
                            self.isSearch.toggle()
                            promise.fulfill([Message]())
                            return
                        }
                            self.isSearch.toggle()
                            let messages = documents.map { docSnapshot -> Message in
                            let data = docSnapshot.data()
                            let docId = docSnapshot.documentID
                            let msgId = data["msgId"] as? Int64 ?? 0
                            let content = data["content"] as? String ?? ""
                            let displayName = data["displayName"] as? String ?? ""
                            let sender = data["sender"] as? String ?? ""
                            let sentAtStr = String((data["sentAt"] as? Int64 ?? 0) * 1000)
    //                        print("sendAtStr", sentAtStr)
                            let sentAt = Date(fromString: "/Date(\(sentAtStr))/", format: .dotNet) ?? Date()
    //                        print("/Date(\(sentAtStr))/")
                            return Message(id: docId, msgId: String(msgId), content: content, name: displayName, sentAt: sentAt.getTimeAgo(), sender: sender)
                        }
                            promise.fulfill(messages)
                    })
                }
                else
                {
                    promise.reject(error)
                }
            }
        }
        
    }
}
