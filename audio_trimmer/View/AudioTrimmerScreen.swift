//
//  AudioTrimmerScreen.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/26.
//

import SwiftUI

struct AudioTrimmerScreen: View {
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
