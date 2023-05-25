import Foundation

// MARK: - Structure Chip

public struct Chip {
    public enum ChipType: UInt32 {
        case small = 1
        case medium
        case big
    }

    public let chipType: ChipType

    public static func make() -> Chip {
        guard let chipType = Chip.ChipType(rawValue: UInt32(arc4random_uniform(3) + 1)) else {
            fatalError("Incorrect random value")
        }

        return Chip(chipType: chipType)
    }

    public func sodering() {
        let soderingTime = chipType.rawValue
        sleep(UInt32(soderingTime))
    }
}

// MARK: - SpawningThread

class SpawningThread: Thread {
    private var timer = Timer()
    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    override func main() {
        timer = Timer.scheduledTimer(timeInterval: 2,
                                     target: self,
                                     selector: #selector(createChip),
                                     userInfo: nil,
                                     repeats: true)

        RunLoop.current.add(timer, forMode: .common)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 20))
    }

    @objc func createChip() {
        print("чип создан")
        storage.putInStorage(chip: Chip.make())
    }
}

// MARK: - WorkingThread

class WorkingThread: Thread {

}

// MARK: - Storage

class Storage {
    private var chipStorage = [Chip]()

    func putInStorage(chip: Chip) {
        chipStorage.append(chip)
        print("чип добавлен в хранилище")
    }
}

// MARK: - Start work

let storage = Storage()
let spawningThread = SpawningThread(storage: storage)

spawningThread.start()
