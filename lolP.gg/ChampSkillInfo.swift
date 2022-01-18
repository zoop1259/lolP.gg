//
//  ChampSkillInfo.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/01/17.
//

import Foundation
import UIKit

// 챔피언 json
// https://ddragon.leagueoflegends.com/cdn/11.23.1/data/ko_KR/champion/Aatrox.json
// 챔피언 skill img UI
// https://ddragon.leagueoflegends.com/cdn/11.24.1/img/spell/AatroxQ.png

func getskillName(skills: Passive) -> [String] {
    return [skills.name]
}

//let prac1 = SkillData.passive( ... )


// MARK: - mainSkillData
struct MainSkillData: Codable {
    let data: [String: SkillData]
}
// MARK: - skillData
struct SkillData: Codable {
    //let spells: [Passive]
    let passive: Passive
}

// MARK: - Passive
struct Passive: Codable {
    let name, passiveDescription: String
    let image: SkillImage
    let id: String

    enum CodingKeys: String, CodingKey {
        case name
        case passiveDescription = "description"
        case image, id
    }
}

struct SkillImage: Codable {
    let full: String
}
