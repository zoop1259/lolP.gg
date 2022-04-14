import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIGestureRecognizerDelegate {

    var champion: [ChampData] = []
    
    var champ = [String:String]()
    var newVersion = String()
    
    public var champArr = [String:String]() //필터링을 위해 사용할 딕셔너리....

    //필터링을 위한 배열
    var filteredArr: [String] = []
    var filteredChamp = [ChampData]()

    //챔피언컬렉션뷰
    @IBOutlet var collectionViewMain: UICollectionView!
    
    
    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ui설정
        //searchController.delegate = self
        setupSearchController()
        //config()
        champData()
    }

    //MARK: -- Collection View delegate
    //셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.isFiltering ? self.filteredChamp.count : self.champion.count
        //return self.champion.count
    }
    
    //셀 정보 - 어떻게 보여줄 것인가.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewMain.dequeueReusableCell(withReuseIdentifier: "champList", for: indexPath) as? ChampList else {
            return UICollectionViewCell()
        }
        
          let champions: ChampData
          if isFiltering {
            champions = filteredChamp[indexPath.row]
          } else {
              champions = champion[indexPath.row]
          }
       
        cell.nameLabel.text = champions.name
        
        let url: URL! = URL(string: "http://ddragon.leagueoflegends.com/cdn/\(self.newVersion)/img/champion/\(champions.id).png")
        // 이미지를 읽어와 Data객체에 저장
        let imageData = try! Data(contentsOf: url)
        // UIImage객체를 생성하여 아울렛 변수의 image 속성에 대입
        cell.imgView.image = UIImage(data: imageData)
        
        return cell
    }
    
    //MARK: -- prepare method 데이터 넘겨주기.
    //셀 눌렀을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item + 1)번째 셀의 챔피언")
        //메인 스토리 보드를 찾고 그 스토리보드안에 지정한 ID를 가진 뷰컨트롤러를 찾아서 controller에 저장.
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "champDetailView") as! ChampDetailView

        let championSkill: ChampData
        if isFiltering {
          championSkill = filteredChamp[indexPath.row]
            if let VCName = filteredChamp[indexPath.row].name as? String {
                controller.VCName = VCName
                print("챔프디테일에 넘겨주는 name : \(VCName)")
            }
            
            if let VCImg = filteredChamp[indexPath.row].id as? String {
                controller.VCImg = VCImg
                print("챔프디테일에 넘겨주는 img값 : \(VCImg)")
            }
        } else {
            championSkill = champion[indexPath.row]
            if let VCName = champion[indexPath.row].name as? String {
                controller.VCName = VCName
                print("챔프디테일에 넘겨주는 name : \(VCName)")
            }
            
            if let VCImg = champion[indexPath.row].id as? String {
                controller.VCImg = VCImg
                print("챔프디테일에 넘겨주는 img값 : \(VCImg)")
            }
        }
        
        //이동
        show(controller, sender: nil)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemSpacing: CGFloat = 5 // 가로에서 cell과 cell 사이의 거리
//        let textAreaHeight: CGFloat = 20 // textLabel이 차지하는 높이
//        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2 // 셀 하나의 너비
//        let height: CGFloat = width * 10/7 + textAreaHeight //셀 하나의 높이
//
//        return CGSize(width: width, height: height)
//    }
  
    func champData() {
        
        if let urls = URL(string: "https://ddragon.leagueoflegends.com/api/versions.json") {
            var request = URLRequest.init(url: urls)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                // 버전 구하기.
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    
                    let newversion = json[0]
                    print("최신버전 : \(newversion)")
                    
                    if let url = URL(string:  "http://ddragon.leagueoflegends.com/cdn/\(newversion)/data/ko_KR/champion.json") {
        
                        print("최신버전의 url : \(url)")
                        
                        var request = URLRequest.init(url: url)
                        request.httpMethod = "GET"
                        URLSession.shared.dataTask(with: request) { (data, response, error) in
                            guard let data = data else { return }
                            print("데이터 크기 : \(data)") //데이터 크기
                            var result: MainData?
                            do {
                                result = try JSONDecoder().decode(MainData.self, from: data)
                            }
                            catch {
                                print("Failed to decode with error: \(error)")
                            }
                            guard let final = result else {
                                return
                            }
                            for (_, datas) in final.data {
                                //데이터 담기
                                self.champion.append(ChampData(id: datas.id, key: datas.key, name: datas.name))
                                //정렬하기
                                self.champion.sort(by: {$0.name < $1.name})
                            }
                            //버전도 담기
                            self.newVersion = newversion
                            //async하여 데이터 메인에서 돌게
                            DispatchQueue.main.async {
                                self.collectionViewMain.reloadData()
                            }
                            print("챔피언 수 : \(self.champion.count)") //챔피언 수 파악
                            print("newVersion : \(self.newVersion)") //버전 확인
                            //print(self.champion)                     //담은 데이터 출력 . 방대한 양이므로 주석처리
                        }.resume()
                    }
                }
            }.resume()
        }
    }

//    fileprivate func config() {
//        //스토리보드에 존재하는 라이브러리들은 VC로 직접 델리게이트를 설정해줄수있지만 제스처는 그렇지 않으므로 코드로 델리게이트 선언
//        self.keyboardDismissTabGesture.delegate = self
//        self.view.addGestureRecognizer(keyboardDismissTabGesture)
//    }

 /*
    //MARK: - UISearchBar Delegate methods
    //서치바에 입력된 텍스트를 가져옴
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("VC - searchBarSearchButtonClicked()")
        guard let userInputString = searchBar.text else { return }
        if userInputString.isEmpty {
            self.view.makeToast("❌키워드를 입력해주세요", duration: 1.0, position: .center)
        }
        //여기서 이제 검색된 챔피언을 출력? 할 필요는 없는듯.
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
            print("서치바가 아닌곳이 터치되었다.")
            return true
        }
    }
*/
    
    
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
            if(keyboardSize.height < collectionViewMain.frame.origin.y){
                let distance = keyboardSize.height - collectionViewMain.frame.origin.y
                self.view.frame.origin.y = distance + collectionViewMain.frame.height
            }
        }
    }
    @objc func keyboardWillHideHandle() {
    }
    
    // MARK: - Filter methods
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "챔피언 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.tintColor = .link
        //searchController.searchBar.frame.size.height = 44
        //서치바의 라인 삭제
        //searchController.searchBar.searchBarStyle = .minimal

        self.navigationItem.searchController = searchController
        //스크롤시에도 서치바 유지되게 하기.
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        //텍스트 업데이트 확인하기
        searchController.searchResultsUpdater = self
        
        //먼 훗날 scopebar 사용해보자.
    }
      
    //필터링 파악
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    func searchBarIsEmpty() -> Bool {
      // Returns true if the text is empty or nil
      return searchController.searchBar.text?.isEmpty ?? true
    }
      
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
      filteredChamp = champion.filter({( champion : ChampData) -> Bool in
        return champion.name.lowercased().contains(searchText.lowercased())
      })

      collectionViewMain.reloadData()
    }
}

//필터링
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredChamp = champion.filter({ (data:ChampData) -> Bool in
            return data.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        dump(filteredChamp)
        self.collectionViewMain.reloadData()
    }
}

//셀 구성
class ChampList: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}
