//
//  GameViewController.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create "menu" screen
        let menu = MenuScene(size: view.bounds.size)
        let skView = self.view as! SKView
        
        // shows frames per second, and nodes
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        // show the "menu" screen
        menu.scaleMode = .resizeFill
        skView.presentScene(menu)
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

