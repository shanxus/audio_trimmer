//
//  AudioTrimmerScreen.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/26.
//

import SwiftUI

struct AudioTrimmerScreen<VM: AudioTrimmerViewModel>: View {
    @StateObject private var vm: VM
    
    init(vm: VM) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {            
            Color.darkGrey.ignoresSafeArea()
            
            VStack {
                KeyTimeSelectionView(
                    infoState: vm.keyTimeInfoState,
                    progressState: vm.keyTimeProgressState,
                    onUserSeekToProgress: { progress in
                        vm.seek(toProgressRatio: progress)
                    })
                .frame(height: 150)
                            
                MusicTimelineView(
                    infoState: vm.timelineInfoState,
                    progressState: vm.timelineProgressState,
                    playPauseState: vm.timelinePlayPauseState,
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
}
