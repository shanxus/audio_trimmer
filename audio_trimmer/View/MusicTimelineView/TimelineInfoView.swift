//
//  TimelineInfoView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/7.
//
import SwiftUI

struct TimelineInfoView: View {
    let state: TimelineInfoState
    
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
        }
    }
}
