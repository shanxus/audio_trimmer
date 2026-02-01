//
//  MusicTimelineView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/31.
//

import SwiftUI

struct MusicTimelineView: View {
    
    @Binding var state: TimelineViewState
    
    var onUserSeekToProgress: onUserSeekToProgressCallback
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Music Timeline")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            Text("Selected: \(state.selectedStartTimeLabelValue) -> \(state.selectedEndTimeLabelValue)")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            Text("Current: \(state.currentPlaybackTimeLabelValue)")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            TimelineView(state: $state, onUserSeekToProgress: onUserSeekToProgress)
                .frame(maxHeight: .infinity)
        }.background(Color.darkGrey)
    }
}
