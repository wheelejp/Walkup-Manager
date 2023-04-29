//
//  PlayBallView.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/27/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import AVFAudio
import PhotosUI

struct PlayBallView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @FirestoreQuery(collectionPath: "teams") var players : [Player]
    @Environment(\.dismiss) private var dismiss
    @State private var audioPlayer: AVAudioPlayer!
    @State var team: Team
    @State private var nowBatting = Player()




    var body: some View {
        NavigationStack {
            VStack {
                Text("Play Ball")
                    .font(.largeTitle)
                    .bold()
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                Spacer()
                
                VStack {
                    Text("Now Batting")
                        .bold()
                        .font(.title3)
                        .padding(.bottom)
                    HStack {
                        Spacer()
                        Text(nowBatting.name)
                        Spacer()
                        Text("#:")
                        Text(nowBatting.number)
                        Spacer()
                        Text("Pos:")
                        Text(nowBatting.position)
                        Spacer()
                    }
                        
                    
                    
                }
                
                List(players) { player in
                    Button {
                        if audioPlayer != nil {
                            audioPlayer.stop()
                            audioPlayer = nil
                        } else {
                            playSound(soundName: player.song)
                        }
                        nowBatting = player
                    } label: {
                        Text(player.name)
                            .font(.title2)
                            .bold()
                    }

                }
                .onAppear {
                    if team.id != nil {
                        $players.path = "teams/\(team.id ?? "")/players"
                        print("$players.path = \($players.path)")
                    }
                }
                
                
                Spacer()
            }
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func playSound(soundName: String){
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("Error: \(error.localizedDescription) creating audioplayer.")
        }
    }
}

struct PlayBallView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PlayBallView(team: Team())
                .environmentObject(TeamViewModel())
                .environmentObject(PlayerViewModel())
        }
    }
}
