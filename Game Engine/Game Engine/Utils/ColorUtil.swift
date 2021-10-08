import simd

class ColorUtil {
    
    public static var randomColor: SIMD4<Float> {
        return SIMD4<Float>(Float.randomZeroToOne, Float.randomZeroToOne, Float.randomZeroToOne, 1.0)
    }
    
}
