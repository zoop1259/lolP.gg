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

func asdasd(skillids: Spell) -> [String] {
    return [skillids.skillid]
}

let asd = Spell.CodingKeys.skillid


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
    /*
     let data: [SkillData]
     Failed to decode with error: typeMismatch(Swift.Array<Any>, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "data", intValue: nil)], debugDescription: "Expected to decode Array<Any> but found a dictionary instead.", underlyingError: nil))
     */
    
}
// MARK: - skillData
struct SkillData: Codable {
    let id, key, name: String
    let spells: [Spell]
    /*
     let spells: [String:Spell]
     Failed to decode with error: typeMismatch(Swift.Dictionary<Swift.String, lolP_gg.Spell>, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "data", intValue: nil), _JSONKey(stringValue: "Garen", intValue: nil), CodingKeys(stringValue: "spells", intValue: nil)], debugDescription: "Expected to decode Dictionary<String, Spell> but found an array instead.", underlyingError: nil))
     */
}

// MARK: - Spell
struct Spell: Codable {
    let skillid, skillname, spellDescription: String
    //let image: SkillImage

    enum CodingKeys: String, CodingKey {
        case skillid = "id"
        case skillname = "name"
        case spellDescription = "description"
        //case image
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

struct SkillImage: Codable {
    let full: String
}

