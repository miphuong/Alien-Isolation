//
//  MenuScene.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    // create sprite nodes for buttons and pictures
    let newGame = SKSpriteNode(imageNamed: "newGame")
    let topTen = SKSpriteNode(imageNamed: "topTenPlayers")
    let exit = SKSpriteNode(imageNamed: "exit")
    let enemy = SKSpriteNode(imageNamed: "blueEnemy")
    let alienInvasion = SKSpriteNode(imageNamed: "alienInvasion")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        // create a visual effect, making the enemy dissappear and re-appear above the top of the screen
        enemy.position = CGPoint(x: self.size.width/2, y: self.size.height + 70)
        enemy.size.width = 600
        enemy.size.height = 600
        enemy.zPosition = 4
        let fadeOut = SKAction.fadeOut(withDuration: 3)
        let fadeIn = SKAction.fadeIn(withDuration: 2)
        let sequence = SKAction.sequence([fadeOut, fadeIn])
        let sequenceRepeat = SKAction.repeatForever(sequence)
        enemy.run(sequenceRepeat)
        
        // set up the title of the game
        alienInvasion.name = "alienInvasion"
        alienInvasion.size.width = 400
        alienInvasion.size.height = 300
        alienInvasion.zPosition = 3
        alienInvasion.position = CGPoint( x: self.size.width/2, y: (self.size.height/2 + 275) )
        
        // set up the "new game" button
        newGame.name = "newGame"
        newGame.size.width = 200
        newGame.size.height = 100
        newGame.position = CGPoint(x: self.size.width/2, y: (self.size.height/2 + 50) ) // 600
        
        // set up the "top ten players" button
        topTen.name = "topTenPlayers"
        topTen.size.width = 200
        topTen.size.height = 100
        topTen.position = CGPoint(x:self.size.width/2, y:(self.size.height/2 - 100)) // 400
        
        // set up the "exit" button
        exit.name = "exit"
        exit.size.width = 200
        exit.size.height = 100
        exit.position = CGPoint(x: self.size.width/2, y: (self.size.height/2 - 250)) // 200
        
        // add everything to the "menu" screen
        self.addChild(enemy)
        self.addChild(alienInvasion)
        self.addChild(newGame)
        self.addChild(topTen)
        self.addChild(exit)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get touch location of user
        let touch = touches.first
        
        let positionInScene = touch?.location(in: self)
        
        let touchNode = self.atPoint(positionInScene!)
        
        // check which buttons are pressed
        if let name = touchNode.name {
            if name == "newGame"{
                // create a "login" screen
                let logIn = LogInScene(size: size)
                logIn.scaleMode = .resizeFill
                
                // show the "login" screen
                let reveal = SKTransition.doorsOpenVertical(withDuration: 1)
                view!.presentScene(logIn, transition: reveal)
            }
            else if(name == "topTenPlayers"){
                // create a "top ten players" screen
                let topTenPlayer = TopTenPlayerScene()
                topTenPlayer.scaleMode = scaleMode
                
                // show the "top ten player" screen
                let reveal = SKTransition.doorsOpenVertical(withDuration: 1)
                view!.presentScene(topTenPlayer, transition: reveal)
                
            }
            else if(name == "exit"){
                // exit the game
                UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
            }
        }
        
    }
    
}
