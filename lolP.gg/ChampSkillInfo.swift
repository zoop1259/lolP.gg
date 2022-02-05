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

// MARK: - mainSkillData
struct MainSkillData: Codable {
    let data: [String: SkillData]
}

// MARK: - skillData
struct SkillData: Codable {
    let id, key, name: String
    let spells: [Spell]
}

// MARK: - Spell
struct Spell: Codable {
    let skillid, skillname, spellDescription: String
    //let image: SkillImage

    enum CodingKeys: String, CodingKey {
        case skillid = "id"
        case skillname = "name"
        case spellDescription = "description"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        skillid = try values.decode(String.self, forKey: .skillid)
        skillname = try values.decode(String.self, forKey: .skillname)
        spellDescription = try values.decode(String.self, forKey: .spellDescription)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(skillid, forKey: .skillid)
        try container.encode(skillname, forKey: .skillname)
        try container.encode(spellDescription, forKey: .spellDescription)
    }
}

//struct SkillImage: Codable {
//    let full: String
//}

