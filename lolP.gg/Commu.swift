//
//  Commu.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/04/19.
//

import Foundation

//게시글과 댓글로 이루어진 섹션 2개
enum SettingSection {
    case Board([Board])
    case Comment([Comment])
}

struct Board {
    var uuidString: String //고유한 uuid를 생성. 근데 이방식은 다른아이디로 로그인해도 똑같음..
    var title: String //제목
    var contents: String //내용
    var date: Date //날짜
    var commentCount: Int //댓글 수
}

struct Comment {
    var uuidString: String
    var contents: String
    var date: Date
}


