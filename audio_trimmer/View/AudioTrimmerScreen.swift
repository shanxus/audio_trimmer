//
//  AudioTrimmerScreen.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/26.
//

import SwiftUI

struct AudioTrimmerScreen: View {    
    @StateObject private var vm: AudioTrimmerViewModel
    
    init(audioService: AudioService, appConfig: AppConfig) {
        _vm = StateObject(wrappedValue: AudioTrimmerViewModelImpl(audioService: audioService, appConfig: appConfig))
    }
    
    var body: some View {
        VStack {                        
            KeyTimeSelectionView(infoState: $vm.keyTimeInfoState, progressState: $vm.keyTimeProgressState) { progress in
                vm.seek(toProgressRatio: progress)
            }
            .frame(height: 150)
                        
            MusicTimelineView(
                infoState: $vm.timelineInfoState,
                progressState: $vm.timelineProgressState,
                playPauseState: $vm.timelinePlayPauseState,
                onPlayButtonTap: {
                    vm.play()
                },
                onPauseButtonTap: {
                    vm.pause()
                },
                onResetButtonTap: {
                    vm.reset()
                },
                onUserSeekToProgress: { (progress: Double) in
                    vm.onTimelineScroll(toRatio: progress)
                })
            .frame(height: 400)
        }
    }
}
