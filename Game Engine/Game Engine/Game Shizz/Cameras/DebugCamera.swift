import simd

class DebugCamera: Camera {
    var cameraType: CameraTypes = CameraTypes.Debug
    
    var position: SIMD3<Float> = SIMD3<Float>(0,0,0)
    
    var projectionMatrix : matrix_float4x4 {
        return matrix_float4x4.perspective(degreesFov: 45,
                                           aspectRatio: Renderer.AcpectRation ,
                                           near: 0.1,
                                           far: 1000)
    }
    
    func update(deltaTime: Float) {
        if(Keyboard.IsKeyPressed(.leftArrow)){
            self.position.x -= deltaTime
        }
        
        if(Keyboard.IsKeyPressed(.rightArrow)){
            self.position.x += deltaTime
        }
        
        if(Keyboard.IsKeyPressed(.upArrow)){
            self.position.y += deltaTime
        }
        
        if(Keyboard.IsKeyPressed(.downArrow)){
            self.position.y -= deltaTime
        }
    }
}
