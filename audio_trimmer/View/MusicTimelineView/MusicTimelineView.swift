//
//  MusicTimelineView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/31.
//

import SwiftUI

struct MusicTimelineView: View {    
    @Binding var infoState: TimelineInfoState
    @Binding var progressState: TimelineProgressState
    @Binding var playPauseState: TimelinePlayPauseState
    
    var onPlayButtonTap: () -> Void
    var onPauseButtonTap: () -> Void
    var onResetButtonTap: () -> Void
    var onUserSeekToProgress: onUserSeekToProgressCallback
    
    var body: some View {
        VStack(spacing: 0) {
            TimelineInfoView(state: $infoState)
            TimelineView(state: $progressState, onUserSeekToProgress: onUserSeekToProgress)
                .frame(height: 80)
            
            Button(playPauseState.isPlaying ? "pause" : "play") {
                playPauseState.isPlaying ? onPauseButtonTap() : onPlayButtonTap()
            }
            
            Button("reset") {
                onResetButtonTap()
            }
            
        }.background(Color.darkGrey)
    }
}
