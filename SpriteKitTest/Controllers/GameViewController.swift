//
//  GameViewController.swift
//  SpriteKitTest
//
//  Created by Роман далинкевич on 14.10.2021.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var textureAtlas = SKTextureAtlas(named: "scene.atlas")
    @IBOutlet var loadingView: UIView!
    @IBOutlet var loadingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingImageView.image = UIImage(named: "presentGame.jpeg")
        loadingView.isHidden = false
        
        textureAtlas.preload {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.loadingView.isHidden = true
                let scene = GameScene(size: CGSize(width: 1024, height: 768))
                let skView = self.view as! SKView
                skView.presentScene(scene)
            }
        }
    }
}
