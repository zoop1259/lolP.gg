import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIGestureRecognizerDelegate {

    var champsInfo = [String:String]() // 챔피언의 정보를 담은 Dictionary
    public var krarr = [String]() //챔피언 한글 이름
    public var enarr = [String]() //챔피언 영어 이름
    public var champArr = [String:String]() //필터링을 위해 사용할 딕셔너리....

    //필터링을 위한 배열
    var filteredArr: [String] = []
    //필터링 파악
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }

    //챔피언컬렉션뷰
    @IBOutlet var CollectionViewMain: UICollectionView!
    
    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ui설정
        //searchController.delegate = self
        setupSearchController()
        getData()
        //config()
        //getVersion()

    }
    
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


    //다시 그리는거 viewDidappear
    
    //MARK: -- Collection View delegate
    //셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("챔피언의 수 : \(krarr.count)")
        //return krarr.count
        return self.isFiltering ? self.filteredArr.count : self.krarr.count

    }
    
    //셀 정보 - 어떻게 보여줄 것인가.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = CollectionViewMain.dequeueReusableCell(withReuseIdentifier: "champList", for: indexPath) as? ChampList else {
            return UICollectionViewCell()
        }
        
        if self.isFiltering {
            cell.nameLabel.text = self.filteredArr[indexPath.row]
        } else {
            cell.nameLabel.text = self.krarr[indexPath.row]
        }
        // 섬네일 경로를 인자값으로 하는 URL객체를 생성
        //음.. 가렌 썸네일만 나오네..
        //갈리오면 갈리오의 주소를 가져와야하는데...
        let url: URL! = URL(string: "http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(enarr[indexPath.row]).png")
        // 이미지를 읽어와 Data객체에 저장
        let imageData = try! Data(contentsOf: url)
        // UIImage객체를 생성하여 아울렛 변수의 image 속성에 대입
        cell.imgView.image = UIImage(data: imageData)
        
        //챔피언 이미지 밑에 챔피언명을 출력해야함. 아래방식은 나중에 챔피언스킬을 다운받아서 사용한다치면?
        //cell.nameLabel.text = krarr[indexPath.row]
        // 섬네일 경로를 인자값으로 하는 URL객체를 생성
//        let url: URL! = URL(string: "http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(enarr[indexPath.row]).png")
//        // 이미지를 읽어와 Data객체에 저장
//        let imageData = try! Data(contentsOf: url)
//        // UIImage객체를 생성하여 아울렛 변수의 image 속성에 대입
//        cell.imgView.image = UIImage(data: imageData)
        
        return cell
    }
    
    //MARK: -- prepare method 데이터 넘겨주기.
    //셀 눌렀을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item + 1)번째 셀의 챔피언")
        //메인 스토리 보드를 찾고 그 스토리보드안에 지정한 ID를 가진 뷰컨트롤러를 찾아서 controller에 저장.
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "champDetailView") as! ChampDetailView

        if let VCName = krarr[indexPath.row] as? String {
            controller.VCName = VCName
            print("챔프디테일에 넘겨주는 name : \(VCName)")
        }
        
        if let VCImg = enarr[indexPath.row] as? String {
            controller.VCImg = VCImg
            print("챔프디테일에 넘겨주는 img값 : \(VCImg)")
        }
        //이동! = 얘는 이동을 수동으로 시켜줘야함.
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
    
    //af사용하여 신버전 받아오기.
//    func getVersion(
//    _ completion: @escaping (Result<Image, Error>) -> () // Result 타입을 사용하면 좋다.
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
            
            let a = final.data
            //챔피언 id와 name의 dictionary 생성.
            var dict = [String:String]()
            for (_, champnames) in final.data {
                //cDic만으론 157개를 가진 dictionary가 아니게 되어 2중for문 사용.
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
            print("reloadData후 champsInfo : \(self.champsInfo.count)")
        })
        print("reloadData전 champsInfo : \(self.champsInfo.count)")

        task.resume()
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
            if(keyboardSize.height < CollectionViewMain.frame.origin.y){
                let distance = keyboardSize.height - CollectionViewMain.frame.origin.y
                self.view.frame.origin.y = distance + CollectionViewMain.frame.height
            }
        }
    }
    @objc func keyboardWillHideHandle() {
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.filteredArr = self.krarr.filter { $0.localizedCaseInsensitiveContains(text) }
        dump(filteredArr)

        self.CollectionViewMain.reloadData()
    }
}

class ChampList: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}
