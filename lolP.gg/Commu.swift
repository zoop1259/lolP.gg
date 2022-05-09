//
//  Commu.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/04/19.
//

import Foundation

//게시글과 댓글로 이루어진 섹션 2개

struct Board: Codable {

    let note: [String: BoardNote]
    let comment: [BoardComment]
    
}

/*
 struct MainData: Codable {
     let data: [String: ChampData]
 }
    
 // MARK: - ChampData
 struct ChampData: Codable {
     let id, key, name: String
 }
 */

struct BoardNote: Codable {
    var uidString: String //
    var title: String //제목
    var contents: BoardComment //댓글관련
    var date: Int //날짜
    var commentCount: Int //댓글 수
    var noteText: String //본문 내용
}

struct BoardComment: Codable {
    var uuidString: String
    var contents: String
    //var date: Date
}


