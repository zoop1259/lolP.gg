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

func getskillName(skills: SkillData) -> [String] {
    return [skills.id]
}

func getskillInfo(infos: Spell) -> [String] {
    return [infos.skillid]
}
//let prac1 = SkillData.passive( ... )

func getspellDict(spellname: Spell, spellid: Spell) -> [String:String] {
    return [spellname.skillname: spellid.skillid]
}

struct spelldata: Decodable {
//    let data: [String: SkillData]
//    let spells: [Spell]
//
//    var skillid: String {
//        data.spells.skillid
}


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
    let image: SkillImage

    enum CodingKeys: String, CodingKey {
        case skillid = "id"
        case skillname = "name"
        case spellDescription = "description"
        case image
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        skillid = try values.decode(String.self, forKey: .skillid)
//    }
    
}

struct SkillImage: Codable {
    let full: String
}
