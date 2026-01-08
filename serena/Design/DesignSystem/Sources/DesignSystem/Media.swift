import SwiftUI

public extension ColorResource {
    enum _Sky {
        public static let aftermidnight = ColorResource.Sky.aftermidnight
        public static let afternoon = ColorResource.Sky.afternoon
        public static let dawn = ColorResource.Sky.dawn
        public static let dusk = ColorResource.Sky.dusk
        public static let evening = ColorResource.Sky.evening
        public static let midnight = ColorResource.Sky.midnight
        public static let morning = ColorResource.Sky.morning
        public static let night = ColorResource.Sky.night
        public static let noon = ColorResource.Sky.noon
    }

    enum _Typing {
        public static let grass = ColorResource.Typing.grass
    }
}

public extension ImageResource {
    enum _TrainingBanner {
        public static let allInARow = ImageResource.TrainingBanner.allInARow
        public static let levelUp = ImageResource.TrainingBanner.levelUp
    }

    enum _ReinaEmotes {
        public static let confused = ImageResource.ReinaEmotes.confused
        public static let mnemonics = ImageResource.ReinaEmotes.mnemonics
        public static let training = ImageResource.ReinaEmotes.training
        public static let easy = ImageResource.ReinaEmotes.easy
        public static let medium = ImageResource.ReinaEmotes.medium
        public static let hard = ImageResource.ReinaEmotes.hard
        public static let party = ImageResource.ReinaEmotes.party
    }

    enum _Typing {
        public static let castle1 = ImageResource.Typing.castle1
        public static let castle2 = ImageResource.Typing.castle2
        public static let castle3 = ImageResource.Typing.castle3
        public static let flag = ImageResource.Typing.flag

        public enum Tutorial {
            public static let kana = ImageResource.Typing.Tutorial.kana
            public static let qwerty = ImageResource.Typing.Tutorial.qwerty
            public static let hand = ImageResource.Typing.Tutorial.hand
        }
    }
}
