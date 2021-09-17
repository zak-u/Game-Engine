//
//  GameView.swift
//  Game Engine
//
//  Created by Zakhary on 9/16/21.
//

import MetalKit

class GameView: MTKView {
    
    var vertices : [Vertex]!
    var vertexBuffer: MTLBuffer!
    
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
        
        createVertices()
        
        //create buffers vertex
        createBuffers()
    }
    
    func createVertices() {
        vertices = [
            Vertex(position: SIMD3<Float>(0,1,0), color: SIMD4<Float>(1,0,0,1)),
            Vertex(position: SIMD3<Float>(-1,-1,0), color: SIMD4<Float>(0,1,0,1)),
            Vertex(position: SIMD3<Float>(1,-1,0), color: SIMD4<Float>(0,0,1,1)),
        
        ]
    }
    
    func createBuffers() {
        vertexBuffer = device?.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let drawble = self.currentDrawable, let renderPassDescriptor = self.currentRenderPassDescriptor else { return }
        //buffer of our tasks(bf1 computing texture, bf2 render texture)
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        /*Command Encoder 4 types:
         - render Command Encoder (render graphics)
         - compute Command Encoder(computation tasks)
         - blit Command Encoder (memmory menagment task)
         - parallel Command Encoder (multiple graphic rendaring task)
         */
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderCommandEncoder?.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        //send info to rendercommandcoder
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawble)
        commandBuffer?.commit()
    }

}
