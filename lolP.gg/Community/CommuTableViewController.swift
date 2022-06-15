//
//  CommuTableViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/11/30.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var commuTableView: UITableView!
    
    var ref = Database.database().reference()
    var titleList = [String]()
    var boardList: [Board] = []
    var autoidList: [FBAutoid] = []
    var keyarr = [String]()
    var keystring = String()
    var testarr = String() //키 값을 확인하기 string
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref.child("board").observeSingleEvent(of: .value) { snapshot in
            //self.getAutoId()
            self.getBoardData()
        }
    }
    
    
    //로그인이 되었는지 확인하고 로그인이 되었으면 글쓰기 화면으로.
    @IBAction func tapWriteBtn(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            self.showCommuCreateViewController()
        } else {
            let confirm = UIAlertController(title: "로그인이 필요합니다.", message: "로그인 해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {_ in
                self.dismiss(animated: true, completion: nil)
            }
            confirm.addAction(okAction)
            self.present(confirm, animated: false, completion: nil)
        }
    }
    
    private func showCommuCreateViewController() {
        let mystoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let createViewController = mystoryboard.instantiateViewController(identifier: "ShowCommuCreateViewController")
        //이방법은 로그인창까지 겹쳐서 올라옴.
        self.show(createViewController, sender: self)
        //로그인창을 닫으면서 정보창 띄우기.
//        guard let pvc = self.presentingViewController else { return }
//        self.dismiss(animated: true) {
//            pvc.present(DetailViewController, animated: true, completion: nil)
//        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return boardList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as? CommunityCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = boardList[indexPath.row].title
        cell.dateLabel.text = boardList[indexPath.row].writeDate
        cell.userLabel.text = boardList[indexPath.row].nickName
        
        let commentText: String = "\(boardList[indexPath.row].commentCount)"
        print("댓글 수 : \(commentText)")
        
        //cell.commentLabel.text = boardList[indexPath.row].commentCount
        cell.commentLabel.text = commentText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CommuDetailViewController") as? CommuDetailViewController else { return }
        //이동! = 얘는 이동을 수동으로 시켜줘야함.
        //viewController.commuKey = self.testarr
        viewController.commuKey = boardList[indexPath.row].keyValue
        viewController.detailtitle = boardList[indexPath.row].title
        viewController.detailtext = boardList[indexPath.row].text
        viewController.detailwriteDate = boardList[indexPath.row].writeDate
        viewController.detailnickName = boardList[indexPath.row].nickName
        viewController.detailuid = boardList[indexPath.row].uid
        //디테일뷰call
        show(viewController, sender: nil)
    }
    
    //게시글 가져오기.
    func getBoardData() {
        ref.child("board").child("create").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String:Any] else { return }
            for snapshotkey in value.keys {
                self.testarr = snapshotkey
            }
            let boarddata = try! JSONSerialization.data(withJSONObject: Array(value.values), options: [])
            //print("게시글 데이터 ---> \(value.values)")
            
            do {
                let decoder = JSONDecoder()
                let usingBoardData = try decoder.decode([Board].self, from: boarddata)
                self.boardList = usingBoardData
                self.boardList.sort(by: {$0.recordTime > $1.recordTime})
                DispatchQueue.main.async {
                    self.commuTableView.reloadData()
                }
            } catch let error {
                print("게시글 로드 에러 : \(error.localizedDescription)")
            }
        }
    }
    //MARK: - 로그인창
    @IBAction func profileBtn(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            print("유저정보화면")
            self.showDetailViewController()
        } else {
            print("로그인화면")
            self.showLoginPopupViewController()
        }
    }
    
    private func showDetailViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginDetailView") as! LoginDetailView
        present(vc, animated: true, completion: nil)
    }
    
    private func showLoginPopupViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPopupViewController") as! LoginPopupViewController
        present(vc, animated: true, completion: nil)
    }
    
}
//MARK: - Cell
class CommunityCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
        
}
