//
//  KeyTimeSelectionView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//
import SwiftUI

struct KeyTimeSelectionView: View {
    @Binding var infoState: KeyTimeInfoState
    @Binding var progressState: KeyTimeProgressState
    
    var onUserSeekToProgress: onUserSeekToProgressCallback
    
    var body: some View {
        VStack {
            KeyTimeInfoView(state: $infoState)
            
            Spacer()
                .frame(height: 20)
            
            KeyTimeProgressView(state: $progressState, onTapKeyTimeProgress: { (progress: Double) in
                onUserSeekToProgress(progress)
            })
            .padding(.horizontal, 30)
            .background(Color.black)
        }
    }
}
