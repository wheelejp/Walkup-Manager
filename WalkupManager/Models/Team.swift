//
//  Team.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/26/23.
//

import Foundation
import FirebaseFirestoreSwift


struct Team: Codable, Identifiable {
    @DocumentID var id: String?
    var name = ""
    var manager = ""
    var players: [Player] = []
    
    var dictionary: [String: Any] {
        return ["name": name,"manager": manager, "players": players]
    }
}
