quit -sim
# Create the library.
if [file exists work] {
        vdel -all
}
vlib work
vcom ampel.vhd
vcom testbench.vhd
vsim -debugdb testbench
vcd file testbench.vcd
vcd add testbench/*

run 200 sec

quit

