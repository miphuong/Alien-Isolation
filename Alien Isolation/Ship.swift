//
//  Ship.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import Foundation
import GameplayKit

class Ship : Player {
    
    let spriteTexture = SKTexture(imageNamed: "ship")
    
    init(){
        super.init(texture: spriteTexture, color: UIColor.clear, size: spriteTexture.size())
        
        // set up the Ship's physical properties
        self.name = "ship"
        self.size = CGSize(width: 65, height:65)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.position = CGPoint(x: 160, y: 0)
        self.zPosition = 10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
