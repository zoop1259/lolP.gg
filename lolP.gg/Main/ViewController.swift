import UIKit
import FirebaseAuth

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    var champion: [ChampData] = []
    var champ = [String:String]()
    var newVersion = String()
    
    //필터링을 위한 배열
    var filteredArr: [String] = []
    var filteredChamp = [ChampData]()

    //챔피언컬렉션뷰
    @IBOutlet var collectionViewMain: UICollectionView!
    
    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    let searchController = UISearchController()
    
    //인디케이터 생성
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        return activityIndicator
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //인디케이터 추가
        self.view.addSubview(self.activityIndicator)
        
        champData()
        setupSearchController()
    }

    
    //MARK: -- 컬렉션뷰 델리게이트
    //셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? filteredChamp.count : champion.count
    }
    
    //셀 정보 - 어떻게 보여줄 것인가.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewMain.dequeueReusableCell(withReuseIdentifier: "champList", for: indexPath) as? ChampList else {
            return UICollectionViewCell()
        }
        
        let champions: ChampData
        //필터링 적용

        if isFiltering {
            champions = filteredChamp[indexPath.row]
        } else {
            champions = champion[indexPath.row]
        }
        
//        cell.nameLabel.text = champion[indexPath.row].key
        
        //이걸 글로벌하게 하니까. 필터했을떄 이쁘지가 않은것.
        //이미지를 빠르게 그리기 위해서 global로 돌린다.
        DispatchQueue.global().async {
            let url: URL! = URL(string: "http://ddragon.leagueoflegends.com/cdn/\(self.newVersion)/img/champion/\(champions.id).png")
            // 이미지를 읽어와 Data객체에 저장
            let imageData = try! Data(contentsOf: url)
            //ui는 main에서 돌려야 하기 떄문에.
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                cell.nameLabel.text = champions.name
                // UIImage객체를 생성하여 아울렛 변수의 image 속성에 대입
                cell.imgView.image = UIImage(data: imageData)
                self.activityIndicator.stopAnimating()
            }
        }
        return cell
    }
    
    //MARK: -- 데이터 넘겨주기.
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
        
        if let VCVersion = newVersion as? String {
            controller.VCVersion = VCVersion
            print("챔프디테일에 넘겨주는 버전: \(VCVersion)")
        }
        //이동
        show(controller, sender: nil)
    }
  
    //MARK: - 데이터파싱
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
                            
                            //main에서 일처리
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
    
    //MARK: - 로그인창.
    @IBAction func profileBtn(_ sender: Any) {
//        self.showLoginPopupViewController()
        if Auth.auth().currentUser != nil {
            print("유저정보화면")
//            self.showDetailViewController()
            self.showTestViewController()
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
    
    private func showTestViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestLoginView") as! TestLoginView
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Filter configure & methods
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        //서치바 설정
        self.navigationItem.searchController = searchController
        
        self.definesPresentationContext = true
        searchController.searchBar.placeholder = "챔피언 검색"
        // searchController가 검색하는 동안 네비게이션에 가려지지 않도록
        searchController.hidesNavigationBarDuringPresentation = false
        // searchBar cancel 버튼의 텍스트를 (cancel을 취소로 텍스트 변경)
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        
        searchController.searchBar.backgroundColor = .link
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        searchController.searchBar.tintColor = .white
        //스크롤시에도 서치바 유지되게 하기.
        self.navigationItem.hidesSearchBarWhenScrolling = false
        //텍스트 업데이트 확인하기
        searchController.searchResultsUpdater = self
        //먼 훗날 scopebar 사용해보자.
    }
      
    //필터링 파악
    var isFiltering: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
      
    //scope사용하게되면 사용할 것
//    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//      filteredChamp = champion.filter({( champion : ChampData) -> Bool in
//        return champion.name.lowercased().contains(searchText.lowercased())
//      })
//    }
    
}

//필터링
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        self.filteredChamp = champion.filter({ (data:ChampData) -> Bool in
//            return data.name.lowercased().contains(searchController.searchBar.text!.lowercased())
//        })
        
        self.filteredChamp = champion.filter({ ChampData -> Bool in
            return ChampData.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
//        guard let text = searchController.searchBar.text else { return }
//        self.filteredChamp = champion.filter { $0.name.contains(text) }
        dump(filteredChamp)
        collectionViewMain.reloadData()
    }
}


//MARK: - Cell Model
class ChampList: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}
