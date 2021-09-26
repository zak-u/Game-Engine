import MetalKit

class Renderer: NSObject {
        
}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //When the window is resized
    }
    
    func draw(in view: MTKView) {
        guard let drawble = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        //buffer of our tasks(bf1 computing texture, bf2 render texture)
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        /*Command Encoder 4 types:
         - render Command Encoder (render graphics)
         - compute Command Encoder(computation tasks)
         - blit Command Encoder (memmory menagment task)
         - parallel Command Encoder (multiple graphic rendaring task)
         */
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        //change position
        
        SceneManager.TickScene(renderCommandEncoder: renderCommandEncoder!, deltaTime: 1/Float(view.preferredFramesPerSecond)) 
        
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawble)
        commandBuffer?.commit()
        
    }
    
}
