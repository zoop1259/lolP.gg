import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    let nameList = ["가렌", "갈리오", "갱플랭크","갱플랭크","갱플랭크","갱플랭크"]
    var nameArr = [String]()

    @IBOutlet var CollectionViewMain: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchIndicator: UIActivityIndicatorView!
    
    
    

    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //서치바의 라인 삭제
        //self.searchBar.searchBarStyle = .minimal
    
        //ui설정
        self.config()
        

        getinfo()
    }
    
    //MARK: -- prepare method 데이터 넘겨주기.
    //1. 메인 화면에 챔피언 이름과 사진을 받아와야함.
    //2. 메인화면의 챔피언 이름과 사진을 디테일화면에 넘겨줘야함.
    //3. 디테일 화면에서는 스킬정보를 받아와야함.
    //4. 끗....
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("VC - prepare() called / segue.identifier : \(segue.identifier)")
    
    }
    
    //MARK: -- Collection View delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    
            return nameArr.count
        //return nameList.count
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = CollectionViewMain.dequeueReusableCell(withReuseIdentifier: "champList", for: indexPath) as? ChampList else {
            return UICollectionViewCell()
        }
        
//                챔피언 이미지 밑에 챔피언명을 출력해야함.
        cell.nameLabel.text = nameArr[(indexPath as NSIndexPath).item]


        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemSpacing: CGFloat = 5 // 가로에서 cell과 cell 사이의 거리
//        let textAreaHeight: CGFloat = 20 // textLabel이 차지하는 높이
//        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2 // 셀 하나의 너비
//        let height: CGFloat = width * 10/7 + textAreaHeight //셀 하나의 높이
//
//        return CGSize(width: width, height: height)
//    }
    
    func getinfo() {

        var idArr = [String]()
        var krnameArr = [String]()
        var allArr = [String]()
        
        AF.request("http://ddragon.leagueoflegends.com/cdn/11.23.1/data/ko_KR/champion.json").responseJSON { response in

            if let value = response.value as? [String: AnyObject] {
                //모든값
    //            print(value)
                //type, format, version를 제외하고 data안에 있는 모든 값
                if let datas = value["data"] as? [String : AnyObject] {
                    //print(datas)
                    //데이타 정렬
                    let dataskey = datas.keys.sorted(by: <) // ahry brand camil....
                    for i in dataskey {
                        self.nameArr.append(i)
                    }
                    
                    
                        
//                    for j in datas {
//                        idArr.append(j["id"] as! String)
//                        krnameArr.append(j["name"] as! String)
//                    }
                    
//                    if let namedata = datas["Aatrox"] as? [String : AnyObject] {
//                        //print(namedata)
//                    }
                }
                
                
                DispatchQueue.main.async {
                    //이것이 4번 통보하는 법. reloadData
                    self.CollectionViewMain.reloadData()
                }
                //print(self.nameArr)
                //print(idArr)
                //print(krnameArr)
                
                
    //            for (key, value) in value {
    //                print(key)
    //            }
                
                //정렬인데.. 못써먹을듯.
    //            let order = value.keys.sorted(by: <)
    //            print(order)
    //            let order = value.values.sorted(by: <)
    //            print(order)
    //            let order = value.sorted(by: <)
            }
        }
    }

    fileprivate func config() {
        //스토리보드에 존재하는 라이브러리들은 VC로 직접 델리게이트를 설정해줄수있지만 제스처는 그렇지 않으므로 코드로 델리게이트 선언
        self.keyboardDismissTabGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTabGesture)

    }
    
    //버튼이 클릭되었을때?
    @IBAction func onSearchButtonClicked(_ sender: Any) {
        print("검색버튼 터치")
        

        
    }
    
    //MARK: - UISearchBar Delegate methods
    //서치바에 입력된 텍스트를 가져옴
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("VC - searchBarSearchButtonClicked()")
        
        guard let userInputString = searchBar.text else { return }
        
        if userInputString.isEmpty {
            self.view.makeToast("❌키워드를 입력해주세요", duration: 1.0, position: .center)
        }
        //여기서 이제 챔피언 필터링이 들어가야할거같다.
//        else {
//
//        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("VC - 서치바 텍스트변경 : \(searchText)")
        
        // 사용자가 입력한 값이 없을때 키보드 내림
        if (searchText.isEmpty) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                searchBar.resignFirstResponder() //포커싱해제
            })
        } else {
            self.searchButton.isHidden = false
        }
    }
    
    //앱키자마자 키보드 뜨게하기.
//    override func viewDidAppear(_ animated: Bool) {
//        self.searchBar.becomeFirstResponder() // 포커싱주기
//    }
    
    
    //글자가 입력될 때
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //언래핑을 통해 카운트 감지
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        if (inputTextCount >= 15) {
            // 토스트 라이브러리 사용
            self.view.makeToast("❌15자 이하로 입력해주세요.", duration: 1.0, position: .center)
        }
//        if inputTextCount <= 12 {
//            return true
//        } else {
//            return false
//        }
        return inputTextCount <= 15
    }
    
    //MARK: - UIGestureRecognizerDelegate
    //터치를 감지
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //엄한곳 터치됐다고 내려가면 안되니까.
        if(touch.view?.isDescendant(of: searchBar) == true ) {
            print("서치바가 터치되었다.")
            return false
        } else if (touch.view?.isDescendant(of: CollectionViewMain) == true ) {
            return false
        } else {
        //편집이 끝났다함을 감지하여 키보드가 내려감 (빈곳을 터치)
            view.endEditing(true)
            print("빈곳이 터치되었다.")
            return true
        }
    }
    
    //키보드가 올라가는 사실은 아이폰이 알려준다. 그걸 notificationcenter로 받아오는것.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //키보드 올라가는 이벤트를 받는 처리
        //키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    @objc func keyboardWillShowHandle(notification: NSNotification) {
        
        //키보드 사이즈를 가져와서 그만큼 뷰를 밀어냄.
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if(keyboardSize.height < CollectionViewMain.frame.origin.y){
                let distance = keyboardSize.height - CollectionViewMain.frame.origin.y
                self.view.frame.origin.y = distance + CollectionViewMain.frame.height
            }
        }
        
    }
    
    @objc func keyboardWillHideHandle() {
        
    }
    
}

class ChampList: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}

struct ChampInfo: Decodable {
    
    //이미지 크기는 48,48
    //data에서 name, image에서 full
    let data: String
    let name: String
    let id: String
    
    
}




        
