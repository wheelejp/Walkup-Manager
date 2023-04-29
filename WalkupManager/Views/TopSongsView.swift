//
//  TopSongsView.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/28/23.
//

import SwiftUI
import AVFAudio

enum Songs: String, CaseIterable, Codable {
    case CultOfPersonality
    case DarkFantasy
    case Gasolina
    case Jump
    case LoudAndHeavy
    case SevenNationArmy
    case Sirius
    case StoneCold
    case Suavemente
    case TheShowGoesOn
}

struct TopSongsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Group {
                        //Yes I know this looks awful
                        //I might fix it later depending how do other things
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "CultOfPersonality")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("Cult of Personality")
                        }
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "DarkFantasy")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("Dark Fantasy")
                        }
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "Gasolina")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("Gasolina")
                        }
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "Jump")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("Jump")
                        }
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "LoudAndHeavy")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("Loud And Heavy")
                        }
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "SevenNationArmy")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("Seven Nation Army")
                        }
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "Sirius")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("Sirius")
                        }
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "StoneCold")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("Stone Cold")
                        }
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "Suavemente")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("Suavemente")
                        }
                        Button {
                            if audioPlayer != nil {
                                audioPlayer.stop()
                                audioPlayer = nil
                            } else {
                                playSound(soundName: "TheShowGoesOn")
                            }
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.red)
                            Text("The Show Goes On")
                        }
                    }
                    .buttonStyle(.plain)
                    
                    
                }
                .listStyle(.automatic)
                .navigationTitle("Top Walk-Up Songs")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
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



struct TopSongsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TopSongsView()
        }
    }
}
