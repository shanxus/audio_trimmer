//
//  KeyTimeSelectionView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//
import SwiftUI

struct KeyTimeSelectionView: View {
    @Binding var state: KeyTimeSelectionState
    
    var onUserSeekToProgress: onUserSeekToProgressCallback
    
    var body: some View {
        VStack {
            Text("KeyTime Selection")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            Text("Selected: \(state.selectedStartTimeProgressLabelValue) -> \(state.selectedEndTimeProgressLabelValue)")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            Text("Current: \(state.currentPlaybackProgressLabelValue)")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            VideoProgressView(state: $state, onTapKeyTimeProgress: { (progress: Double) in
                onUserSeekToProgress(progress)
            }).padding(.horizontal, 30)
        }.background(Color.darkGrey)
    }
}
