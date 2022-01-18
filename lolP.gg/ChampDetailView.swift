//
//  ChampDetailView.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/01/11.
//

import Foundation
import UIKit

public class ChampDetailView : UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var DetailTableView: UITableView!
    @IBOutlet var detailImg: UIImageView! //VC의 챔피언 이미지
    @IBOutlet var detailName: UILabel! //VC의 챔피언 이름

    public var VCImg : String? //viewcontroller에서 넘겨받은 챔피언 썸네일
    public var VCName : String? //vc에서 넘겨받은 챔피언 이름
    
    var detailErName : String?
    var skillLabel : String?
    var skillimgLabel : String?
    
    var urlString = "url정보담을 변수"
    //"https://ddragon.leagueoflegends.com/cdn/11.23.1/data/ko_KR/champion/\(self.detailErName).json"
    //let urlString = "https://ddragon.leagueoflegends.com/cdn/11.23.1/data/ko_KR/champion/Aatrox.json"

    public override func viewDidLoad() {
        super.viewDidLoad()
    
        if let vcname = VCName {
            //본문을 보여준다.
            self.detailName.text = vcname
            print("챔프디테일에서의 vcname값 : \(vcname)")
        }
        
        if let vcimg = VCImg {
            detailErName = vcimg
            if let data = try? Data(contentsOf: URL(string: "http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(vcimg).png")!) {
                DispatchQueue.main.async {
                    self.detailImg.image = UIImage(data: data)
                    print("챔프디테일에서의 vcimg값 : \(vcimg)")
                    
                    self.urlString = "https://ddragon.leagueoflegends.com/cdn/11.24.1/data/ko_KR/champion/\(vcimg).json"
                    self.getSkill()
                    print(self.urlString)
                    
                }
            }
        }
        
    }
    
    func getSkill() {
 
        //챔피언의 이름을 받아서 urlString을 완성시켜야함.
        //만 되면 좋은데...
               
        guard let url = URL(string: self.urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            var result: MainSkillData?
            do {
                result = try JSONDecoder().decode(MainSkillData.self, from: data)
            }
            catch {
                print("Failed to decode with error: \(error)")
            }
            guard let final = result else {
                return
            }
            
            print(final.data)
            
            
//            var skills: SkillData?
//            do {
//                skills = try JSONDecoder().decode(SkillData.self, from: data)
//            }
//            catch {
//                print("Failed to decode with error: \(error)")
//            }
//            guard let skilldatas = skills else {
//                return
//            }
//            print("asdasd: \(skilldatas.passive)")
            
//            print("skilldatas : \(skilldatas)")
            
            //챔피언스킬의 name과 image를 가져와야 한다.
//            for (skilll , skillnames) in skilldatas.passive {
//                let skillList = getskillName(skills: skillnames)
//            }
           
            //챔피언 id와 name의 dictionary 생성.
//            var dict = [String:String]()
//            for (_, champnames) in final.data {
//                //cDic만으론 157개를 가진 dictionary가 아니게 되어 2중for문 사용. 알아본바 map? 같은걸 사용해볼....
//                let cDic = getDict(names: champnames, ids: champnames)
//                //챔피언의 dictionary
////                print("cImg : \(cImg)")
//                for (names , ids) in cDic {
//                    dict.updateValue(names, forKey: ids)
////                    self.champsInfo = dict
//                    self.champsInfo.updateValue(names, forKey: ids)
//                }
//            }
//
//            for (name, id) in self.champsInfo.sorted(by: <) {
//                self.krarr.append(name)
//                self.enarr.append(id)
//            }
            
//            메인에서 일을 시킴. reloadData를 사용하기 떄문에 맨 마지막에 사용
            DispatchQueue.main.async {
                self.DetailTableView.reloadData()
            }
                                              
        })
        task.resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //스킬수만큼 카운트 패시브까지 한다면 패시브를 +
        return 1
    }
//
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DetailTableView.dequeueReusableCell(withIdentifier: "champSkill", for: indexPath) as! ChampSkill
        //스킬이름
//        cell.skillName.text = ''''
        //스킬이미지
//        cell.skillImg.image = ''''
        return cell
    }
    
}

class ChampSkill: UITableViewCell {
    
    @IBOutlet var skillImg: UIImageView!
    @IBOutlet var skillName: UILabel!
    
}
