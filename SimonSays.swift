var isWatching = true {
    didSet {
        if isWatching {
            setTitle("WATCH!")
        } else {
            setTitle("REPEAT!")
        }
    }
}

var sequence = [WKInterfaceButton]()
var sequenceIndex = 0
func playNextSequenceItem() {
    // stop flashing if we've finished our sequence
    guard sequenceIndex < sequence.count else {
        isWatching = false
        sequenceIndex = 0
        return
    }

    // otherwise move our sequence forward
    let button = sequence[sequenceIndex]
    sequenceIndex += 1

    // wait a fraction of a second before flashing
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        // mark this button as being active
        button.setTitle("•")

        // wait again
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // deactivate the button and flash again
            button.setTitle("")
            self?.playNextSequenceItem()
        }
    }
}
let colors = [red, yellow, green, blue]
sequence.append(colors.randomElement()!!)

let colors: [WKInterfaceButton] = [red, yellow, green, blue]
sequence.append(colors.randomElement()!)
func addToSequence() {
    // add a random button to our sequence
    let colors: [WKInterfaceButton] = [red, yellow, green, blue]
    sequence.append(colors.randomElement()!)

    // start the flashing at the beginning
    sequenceIndex = 0

    // update the player instructions
    isWatching = true

    // give the player a little respite, then start flashing
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
        self.playNextSequenceItem()
    }
}
func startNewGame() {
    sequence.removeAll()
    addToSequence()
}
override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    startNewGame()
}
func addToSequence() {
    let colors: [WKInterfaceButton] = [red, yellow, green, blue]

    for _ in 1...10 {
        sequence.append(colors.randomElement()!)
    }

    sequenceIndex = 0
    isWatching = true

    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
        self.playNextSequenceItem()
    }
}
func makeMove(_ color: WKInterfaceButton) {
    // don't let the player touch stuff while in watch mode
    guard isWatching == false else { return }

    if sequence[sequenceIndex] == color {
        // they were correct! Increment the sequence index.
        sequenceIndex += 1

        if sequenceIndex == sequence.count {
            // they made it to the end; add another button to the sequence
            addToSequence()
        }
    } else {
        // they were wrong! End the game.
        let playAgain = WKAlertAction(title: "Play Again", style: .default) {
            self.startNewGame()
        }

        presentAlert(withTitle: "Game over!", message: "You scored \(sequence.count - 1).", preferredStyle: .alert, actions: [playAgain])
    }
}
@IBAction func redTapped() {
    makeMove(red)
}

@IBAction func yellowTapped() {
    makeMove(yellow)
}

@IBAction func greenTapped() {
    makeMove(green)
}

@IBAction func blueTapped() {
    makeMove(blue)
}
