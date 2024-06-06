//
//  GameBase.swift
//  Shooting
//
//  Created by yuki on 2024/06/06.
//

import Foundation
import SpriteKit

class ScoreManager {
    static let shared = ScoreManager()
    
    private init() {}
    
    var score = 0  //scoreカウント
    
    var hero = 0 //ベストスコア
    
    var stage = 1 //ステージ数
    
    var debug = true //モード
    
    var reverse = false //裏ステージ
    
}

class GameBase: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        static let Alien: UInt32 = 1
        static let Bullet: UInt32 = 2
        static let Ship: UInt32 = 4
        static let Item: UInt32 = 8
    }
    
    let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
    let bestScoreLabel = SKLabelNode(fontNamed: "Helvetica")
    let stageLabel = SKLabelNode(fontNamed: "Helvetica")
    let ship = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        scoreLabel.text = "Score: \(ScoreManager.shared.score)"
        scoreLabel.fontSize = 25
        scoreLabel.position = CGPoint(x: UIScreen.main.bounds.maxX - 100, y: UIScreen.main.bounds.maxY - 100)
        scoreLabel.fontColor = .blue
        addChild(scoreLabel)
        
        bestScoreLabel.text = "BestScore: \(ScoreManager.shared.hero)"
        bestScoreLabel.fontSize = 25
        bestScoreLabel.position = CGPoint(x: UIScreen.main.bounds.minX + 100, y: UIScreen.main.bounds.maxY - 100)
        bestScoreLabel.fontColor = .blue
        addChild(bestScoreLabel)
        
        stageLabel.text = "Stage: \(ScoreManager.shared.stage)"
        stageLabel.fontSize = 25
        stageLabel.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 70)
        stageLabel.fontColor = .blue
        addChild(stageLabel)
        
        self.physicsWorld.contactDelegate = self
        
        makeDeadline()
        generateAliens()
        createShip()
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
        let startY = Int(UIScreen.main.bounds.maxY - 300)
        var startX = 50
        
        for row in 0..<ScoreManager.shared.stage {
            startX = 50
            if ScoreManager.shared.stage <= 5{
                for _ in 1...ScoreManager.shared.stage {
                    createAlien(pos: CGPoint(x: startX, y: startY + row * 30), color: .green)
                    startX += 35
                }
            }else{
                for _ in 1...5 {
                    createAlien(pos: CGPoint(x: startX, y: startY + row * 30), color: .green)
                    startX += 35
                }
            }
        }
    }
    
    func createItem() {
        let item = SKSpriteNode()
        item.size = CGSize(width: 25, height: 25)
        item.color = UIColor.yellow
        item.position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: UIScreen.main.bounds.height - 100)
        item.name = "item"
        
        item.physicsBody = SKPhysicsBody(rectangleOf: item.frame.size)
        item.physicsBody?.isDynamic = true
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.usesPreciseCollisionDetection = true
        item.physicsBody?.categoryBitMask = PhysicsCategory.Alien
        item.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        
        self.addChild(item)
        
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 0.3)
        let repeatSequence = SKAction.repeatForever(moveDown)
        
        item.run(repeatSequence)
    }
    
    func createAlien(pos: CGPoint, color: UIColor) {
        let alien = SKSpriteNode()
        alien.size = CGSize(width: 25, height: 25)
        alien.color = color
        alien.position = pos
        alien.name = "alien"
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.frame.size)
        alien.physicsBody?.isDynamic = false
        alien.physicsBody?.affectedByGravity = false
        alien.physicsBody?.usesPreciseCollisionDetection = true
        alien.physicsBody?.categoryBitMask = PhysicsCategory.Alien
        alien.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        
        self.addChild(alien)
        
        let moveRight = SKAction.move(by: CGVector(dx: 125, dy: 0), duration: 0.3)
        let moveLeft = SKAction.move(by: CGVector(dx: -125, dy: 0), duration: 0.3)
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 0.3)
        let wait = SKAction.wait(forDuration: 0.1)
        
        let sequence = SKAction.sequence([moveRight, wait, moveDown, moveLeft, wait])
        let repeatSequence = SKAction.repeatForever(sequence)
        
        alien.run(repeatSequence)
    }
    
    func createShip() {
        ship.size = CGSize(width: 50, height: 50)
        ship.color = UIColor.blue
        ship.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
        ship.name = "ship"
        
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
        let bullet = SKShapeNode(circleOfRadius: 5)
        bullet.fillColor = .red
        bullet.strokeColor = bullet.fillColor
        bullet.name = "bullet"
        bullet.position = CGPoint(x: ship.position.x, y: ship.position.y + 20)
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        
        addChild(bullet)
        
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 800), duration: 1.0)
        let delete = SKAction.removeFromParent()
        let sequenceActions = SKAction.sequence([moveUp, delete])
        
        bullet.run(sequenceActions)
    }
    
   //  タッチ処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        createBullet()
        ship.position.y = 100
    }
    
    var lastBulletFireTime = 0.0
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let currentTime = Date().timeIntervalSince1970
            if currentTime - lastBulletFireTime >  (ScoreManager.shared.stage >= 5 ? 0.15 : 0.2) {
                lastBulletFireTime = currentTime
                DispatchQueue.main.asyncAfter(deadline: .now() + (ScoreManager.shared.stage >= 5 ? 0.15 : 0.2)) {
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
            if node.position.y <= 100 {
                if ScoreManager.shared.score > ScoreManager.shared.hero {
                    ScoreManager.shared.hero = ScoreManager.shared.score
                    self.bestScoreLabel.text = "BestScore: \(ScoreManager.shared.hero)"
                }
                self.GameOver()
            }
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
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()

            ScoreManager.shared.score += 10
            scoreLabel.text = "Score: \(ScoreManager.shared.score)"
        }
        
        if collisionObject.categoryBitMask == PhysicsCategory.Ship {
            if ScoreManager.shared.score > ScoreManager.shared.hero {
                ScoreManager.shared.hero = ScoreManager.shared.score
                bestScoreLabel.text = "BestScore: \(ScoreManager.shared.hero)"
            }
            GameOver()
        }
        
        if countSpriteNodes() == 0 {
            ScoreManager.shared.reverse.toggle()
            ScoreManager.shared.stage += 1
            let scene = ScoreManager.shared.reverse ? GameScene2() : GameScene()
            scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scene.scaleMode = .fill
            scene.backgroundColor = ScoreManager.shared.reverse ? .black : .white
            view?.presentScene(scene, transition: .flipVertical(withDuration: 1.0))
        }
    }
}

extension SKNode {
    func countSpriteNodes() -> Int {
        var count = 0
        enumerateChildNodes(withName: "alien") { node, _ in
            if node is SKSpriteNode {
                count += 1
            }
        }
        return count
    }
}
