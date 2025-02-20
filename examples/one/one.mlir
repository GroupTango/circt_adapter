module {
  hw.module @PassthroughGenerator(in %clock : !seq.clock, in %reset : i1, in %io_in : i10, out io_out : i10) {
    hw.output %io_in : i10
  }
  om.class @PassthroughGenerator_Class(%basepath: !om.basepath) {
    om.class.fields
  }
}
