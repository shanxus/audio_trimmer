//
//  AudioService.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/27.
//

import Foundation
import Combine

protocol AudioService {
    func play()
    func pause()
    func seek(withRatio ratio: Double)
    
    var state: AudioServiceState { get }
    var statePublisher: AnyPublisher<AudioServiceState, Never> { get }
}

final class AudioServiceImpl: AudioService {
    private let audioConfig: AudioConfig
    
    private let fps: Double = 30
    private var timer: Timer?
    
    @Published private(set) var state: AudioServiceState = .initial
    
    init(withConfig config: AudioConfig) {
        audioConfig = config
    }
    
    var statePublisher: AnyPublisher<AudioServiceState, Never> {
        return $state.eraseToAnyPublisher()
    }
    
    func play() {
        guard !state.isPlaying else { return }
        print("[AudioServiceImpl] play")
        state.isPlaying = true
        
        let interval: TimeInterval = 1.0 / fps
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: {[weak self] _ in
            guard let weakSelf = self else { return }
                        
            var newPlaybackTime = weakSelf.state.currentPlaybackTime + interval
            let trackLength = Double(weakSelf.audioConfig.totalTrackLength)
            
            let playToEnd = newPlaybackTime >= trackLength
            newPlaybackTime = playToEnd ? trackLength : newPlaybackTime
            weakSelf.state.currentPlaybackTime = newPlaybackTime
            if playToEnd {
                weakSelf.pause()
            }
        })
    }
    
    func pause() {
        guard state.isPlaying else { return }
        print("[AudioServiceImpl] pause")
        state.isPlaying = false;
        timer?.invalidate()
        timer = nil
    }
    
    func seek(withRatio ratio: Double) {
        
    }
}
