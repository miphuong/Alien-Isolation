//
//  LogInScene.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreData
import UIKit

class LogInScene: SKScene {
    // create sprite node for "start game" button
    var startGame = SKSpriteNode(imageNamed: "startGame")
    
    // create textfields and labels for user to enter name
    var infoTF = UILabel()
    var errorMessage =  UILabel()
    var logInTF = UITextField()
    
    var isUserNameValid:Bool = false
    
    // user's name
    struct user{
        static var userNameOfPlayer:String = ""
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        // create a label to tell the user to create a user name to log in
        infoTF = UILabel(frame: CGRect(x: self.size.width/2 - 100, y: self.size.height/2 - 250, width: 200, height: 40))
        infoTF.backgroundColor = SKColor.black
        infoTF.textColor = .red
        infoTF.text = "Create User Name:"
        
        // create a text field for user to enter their information
        logInTF = UITextField(frame: CGRect(x: self.size.width/2 - 100, y: self.size.height/2 - 200, width: 150, height: 40))
        logInTF.backgroundColor = SKColor.white
        logInTF.placeholder = "name"
        
        // create a "start game" button
        startGame.name = "startGame"
        startGame.size.width = 200
        startGame.size.height = 100
        startGame.position = CGPoint(x: self.size.width/2, y: self.size.height - 400)
        startGame.color = .red
        
        // create an error message, if user did not create a user name
        errorMessage = UILabel(frame: CGRect(x: self.size.width/2 - 100, y: self.size.height/2 - 145, width: 240, height: 35))
        errorMessage.backgroundColor = .yellow
        errorMessage.text = "Please create a user name first"
        errorMessage.textColor = .red
        errorMessage.layer.borderWidth = 2
        errorMessage.isHidden = true
        
        // add everything to screen
        self.view?.addSubview(errorMessage)
        self.view?.addSubview(infoTF)
        self.view?.addSubview(logInTF)
        self.addChild(startGame)
        
        // create a done button for the keyboard, so user can dismiss the keyboard after using it
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: (self.view?.frame.size.width)!, height: 30))
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([doneBtn], animated: false)
        toolbar.sizeToFit()
        self.logInTF.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view?.endEditing(true)
    }
    
    func getUserName() -> String{
        return user.userNameOfPlayer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // dismiss keyboard if user touches screen
        logInTF.resignFirstResponder()
        
        // get touch location of user
        let touch = touches.first
        
        let positionInScene = touch?.location(in: self)
        
        let touchNode = self.atPoint(positionInScene!)
        
        // check if "start game" button is pressed
        if let name = touchNode.name {
            if name == "startGame"{
                // checks to see if user entered a user name
                if( (logInTF.text!).count > 0 ){
                    // set the user name
                    user.userNameOfPlayer = logInTF.text!
                    
                    // remove textfields and labels
                    logInTF.removeFromSuperview()
                    infoTF.removeFromSuperview()
                    errorMessage.removeFromSuperview()
                    
                    isUserNameValid = true
                    
                    // create "game scene"
                    let gameScene = SKScene(fileNamed: "GameScene")
                    gameScene?.scaleMode = .resizeFill
                    
                    // show "game scene"
                    let reveal = SKTransition.doorsOpenVertical(withDuration: 1)
                    view!.presentScene(gameScene!, transition: reveal)
                } else{
                    // show error message if user did not enter a user name
                    errorMessage.isHidden = false
                }
                
            }
        }
        
    }
    
}
