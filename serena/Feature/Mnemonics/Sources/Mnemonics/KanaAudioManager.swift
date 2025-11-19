import AVFoundation
import SwiftUI

class KanaAudioManager {
    var audioPlayer: AVAudioPlayer?

    func play(kanaString: String) {
        guard let audioUrl = Bundle.module.url(forResource: kanaString, withExtension: "mp3") else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: audioUrl)
        audioPlayer?.play()
    }
}
