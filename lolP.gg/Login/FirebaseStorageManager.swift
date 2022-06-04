//
//  FirebaseStorageManager.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/06/03.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseDatabase

class FirebaseStorageManager {
    //db
    static func uploadImage(image: UIImage, pathRoot: String, completion: @escaping (URL?) -> Void) {
        let ref = Database.database().reference()
        guard let user = Auth.auth().currentUser else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
//        ref.child("users").child(user.uid).updateChildValues(["imgURL" : url ])
        let firebaseReference = Storage.storage().reference().child("\(user.uid)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    /*
     Storage.storage().reference().child("userImages").child(uid!).putData(image!, metadata: nil) { (data, err) in
         
         print("data fetch")
         Storage.storage().reference().child("userImages").child(uid!).downloadURL { (url, err) in
             print("url fetch")
             Database.database().reference().child("users").child(uid!).setValue(["name":self.name.text,"profileImageUrl":url?.absoluteString])
         }
     */
    
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
}
