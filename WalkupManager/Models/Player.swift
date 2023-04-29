//
//  Player.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum Position: String, CaseIterable, Codable {
    case Pitcher, FirstBase, SecondBase, ThirdBase, Shortstop, RightField, CenterField, LeftField, Catcher
}

struct Player: Codable, Identifiable {
    @DocumentID var id: String?
    var name = ""
    var number = ""
    var song = Songs.CultOfPersonality.rawValue
    var position = Position.Pitcher.rawValue
    var imageID = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "number": number, "song": song, "position": position, "imageID": imageID]
    }
}
