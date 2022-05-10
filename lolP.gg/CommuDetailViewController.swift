//
//  CommuDetailViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/02.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommuDetailViewController : UIViewController {
    
    @IBOutlet weak var detailtableView: UIView!
    

    var ref = Database.database().reference()
    
    //게시글 key값 받아오자.
    var commuKey : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDetailBoard()
        
    }
    
    func getDetailBoard() {
        
        //키값으로 게시글 찾기.
        if let commukey = commuKey {
        
         ref.child(commukey).observeSingleEvent(of: .value) { snapshot in
             guard let value = snapshot.value as? [String:Any] else { return }
        
             let boarddata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
             //print("게시글 데이터 ---> \(value.values)")
             do {
                 let decoder = JSONDecoder()
                 let usingBoardData = try decoder.decode([Board].self, from: boarddata)
                 self.boardList = usingBoardData
                 DispatchQueue.main.async {
                     self.commuTableView.reloadData()
                 }
             } catch let error {
                 print("게시글 로드 에러 : \(error.localizedDescription)")
             }
         }
        }
    }
    
    
}
