//
//  GameView.swift
//  Game Engine
//
//  Created by Zakhary on 9/16/21.
//

import MetalKit

class GameView: MTKView {
    
    struct Vertex {
        
        var position: SIMD3<Float>
        var color: SIMD4<Float>
    }
    var commandQueue : MTLCommandQueue!
    var renderPipelineState : MTLRenderPipelineState!
    
    let vertices : [SIMD3<Float>] = [
        SIMD3<Float>(0,1,0),//top middle
        SIMD3<Float>(-1,-1,0),//bottom left
        SIMD3<Float>(1,-1,0)//bottom right
    ]
    
    var vertexBuffer: MTLBuffer!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.device = MTLCreateSystemDefaultDevice()
        
        //color that wil be in the back, when we redraw view
        self.clearColor = MTLClearColor(red: 0.43, green: 0.85, blue: 0.35, alpha: 1.0)
        
        self.colorPixelFormat = .bgra8Unorm
        
        self.commandQueue = device?.makeCommandQueue()
        
        //состояние конвейера рендеринга : Render pipeline state
        /*
         MTL Libriary -> vertex(вершин) shader and fragment shader
        Render pipeline descriptor:
         - color attachments (pixel Format !!!)
         - vertex function
         - fragment function
         */
        
        createRenderPipelineState()
        
        //create buffers vertex
        createBuffers()
    }
    
    func createBuffers() {
        vertexBuffer = device?.makeBuffer(bytes: vertices, length: MemoryLayout<SIMD3<Float>>.stride*vertices.count, options: [])
    }
    
    func createRenderPipelineState() {
        let library = device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_shader")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        do {
            renderPipelineState = try device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let drawble = self.currentDrawable, let renderPassDescriptor = self.currentRenderPassDescriptor else { return }
        //buffer of our tasks(bf1 computing texture, bf2 render texture)
        let commandBuffer = commandQueue.makeCommandBuffer()
        /*Command Encoder 4 types:
         - render Command Encoder (render graphics)
         - compute Command Encoder(computation tasks)
         - blit Command Encoder (memmory menagment task)
         - parallel Command Encoder (multiple graphic rendaring task)
         */
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        //send info to rendercommandcoder
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawble)
        commandBuffer?.commit()
    }

}
