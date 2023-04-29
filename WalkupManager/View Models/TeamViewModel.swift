//
//  TeamViewModel.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/26/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

@MainActor

class TeamViewModel: ObservableObject {
    @Published var teams = Team()
    
    func saveTeam(team: Team) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = team.id {
            do { //Team exists so save team data
                try await db.collection("teams").document(id).setData(team.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'teams' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                _ = try await db.collection("teams").addDocument(data: team.dictionary)
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new team in 'teams' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func deleteData(team: Team) async {
        let db = Firestore.firestore()
        
        guard let id = team.id else {
            print("ERROR: ID was nil, should not have happened")
            return
        }
        
        do {
            try await db.collection("teams").document(id).delete()
            print("Document successfully removed")
            return
        } catch {
            print("ERROR: Removing Document \(error.localizedDescription)")
            return
        }
    }
    
}
