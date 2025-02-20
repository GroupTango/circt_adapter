FIRRTL version 2.0.0
circuit PassthroughGenerator :
  module PassthroughGenerator :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<10>, out : UInt<10>}

    io.out <= io.in @[cmd2.sc 6:10]