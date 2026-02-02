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
    
    func setupConfig(_ config: AudioConfig)
    
    var state: AudioServiceState { get }
    var statePublisher: AnyPublisher<AudioServiceState, Never> { get }
}

final class AudioServiceImpl: AudioService {
    private var audioConfig: AudioConfig?
    
    private let fps: Double = 30
    private var timer: Timer?
    
    @Published private(set) var state: AudioServiceState = .initial
    
    var statePublisher: AnyPublisher<AudioServiceState, Never> {
        return $state.eraseToAnyPublisher()
    }
    
    func play() {
        guard let config = audioConfig else { return }
        
        guard !state.isPlaying else { return }
        print("[AudioServiceImpl] play")
        state = state.copyWith(isPlaying: true)
        
        let interval: TimeInterval = 1.0 / fps
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: {[weak self] _ in
            guard let weakSelf = self else { return }
                        
            var newPlaybackTime = weakSelf.state.currentPlaybackTime + interval
            let trackLength = Double(config.totalTrackLength)
            
            let playToEnd = newPlaybackTime >= trackLength
            newPlaybackTime = playToEnd ? trackLength : newPlaybackTime
            weakSelf.state = weakSelf.state.copyWith(currentPlaybackTime: newPlaybackTime, playbackTimeUpdateAction: .playback)
            
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
        guard let config = audioConfig else { return }
        state = state.copyWith(
            currentPlaybackTime: Double(config.totalTrackLength) * ratio,
            playbackTimeUpdateAction: .seek
        )
    }
    
    func setupConfig(_ config: AudioConfig) {
        audioConfig = config
    }
}
