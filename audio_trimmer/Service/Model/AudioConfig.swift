//
//  AudioConfig.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/29.
//

struct AudioConfig {
    let totalTrackLength: Int
    let playRangeDurationRatio: Double
    
    var playRangeDuration: Double {
        Double(totalTrackLength) * playRangeDurationRatio
    }
}
