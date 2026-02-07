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
    
    var onUserSeekToProgress: onUserSeekToProgressCallback
    
    var body: some View {
        VStack(spacing: 0) {
            TimelineInfoView(state: $infoState)
            TimelineView(state: $progressState, onUserSeekToProgress: onUserSeekToProgress)
                .frame(maxHeight: .infinity)
        }.background(Color.darkGrey)
    }
}
