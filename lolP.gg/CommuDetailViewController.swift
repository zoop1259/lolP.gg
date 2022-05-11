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
    
    //게시글 key값 받아오자. 주후에 댓글에 쓸것.
    var commuKey : String?
    
    //게시글 값 받아오기
    var detailtitle : String?
    var detailtext : String?
    var detailwriteDate : String?
    var detailnickName : String?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        detailcommutableView.dataSource = self
        detailcommutableView.delegate = self
        
        detailcommutableView.estimatedRowHeight = 100.0
        detailcommutableView.rowHeight = UITableView.automaticDimension
        
        //getDetailBoard() //댓글 받아올 것.
        
    }
    
    // MARK: - 댓글 받아오기
    func getDetailBoard() {
        //키값으로 게시글 찾기.
        if let commukey = commuKey {
            print("받은 커뮤키값 : \(commukey)")
         
            ref.child("board").child(commukey).observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String:Any] else { return }

                let commudetaildata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
             print("게시글 데이터 ---> \(value.values)")
                do {
                    let decoder = JSONDecoder()
                    let usingcommudetailData = try decoder.decode(DetailBoard.self, from: commudetaildata)

                    print(usingcommudetailData)

                    DispatchQueue.main.async {
                        self.detailcommutableView.reloadData()
                    }

                    print("--->커뮤디테일 : \(self.detailBoard)")
                } catch let error {
                    print("게시글 로드 에러 : \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    // MARK: - 테이블뷰 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCommuCell", for: indexPath) as? DetailCommuCell else {
        return UITableViewCell()
    }
        cell.detailtitleLabel.text = self.detailtitle
        cell.detailtextLabel.text = self.detailtext
        cell.detailnickNameLabel.text = self.detailnickName
        cell.detailwriteDateLabel.text = self.detailwriteDate
        
        return cell
    }
    
    //섹션 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //셀 오토사이징
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}


// MARK: - 셀 클래스들
//이건 댓글셀

class DetailCommuCell: UITableViewCell {
    @IBOutlet weak var detailtitleLabel: UILabel!
    @IBOutlet weak var detailtextLabel: UILabel!
    @IBOutlet weak var detailnickNameLabel: UILabel!
    @IBOutlet weak var detailwriteDateLabel: UILabel!
}

class DetailCommentCell: UITableViewCell {
    @IBOutlet weak var detailcommentLabel: UILabel!
    @IBOutlet weak var detailcommentnickNameLabel: UILabel!
    @IBOutlet weak var detailcommentdateLabel: UILabel!
}
