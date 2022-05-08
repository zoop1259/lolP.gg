//
//  StorageManager.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/05/08.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    /*
     이미지경로는 대략
     /images/이메일아이디_profile_picture.png
     */
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    /// url String으로 다운로드하여 파이어베이스 storage에 사진 업로드
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion:  { matadata, error in
            guard error == nil else {
                //실패시
                print("사진업로드 실패")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("다운로드 url : \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
}
