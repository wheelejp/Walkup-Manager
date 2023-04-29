//
//  PlayerView.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/26/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import PhotosUI

struct PlayerView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @State var team: Team
    @State var player: Player
    @Environment(\.dismiss) private var dismiss
    @State private var showingAsSheet = false
    @State private var selectedImage: Image = Image(systemName: "figure.baseball")
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageURL: URL?
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                Text("Player Name:")
                    .bold()
                TextField("player:", text: $player.name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)
                
                Text("Number:")
                    .bold()
                TextField("number:", text: $player.number)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)
                    .keyboardType(.numberPad)
                
                HStack {
                    Text("Position:")
                        .bold()
                    
                    Picker("", selection: $player.position) {
                        ForEach(Position.allCases, id: \.self) { position in
                            Text(position.rawValue.capitalized)
                                .tag(position.rawValue)
                        }
                    }
                }
                
                HStack {
                    Text("Song:")
                        .bold()
                    
                    Picker("", selection: $player.song) {
                        ForEach(Songs.allCases, id: \.self) { song in
                            Text(song.rawValue.capitalized)
                                .tag(song.rawValue)
                        }
                    }
                }
                
                HStack {
                    Text("Player Photo:")
                        .bold()
                    Spacer()
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Label("", systemImage: "photo.fill.on.rectangle.fill")
                    }
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        selectedImage = Image(uiImage: uiImage)                    }
                                }
                            } catch {
                                print("😡 ERROR: loading failed \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
                if imageURL != nil {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                
                Spacer()
                
            }
            .padding()
            .task { // add to VStack - acts like .onAppear
                if let id = player.id { // if this isn't a new player id
                    if let url = await playerVM.getImageURL(id: id) { // It should have a url for the image (it may be "")
                        imageURL = url
                    }
                }
            }
            .onAppear {
                if player.name == "" {
                    showingAsSheet = true
                }
            }
            .toolbar {
                if showingAsSheet {
                    ToolbarItem (placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem (placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                let id = await playerVM.savePlayer(team: team, player: player)
                                if id != nil { //save worked
                                    player.id = id
                                    await playerVM.saveImage(id: player.id ?? "" , image: ImageRenderer(content: selectedImage).uiImage ?? UIImage())
                                    dismiss()
                                } else { //did not save
                                    print("ERROR: saving spot😡")
                                }
                            }
                            dismiss()
                        }
                    }
                } else {
                    ToolbarItem (placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                let id = await playerVM.savePlayer(team: team, player: player)
                                if id != nil { //save worked
                                    player.id = id
                                    await playerVM.saveImage(id: player.id ?? "" , image: ImageRenderer(content: selectedImage).uiImage ?? UIImage())
                                    dismiss()
                                } else { //did not save
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
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PlayerView(team: Team(), player: Player(name: "Jack",number: "11",song: Songs.CultOfPersonality.rawValue, position: Position.Pitcher.rawValue))
                .environmentObject(PlayerViewModel())
        }
    }
}
