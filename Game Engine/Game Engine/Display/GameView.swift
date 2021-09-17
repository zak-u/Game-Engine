//
//  GameView.swift
//  Game Engine
//
//  Created by Zakhary on 9/16/21.
//

import MetalKit

class GameView: MTKView {
    
    var renderer : Renderer!
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        Engine.Ignite(device: device!)
        
        //color that wil be in the back, when we redraw view
        self.clearColor = Preferences.ClearColor
        
        self.colorPixelFormat = Preferences.MainPixelFormat
        
        //состояние конвейера рендеринга : Render pipeline state
        /*
         MTL Libriary -> vertex(вершин) shader and fragment shader
        Render pipeline descriptor:
         - color attachments (pixel Format !!!)
         - vertex function
         - fragment function
         */
        self.renderer = Renderer()
        
        self.delegate = renderer
    }
    
    //Mouse Input
        
    //Keyboard Input
    

}
