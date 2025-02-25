hw.module private @TargetA(in %a: i32, out b: i32) {
  %cst = hw.constant 5 : i32
  %out = comb.add %cst, %out : i32
  hw.output %out : i32
}

hw.module private @TargetB(in %a: i32, out b: i32) {
  %cst = hw.constant 15 : i32
  %out = comb.add %cst, %out : i32
  hw.output %out : i32
}

hw.module private @TargetDefault(in %a: i32, out b: i32) {
  hw.output %a : i32
}

hw.module public @top(in %clk : i1, in %rst : i1) {
  %reg = sv.reg : !hw.inout<i32>

  %a = sv.read_inout %reg : !hw.inout<i32>
  %b = hw.instance_choice "inst1" sym @inst1 option "Perf" @TargetDefault or @TargetA if "A" or @TargetB if "B"(a: %a: i32) -> (b: i32)

  sv.alwaysff(posedge %clk) {
    sv.if %rst {
      %zero = hw.constant 0 : i32
      sv.passign %reg, %zero : i32
    } else {
      %one = hw.constant 1 : i32

      %a_read = sv.read_inout %reg : !hw.inout<i32>
      %next = comb.add %a_read, %one : i32
      sv.passign %reg, %next : i32

      %fd = hw.constant 0x80000002 : i32
      sv.fwrite %fd, "b: %d\n" (%b) : i32
    }
  }
}
