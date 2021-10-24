//
//  GameOverScene.swift
//  SpriteKitTest
//
//  Created by Роман далинкевич on 14.10.2021.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let label = SKLabelNode(text: "Game Over")
    
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
    var score = 0
    var highScore = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        highScore = ScoreStorage.shared.getHighScore()
        score = ScoreStorage.shared.getScore()
        
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.fontName = "Papyrus"
        label.fontSize = 60
        label.fontColor = .white

        scoreLabel = SKLabelNode(text: "Your score: \(score)")
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 60)
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "Papyrus"
        
        
        highScoreLabel = SKLabelNode(text: "Your highscore: \(highScore)")
        highScoreLabel.position =  CGPoint(x: self.frame.maxX - 220, y: self.frame.maxY - 60)
        highScoreLabel.fontName = "Papyrus"
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = .white
        
        addChild(scoreLabel)
        addChild(highScoreLabel)
        addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let scene = GameScene(size: size)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: reveal)
    }
}
