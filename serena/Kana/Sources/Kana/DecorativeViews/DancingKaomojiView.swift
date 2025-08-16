import SwiftUI

struct DancingKaomojiView: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let date = context.date
            let seconds = Calendar.current.component(.second, from: date)
            let kaoText = if seconds % 2 == 0 {
                "└[∵┌]   ヾ(-_- )ゞ   [┐∵]┘"

            } else {
                "┌[∵└]   ノ( -_-)ノ   [┘∵]┐"
            }
            Text(kaoText)
                .typography(.title2)
        }
    }
}
