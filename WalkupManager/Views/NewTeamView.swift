//
//  NewTeamView.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/26/23.
//

import SwiftUI
import FirebaseFirestoreSwift


struct NewTeamView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    @Environment(\.dismiss) private var dismiss

    @State var team: Team
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter Your Team Info")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                
                Text("Team Name:")
                    .bold()
                TextField("name", text: $team.name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)
                
                Text("Manager:")
                    .bold()
                TextField("manager", text: $team.manager)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)
                    .keyboardType(.numberPad)
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem (placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await teamVM.saveTeam(team: team)
                            if success {
                                dismiss()
                            } else {
                                print("ERROR: saving spot😡")
                            }
                        }
                        dismiss()
                    }
                }
        }
        }
    }
}

struct NewTeamView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewTeamView(team: Team())
                .environmentObject(TeamViewModel())
        }
    }
}
