//
//  Extensions.swift
//  SpriteKitTest
//
//  Created by Роман далинкевич on 20.10.2021.
//


import SpriteKit
import GameplayKit

//MARK: touchesBegan
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        hero.physicsBody?.velocity = CGVector.zero
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 180))
        
        if tabToPlayLabel.isHidden == false {
            tabToPlayLabel.isHidden = true
        }
        
        let heroFlyAnimation = SKAction.animate(with: textureArrays.heroFlyTexturesArray, timePerFrame: 0.1)
        let flyHero = SKAction.repeatForever(heroFlyAnimation)
        hero.run(flyHero)
    }
}

//MARK: PhisicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let objectNode = contact.bodyA.categoryBitMask == enemyGroup ? contact.bodyA.node : contact.bodyB.node
        
        //MARK: Contact with enemy
        if contact.bodyA.categoryBitMask == enemyGroup || contact.bodyB.categoryBitMask == enemyGroup {
            hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            if shieldBool == false {
                animations.shakeAndFlashAnimation(view: self.view!)
                
                if sound == true {
                    run(heroDeadPreload)
                }
                
                hero.physicsBody?.allowsRotation = false
                
                coinObject.removeAllChildren()
                redCoinObject.removeAllChildren()
                groundObject.removeAllChildren()
                movingObject.removeAllChildren()
                bonusObject.removeFromParent()
                shieldObject.removeFromParent()
                
                stopGameObject()
                
                timerAddCoin.invalidate()
                timerAddRedCoin.invalidate()
                timerAddEnemyFlyHero.invalidate()
                timerAddEnemyRunHero.invalidate()
                timerAddBonus.invalidate()
                
                let heroDeathAnimation = SKAction.animate(with: textureArrays.heroDeathTexturesArray, timePerFrame: 0.2)
                hero.run(heroDeathAnimation)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.scene?.isPaused = true
                    self.heroObject.removeAllChildren()
                    self.stageLabel.isHidden = true
                    self.gameOver()
                }
            } else {
                if sound == true { run(shieldCreatePreload) }
                objectNode?.removeFromParent()
                bonusObject.removeAllChildren()
                shieldBool = false
            }
        }
        
        //MARK: Contact with bonus
        if contact.bodyA.categoryBitMask == bonusGroup || contact.bodyB.categoryBitMask == bonusGroup {
            let sheildNode = contact.bodyA.categoryBitMask == bonusGroup ? contact.bodyA.node : contact.bodyB.node
            if shieldBool == false {
                if sound == true { run(bonusCreatePreload) }
                sheildNode?.removeFromParent()
                addSheild()
                shieldBool = true
            }
        }
        
        //MARK: Contact with ground
        if contact.bodyA.categoryBitMask == groundGroup || contact.bodyB.categoryBitMask == groundGroup {
            let heroRunAnimation = SKAction.animate(with: textureArrays.heroRunTexturesArray, timePerFrame: 0.1)
            let heroRun = SKAction.repeatForever(heroRunAnimation)
            
            hero.run(heroRun)
        }
        
        //MARK: Contact with coins
        if contact.bodyA.categoryBitMask == coinGroup || contact.bodyB.categoryBitMask == coinGroup {
            let coinNode = contact.bodyA.categoryBitMask == coinGroup ? contact.bodyA.node : contact.bodyB.node
            
            if sound == true {
                run(pickCoinPreload)
            }
            
            score = score + 1
            scoreLabel.text = "\(score)"
            
            coinNode?.removeFromParent()
        }
        
        //MARK: Contact with red coins
        if contact.bodyA.categoryBitMask == redCoinGroup || contact.bodyB.categoryBitMask == redCoinGroup {
            let redCoinNode = contact.bodyA.categoryBitMask == redCoinGroup ? contact.bodyA.node : contact.bodyB.node
            
            if sound == true {
                run(pickRedCoinPreload)
            }
            
            score = score + 5
            scoreLabel.text = "\(score)"
            
            redCoinNode?.removeFromParent()
        }
    }
}
