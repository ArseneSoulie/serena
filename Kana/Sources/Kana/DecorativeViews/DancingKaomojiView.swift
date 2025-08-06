import SwiftUI

struct DancingKaomojiView: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let date = context.date
            let seconds = Calendar.current.component(.second, from: date)
            if seconds % 2 == 0 {
                Text("└[∵┌]   ヾ(-_- )ゞ   [┐∵]┘").font(.title2)
            } else {
                Text("┌[∵└]   ノ( -_-)ノ   [┘∵]┐").font(.title2)
            }
        }
    }
}
