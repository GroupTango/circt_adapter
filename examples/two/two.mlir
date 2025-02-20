module {
  hw.module private @Invert(in %io_in : i2, out io_out : i2) {
    %c-1_i2 = hw.constant -1 : i2
    %0 = comb.xor bin %io_in, %c-1_i2 {sv.namehint = "io_out"} : i2
    hw.output %0 : i2
  }
  hw.module private @Mux2(in %io_sel : i1, in %io_in0 : i1, in %io_in1 : i1, out io_out : i1) {
    %true = hw.constant true
    %0 = comb.and bin %io_sel, %io_in1 : i1
    %1 = comb.xor bin %io_sel, %true : i1
    %2 = comb.and bin %1, %io_in0 : i1
    %3 = comb.or bin %0, %2 {sv.namehint = "io_out"} : i1
    hw.output %3 : i1
  }
  hw.module @Mux4(in %clock : !seq.clock, in %reset : i1, in %io_in0 : i1, in %io_in1 : i1, in %io_in2 : i1, in %io_in3 : i1, in %io_sel : i2, out io_out : i1) {
    %i1.io_out = hw.instance "i1" @Invert(io_in: %io_sel: i2) -> (io_out: i2) {sv.namehint = "i1.io_out"}
    %m0.io_out = hw.instance "m0" @Mux2(io_sel: %0: i1, io_in0: %io_in0: i1, io_in1: %io_in1: i1) -> (io_out: i1) {sv.namehint = "m2.io_in0"}
    %0 = comb.extract %i1.io_out from 0 {sv.namehint = "m1.io_sel"} : (i2) -> i1
    %m1.io_out = hw.instance "m1" @Mux2(io_sel: %0: i1, io_in0: %io_in2: i1, io_in1: %io_in3: i1) -> (io_out: i1) {sv.namehint = "m2.io_in1"}
    %m2.io_out = hw.instance "m2" @Mux2(io_sel: %1: i1, io_in0: %m0.io_out: i1, io_in1: %m1.io_out: i1) -> (io_out: i1) {sv.namehint = "m2.io_out"}
    %1 = comb.extract %i1.io_out from 1 {sv.namehint = "m2.io_sel"} : (i2) -> i1
    hw.output %m2.io_out : i1
  }
  om.class @Mux4_Class(%basepath: !om.basepath) {
    om.class.fields
  }
}
