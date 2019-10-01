//
//  GameScene.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreData
import UIKit

class GameScene: SKScene,  SKPhysicsContactDelegate {
    // create players and enemies
    var earth:Earth?
    var ship:Ship?
    var blueEnemy:BlueEnemy?
    var greenEnemy: GreenEnemy?
    
    // create category bit masks
    var earthCategory: UInt32 = 0x1 << 1
    var shipCategory: UInt32 = 0x1 << 2
    var blueEnemyCategory: UInt32 = 0x1 << 3
    var greenEnemyCategory: UInt32 = 0x1 << 4
    var bulletCategory: UInt32 = 0x1 << 5
    
    // create timers
    var blueEnemyTimer:Timer?
    var bulletTimer:Timer?
    var greenEnemyTimer:Timer?
    
    var isShipPressed: Bool = false
    
    var gameOverLabel:SKLabelNode?
    var gameOver:Bool = false
    
    var scoreLabel : SKLabelNode?
    var score:Int = 0
    
    var earthHealthLabel: SKLabelNode?
    var shipHealthLabel: SKLabelNode?
    
    var login = LogInScene()
    var userName:String?
    
    override func didMove(to view: SKView) {
        // create a border, so ship doesn't leave the screen
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        physicsWorld.contactDelegate = self
        
        backgroundColor = .black
        
        // create earth and ship
        createEarth()
        
        createShip()
        
        // create score label
        scoreLabel = SKLabelNode()
        scoreLabel?.name = "scoreLabel"
        scoreLabel?.fontSize = 30
        scoreLabel?.fontColor = .red
        scoreLabel?.text = "Score: \( (score) )"
        scoreLabel?.position = CGPoint(x: -size.width/2 + 80, y: size.height/2 - 60)
        
        // create earth's health label
        earthHealthLabel = SKLabelNode()
        earthHealthLabel?.name = "healthLabel"
        earthHealthLabel?.fontSize = 20
        earthHealthLabel?.fontColor = UIColor.cyan
        earthHealthLabel?.text = "Earth: \( (earth?.getHealth())!)"
        earthHealthLabel?.position = CGPoint(x: size.width/2 - 65, y: size.height/2 - 60)
        
        // create ship's health label
        shipHealthLabel = SKLabelNode()
        shipHealthLabel?.name = "shipLabel"
        shipHealthLabel?.fontSize = 20
        shipHealthLabel?.fontColor = .gray
        shipHealthLabel?.text = "Ship: \( (ship?.getHealth())! )"
        shipHealthLabel?.position = CGPoint(x: size.width/2 - 65, y: size.height/2 - 40)
        
        // add the labels
        self.addChild(scoreLabel!)
        self.addChild(earthHealthLabel!)
        self.addChild(shipHealthLabel!)
        
        // spawn blueEnemy every 1.5 seconds
        blueEnemyTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createBlueEnemy), userInfo: nil, repeats: true)
        
        // spawn greenEnemy every 1.8 seconds
        greenEnemyTimer = Timer.scheduledTimer(timeInterval: 1.8, target: self, selector: #selector(createGreenEnemy), userInfo: nil, repeats: true)
    }
    
    func createShip(){
        ship = Ship()
        // set category and contact bit mask
        ship?.physicsBody?.categoryBitMask = shipCategory
        ship?.physicsBody?.contactTestBitMask = blueEnemyCategory
        
        self.addChild(ship!)
    }
    
    func createEarth(){
        earth = Earth(sizeOfScreen: self.size)
        // set category, contact, and collision bit mask
        earth?.physicsBody?.categoryBitMask = earthCategory
        earth?.physicsBody?.contactTestBitMask = blueEnemyCategory | greenEnemyCategory
        earth?.physicsBody?.collisionBitMask =  0
        
        self.addChild(earth!)
    }
    
    @objc func createBlueEnemy(){
        blueEnemy = BlueEnemy(sizeOfScreen: self.size)
        // set category, contact, and collision bit mask
        blueEnemy?.physicsBody?.categoryBitMask = blueEnemyCategory
        blueEnemy?.physicsBody?.contactTestBitMask = shipCategory | bulletCategory
        blueEnemy?.physicsBody?.collisionBitMask = greenEnemyCategory
        
        self.addChild( blueEnemy!)
        
        // give blueEnemy random speeds
        let randomSpeed = Int.random(in: 6..<10)
        blueEnemy?.moveDown(screenSize: size, shipSize: (blueEnemy?.size)!, spd: randomSpeed)
    }
    
    @objc func createGreenEnemy(){
        greenEnemy = GreenEnemy(sizeOfScreen: self.size)
        // set category, contact, and collision bit mask
        greenEnemy?.physicsBody?.categoryBitMask = greenEnemyCategory
        greenEnemy?.physicsBody?.contactTestBitMask = shipCategory | bulletCategory
        greenEnemy?.physicsBody?.collisionBitMask = blueEnemyCategory
        
        self.addChild(greenEnemy!)
        
        // give greenEnemy random speeds
        let randomSpeed = Int.random(in: 2..<8)
        greenEnemy?.moveDown(screenSize: size, shipSize: (greenEnemy?.size)!, spd: randomSpeed)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if(gameOver){
            
        }
        else{
            if( (contact.bodyA.categoryBitMask == shipCategory && contact.bodyB.categoryBitMask == blueEnemyCategory) || (contact.bodyA.categoryBitMask == blueEnemyCategory && contact.bodyB.categoryBitMask == shipCategory) ){
                // decrease health of ship
                ship?.decreaseHealth(attackDamage: 5)
                
                // check to see if it's game over
                checkGame()
                
                // deal with collision
                if firstBody.categoryBitMask == blueEnemyCategory{
                    collisionWithPlayer(enemy: firstBody.node as! SKSpriteNode)
                }
                else if (secondBody.categoryBitMask == blueEnemyCategory){
                    collisionWithPlayer(enemy: secondBody.node as! SKSpriteNode)
                }
            }
            else if((contact.bodyA.categoryBitMask == earthCategory && contact.bodyB.categoryBitMask == blueEnemyCategory) || (contact.bodyA.categoryBitMask == blueEnemyCategory && contact.bodyB.categoryBitMask == earthCategory) ){
                // decrease health of earth
                earth?.decreaseHealth(attackDamage: 5)
                
                // check to see if it's game over
                checkGame()
                
                // deal with collision
                if firstBody.categoryBitMask == blueEnemyCategory{
                    collisionWithPlayer(enemy: firstBody.node as! SKSpriteNode)
                }
                else if(secondBody.categoryBitMask == blueEnemyCategory){
                    collisionWithPlayer(enemy: secondBody.node as! SKSpriteNode)
                }
            }
            else if((contact.bodyA.categoryBitMask == earthCategory && contact.bodyB.categoryBitMask == greenEnemyCategory) || (contact.bodyA.categoryBitMask == greenEnemyCategory && contact.bodyB.categoryBitMask == earthCategory) ){
                // decrease health of earth
                earth?.decreaseHealth(attackDamage: 10)
                
                // check to see if it's game over
                checkGame()
                
                // deal with collision
                if firstBody.categoryBitMask == greenEnemyCategory{
                    collisionWithPlayer(enemy: firstBody.node as! SKSpriteNode)
                }
                else if(secondBody.categoryBitMask == greenEnemyCategory){
                    collisionWithPlayer(enemy: secondBody.node as! SKSpriteNode)
                }
            }
            else if ( (contact.bodyA.categoryBitMask == shipCategory && contact.bodyB.categoryBitMask == greenEnemyCategory) || (contact.bodyA.categoryBitMask == greenEnemyCategory && contact.bodyB.categoryBitMask == shipCategory) ){
                // decrease health of ship
                ship?.decreaseHealth(attackDamage: 10)
                
                // check to see if it's game over
                checkGame()
                
                // deal with collision
                if firstBody.categoryBitMask == greenEnemyCategory{
                    collisionWithPlayer(enemy: firstBody.node as! SKSpriteNode)
                }
                else if (secondBody.categoryBitMask == greenEnemyCategory){
                    collisionWithPlayer(enemy: secondBody.node as! SKSpriteNode)
                }
            }
            else if ( (contact.bodyA.categoryBitMask == bulletCategory && contact.bodyB.categoryBitMask == greenEnemyCategory) || (contact.bodyA.categoryBitMask == greenEnemyCategory && contact.bodyB.categoryBitMask == bulletCategory) ){
                
                // deal with collision
                collisionWithBullet(enemy: contact.bodyA.node as! SKSpriteNode, bullet: contact.bodyB.node as! SKSpriteNode)
                
                score += 15 // increase score
            }
            else if ( (contact.bodyA.categoryBitMask == bulletCategory && contact.bodyB.categoryBitMask == blueEnemyCategory) || (contact.bodyA.categoryBitMask == blueEnemyCategory && contact.bodyB.categoryBitMask == bulletCategory) ){
                
                // deal with collision
                collisionWithBullet(enemy: contact.bodyA.node as! SKSpriteNode, bullet: contact.bodyB.node as! SKSpriteNode)
                
                score += 10 // increase score
            }
            scoreLabel?.text = "Score: \(score)"
            earthHealthLabel?.text = "Earth: \( (earth?.getHealth())!)"
            shipHealthLabel?.text = "Ship: \( (ship?.getHealth())! )"
        }
        
    }
    
    func checkGame(){
        if ( (earth?.getHealth())! <= 0 || (ship?.getHealth())! <= 0 ){
            // set gameOver to true, stop the game, save user information, and show top ten players
            gameOver = true
            stopGame()
            saveInfo()
            showTopTen()
        }
    }
    
    func showTopTen(){
        // create a final score label to show the user
        let finalScore = SKLabelNode()
        finalScore.position = CGPoint(x: 0, y: 0)
        finalScore.text = "Final Score: \(score)"
        finalScore.fontSize = 30
        finalScore.fontColor = .green
        self.addChild(finalScore)
        
        // show "top ten player" screen after 3 seconds
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
            finalScore.removeFromParent()
            // show "top ten player" screen
            let topTenPlayer = TopTenPlayerScene()
            topTenPlayer.scaleMode = self.scaleMode
            let reveal = SKTransition.doorsOpenVertical(withDuration: 10)
            self.view!.presentScene(topTenPlayer, transition: reveal)
        }
    }
    
    func saveInfo(){
        // get user's name
        userName = login.getUserName()
        
        // saving user information
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        // set user's score and name
        newUser.setValue(userName, forKey: "userName")
        newUser.setValue(score, forKey: "userScore")
        
        do{
            try context.save()
        }
        catch {
            print("I/O unsuccesful")
        }
    }
    
    func collisionWithBullet(enemy : SKSpriteNode, bullet: SKSpriteNode){
        enemy.removeFromParent()
        bullet.removeFromParent()
    }
    
    func collisionWithPlayer(enemy: SKSpriteNode){
        enemy.removeFromParent()
    }
    
    @objc func createBullet(){
        var bullet:Bullet?
        bullet = Bullet()
        
        // set up bullet's physical properties
        bullet?.position = CGPoint(x: (ship?.position.x)!, y: ((ship?.position.y)! + 50))
        bullet?.physicsBody?.categoryBitMask = bulletCategory
        bullet?.physicsBody?.contactTestBitMask = blueEnemyCategory | greenEnemyCategory
        
        self.addChild(bullet!)
        bullet?.moveUp(size, (bullet?.size)!) // animate the bullet
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if the user touches the ship, create a bullet and fire it
        if(!gameOver){
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            
            if let body = physicsWorld.body(at: touchLocation){
                if body.node!.name == "ship"{
                    isShipPressed = true
                    
                    // create a bullet every 0.6 seconds
                    bulletTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(createBullet), userInfo: nil, repeats: true)
                }
            }
        }
        else{
            stopGame()
        }
    }
    
    func stopGame(){
        // remove everything from the screen
        self.removeAllChildren()
        blueEnemyTimer?.invalidate()
        greenEnemyTimer?.invalidate()
        bulletTimer?.invalidate()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // move the ship according to the user's touch
        if (isShipPressed && !gameOver){
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            ship?.run(SKAction.move(to: touchLocation, duration: 0.1))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isShipPressed = false
        bulletTimer?.invalidate()
        ship?.removeAllActions()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isShipPressed = false
        bulletTimer?.invalidate()
        ship?.removeAllActions()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}


