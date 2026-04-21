//
//  GameController.swift
//  CSC308GroupProject
//
//  Created by Morgan, Greyson F. on 4/16/26.
//  Edited by Schmidt, Alex on 4/20/26
// Edited by Schmidt, Alex on 4/21/26

import UIKit

class GameController: UIViewController {

    // MARK: - Passed in from PlayModeController
    var mode: Mode = .TP
    var playerNames: [String] = ["Player 1", "Player 2"]
    var playerColors: [UIColor] = [.systemYellow, .systemRed]
    var modeTitleLabel: UILabel!
    // MARK: - IBOutlets

    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player1ColorLabel: UILabel!

    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player2ColorLabel: UILabel!

    // MARK: - Board constants
    let rows = 6
    let cols = 7
    let cellSize: CGFloat = 40
    let cellPadding: CGFloat = 5

    // MARK: - Game state
    var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 7), count: 6)
    var currentPlayer = 1
    var isAnimating = false
    var gameOver = false

    // MARK: - Timed mode
    var turnTimeLimit: Double = 15.0
    var timeRemaining: Double = 15.0
    var turnTimer: Timer?

    // MARK: - UI references
    var boardContainer: UIView!
    var cellViews: [[UIView]] = []
    var columnButtons: [UIButton] = []
    var statusLabel: UILabel!
    var timerLabel: UILabel!
    var timerBar: UIView!
    var timerBarWidth: NSLayoutConstraint!
    var timerContainerWidth: CGFloat = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1)

        setupTopUI()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mode == .TPT {
            startTurnTimer()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        turnTimer?.invalidate()
    }

    // MARK: - Top UI

    func setupTopUI() {

        // Create title label
        modeTitleLabel = UILabel()
        modeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        modeTitleLabel.textAlignment = .center
        modeTitleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        modeTitleLabel.textColor = .white

        // Only show in timed mode
        if mode == .TPT {
            modeTitleLabel.text = "⏱"
        } else {
            modeTitleLabel.text = "1v1"
        }

        view.addSubview(modeTitleLabel)

        NSLayoutConstraint.activate([
            modeTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            modeTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Player buttons (already in storyboard)
        // Player names
        player1Label.text = playerNames[0]
        player2Label.text = playerNames[1]

        // Match text color to player color
        player1Label.textColor = playerColors[0]
        player2Label.textColor = playerColors[1]

        // Show color text
        player1ColorLabel.text = "Color"
        player2ColorLabel.text = "Color"

        // Make the color labels actually display the color
        player1ColorLabel.backgroundColor = playerColors[0]
        player2ColorLabel.backgroundColor = playerColors[1]

        // Styling (optional but looks clean)
        player1ColorLabel.layer.cornerRadius = 8
        player2ColorLabel.layer.cornerRadius = 8

        player1ColorLabel.clipsToBounds = true
        player2ColorLabel.clipsToBounds = true

        player1ColorLabel.textAlignment = .center
        player2ColorLabel.textAlignment = .center
    }

    // MARK: - UI Setup

    func setupUI() {
        setupStatusLabel()
        setupTimerUI()
        setupBoard()
        setupColumnButtons()
        updateStatusLabel()
        updateArrowColors()
        setButtonsEnabled(true)
    }

    func setupStatusLabel() {
        statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.boldSystemFont(ofSize: 22)
        statusLabel.textColor = .white
        view.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }

    func setupTimerUI() {
        timerLabel = UILabel()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 26, weight: .bold)
        timerLabel.textColor = .white
        timerLabel.isHidden = (mode != .TPT)
        view.addSubview(timerLabel)

        let timerBarBG = UIView()
        timerBarBG.translatesAutoresizingMaskIntoConstraints = false
        timerBarBG.backgroundColor = UIColor(white: 0.25, alpha: 1)
        timerBarBG.layer.cornerRadius = 5
        timerBarBG.clipsToBounds = true
        timerBarBG.isHidden = (mode != .TPT)
        view.addSubview(timerBarBG)

        timerBar = UIView()
        timerBar.translatesAutoresizingMaskIntoConstraints = false
        timerBar.backgroundColor = .systemGreen
        timerBar.layer.cornerRadius = 5
        timerBarBG.addSubview(timerBar)

        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 28),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            timerBarBG.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 12),
            timerBarBG.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            timerBarBG.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            timerBarBG.heightAnchor.constraint(equalToConstant: 10),

            timerBar.leadingAnchor.constraint(equalTo: timerBarBG.leadingAnchor),
            timerBar.topAnchor.constraint(equalTo: timerBarBG.topAnchor),
            timerBar.bottomAnchor.constraint(equalTo: timerBarBG.bottomAnchor)
        ])

        timerContainerWidth = view.bounds.width - 64
        timerBarWidth = timerBar.widthAnchor.constraint(equalToConstant: timerContainerWidth)
        timerBarWidth.isActive = true
    }

    func setupBoard() {
        let totalW = CGFloat(cols) * (cellSize + cellPadding) + cellPadding
        let totalH = CGFloat(rows) * (cellSize + cellPadding) + cellPadding

        boardContainer = UIView()
        boardContainer.translatesAutoresizingMaskIntoConstraints = false
        boardContainer.backgroundColor = UIColor(red: 0.1, green: 0.28, blue: 0.85, alpha: 1)
        boardContainer.layer.cornerRadius = 14
        boardContainer.layer.shadowColor = UIColor.black.cgColor
        boardContainer.layer.shadowOpacity = 0.6
        boardContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        boardContainer.layer.shadowRadius = 8
        boardContainer.clipsToBounds = false
        view.addSubview(boardContainer)

        let boardTopConstant: CGFloat = 300

        NSLayoutConstraint.activate([
            boardContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: boardTopConstant),
            boardContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardContainer.widthAnchor.constraint(equalToConstant: totalW),
            boardContainer.heightAnchor.constraint(equalToConstant: totalH)
        ])

        cellViews = []

        for row in 0..<rows {
            var rowViews: [UIView] = []

            for col in 0..<cols {
                let x = cellPadding + CGFloat(col) * (cellSize + cellPadding)
                let y = cellPadding + CGFloat(row) * (cellSize + cellPadding)

                let circle = UIView(frame: CGRect(x: x, y: y, width: cellSize, height: cellSize))
                circle.backgroundColor = UIColor(white: 0.08, alpha: 1)
                circle.layer.cornerRadius = cellSize / 2
                circle.clipsToBounds = true
                circle.layer.borderColor = UIColor(white: 0.0, alpha: 0.5).cgColor
                circle.layer.borderWidth = 2

                boardContainer.addSubview(circle)
                rowViews.append(circle)
            }

            cellViews.append(rowViews)
        }
    }

    func setupColumnButtons() {
        let totalW = CGFloat(cols) * (cellSize + cellPadding) + cellPadding

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = cellPadding
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.bottomAnchor.constraint(equalTo: boardContainer.topAnchor, constant: -8),
            stack.centerXAnchor.constraint(equalTo: boardContainer.centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: totalW),
            stack.heightAnchor.constraint(equalToConstant: cellSize)
        ])

        for col in 0..<cols {
            let btn = UIButton(type: .system)
            btn.tag = col
            let arrowImg = UIImage(systemName: "arrowtriangle.down.fill")
            btn.setImage(arrowImg, for: .normal)
            btn.tintColor = playerColors[0]
            btn.addTarget(self, action: #selector(columnTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(btn)
            columnButtons.append(btn)
        }

        let quitBtn = UIButton(type: .system)
        quitBtn.translatesAutoresizingMaskIntoConstraints = false
        quitBtn.setTitle("Quit Game", for: .normal)
        quitBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        quitBtn.tintColor = .systemRed
        quitBtn.addTarget(self, action: #selector(quitTapped), for: .touchUpInside)
        view.addSubview(quitBtn)

        NSLayoutConstraint.activate([
            quitBtn.topAnchor.constraint(equalTo: boardContainer.bottomAnchor, constant: 48),
            quitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Timer

    func startTurnTimer() {
        turnTimer?.invalidate()
        timeRemaining = turnTimeLimit

        timerBarWidth.constant = timerContainerWidth
        view.layoutIfNeeded()

        updateTimerLabel()
        updateTimerBarColor()

        turnTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.timeRemaining -= 0.1
            self.updateTimerLabel()
            self.updateTimerBarColor()

            let fraction = max(0, self.timeRemaining / self.turnTimeLimit)
            self.timerBarWidth.constant = self.timerContainerWidth * CGFloat(fraction)

            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }

            if self.timeRemaining <= 0 {
                self.turnTimer?.invalidate()
                self.turnTimedOut()
            }
        }
    }

    func updateTimerLabel() {
        let secs = max(0, Int(ceil(timeRemaining)))
        timerLabel.text = "\(secs)s"
        timerLabel.textColor = timeRemaining <= 5 ? .systemRed : .white
    }

    func updateTimerBarColor() {
        let fraction = timeRemaining / turnTimeLimit

        if fraction > 0.5 {
            timerBar.backgroundColor = .systemGreen
        } else if fraction > 0.25 {
            timerBar.backgroundColor = .systemOrange
        } else {
            timerBar.backgroundColor = .systemRed
        }
    }

    func turnTimedOut() {
        guard !gameOver && !isAnimating else { return }

        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor = UIColor(red: 0.4, green: 0.0, blue: 0.0, alpha: 1)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1)
            }
        }

        let skippedName = playerNames[currentPlayer - 1]
        currentPlayer = currentPlayer == 1 ? 2 : 1
        statusLabel.text = "\(skippedName)'s turn skipped! ⏰"

        updateStatusLabel()
        updateArrowColors()
        setButtonsEnabled(true)

        if mode == .TPT {
            startTurnTimer()
        }
    }

    // MARK: - Column Tap & Drop Animation

    @objc func columnTapped(_ sender: UIButton) {
        guard !isAnimating, !gameOver else { return }

        let col = sender.tag
        guard let targetRow = availableRow(in: col) else { return }

        turnTimer?.invalidate()
        isAnimating = true
        setButtonsEnabled(false)

        let player = currentPlayer
        let pieceColor = playerColors[player - 1]

        let boardOrigin = boardContainer.convert(CGPoint.zero, to: view)
        let colX = boardOrigin.x + cellPadding + CGFloat(col) * (cellSize + cellPadding)
        let startY = boardOrigin.y - cellSize - 8
        let finalY = boardOrigin.y + cellPadding + CGFloat(targetRow) * (cellSize + cellPadding)

        let fallingPiece = UIView(frame: CGRect(x: colX, y: startY, width: cellSize, height: cellSize))
        fallingPiece.backgroundColor = pieceColor
        fallingPiece.layer.cornerRadius = cellSize / 2
        fallingPiece.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        fallingPiece.layer.borderWidth = 2
        fallingPiece.clipsToBounds = true
        view.addSubview(fallingPiece)
        view.bringSubviewToFront(fallingPiece)

        let distance = finalY - startY
        let duration = Double(distance / 900) + 0.15

        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            fallingPiece.frame.origin.y = finalY
        }) { _ in

            UIView.animate(withDuration: 0.06, animations: {
                fallingPiece.transform = CGAffineTransform(scaleX: 1.15, y: 0.85)
            }) { _ in
                UIView.animate(withDuration: 0.06) {
                    fallingPiece.transform = .identity
                }
            }

            fallingPiece.removeFromSuperview()
            self.grid[targetRow][col] = player
            self.cellViews[targetRow][col].backgroundColor = pieceColor
            self.cellViews[targetRow][col].layer.borderColor = UIColor(white: 0, alpha: 0.25).cgColor
            self.isAnimating = false

            if self.checkWin(player: player, row: targetRow, col: col) {
                self.gameOver = true
                self.highlightWinningPieces(player: player, row: targetRow, col: col)
                self.statusLabel.text = "🎉 \(self.playerNames[player - 1]) wins!"
                self.statusLabel.textColor = self.playerColors[player - 1]
                self.showGameOver(winner: player)
            } else if self.checkDraw() {
                self.gameOver = true
                self.statusLabel.text = "It's a draw!"
                self.statusLabel.textColor = .white
                self.showGameOver(winner: nil)
            } else {
                self.currentPlayer = (player == 1) ? 2 : 1
                self.updateStatusLabel()
                self.updateArrowColors()
                self.setButtonsEnabled(true)

                if self.mode == .TPT {
                    self.startTurnTimer()
                }
            }
        }
    }

    // MARK: - Game Logic

    func availableRow(in col: Int) -> Int? {
        var row = rows - 1

        while row >= 0 {
            if grid[row][col] == 0 {
                return row
            }
            row -= 1
        }

        return nil
    }

    func checkWin(player: Int, row: Int, col: Int) -> Bool {
        return checkDir(player: player, row: row, col: col, dr: 0, dc: 1) ||
               checkDir(player: player, row: row, col: col, dr: 1, dc: 0) ||
               checkDir(player: player, row: row, col: col, dr: 1, dc: 1) ||
               checkDir(player: player, row: row, col: col, dr: 1, dc: -1)
    }

    func checkDir(player: Int, row: Int, col: Int, dr: Int, dc: Int) -> Bool {
        var count = 1

        var r = row + dr
        var c = col + dc
        while r >= 0 && r < rows && c >= 0 && c < cols && grid[r][c] == player {
            count += 1
            r += dr
            c += dc
        }

        r = row - dr
        c = col - dc
        while r >= 0 && r < rows && c >= 0 && c < cols && grid[r][c] == player {
            count += 1
            r -= dr
            c -= dc
        }

        return count >= 4
    }

    func checkDraw() -> Bool {
        for cell in grid[0] {
            if cell == 0 {
                return false
            }
        }
        return true
    }

    func winningCells(player: Int, row: Int, col: Int) -> [(Int, Int)] {
        let directions = [(0, 1), (1, 0), (1, 1), (1, -1)]

        for (dr, dc) in directions {
            var cells = [(row, col)]

            var r = row + dr
            var c = col + dc
            while r >= 0 && r < rows && c >= 0 && c < cols && grid[r][c] == player {
                cells.append((r, c))
                r += dr
                c += dc
            }

            r = row - dr
            c = col - dc
            while r >= 0 && r < rows && c >= 0 && c < cols && grid[r][c] == player {
                cells.append((r, c))
                r -= dr
                c -= dc
            }

            if cells.count >= 4 {
                return cells
            }
        }

        return []
    }

    func highlightWinningPieces(player: Int, row: Int, col: Int) {
        let cells = winningCells(player: player, row: row, col: col)

        for r in 0..<rows {
            for c in 0..<cols {
                var isWinningCell = false

                for cell in cells {
                    if cell.0 == r && cell.1 == c {
                        isWinningCell = true
                        break
                    }
                }

                if grid[r][c] != 0 && !isWinningCell {
                    UIView.animate(withDuration: 0.3) {
                        self.cellViews[r][c].alpha = 0.3
                    }
                }
            }
        }

        for (r, c) in cells {
            let cell = cellViews[r][c]
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.autoreverse, .repeat, .allowUserInteraction],
                           animations: {
                cell.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 3
            })
        }
    }

    // MARK: - UI Helpers

    func updateStatusLabel() {
        statusLabel.text = "\(playerNames[currentPlayer - 1])'s turn"
        statusLabel.textColor = playerColors[currentPlayer - 1]
    }

    func updateArrowColors() {
        let color = playerColors[currentPlayer - 1]
        for button in columnButtons {
            button.tintColor = color
        }
    }

    func setButtonsEnabled(_ enabled: Bool) {
        for btn in columnButtons {
            btn.isEnabled = enabled

            if enabled {
                let full = availableRow(in: btn.tag) == nil
                btn.isEnabled = !full
                btn.alpha = full ? 0.2 : 1.0
            } else {
                btn.alpha = 0.5
            }
        }
    }

    // MARK: - Game Over

    func showGameOver(winner: Int?) {
        turnTimer?.invalidate()
        setButtonsEnabled(false)

        let title: String
        let message: String

        if let winner = winner {
            title = "\(playerNames[winner - 1]) Wins! 🎉"
            message = "\(playerNames[winner - 1]) got four in a row!"
        } else {
            title = "Draw!"
            message = "The board is full. No winner this time."
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            self.resetGame()
        })

        alert.addAction(UIAlertAction(title: "Main Menu", style: .cancel) { _ in
            self.dismiss(animated: true)
        })

        present(alert, animated: true)
    }

    func resetGame() {
        grid = Array(repeating: Array(repeating: 0, count: cols), count: rows)
        currentPlayer = 1
        gameOver = false
        isAnimating = false

        for row in cellViews {
            for cell in row {
                cell.backgroundColor = UIColor(white: 0.08, alpha: 1)
                cell.layer.borderColor = UIColor(white: 0.0, alpha: 0.5).cgColor
                cell.layer.borderWidth = 2
                cell.alpha = 1.0
                cell.transform = .identity
            }
        }

        updateStatusLabel()
        updateArrowColors()
        setButtonsEnabled(true)

        if mode == .TPT {
            timerContainerWidth = view.bounds.width - 64
            startTurnTimer()
        }
    }

    @objc func quitTapped() {
        turnTimer?.invalidate()

        let alert = UIAlertController(title: "Quit Game?",
                                      message: "Are you sure you want to quit?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes, Quit", style: .destructive) { _ in
            self.dismiss(animated: true)
        })

        alert.addAction(UIAlertAction(title: "Keep Playing", style: .cancel) { _ in
            if self.mode == .TPT && !self.gameOver && !self.isAnimating {
                self.startTurnTimer()
            }
        })

        present(alert, animated: true)
    }
}
