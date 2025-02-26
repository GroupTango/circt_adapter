module {
  hw.module private @Tick(in %clock : !seq.clock, in %reset : i1, out io_tick : i1) {
    %c1_i32 = hw.constant 1 : i32
    %c8333332_i32 = hw.constant 8333332 : i32
    %c0_i32 = hw.constant 0 : i32
    %r1 = seq.firreg %2 clock %clock reset sync %reset, %c0_i32 {firrtl.random_init_start = 0 : ui64} : i32
    %0 = comb.icmp bin eq %r1, %c8333332_i32 {sv.namehint = "limit"} : i32
    %1 = comb.add bin %r1, %c1_i32 : i32
    %2 = comb.mux bin %0, %c0_i32, %1 : i32
    hw.output %0 : i1
  }
  hw.module private @KnightRider(in %clock : !seq.clock, in %reset : i1, out io_led : i6) {
    %true = hw.constant true
    %false = hw.constant false
    %c1_i6 = hw.constant 1 : i6
    %stateReg = seq.firreg %5 clock %clock reset sync %reset, %false {firrtl.random_init_start = 0 : ui64} : i1
    %ledReg = seq.firreg %11 clock %clock reset sync %reset, %c1_i6 {firrtl.random_init_start = 1 : ui64} : i6
    %tick.io_tick = hw.instance "tick" @Tick(clock: %clock: !seq.clock, reset: %reset: i1) -> (io_tick: i1)
    %0 = comb.extract %ledReg from 4 : (i6) -> i1
    %1 = comb.extract %ledReg from 1 : (i6) -> i1
    %2 = comb.xor %1, %true : i1
    %3 = comb.and %2, %stateReg : i1
    %4 = comb.or %0, %3 : i1
    %5 = comb.mux bin %tick.io_tick, %4, %stateReg : i1
    %6 = comb.extract %ledReg from 0 : (i6) -> i5
    %7 = comb.concat %6, %false : i5, i1
    %8 = comb.extract %ledReg from 1 : (i6) -> i5
    %9 = comb.concat %false, %8 : i1, i5
    %10 = comb.mux bin %stateReg, %9, %7 : i6
    %11 = comb.mux bin %tick.io_tick, %10, %ledReg : i6
    hw.output %ledReg : i6
  }
  hw.module @KnightTop(in %clock : !seq.clock, in %reset : i1, in %io_btn : i4, out io_led : i6) {
    %knight.io_led = hw.instance "knight" @KnightRider(clock: %clock: !seq.clock, reset: %reset: i1) -> (io_led: i6) {sv.namehint = "io_led"}
    hw.output %knight.io_led : i6
  }
  om.class @KnightTop_Class(%basepath: !om.basepath) {
    om.class.fields
  }
}
