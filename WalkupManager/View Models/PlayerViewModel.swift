//
//  PlayerViewModel.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/26/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

@MainActor

class PlayerViewModel: ObservableObject {
    @Published var player = Player()
    
    func savePlayer(team: Team, player: Player) async -> String? {
        let db = Firestore.firestore()
        
        let collectionString = "teams/\(team.id ?? "")/players"
        
        if let id = player.id { //player exists already, so save
            do {
                try await db.collection(collectionString).document(id).setData(player.dictionary)
                print("Data updated successfully! 😎")
                return player.id
            } catch {
                print("ERROR: Data could not be updated in 'players'😡 \(error.localizedDescription)")
                return nil
            }
        } else { //new player so save the new one
            do {
                let docRef = try await db.collection(collectionString).addDocument(data: player.dictionary)
                print("Data added successfully!🐣")
                return docRef.documentID
            } catch {
                print("ERROR: Could not create new data in 'players'😡 \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func deletePlayer(team: Team, player: Player) async -> Bool {
        let db = Firestore.firestore()
        guard let teamID = team.id, let playerID = player.id else {
            print("Error: team.id =  \(team.id ?? "nil"), player.id = \(player.id ?? "nil"). this should not have happened")
            return false
        }
        
        do {
            let _ = try await db.collection("teams").document(teamID).collection("players").document(playerID).delete()
            print("🗑️ Document successfully deleted")
            return true
        } catch {
            print("Error: removing document \(error.localizedDescription)")
            return false
        }
    }
    
    func saveImage(id: String, image: UIImage) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpg")
        
        let resizedImage = image.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let resizedImage = resizedImage {
            do {
                let metadata = try await storageRef.putDataAsync(resizedImage)
                print("Metadata: ", metadata)
                print("📸 Image Saved!")
            } catch {
                print("😡 ERROR: uploading image to FirebaseStorage \(error.localizedDescription)")
            }
        }
    }
    
    func getImageURL(id: String) async -> URL? {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpg")
        
        do {
            let url = try await storageRef.downloadURL()
            return url
        } catch {
            return nil
        }
    }
}
