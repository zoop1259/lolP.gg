//
//  Commu.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/04/19.
//

import Foundation

struct FBAutoid:Codable {
    let fbautoid: String
}

struct Board:Codable {
    let title: String
    let nickName: String
    let text: String
    let uid: String
    let writeDate: String
    let recordTime: Int
}

struct DetailBoard:Codable {
    let title: String
    let nickName: String
    let text: String
    //let uid: String
    let writeDate: String
    //let recordTime: Int
}

struct FBUser:Codable {
    let nickName: String
}


//
////게시글과 댓글로 이루어진 섹션 2개
//
///*
// struct MainData: Codable {
//     let data: [String: ChampData]
// }
//
// // MARK: - ChampData
// struct ChampData: Codable {
//     let id, key, name: String
// }
// */
//
//struct Board: Codable {
//
//    let note: [String: BoardNote]
//    let comment: [BoardComment]
//
//}
//
//struct BoardNote: Codable {
//    var uidString: String //
//    var title: String //제목
//    var contents: BoardComment //댓글관련
//    var date: Int //날짜
//    var commentCount: Int //댓글 수
//    var noteText: String //본문 내용
//}
//
//struct BoardComment: Codable {
//    var uuidString: String
//    var contents: String
//    //var date: Date
//}
//

