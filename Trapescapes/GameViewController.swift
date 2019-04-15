//
//  GameViewController.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 08/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    //var music = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'MenuScene.swift'
            let gameSceneTemp = MenuScene()
            gameSceneTemp.scene?.anchorPoint = CGPoint(x: 0, y: 1)
            gameSceneTemp.scene?.size = CGSize(width: 750, height: 1334)
            view.presentScene(gameSceneTemp, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))

            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            //initialize background music using Singleton
            MusicManager.shared.setup()
            MusicManager.shared.play()
        }
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
