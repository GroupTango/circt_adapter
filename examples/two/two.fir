FIRRTL version 2.0.0
circuit Mux4 :
  module Invert :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<2>, out : UInt<2>}

    node _T = xor(io.in, UInt<2>("h3"))
    io.out <= _T

  module Mux2 :
    input clock : Clock
    input reset : Reset
    output io : { flip sel : UInt<1>, flip in0 : UInt<1>, flip in1 : UInt<1>, out : UInt<1>}

    node _T = and(io.sel, io.in1)
    node _T_1 = not(io.sel)
    node _T_2 = and(_T_1, io.in0)
    node _T_3 = or(_T, _T_2)
    io.out <= _T_3

  module Mux2_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip sel : UInt<1>, flip in0 : UInt<1>, flip in1 : UInt<1>, out : UInt<1>}

    node _T = and(io.sel, io.in1)
    node _T_1 = not(io.sel)
    node _T_2 = and(_T_1, io.in0)
    node _T_3 = or(_T, _T_2)
    io.out <= _T_3

  module Mux2_2 :
    input clock : Clock
    input reset : Reset
    output io : { flip sel : UInt<1>, flip in0 : UInt<1>, flip in1 : UInt<1>, out : UInt<1>}

    node _T = and(io.sel, io.in1)
    node _T_1 = not(io.sel)
    node _T_2 = and(_T_1, io.in0)
    node _T_3 = or(_T, _T_2)
    io.out <= _T_3

  module Mux4 :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in0 : UInt<1>, flip in1 : UInt<1>, flip in2 : UInt<1>, flip in3 : UInt<1>, flip sel : UInt<2>, out1 : UInt<1>, out2 : UInt<2>}

    inst i1 of Invert
    i1.clock <= clock
    i1.reset <= reset
    i1.io.in <= io.sel
    inst m0 of Mux2
    m0.clock <= clock
    m0.reset <= reset
    node _T = bits(i1.io.out, 0, 0)
    m0.io.sel <= _T
    m0.io.in0 <= io.in0
    m0.io.in1 <= io.in1
    inst m1 of Mux2_1
    m1.clock <= clock
    m1.reset <= reset
    node _T_1 = bits(i1.io.out, 0, 0)
    m1.io.sel <= _T_1
    m1.io.in0 <= io.in2
    m1.io.in1 <= io.in3
    inst m2 of Mux2_2
    m2.clock <= clock
    m2.reset <= reset
    node _T_2 = bits(i1.io.out, 1, 1)
    m2.io.sel <= _T_2
    m2.io.in0 <= m0.io.out
    m2.io.in1 <= m1.io.out
    io.out1 <= m2.io.out
    io.out2 <= i1.io.out