//
//  ListView.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/25/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
    @FirestoreQuery(collectionPath: "teams") var teams: [Team]
    @Environment(\.dismiss) private var dismiss
    @State private var newTeamSheetIsPresented = false
    @State private var topSongsShowing = false
    
    
    var body: some View {
        NavigationStack {
            Spacer()
            Text("Who's Playing Today?")
                .font(.largeTitle)
                .bold()
            
            List(teams) { team in
                NavigationLink {
                    TeamView(team: team)
                } label: {
                    Text(team.name)
                        .font(.title2)
                }
            }
            .listStyle(.automatic)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Group {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                print("🪵➡️ Log out successful!")
                                dismiss()
                            } catch {
                                print("😡 ERROR: Could not sign out!")
                            }
                        }
                        .tint(.red)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add Team") {
                            newTeamSheetIsPresented.toggle()
                        }
                        .tint(.red)
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button("Top Songs") {
                            topSongsShowing.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
                
            }
        }
        
        .sheet(isPresented: $newTeamSheetIsPresented) {
            NewTeamView(team: Team())
        }
        .sheet(isPresented: $topSongsShowing) {
            TopSongsView()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
