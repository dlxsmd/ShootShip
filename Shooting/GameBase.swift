//
//  GameBase.swift
//  Shooting
//
//  Created by yuki on 2024/06/06.
//

import Foundation
import SpriteKit

class ValueManager {
    static let shared = ValueManager()
    
    private init() {}
    
    var score = 0  //scoreカウント
    
    var hero = 0 //ベストスコア
    
    var stage = 0 //ステージ数(defaultは0)
    
    var bossstage = 0 //ボスステージ
    
    var isDebug = true //モード
    
    var isBoss = true //ボスステージ(defaultはfalse)
    
    var isDouble = false //二重弾
    
    var isBest = false //ベストスコア
    
}

class GameBase: SKScene, SKPhysicsContactDelegate {
    
    
    let value = ValueManager.shared
    
    
    struct PhysicsCategory {
        static let Alien: UInt32 = 1
        static let Bullet: UInt32 = 2
        static let Ship: UInt32 = 4
        static let Item: UInt32 = 8
        static let Boss: UInt32 = 16
    }
    
    let background = SKSpriteNode(imageNamed: "background")
    let scoreLabel = SKLabelNode()
    let bestScoreLabel = SKLabelNode()
    let stageLabel = SKLabelNode()
    let ship = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.physicsWorld.contactDelegate = self
        
