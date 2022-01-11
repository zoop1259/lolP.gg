import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIGestureRecognizerDelegate {

    var nameArr = [String]()
    var champsInfo = [String:String]() // 챔피언의 정보를 담은 Dictionary
    var krarr = [String]() //챔피언 한글 이름
    var enarr = [String]() //챔피언 영어 이름

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
        getData()
        config()
        //getVersion()

    }
    
    //다시 그리는거 viewDidappear
    
    //MARK: -- Collection View delegate
    //셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("챔피언의 수 : \(krarr.count)")
        return krarr.count
    }
    
    //셀 정보 - 어떻게 보여줄 것인가.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = CollectionViewMain.dequeueReusableCell(withReuseIdentifier: "champList", for: indexPath) as? ChampList else {
            return UICollectionViewCell()
        }
//                챔피언 이미지 밑에 챔피언명을 출력해야함. 아래방식은 나중에 챔피언스킬을 다운받아서 사용한다치면?
        //let img = UIImage(named: "http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(enarr[indexPath.row]).png")
        cell.nameLabel.text = krarr[indexPath.row]
        
        // 섬네일 경로를 인자값으로 하는 URL객체를 생성
        let url: URL! = URL(string: "http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(enarr[indexPath.row]).png")
        // 이미지를 읽어와 Data객체에 저장
        let imageData = try! Data(contentsOf: url)
        // UIImage객체를 생성하여 아울렛 변수의 image 속성에 대입
        cell.imgView.image = UIImage(data: imageData)
        
       
//        //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
//        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
//        DispatchQueue.global().async {
//        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//        DispatchQueue.main.async {
//        image = UIImage(data: data!)
//        }
//        }
        
        return cell
    }
    
    //MARK: -- prepare method 데이터 넘겨주기.
    //셀 눌렀을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item + 1)번째 셀의 챔피언")
        //performSegue(withIdentifier: "champDetailsegue", sender: indexPath.item)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "champDetailView") as! ChampDetailView

        controller.VCName = krarr[indexPath.row]
        //controller.VCImg = ChampList.imgView.image
        
        //1. 메인 화면에 챔피언 이름과 사진을 받아와야함.
        //2. 메인화면의 챔피언 이름과 사진을 디테일화면에 넘겨줘야함.
        //3. 디테일 화면에서는 스킬정보를 받아와야함.
        //4. 끗....
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let id = segue.identifier, "champDetailsegue" == id {
    //            //NewsDetail을 NewsDetailController로 이동시키려면
    //            if let controller = segue.destination as? ChampDetailView {
    //
    //                if let indexPath = CollectionViewMain.indexPathsForSelectedItems {
    //                }
    //            }
    //        }
    //    }
        
        //여기에 이제 챔프스킬들을 넘겨주는게 필요함.
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemSpacing: CGFloat = 5 // 가로에서 cell과 cell 사이의 거리
//        let textAreaHeight: CGFloat = 20 // textLabel이 차지하는 높이
//        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2 // 셀 하나의 너비
//        let height: CGFloat = width * 10/7 + textAreaHeight //셀 하나의 높이
//
//        return CGSize(width: width, height: height)
//    }
    
    //af사용하여 신버전 받아오기.
//    func getVersion(
//    _ completion: @escaping (Result<Image, Error>) -> () // Result 타입을 사용하면 좋아요.
//    ) {
//        AF.request("https://ddragon.leagueoflegends.com/api/versions.json").responseString { (response) in
//    }

    func getData() {
 
        let urlString = "http://ddragon.leagueoflegends.com/cdn/11.24.1/data/ko_KR/champion.json"
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            var result: mainData?
            do {
                result = try JSONDecoder().decode(mainData.self, from: data)
            }
            catch {
                print("Failed to decode with error: \(error)")
            }
            guard let final = result else {
                return
            }

            for (_, champdata) in final.data {
                let cName = getName(datas: champdata)
//                let newArr = cName.components(separatedBy: "")
//                let sortName = newArr.sorted(by: <)
//                print(sortName)
                for i in cName {
                    self.nameArr.append(String(i))
                }
            }
            //print("nameArr : \(self.nameArr.count)")
            
            for (_, champdata) in final.data {
                let cImg = getID(ids: champdata)
                
                for i in cImg {
                    var imsiArr = [String]()
                    imsiArr.append(String(i))
//                    "http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(id).png"
                }
//                let url = URL(string: "http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(id).png")
//                let data = try Data(contentsOf: url!)
//                uiImageView.image = UIImage(data: data)
//                uiImageView
            }
            
            //챔피언 id와 name의 dictionary 생성.
            var dict = [String:String]()
            for (_, champnames) in final.data {
                //cDic만으론 157개를 가진 dictionary가 아니게 되어 2중for문 사용. 알아본바 map? 같은걸 사용해볼....
                let cDic = getDict(names: champnames, ids: champnames)
                //챔피언의 dictionary
//                print("cImg : \(cImg)")
                for (names , ids) in cDic {
                    dict.updateValue(names, forKey: ids)
//                    self.champsInfo = dict
                    self.champsInfo.updateValue(names, forKey: ids)
                }
            }

            for (name, id) in self.champsInfo.sorted(by: <) {
                self.krarr.append(name)
                self.enarr.append(id)
            }
            
            //메인에서 일을 시킴. reloadData를 사용하기 떄문에 맨 마지막에 사용
            DispatchQueue.main.async {
                self.CollectionViewMain.reloadData()
            }
            //print("Aarr : \(self.Aarr) Barr : \(self.Barr)") //챔피언 한글이름과 영어이름 출력
            print("reloadData후 champsInfo : \(self.champsInfo.count)")
            
        })
        print("reloadData전 champsInfo : \(self.champsInfo.count)")

        task.resume()
    }
    
    fileprivate func config() {
        //스토리보드에 존재하는 라이브러리들은 VC로 직접 델리게이트를 설정해줄수있지만 제스처는 그렇지 않으므로 코드로 델리게이트 선언
        self.keyboardDismissTabGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    //버튼이 터치되었을때 - 필터링?
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
    
    public func configure(with image : UIImage) {
        imgView.image = image
        }
    
}

