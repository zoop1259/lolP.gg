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

struct UserProfile:Codable {
    let nickName: String
}

struct Board:Codable {
    let title: String
    let nickName: String
    let text: String
    let uid: String
    let writeDate: String
    let recordTime: Int
    let keyValue: String
    let commentCount: Int
}


struct DetailBoard:Codable {
    let title: String
    let nickName: String
    let text: String
    let writeDate: String
    let keyValue: String
    //let commentCount: Int
}

struct CommentsBoard:Codable {
    let text: String
    let nickName: String
    let writeDate: String
    let recordTime: Int
    let uid: String
}
