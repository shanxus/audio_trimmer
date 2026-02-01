//
//  ContentView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/26.
//

import SwiftUI

struct AppConfig {
    var trackLenght: Int
    var keyTimes: [Double]
    var trimmedRangeRatio: Double
    
    var trimmedDuration: Double {
        return trimmedRangeRatio * Double(trackLenght)
    }
    
    static let `default` = AppConfig(trackLenght: 15, keyTimes: [0, 0.5, 0.75, 1], trimmedRangeRatio: 0.1)
}

struct ContentView: View {
    @ObservedObject var vm: AudioTrimmerViewModel = AudioTrimmerViewModelImpl(audioService: AudioServiceImpl(), appConfig: .default)
    
    var body: some View {
        VStack {
            Button("play") {
                vm.play()
            }
            
            Button("pause") {
                vm.pause()
            }
            
            KeyTimeSelectionView(state: $vm.keyTimeSelectionState) { progress in
                vm.seek(toProgressRatio: progress)
            }
            .frame(height: 150)
                        
            MusicTimelineView(state: $vm.timelineViewState, onUserSeekToProgress: { (progress: Double) in                
                vm.seek(toProgressRatio: progress)
            })
            .frame(height: 150)
        }
    }
}
