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

class CommuDetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var detailcommutableView: UITableView!
    
    
    var ref = Database.database().reference()
    var detailBoard: [DetailBoard] = []
    
    //게시글 key값 받아오자.
    var commuKey : String?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailBoard()
    }
    
    // MARK: - 게시글 받아오기
    func getDetailBoard() {
        
        //키값으로 게시글 찾기.
        if let commukey = commuKey {
        
         ref.child(commukey).observeSingleEvent(of: .value) { snapshot in
             guard let value = snapshot.value as? [String:Any] else { return }
             
             
             let commudetaildata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
             //print("게시글 데이터 ---> \(value.values)")
                do {
                    let decoder = JSONDecoder()
                    let usingcommudetailData = try decoder.decode([DetailBoard].self, from: commudetaildata)
                    self.detailBoard = usingcommudetailData
//                    DispatchQueue.main.async {
//                        self.detailtableView.reloadData()
//                    }
                } catch let error {
                    print("게시글 로드 에러 : \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - 테이블뷰 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailcommunityCell", for: indexPath) as? DetailCommuCell else {
        return UITableViewCell()
    }
        
        
        return cell
    }
    
    
}


// MARK: - 셀 클래스들
class DetailCommuCell: UITableViewCell {
    @IBOutlet weak var detailtitleLabel: UILabel!
    @IBOutlet weak var detailnickName: UILabel!
    @IBOutlet weak var detailwriteDate: UILabel!
    @IBOutlet weak var detailtextLabel: UILabel!
    
    //댓글셀을 한 클래스 셀에 만들어버리고싶음.

}

//이건 댓글셀
class DetailCommentCell: UITableViewCell {
    @IBOutlet weak var detailcommentLabel: UILabel!
}
