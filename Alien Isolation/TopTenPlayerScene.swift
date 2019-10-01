//
//  TopTenPlayerScene.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit
import CoreData

class TopTenPlayerScene: SKScene, UITableViewDataSource, UITableViewDelegate  {
    
    let simpleTableIdentifier = "SimpleTableIdentifier"
    
    // create a table
    private var myTableView: UITableView!
    
    // create an array of user names, and user scores
    var usersName:[String] = []
    var usersScore:[String] = []
    
    override func didMove(to view: SKView) {
        // add a tap gesture to signal that the user wants to go back to the "menu" screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view?.addGestureRecognizer(tapGesture)
        
        // create the table
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view!.frame.width
        let displayHeight: CGFloat = self.view!.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.backgroundColor = .black//UIColor.lightGray
        
        // table header
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        label.text = "Top Ten Players"
        label.textAlignment = .center
        label.font = label.font.withSize(50)
        label.textColor = .black
        label.backgroundColor = .red
        myTableView.tableHeaderView = label
        
        // add the table
        self.view!.addSubview(myTableView)
        
        // retrieve information
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                // sort the results from largest to smallest
                let sort = NSSortDescriptor(key: "userScore", ascending: false)
                
                request.fetchLimit = 10 // gets top 10 data
                request.sortDescriptors = [sort]
                
                do{
                    // get the top tep user scores
                    let fetchRequest = try context.fetch(request) as! [User]
                    
                    // for each score, append it to user name, and user score
                    for result in fetchRequest as! [NSManagedObject] {
                        // if there is a username get it's score
                        if let userName = result.value(forKey: "userName") as? String {
                            
                            let score = result.value(forKey: "userScore") as! Int
                            let newScore = String(score)
                            
                            // append data to array
                            var row:[String] = []
                            row.append(userName)
                            row.append(newScore)
                            
                            usersName.append(userName)
                            usersScore.append(newScore)
                        }
                    }
                }catch{
                    print("cannot fetch")
                }
                
            }
        }
        catch {
            
        }
    }
    
    
    @objc func handleTap(){
        // remove table
        myTableView.removeFromSuperview()
        
        // create "menu"
        let menu = MenuScene(size:size)
        menu.scaleMode = scaleMode
        
        // show "menu" screen
        let reveal = SKTransition.doorsOpenVertical(withDuration: 1)
        view!.presentScene(menu, transition: reveal)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return amount of users
        return usersName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        let rank = indexPath.row + 1
        
        // style the cell, display user's rank, user's name and user's score
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .red
        cell.textLabel!.text = "\(rank). \t" + "User: " + usersName[indexPath.row] + " \t Score: " + usersScore[indexPath.row]
        
        return cell
    }
    
    
}
