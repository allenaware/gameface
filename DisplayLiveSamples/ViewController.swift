//
//  ViewController.swift
//  DisplayLiveSamples
//
//  Created by Luis Reisewitz on 15.05.16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

extension SKNode {
    class func unarchiveFromFileName(fileName : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class ViewController: UIViewController {
    let sessionHandler = SessionHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sessionHandler.openSession()
        
//        let previewLayer: AVCaptureVideoPreviewLayer = sessionHandler.preview
//        previewLayer.frame = self.view.bounds
//        self.view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        let layer = sessionHandler.layer
        layer.frame = self.view.bounds
        self.view.layer.addSublayer(layer)
        
        ////
        if let scene = GameScene.unarchiveFromFileName("GameScene") as? GameScene {
            // Configure the view.
            
            let skView = SKView(frame: view.frame)
            skView.allowsTransparency = true
            self.view.addSubview(skView as UIView)
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.backgroundColor = UIColor.clearColor()
            skView.presentScene(scene)
        }
        ////

    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

