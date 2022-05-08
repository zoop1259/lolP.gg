//
//  DatabaseManager.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/05/08.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}

//account management
extension DatabaseManager {
    /// Inserts new user to database
    public func insertUser(with user: UserProfile, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "nick_name": user.nickName
//            "profile_picture_url: user.profilePictureUrl
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("DB에 쓰기 실패!")
                completion(false)
                return
            }
        })
    }
}

struct UserProfile {
    let emailAddress: String
    let nickName: String
    //크래시방지를 위해 .과 @를 -로 교체하여 데이터베이스에 저장.
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
    
}
