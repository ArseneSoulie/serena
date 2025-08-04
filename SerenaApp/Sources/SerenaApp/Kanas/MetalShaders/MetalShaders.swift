// A metal device for access to the GPU.

import Metal
nonisolated(unsafe) public var metalDevice: MTLDevice!

// A metal library.
nonisolated(unsafe) public var packageMetalLibrary: MTLLibrary!

// Function to perform the initial setup for Metal processing on the GPU
public func setupMetal() {
    // Create metal device for the default GPU:
    metalDevice = MTLCreateSystemDefaultDevice()
    
    // Create the library of metal functions
    // Note: Need to use makeDefaultLibrary(bundle:) as the "normal"
    //       call makeDefaultLibrary() returns nil.
    packageMetalLibrary = try? metalDevice.makeDefaultLibrary(bundle: Bundle.module)

    // List the available Metal shader functions
    print(packageMetalLibrary.functionNames)

    //
    // ... add additional setup code here ...
    //

}
