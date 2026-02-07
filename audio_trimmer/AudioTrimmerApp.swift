//
//  AudioTrimmerApp.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/26.
//

import SwiftUI

@main
struct AudioTrimmerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var path: [Screen] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            SettingsScreen { appConfig in
                path.append(.AudioTrimmerScreen(config: appConfig))
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .AudioTrimmerScreen(let appConfig):
                    AudioTrimmerScreen(audioService: AudioServiceImpl(), appConfig: appConfig)
                }
            }
        }
    }
}
