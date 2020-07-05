//
//  ViewController.swift
//  SceneKitTest
//
//  Created by 福山帆士 on 2020/07/05.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
// タップしたらshipを追加表示する(この方法だと環境の変化に適応できない)
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = SCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        // これ入れないとobjectの色がつかない
        sceneView.autoenablesDefaultLighting = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        sceneView.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        guard let scene = SCNScene(named: "ship.scn", inDirectory: "art.scnassets") else {
            return
        }
        let shipNode = (scene.rootNode.childNode(withName: "ship", recursively: false))!
        // nodeだけを取り出す
        
        let position = sender.location(in: sceneView) // tapしたlocation取得
        let results = sceneView.hitTest(position, types: .featurePoint) // sceneView上の特徴点取得(配列)
        
        if !results.isEmpty {
            let hitTestResult = results.first! //　最初のhitTest
            let transform = hitTestResult.worldTransform // hitTestを空間全体に変換
            
            shipNode.position = SCNVector3( // objectのposition
                transform.columns.3.x,
                transform.columns.3.y,
                transform.columns.3.z
            )
            sceneView.scene.rootNode.addChildNode(shipNode) // 追加
        }
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
