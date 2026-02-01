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
            Text("Selected: \(state.currentPlaybackProgress) -> \(state.selectedEndTimeProgress)")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            Text("Current: \(state.currentPlaybackProgress)")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            VideoProgressView(keyTimes: state.keyTimes, onTap: { (progress: Double) in
                onUserSeekToProgress(progress)
            })
        }.background(Color.darkGrey)
    }
}
