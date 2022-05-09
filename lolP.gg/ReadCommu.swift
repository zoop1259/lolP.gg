//
//  ReadCommu.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/05/09.
//


/*
 
import Foundation
import Firebase

class ReadData {
    private let ref: DatabaseReference! = Database.database().reference()
    
    var boardNote: [BoardNote]
    var boardComment: [BoardComment]
    
    init(userIndex: Int) {
        boardNote = [BoardNote]()
        boardComment = [BoardComment]()
        
        self.getAllData(userIndex)
    }
    
    private func getAllData(_ userIndex: Int) {
        ref.queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            // user
//            let userDataSnapshot = snapshot.childSnapshot(forPath: "user").childSnapshot(forPath: String(userIndex))
//            let userItem = userDataSnapshot.value as? NSDictionary
//            self.user.pS = userItem?["key1"] as? String ?? "No string"
//            self.user.pI = userItem?["key2"] as? Int ?? -1
//            self.user.pB = userItem?["key3"] as? Bool ?? false
            
            // arr1
            for child in snapshot.childSnapshot(forPath: "collection1").children {
                let dataSnapshot = child as? DataSnapshot
                let item = dataSnapshot?.value as? NSDictionary
                self.boardNote.append(BoardNote(
                    uidString: item?["uidString"] as? String ?? "별명없는사람"
                    title: item?["title"] as? String ?? "무제"
                    date: item?["date"] as? Int ?? "00-00-00"
                    commentCount: item?["commentCount"] as? Int ?? ""
                    noteText: item?["noteText"] as? String ?? "내용무"
                ))
            }
            
//            struct BoardNote {
//                var uidString: String //
//                var title: String //제목
//                var contents: BoardComment //댓글관련
//                var date: Int //날짜
//                var commentCount: Int //댓글 수
//                var noteText: String //본문 내용
//            }
            
            
            // arr2
//            for child in snapshot.childSnapshot(forPath: "collection2").children {
//                let dataSnapshot = child as? DataSnapshot
//                let item = dataSnapshot?.value as? NSDictionary
//                if(item?["userIndex"] as! Int == userIndex) {
//                    self.boardComment.append(BoardComment(
//                        collectionIndex: Int(dataSnapshot?.key ?? "-1")!,
//                        p1: item?["key1"] as? String ?? "No string",
//                        p2: item?["key2"] as? Int ?? -1
//                    ))
//                }
//            }
            
            self.printData()
        })
    }
    
    public func printData() {
//        print("* user")
//        let pSStr = "pS: " + self.user.pS
//        let pIStr = ", pI: " + String(self.user.pI)
//        let pBStr = ", pB: " + String(self.user.pB)
//        print(pSStr + pIStr + pBStr)
        print("* BoardNote")
        for element in self.boardNote {
            print("p: " + String(element.p))
        }
//        print("* arr2")
//        for element in self.boardComment {
//            let collectionIndexStr = "collectionIndex: " + String(element.collectionIndex)
//            let p1Str = ", p1: " + element.p1
//            let p2Str = ", p2: " + String(element.p2)
//            print(collectionIndexStr + p1Str + p2Str)
//        }
    }
}

*/
