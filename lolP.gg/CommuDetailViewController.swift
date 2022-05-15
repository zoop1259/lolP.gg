//. 복사용...
//  CommuDetailViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/02.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommuDetailViewController : UITableViewController {

    @IBOutlet var detailcommutableView: UITableView!
    
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
        
        tableView.register(CommuDetailCell.nib(), forCellReuseIdentifier: CommuDetailCell.identifier)
        tableView.register(CommuCommentCell.nib(), forCellReuseIdentifier: CommuCommentCell.identifier)
        tableView.register(CommuButtonCell.nib(), forCellReuseIdentifier: CommuButtonCell.identifier)
        
        //테이블뷰 설정
        tableView.rowHeight = UITableView.automaticDimension
        detailcommutableView.dataSource = self
        detailcommutableView.delegate = self
        detailcommutableView.estimatedRowHeight = 100.0
        getDetailBoard() //댓글 받아올 것.
        
    }
    
    // MARK: - 댓글 작성하고 정보 저장하기.
    func getDetailBoard() {
        //키값으로 게시글 찾기.
        if let commukey = commuKey {
            print("받은 커뮤키값 : \(commukey)")
            
            ref.child("board").child("create").observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String:Any] else { return }

                let commudetaildata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
                //print("게시글 데이터 ---> \(value.values)")
                do {
                    let decoder = JSONDecoder()
                    let usingcommudetailData = try decoder.decode([DetailBoard].self, from: commudetaildata)

                    print(usingcommudetailData)
                    
                    DispatchQueue.main.async {
                        self.detailcommutableView.reloadData()
                    }
                } catch let error {
                    print("게시글 로드 에러 : \(error.localizedDescription)")
                    print("정확한 에러 원인 : \(String(describing: error))")
                }
            }
        }
    }
    
    // MARK: - 테이블뷰 설정
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommuDetailCell", for: indexPath) as? CommuDetailCell else {
            return UITableViewCell()
            }
            cell.detailtitleLabel.text = self.detailtitle
            cell.detailtextLabel.text = self.detailtext
            cell.detailnicknameLabel.text = self.detailnickName
            cell.detaildateLabel.text = self.detailwriteDate
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommuCommentCell", for: indexPath) as? CommuCommentCell else {
            return UITableViewCell()
            }
                return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommuButtonCell", for: indexPath) as? CommuButtonCell else {
            return UITableViewCell()
            }
                
            return cell
        }

    }
}