        value.stage += 1
        makeBackground()
        waveLabel()
        makescoreLabel(pos: CGPoint(x: UIScreen.main.bounds.maxX - 100, y: UIScreen.main.bounds.maxY - 100))
        makebestscoreLabel(pos: CGPoint(x: UIScreen.main.bounds.minX + 100, y: UIScreen.main.bounds.maxY - 100))
        makeStageLabel(pos: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 70))
        createShip()
        //    makeDeadline()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            
            self.generateAliens()
        }
    }
    
    func waveLabel(){
        let waveLabel = SKLabelNode(fontNamed: "Helvetica")
        waveLabel.text = "Wave \(value.stage)"
        waveLabel.fontSize = 50
        waveLabel.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        waveLabel.fontColor = .white
        addChild(waveLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            waveLabel.removeFromParent()
        }
    }
    
    func makeBackground(){
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        addChild(background)
    }
    
    func makeStageLabel(pos: CGPoint){
        stageLabel.text = "Wave : \(value.stage)"
        stageLabel.fontSize = 25
        stageLabel.position = pos
        stageLabel.fontName = "JF-Dot-ShinonomeMaru-12-Regular"
        stageLabel.fontColor = .white
        addChild(stageLabel)
    }
    
    func makebestscoreLabel(pos: CGPoint){
        bestScoreLabel.text = "BestScore: \(value.hero)"
        bestScoreLabel.fontSize = 25
        bestScoreLabel.position = pos
        bestScoreLabel.fontName = "JF-Dot-ShinonomeMaru-12-Regular"
        bestScoreLabel.fontColor = .white
        bestScoreLabel.alpha = 0.7
        addChild(bestScoreLabel)
    }
    
    func makescoreLabel(pos: CGPoint){
        scoreLabel.text = "Score: \(value.score)"
        scoreLabel.fontSize = 25
        scoreLabel.position = pos
        scoreLabel.fontName = "JF-Dot-ShinonomeMaru-12-Regular"
        scoreLabel.fontColor = .white
        scoreLabel.alpha = 0.7
        addChild(scoreLabel)
    }
        
    func makeDeadline() {
        var points = [CGPoint(x: 0, y: 0), CGPoint(x: frame.width, y: 0)]
        
        let deadline = SKShapeNode(points: &points, count: points.count)
        
        deadline.position = CGPoint(x: 0, y: UIScreen.main.bounds.minY + 100)
        deadline.alpha = 1.0
        deadline.strokeColor = UIColor.red
        addChild(deadline)
    }
    
    func generateAliens() {
        let startY = Int(UIScreen.main.bounds.maxY - 100)
        
        for row in 0..<value.stage {
            
            for _ in 0..<2{
                createAlien(pos: CGPoint(x: Int.random(in: Int(UIScreen.main.bounds.midX / 2)..<Int(UIScreen.main.bounds.midX * (3/2))), y: startY + row * 25), color: .green)
            }
        }
    }
    
    func createItem(pos: CGPoint) {
        let item = SKSpriteNode()
        item.texture = SKTexture(imageNamed: "item")
        item.size = CGSize(width: 50, height: 50)
        item.position = pos
        item.zPosition = 0
        item.name = "item"
        
        item.physicsBody = SKPhysicsBody(rectangleOf: item.frame.size)
        item.physicsBody?.isDynamic = true
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.usesPreciseCollisionDetection = true
        item.physicsBody?.allowsRotation = false
        item.physicsBody?.categoryBitMask = PhysicsCategory.Item
        item.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        
        self.addChild(item)
        
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 0.3)
        let repeatSequence = SKAction.repeatForever(moveDown)
        
        item.run(repeatSequence)
    }
    
    func createAlien(pos: CGPoint, color: UIColor) {
        let alien = SKSpriteNode()
        let alienTexture = ["alien1","alien2","alien3","alien4","alien5"]
        alien.size = CGSize(width: 50, height: 50)
        alien.texture = SKTexture(imageNamed: alienTexture.randomElement()!)
        alien.position = pos
        alien.name = "alien"
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.frame.size)
        alien.physicsBody?.isDynamic = false
        alien.physicsBody?.affectedByGravity = false
        alien.physicsBody?.usesPreciseCollisionDetection = true
        alien.physicsBody?.categoryBitMask = PhysicsCategory.Alien
        alien.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        
        self.addChild(alien)
        
        let moveRight = SKAction.move(by: CGVector(dx: Int.random(in: 30...Int(UIScreen.main.bounds.width / 4)), dy: 0), duration: 0.2)
        let moveLeft = SKAction.move(by: CGVector(dx: -Int.random(in: 30...Int(UIScreen.main.bounds.width / 4)), dy: 0), duration: 0.2)
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -Int.random(in: 30...50)), duration: 0.1)
        let wait = SKAction.wait(forDuration: 0.05)
        let seq = [moveRight,moveLeft,moveDown,moveDown,wait]
        
        //ランダムにシークエンスを作成
        
        let sequence = SKAction.sequence(seq.shuffled())
        let sequence2 = SKAction.sequence(seq.shuffled())
        let sequence3 = SKAction.sequence(seq.shuffled())
        let sequence4 = SKAction.sequence(seq.shuffled())
        let sequence5 = SKAction.sequence(seq.shuffled())
        
        let randomSequence = [sequence,sequence2,sequence3,sequence4,sequence5]
        
        let repeatSequence = SKAction.repeatForever(randomSequence.randomElement()!)
        
        alien.run(repeatSequence)
    }
    
    func createShip() {
        ship.texture = SKTexture(imageNamed: "player")
        ship.size = CGSize(width: 75, height: 75)
        ship.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
        ship.name = "ship"
        ship.zPosition = 1
        
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.frame.size)
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.affectedByGravity = false
        ship.physicsBody?.usesPreciseCollisionDetection = true
        ship.physicsBody?.allowsRotation = false
        ship.physicsBody?.categoryBitMask = PhysicsCategory.Ship
        ship.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        
        self.addChild(ship)
    }
    
    func createBullet() {
        let bullet = SKSpriteNode()
        let bulletTexture = ["makaron1","makaron2"]
        
        bullet.texture = SKTexture(imageNamed: bulletTexture.randomElement()!)
        bullet.size = CGSize(width: 50, height: 50)
        bullet.name = "bullet"
        bullet.position = CGPoint(x: ship.position.x, y: ship.position.y + 65)
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        
        addChild(bullet)
        
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 800), duration: 2.0)
        let delete = SKAction.removeFromParent()
        let sequenceActions = SKAction.sequence([moveUp, delete])
        
        bullet.run(sequenceActions)
        
        if value.isDouble {
            let bullet2 = SKSpriteNode()
            bullet2.texture = SKTexture(imageNamed: bulletTexture.randomElement()!)
            bullet2.size = CGSize(width: 50, height: 50)
            bullet2.name = "bullet"
            bullet.position = CGPoint(x: ship.position.x + 25, y: ship.position.y + 65)
            bullet2.position = CGPoint(x: ship.position.x - 25, y: ship.position.y + 65)
            
            bullet2.physicsBody = SKPhysicsBody(rectangleOf: bullet2.frame.size)
            bullet2.physicsBody?.isDynamic = true
            bullet2.physicsBody?.affectedByGravity = false
            bullet2.physicsBody?.usesPreciseCollisionDetection = true
            bullet2.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
            bullet2.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
            
            addChild(bullet2)
            
            let moveUp2 = SKAction.move(by: CGVector(dx: -25, dy: 800), duration: 2.0)
            let delete2 = SKAction.removeFromParent()
            let sequenceActions2 = SKAction.sequence([moveUp2, delete2])
            
            bullet2.run(sequenceActions2)
        }
    }
    
    //  タッチ処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentTime = Date().timeIntervalSince1970
        if currentTime - lastBulletFireTime >  0.2 {
            lastBulletFireTime = currentTime
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.createBullet()
            }
        }
        
        ship.position.y = 100
    }
    
    var lastBulletFireTime = 0.0
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let currentTime = Date().timeIntervalSince1970
            if currentTime - lastBulletFireTime >  0.2 {
                lastBulletFireTime = currentTime
                DispatchQueue.main.asyncAfter(deadline: .now() +  0.2 ) {
                    self.createBullet()
                }
            }
            let location = touch.location(in: self)
            ship.position = CGPoint(x: location.x, y: 100)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        checkForGameOver()
    }
    
    func checkForGameOver() {
        enumerateChildNodes(withName: "alien") { node, _ in
            
            if node.position.x > UIScreen.main.bounds.maxX {
                node.position.x = UIScreen.main.bounds.minX + 25
            }
            if node.position.x < UIScreen.main.bounds.minX {
                node.position.x = UIScreen.main.bounds.maxX - 25
            }
            if node.position.y < 0 {
                self.explosion(pos: node.position)
                node.removeFromParent()
            }
            if self.countSpriteNodes(name: "alien") == 0 {
                if self.value.stage % 10 == 0{
                    self.value.isBoss = true
                }
                let scene = self.value.isBoss ? BossScene() : GameScene()
                scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                scene.scaleMode = .fill
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.view?.presentScene(scene)
                    
                }
            }
        }
    }
        
        func explosion(pos: CGPoint) {
            let explosion = SKSpriteNode()
            explosion.size = CGSize(width: 30, height: 30)
            explosion.position = pos
            explosion.texture = SKTexture(imageNamed: "explosion")
            addChild(explosion)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                explosion.removeFromParent()
            }
        }
        
        func GameOver() {
            let scene = GameOverScene()
            scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scene.backgroundColor = .black
            scene.scaleMode = .fill
            view?.presentScene(scene, transition: .flipVertical(withDuration: 1.0))
        }
        
        func didBegin(_ contact: SKPhysicsContact) {
            let collisionObject = contact.bodyA.categoryBitMask == PhysicsCategory.Alien ? contact.bodyB : contact.bodyA
            
            if collisionObject.categoryBitMask == PhysicsCategory.Bullet {
                explosion(pos: contact.contactPoint)
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                
                Int.random(in: 0...30) == 0 ? createItem(pos: contact.contactPoint) : nil
                
                value.score += 10
                scoreLabel.text = "Score: \(value.score)"
            }
            
            if collisionObject.categoryBitMask == PhysicsCategory.Ship {
                if self.value.score > self.value.hero {
                    self.value.hero = self.value.score
                    self.bestScoreLabel.text = "BestScore: \(self.value.hero)"
                    self.value.isBest = true
                }
                GameOver()
            }
            if collisionObject.categoryBitMask == PhysicsCategory.Item {
                contact.bodyA.node?.removeFromParent()
                value.isDouble = true
                print(value.isDouble)
                DispatchQueue.main.asyncAfter(deadline: .now() + 15.0){
                    self.value.isDouble = false
                    print(self.value.isDouble)
                }
            }
            
            if countSpriteNodes(name: "alien") == 0 {
                if value.stage % 10 == 0{
                    value.isBoss.toggle()
                }
                let scene = value.isBoss ? BossScene() : GameScene()
                scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                scene.scaleMode = .fill
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.view?.presentScene(scene)
                    
                }
            }
        }
    }

extension SKNode {
    func countSpriteNodes(name: String) -> Int {
        var count = 0
        enumerateChildNodes(withName: name) { node, _ in
            if node is SKSpriteNode {
                count += 1
            }
        }
        return count
    }
}
