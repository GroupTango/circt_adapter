FIRRTL version 2.0.0
circuit KnightTop :
  module ResetGen :
    input clock : Clock
    input reset : Reset
    output io : { resetOut : UInt<1>}

    reg cnt : UInt<4>, clock with :
      reset => (UInt<1>("h0"), cnt)
    node _T = neq(cnt, UInt<4>("hf"))
    when _T :
      node _T_1 = add(cnt, UInt<1>("h1"))
      node _T_2 = tail(_T_1, 1)
      cnt <= _T_2
      io.resetOut <= UInt<1>("h1")
    else :
      cnt <= cnt
      io.resetOut <= UInt<1>("h0")

  module Tick :
    input clock : Clock
    input reset : Reset
    output io : { tick : UInt<1>}

    reg r1 : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0"))
    node limit = eq(r1, UInt<23>("h7f2814"))
    node _T = add(r1, UInt<1>("h1"))
    node _T_1 = tail(_T, 1)
    r1 <= _T_1
    when limit :
      r1 <= UInt<1>("h0")
    io.tick <= limit

  module KnightRider :
    input clock : Clock
    input reset : Reset
    output io : { led : UInt<6>}

    reg stateReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0"))
    reg ledReg : UInt<6>, clock with :
      reset => (reset, UInt<6>("h1"))
    inst tick of Tick
    tick.clock <= clock
    tick.reset <= reset
    node _T = eq(tick.io.tick, UInt<1>("h1"))
    when _T :
      node _T_1 = bits(ledReg, 4, 4)
      node _T_2 = eq(_T_1, UInt<1>("h1"))
      when _T_2 :
        stateReg <= UInt<1>("h1")
      else :
        node _T_3 = bits(ledReg, 1, 1)
        node _T_4 = eq(_T_3, UInt<1>("h1"))
        when _T_4 :
          stateReg <= UInt<1>("h0")
      node _T_5 = eq(stateReg, UInt<1>("h0"))
      when _T_5 :
        node _T_6 = shl(ledReg, 1)
        ledReg <= _T_6
      else :
        node _T_7 = shr(ledReg, 1)
        ledReg <= _T_7
    io.led <= ledReg

  module KnightTop :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip btn : UInt<4>, led : UInt<6>}

    node _T = bits(io.btn, 3, 3)
    node _T_1 = not(_T)
    node manReset = bits(_T_1, 0, 0)
    reg REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), REG)
    REG <= manReset
    reg syncBtn : UInt<1>, clock with :
      reset => (UInt<1>("h0"), syncBtn)
    syncBtn <= REG
    inst resGen of ResetGen
    resGen.clock <= clock
    resGen.reset <= reset
    node resetVal = or(syncBtn, resGen.io.resetOut)
    inst knight of KnightRider
    knight.clock <= clock
    knight.reset <= reset
    io.led <= knight.io.led