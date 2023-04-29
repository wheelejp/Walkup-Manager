//
//  WalkupManagerApp.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/25/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct WalkupManagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(TeamViewModel())
                .environmentObject(PlayerViewModel())
        }
    }
}
