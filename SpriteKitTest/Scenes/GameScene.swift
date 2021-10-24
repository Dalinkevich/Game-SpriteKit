//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by Роман далинкевич on 14.10.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
   
    var animations = AnimationClass()
    
    //MARK: Variables
    var sound = true
    var moveEnemyFlyY = SKAction()
    var shieldBool = false
    var score = 0
    var highScore = 0
    
    //MARK: Texture
    let textureArrays = TextureArrays()
    var backgroundTexture: SKTexture!
    var flyHeroTexture: SKTexture!
    var coinTexture: SKTexture!
    var redCoinTexture: SKTexture!
    var coinHeroTexture: SKTexture!
    var redHeroCoinTexture: SKTexture!
    var enemyFlyTexture: SKTexture!
    var enemyRunTexture: SKTexture!
    var enemyRunTexture2: SKTexture!
    var enemyRunTexture3: SKTexture!
    var bonusTexture: SKTexture!
    var sheildTexture: SKTexture!
    var deadHeroTexture: SKTexture!
    
    //MARK: Sprite Nodes
    var background = SKSpriteNode()
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    var hero = SKSpriteNode()
    var coin = SKSpriteNode()
    var redCoin = SKSpriteNode()
    var enemyFly = SKSpriteNode()
    var enemyRun = SKSpriteNode()
    var bonus = SKSpriteNode()
    var sheild = SKSpriteNode()

    //MARK: Label Nodes
    var tabToPlayLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var stageLabel = SKLabelNode()
    
    //MARK: Sprite Objects
    var backgroungObject = SKNode()
    var groundObject = SKNode()
    var movingObject = SKNode()
    var heroObject = SKNode()
    var coinObject = SKNode()
    var redCoinObject = SKNode()
    var bonusObject = SKNode()
    var shieldObject = SKNode()
    var labelObject = SKNode()
    
    //MARK: Bit masks
    var heroGroup: UInt32 = 0b1
    var groundGroup: UInt32 = 0b10
    var coinGroup: UInt32 = 0b100
    var redCoinGroup: UInt32 = 0b1000
    var enemyGroup: UInt32 = 0b10000
    var bonusGroup: UInt32 = 0b100000
    
    //MARK: Textures Array for animateWithTextures
    var heroFlyTexturesArray = [SKTexture]()
    var heroRunTexturesArray = [SKTexture]()
    var coinTexturesArray = [SKTexture]()
    var enemyFlyTexturesArray = [SKTexture]()
    var enemyRunTexturesArray = [SKTexture]()
    var enemyRunTexturesArray2 = [SKTexture]()
    var enemyRunTexturesArray3 = [SKTexture]()
    var heroDeathTexturesArray = [SKTexture]()
    
    //MARK: Timers
    var timerAddCoin = Timer()
    var timerAddRedCoin = Timer()
    var timerAddEnemyFlyHero = Timer()
    var timerAddBonus = Timer()
    var timerAddEnemyRunHero = Timer()
    
    //MARK: Sounds
    var backgroundMusic = SKAudioNode()
    var pickCoinPreload = SKAction()
    var pickRedCoinPreload = SKAction()
    var enemyFlyCreatePreload = SKAction()
    var heroDeadPreload = SKAction()
    var enemyRunCreatePreload = SKAction()
    var bonusCreatePreload = SKAction()
    var shieldCreatePreload = SKAction()

    //MARK: didMove
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //MARK: Background Texture
        backgroundTexture = SKTexture(imageNamed: "background.jpg")
        
        //MARK: Hero Texture
        flyHeroTexture = SKTexture(imageNamed: "frame-1.png")
        
        //MARK: Coin Texture
        coinTexture = SKTexture(imageNamed: "Coin.png")
        redCoinTexture = SKTexture(imageNamed: "Coin.png")
        coinHeroTexture = SKTexture(imageNamed: "Coin1.png")
        redHeroCoinTexture = SKTexture(imageNamed: "Coin1.png")
        
        //MARK: Enemy Texture
        enemyFlyTexture = SKTexture(imageNamed: "1.png")
        enemyRunTexture = SKTexture(imageNamed: "a.png")
        enemyRunTexture2 = SKTexture(imageNamed: "b.png")
        enemyRunTexture3 = SKTexture(imageNamed: "c.png")
        
        //MARK: Bonus Texture
        bonusTexture = SKTexture(imageNamed: "gift1.png")
        sheildTexture = SKTexture(imageNamed: "shield.png")
        
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        createGame()

        //MARK: Preloads
        pickCoinPreload = SKAction.playSoundFileNamed("PickedCoin.wav", waitForCompletion: false)
        pickRedCoinPreload = SKAction.playSoundFileNamed("PickedRedCoin.wav", waitForCompletion: false)
        enemyFlyCreatePreload = SKAction.playSoundFileNamed("bee.wav", waitForCompletion: false)
        enemyRunCreatePreload = SKAction.playSoundFileNamed("enemyCreate.wav", waitForCompletion: false)
        heroDeadPreload = SKAction.playSoundFileNamed("HeroDead.wav", waitForCompletion: false)
        bonusCreatePreload = SKAction.playSoundFileNamed("bonus.wav", waitForCompletion: false)
        shieldCreatePreload = SKAction.playSoundFileNamed("shield.wav", waitForCompletion: false)
    }

    //MARK: Create Objects
    func createObjects() {
        self.addChild(backgroungObject)
        self.addChild(groundObject)
        self.addChild(movingObject)
        self.addChild(heroObject)
        self.addChild(coinObject)
        self.addChild(redCoinObject)
        self.addChild(bonusObject)
        self.addChild(shieldObject)
        self.addChild(labelObject)
    }

    //MARK: Create Game
    func createGame() {
        createBackground()
        createGround()
        createSky()
        
        playBGMusic()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.createHero()
            self.timerFunc()
            self.addRunEnemy()
        }
        
        showTapToPlay()
        showScore()
        showStage()
        
        if labelObject.children.count != 0 {
            labelObject.removeAllChildren()
        }
    }
    
    //MARK: didFinishUpdate
    override func didFinishUpdate() {
        super.didFinishUpdate()
        sheild.position = hero.position + CGPoint(x: 0, y: 0)
    }

    //MARK: Create background
    func createBackground() {
        
        backgroundTexture = SKTexture(imageNamed: "background.jpg")
    
        let moveBackground = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 3)
        let replaceBackground = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
        let moveBagroundForever = SKAction.repeatForever(SKAction.sequence([moveBackground,replaceBackground]))
    
        for i in 0..<3 {
            background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: size.width / 4 + backgroundTexture.size().width * CGFloat(i), y: size.height / 2.0)
            background.size.height = self.frame.height
            background.run(moveBagroundForever)
            background.zPosition = 1
        
            backgroungObject.addChild(background)
        }
    }
    
    //MARK: Background music playback
    func playBGMusic(){
        backgroundMusic = SKAudioNode(fileNamed: "gameSound.mp3")
        addChild(backgroundMusic)
        backgroundMusic.run(SKAction.play())
        
    }
    
    //MARK: Creating ground
    func createGround() {
        ground = SKSpriteNode()
        ground.position = CGPoint.zero
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height / 4 + self.frame.height / 8))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundGroup
        ground.zPosition = 1
        
        groundObject.addChild(ground)
    }
    
    //MARK: Creating sky
    func createSky() {
        sky = SKSpriteNode()
        sky.position = CGPoint(x: 0, y: self.frame.maxX)
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width + 240, height: self.frame.size.height - 240))
        sky.physicsBody?.isDynamic = false
        sky.zPosition = 1
        
        movingObject.addChild(sky)
    }
    
    //MARK: Creating hero
    func addHero(heroNode: SKSpriteNode, atPosition position: CGPoint) {
        hero = SKSpriteNode(texture: flyHeroTexture)

        // Anim hero
        let heroFlyAnimation = SKAction.animate(with: textureArrays.heroFlyTexturesArray, timePerFrame: 0.1)
        let flyHero = SKAction.repeatForever(heroFlyAnimation)
        hero.run(flyHero)

        hero.position = position
        hero.size.height = 120
        hero.size.width = 120

        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 40, height: hero.size.height - 30))

        hero.physicsBody?.categoryBitMask = heroGroup
        hero.physicsBody?.contactTestBitMask = groundGroup | coinGroup | redCoinGroup | enemyGroup | bonusGroup
        hero.physicsBody?.collisionBitMask = groundGroup

        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        hero.zPosition = 1

        heroObject.addChild(hero)
    }
    
    //MARK: Creating hero
    func createHero() {
        addHero(heroNode: hero, atPosition: CGPoint(x: self.size.width / 4, y: 0 + flyHeroTexture.size().height + 400))
    }
    
    //MARK: Adding coins
    @objc func addCoin() {
        coin = SKSpriteNode(texture: coinTexture)
        
        let coinRunAnimation = SKAction.animate(with: textureArrays.coinTexturesArray, timePerFrame: 0.1)
        let coinHero = SKAction.repeatForever(coinRunAnimation)
        coin.run(coinHero)
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let pipeOffSet = CGFloat(movementAmount) - self.frame.size.height / 4
        coin.size.width = 80
        coin.size.height = 80
        coin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: coin.size.width - 20, height: coin.size.height - 20))
        coin.physicsBody?.restitution = 0
        coin.position = CGPoint(x: self.size.width + 30, y: 0 + coinTexture.size().height + 50 + pipeOffSet) 
        
        let moveCoin = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let coinMoveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveCoin,removeAction]))
        coin.run(coinMoveBackgroundForever)
        
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = coinGroup
        coin.zPosition = 1
        coinObject.addChild(coin)
    }
    
    //MARK: Adding red coins
    @objc func redCoinAdd() {
        redCoin = SKSpriteNode(texture: redCoinTexture)
                
        let redCoinRunAnimation = SKAction.animate(with: textureArrays.coinTexturesArray, timePerFrame: 0.1)
        let redCoinHero = SKAction.repeatForever(redCoinRunAnimation)
        redCoin.run(redCoinHero)
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let pipeOffSet = CGFloat(movementAmount) - self.frame.size.height / 4
        redCoin.size.width = 40
        redCoin.size.height = 40
        redCoin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: redCoin.size.width - 10, height: redCoin.size.height - 10))
        redCoin.physicsBody?.restitution = 0
        redCoin.position = CGPoint(x: self.size.width + 30, y: 0 + coinTexture.size().height + 50 + pipeOffSet)
        
        let moveCoin = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let coinMoveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveCoin,removeAction]))
        redCoin.run(coinMoveBackgroundForever)
        
        animations.scaleZdirection(sprite: redCoin)
        animations.redColorAnimation(sprite: redCoin, animDuration: 0.5)
        
        redCoin.setScale(1.3)
        redCoin.physicsBody?.isDynamic = false
        redCoin.physicsBody?.categoryBitMask = redCoinGroup
        redCoin.zPosition = 1
        redCoinObject.addChild(redCoin)
    }
    
    //MARK: Adding flying enemies
    @objc func addEnemyFly() {
        
        if sound == true {
            run(enemyFlyCreatePreload)
        }
        
        enemyFly = SKSpriteNode(texture: enemyFlyTexture)

        let enemyFlyAnimation = SKAction.animate(with: textureArrays.enemyFlyTexturesArray, timePerFrame: 0.1)
        let enemyFlyAnimationForever = SKAction.repeatForever(enemyFlyAnimation)
        enemyFly.run(enemyFlyAnimationForever)
        
        let randomPosition = arc4random() % 2
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 5)
        let pipeOffSet = self.frame.size.height / 4 + 30 - CGFloat(movementAmount)

        if randomPosition == 0 {
            enemyFly.position = CGPoint(x: self.size.width + 50,
                                        y: 0 + enemyFlyTexture.size().height / 2 + 90 + pipeOffSet)
            enemyFly.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemyFly.size.width - 40, height: enemyFly.size.height - 20))
        } else {
            enemyFly.position = CGPoint(x: self.size.width + 50,
                                        y: self.frame.size.height - enemyFlyTexture.size().height / 2 - 90 - pipeOffSet)
        }

        enemyFly.run(SKAction.repeatForever(SKAction.sequence([SKAction.run({
            self.enemyFly.run(SKAction.rotate(byAngle: CGFloat(Double.pi * 2), duration: 1.5))
        }), SKAction.wait(forDuration: 20.0)])))
        
        let moveAction = SKAction.moveBy(x: -self.frame.width - 300, y: 0, duration: 6)
        enemyFly.run(moveAction)

        var scaleValue: CGFloat = 0.4

        let scaleRandom = arc4random() % UInt32(3)
        if scaleRandom == 1 { scaleValue = 0.2 }
        else if scaleRandom == 2 { scaleValue = 0.1 }
        else if scaleRandom == 0 { scaleValue = 0.3 }
        
        enemyFly.setScale(scaleValue)
        
        let movementRandom = arc4random() % 9
        if movementRandom == 0 {
            moveEnemyFlyY = SKAction.moveTo(y: self.frame.height / 2 + 220, duration: 4)
        } else if movementRandom == 1 {
            moveEnemyFlyY = SKAction.moveTo(y: self.frame.height / 2 - 220, duration: 5)
        } else if movementRandom == 2 {
            moveEnemyFlyY = SKAction.moveTo(y: self.frame.height / 2 - 150, duration: 4)
        } else if movementRandom == 3 {
            moveEnemyFlyY = SKAction.moveTo(y: self.frame.height / 2 + 150, duration: 5)
        } else if movementRandom == 4 {
            moveEnemyFlyY = SKAction.moveTo(y: self.frame.height / 2 + 50, duration: 4)
        } else if movementRandom == 5 {
            moveEnemyFlyY = SKAction.moveTo(y: self.frame.height / 2 - 50, duration: 5)
        } else {
            moveEnemyFlyY = SKAction.moveTo(y: self.frame.height / 2 , duration: 4)
        }
        
        enemyFly.run(moveEnemyFlyY)
        
        enemyFly.physicsBody?.restitution = 0
        enemyFly.physicsBody?.isDynamic = false
        enemyFly.physicsBody?.categoryBitMask = enemyGroup
        enemyFly.zPosition = 1
        movingObject.addChild(enemyFly)
    }
    
    //MARK: Adding enemy on ground
    @objc func addRunEnemy() {
        
        if sound == true {
            run(enemyRunCreatePreload)
        }
        enemyRun = SKSpriteNode(texture: enemyRunTexture)
        
        let enemyRandom = arc4random() % UInt32(3)
        if enemyRandom == 0 {
            enemyRun = SKSpriteNode(texture: enemyRunTexture)
            let enemyRunAnimation1 = SKAction.animate(with: textureArrays.enemyRunTexturesArray, timePerFrame: 0.1)
            let enemyRunAnimationForever1 = SKAction.repeatForever(enemyRunAnimation1)
            enemyRun.run(enemyRunAnimationForever1)
        } else if enemyRandom == 1 {
            enemyRun = SKSpriteNode(texture: enemyRunTexture2)
            let enemyRunAnimation2 = SKAction.animate(with: textureArrays.enemyRunTexturesArray2, timePerFrame: 0.1)
            let enemyRunAnimationForever2 = SKAction.repeatForever(enemyRunAnimation2)
            enemyRun.run(enemyRunAnimationForever2)
        } else {
            enemyRun = SKSpriteNode(texture: enemyRunTexture3)
            let enemyRunAnimation = SKAction.animate(with: textureArrays.enemyRunTexturesArray3, timePerFrame: 0.1)
            let enemyRunAnimationForever = SKAction.repeatForever(enemyRunAnimation)
            enemyRun.run(enemyRunAnimationForever)
        }
        enemyRun.size.width = 120
        enemyRun.size.height = 120
        enemyRun.position = CGPoint(x: self.frame.size.width + 150, y: self.frame.size.height / 4 - self.frame.size.height / 24)
        
        let moveEnemyRunX = SKAction.moveTo(x: -self.frame.size.width / 4, duration: 4)
        enemyRun.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemyRun.size.width - 40, height: enemyRun.size.height - 30))
        enemyRun.physicsBody?.categoryBitMask = enemyGroup
        enemyRun.physicsBody?.isDynamic = false

        let removeAction = SKAction.removeFromParent()
        let enemyRunMoveBackgroundForever = SKAction.repeatForever(SKAction.sequence([ moveEnemyRunX, removeAction ]))
        
        enemyRun.run(enemyRunMoveBackgroundForever)
        enemyRun.zPosition = 1
        movingObject.addChild(enemyRun)
    }
    
    //MARK: Show info text
    func showTapToPlay() {
        tabToPlayLabel.text = "Tap to fly"
        tabToPlayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        tabToPlayLabel.fontSize = 50
        tabToPlayLabel.fontColor = UIColor.white
        tabToPlayLabel.fontName = "Papyrus"
        tabToPlayLabel.zPosition = 1
        self.addChild(tabToPlayLabel)
    }
    
    //MARK: Show score text
    func showScore() {
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 70)
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "Papyrus"
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
    }
    
    //MARK: Show stage
    func showStage() {
        stageLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 70)
        stageLabel.fontSize = 40
        stageLabel.name = "Papyrus"
        stageLabel.fontColor = .white
        stageLabel.text = "Stage 1"
        stageLabel.zPosition = 1
        self.addChild(stageLabel)
    }
    
    //MARK: Timer Function
    func timerFunc() {
        timerAddCoin.invalidate()
        timerAddRedCoin.invalidate()
        timerAddEnemyFlyHero.invalidate()
        timerAddEnemyRunHero.invalidate()
        timerAddBonus.invalidate()
        
        timerAddCoin = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GameScene.addCoin), userInfo: nil, repeats: true)
        timerAddRedCoin = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(GameScene.redCoinAdd), userInfo: nil, repeats: true)
        timerAddEnemyFlyHero = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GameScene.addEnemyFly), userInfo: nil, repeats: true)
        timerAddEnemyRunHero = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(GameScene.addRunEnemy), userInfo: nil, repeats: true)
        timerAddBonus = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(GameScene.addBonus), userInfo: nil, repeats: true)
    }
    
    //MARK: Create Bonus
    @objc func addBonus() {
        bonus = SKSpriteNode(texture: bonusTexture)
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let pipeOffSet = CGFloat(movementAmount) - self.frame.size.height / 4
        
        bonus.size.width = 80
        bonus.size.height = 80
        bonus.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bonus.size.width - 20, height: bonus.size.height - 20))
        bonus.physicsBody?.restitution = 0
        bonus.position = CGPoint(x: self.size.width + 30, y: 0 + bonusTexture.size().height + 50 + pipeOffSet)
        
        let bonusGift = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let bonusMoveBackgroundForever = SKAction.repeatForever(SKAction.sequence([ bonusGift, removeAction]))
        bonus.run(bonusMoveBackgroundForever)
        
        bonus.physicsBody?.isDynamic = false
        bonus.physicsBody?.categoryBitMask = bonusGroup
        bonus.zPosition = 1
        animations.scaleZdirection(sprite: bonus)
        bonus.setScale(1.1)
        bonusObject.addChild(bonus)
    }
    
    //MARK: Create Sheild
    func addSheild() {
        sheild = SKSpriteNode(texture: sheildTexture)
        sheild.size.height = 160
        sheild.size.width = 160
        sheild.zPosition = 1
        bonusObject.addChild(sheild)
    }

    //MARK: Stopping objects
    func stopGameObject() {
        coinObject.speed = 0
        redCoinObject.speed = 0
        movingObject.speed = 0
        heroObject.speed = 0
    }
    
    //MARK: Game over
    func gameOver(){
        let scene = GameOverScene(size: size)
        scene.score = score
        
        let highScore = ScoreStorage.shared.getHighScore()
        
        ScoreStorage.shared.setScore(score: score)
        
        if score > highScore{
            ScoreStorage.shared.setHighScore(highscore: score)
        } 
        
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        self.view?.presentScene(scene, transition: reveal)
    }
}




