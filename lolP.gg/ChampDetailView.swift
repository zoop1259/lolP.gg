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
    
    var skillName = [String]()
    var skillDesc = [String]()
    var skillImg = [String]()
    
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
                    print("champskill url : \(self.urlString)")
                    
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
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [self]data, _, error in
            guard let data = data, error == nil else {
                return
            }
            var result: MainSkillData?
            do {
                result = try JSONDecoder().decode(MainSkillData.self, from: data)
                //let spell = result?.SkillData.Spell.CodingKeys.skillid
            }
            catch {
                print("Failed to decode with error: \(error)")
            }
            guard let final = result else {
                return
            }
                
//            챔피언 id와 name의 dictionary 생성.
            for (_, skillnames) in final.data {
                let sub = skillnames.spells
                //print(sub)
                
                //튜플은 형식에 맞게 나눠서 for문돌려야함.
//                for (a, b, c) in sub {
//                    print("a: \(a)")
//                }
                for a in sub {
                    self.skillName.append(a.skillname)
                    self.skillDesc.append(a.spellDescription)
                    self.skillImg.append(a.skillid)
                    print(a.skillid)
                    print(a.skillname)
                    print(a.spellDescription)
                }
                
                print(self.skillName.count)
                //let three = (Spell.self, (sub))
  
                
                
                
            }
                
                
                //cDic만으론 157개를 가진 dictionary가 아니게 되어 2중for문 사용. 알아본바 map? 같은걸 사용해볼....
//                let subdic = getskillName(skills: champnames)
//                print(subdic.count)
//                subarr.append(champnames.spells)
//                print(subarr.count) //왜 1개인가..
//                self.ss.append(champnames.spells)
//                print(dic.count)
//                print("dic key : \(dic.keys) ----value : \(dic.values)")
                
//                for i in champnames.spells {
//                    //여기서 출력하면 추가되는 과정을 출력해주는건가.. ss가 [Any]일때 가능하지만...
//                    let asd = getskillInfo(infos: champnames)
//                    print(asd)
//                }
                
//                let ss = getskillInfo(infos: champnames.name)
//                for (_, subdatas) in champnames.spells {
//
//                }
                
//                for (names , ids) in cDic {
//                    dict.updateValue(names, forKey: ids)
////                    self.champsInfo = dict
//                    self.champsInfo.updateValue(names, forKey: ids)
//                }
            
//            print(final.data)
            
//            for data in final.data {
//                print()
//                for subdata in data.spells {
//                    let content = subdata.content.joined(separator: "\n\t")
//                    print("""
//                        \(subdata.name) - \(subdata.description)
//                        \(content)
//
//                    """)
//                }
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
        return skillName.count
        
        
    }
//
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DetailTableView.dequeueReusableCell(withIdentifier: "champSkill", for: indexPath) as! ChampSkill
        
        
        //스킬이름
        cell.skillName.text = skillName[indexPath.row]
        //스킬이미지
        // 섬네일 경로를 인자값으로 하는 URL객체를 생성
        let url: URL! = URL(string: "https://ddragon.leagueoflegends.com/cdn/11.24.1/img/spell/\(skillImg[indexPath.row]).png")
                                //"http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(enarr[indexPath.row]).png")
        // 이미지를 읽어와 Data객체에 저장
        let imageData = try! Data(contentsOf: url)
        // UIImage객체를 생성하여 아울렛 변수의 image 속성에 대입
        cell.skillImg.image = UIImage(data: imageData)
        
        
        return cell
    }
    
}

class ChampSkill: UITableViewCell {
    
    @IBOutlet var skillImg: UIImageView!
    @IBOutlet var skillName: UILabel!
    
}
