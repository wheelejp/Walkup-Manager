//
//  TeamView.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/26/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct TeamView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @FirestoreQuery(collectionPath: "teams") var players : [Player]
    @Environment(\.dismiss) private var dismiss
    @State var team: Team
    @State private var playerSheetShowing = false
    @State private var playingBall = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(team.name)
                    .bold()
                    .font(.largeTitle)
                
                Text("Manager: \(team.manager.capitalized)")
                    .font(.title2)
                
                NavigationStack {
                    List(players) { player in
                        NavigationLink {
                            PlayerView(team: team, player: player)
                        } label: {
                            Text(player.name)
                                .font(.title2)
                        }
                    }
                    .listStyle(.automatic)
                }
                .onAppear {
                    if team.id != nil {
                        $players.path = "teams/\(team.id ?? "")/players"
                        print("$players.path = \($players.path)")
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Add Player") {
                        playerSheetShowing.toggle()
                    }
                }
                
                
                ToolbarItem(placement: .bottomBar) {
                    Button("Play Ball") {
                        playingBall.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .sheet(isPresented: $playingBall, content: {
            PlayBallView(team: team)
        })
        .sheet(isPresented: $playerSheetShowing) {
            PlayerView(team: team, player: Player())
        }
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TeamView(team: Team(name: "Yankees", manager: "Aaron Boone"))
                .environmentObject(TeamViewModel())
        }
    }
}
