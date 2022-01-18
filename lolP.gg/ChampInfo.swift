//  ChampInfo.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/14.
//

import Foundation
import UIKit

func getName(datas: champData) -> [String] {
    return [datas.name]
}

func printAnd(string: String) -> Int {
    print(string)
    return string.count
}

func getID(ids: champData) -> [String] {
//    //http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/Aatrox.png
//    //http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(id).png
    return [ids.id]
}

func getDict(names: champData, ids: champData) -> [String:String] {
    return [ids.id: names.name]
    
//    func findDic(dict: [String: String]){
//        for (key, value) in dict{
//        print("\(key) : \(value)")
//      }
//    }
    
}

struct mainData: Codable {
    let type: TypeEnum
    let format: String
    let version: String
    let data: [String: champData]
}
    
   
// MARK: - champData
    struct champData: Codable {
        let version: String
        let id, key, name, title: String
        let blurb: String
        let info: Info
        let image: Image
        let tags: [Tag]
        let partype: Partype
        let stats: [String: Double]
    }

    // MARK: - Image
    struct Image: Codable {
        let full: String
        let sprite: String
        let group: TypeEnum
        let x, y, w, h: Int
    }

    enum TypeEnum: String, Codable {
        case champion = "champion"
    }

    enum Sprite: String, Codable {
        case champion0PNG = "champion0.png"
        case champion1PNG = "champion1.png"
        case champion2PNG = "champion2.png"
        case champion3PNG = "champion3.png"
        case champion4PNG = "champion4.png"
        case champion5PNG = "champion5.png"
    }

    // MARK: - Info
    struct Info: Codable {
        let attack, defense, magic, difficulty: Int
    }

    enum Partype: String, Codable {
        case 기력 = "기력"
        case 기류 = "기류"
        case 마나 = "마나"
        case 보호막 = "보호막 "
        case 분노 = "분노"
        case 없음 = "없음"
        case 열기 = "열기"
        case 용기 = "용기"
        case 투지 = "투지"
        case 피의샘 = "피의 샘"
        case 핏빛격노 = "핏빛 격노"
        case 흉포 = "흉포"
    }

    enum Tag: String, Codable {
        case assassin = "Assassin"
        case fighter = "Fighter"
        case mage = "Mage"
        case marksman = "Marksman"
        case support = "Support"
        case tank = "Tank"
    }
