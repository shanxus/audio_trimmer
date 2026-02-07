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
    func seek(withRatio ratio: Double, source: SeekActionSource)
    
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
    
    var playbackRangeStartTime: Double?
    var playbackRangeEndTime: Double?
    
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
            
            let endTime = min(trackLength, (weakSelf.playbackRangeEndTime ?? trackLength))
            
            let playToEnd = newPlaybackTime >= endTime
            newPlaybackTime = playToEnd ? endTime : newPlaybackTime
            
            var playbackProgressInRange: Double = 0
            if let rangeStartTime = weakSelf.playbackRangeStartTime, let rangeEndTime = weakSelf.playbackRangeEndTime {
                playbackProgressInRange = ((newPlaybackTime - rangeStartTime) / (rangeEndTime - rangeStartTime)).clamped()
            }
            
            weakSelf.state = weakSelf.state.copyWith(currentPlaybackTime: newPlaybackTime, playbackProgressInRange: playbackProgressInRange, playbackTimeUpdateAction: .playback)
            
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
    
    func seek(withRatio ratio: Double, source: SeekActionSource) {
        guard let config = audioConfig else { return }
        
        let newPlaybackTime = Double(config.totalTrackLength) * ratio
        playbackRangeStartTime = newPlaybackTime
        playbackRangeEndTime = newPlaybackTime + config.playRangeDuration
        
        state = state.copyWith(
            currentPlaybackTime: newPlaybackTime,            
            playbackProgressInRange: 0,
            playbackTimeUpdateAction: .seek,
            seekActionSource: source,
        )
    }
    
    func setupConfig(_ config: AudioConfig) {
        audioConfig = config
        playbackRangeStartTime = 0
        playbackRangeEndTime = config.playRangeDuration
    }
}
