quit -sim
# Create the library.

if [file exists work] {
        vdel -all
}
vlib work
vcom alu.vhd
vcom testbench.vhd
vsim -debugdb testbench -t 1ps
vcd file testbench.vcd
vcd add -r testbench/*

run 200000

quit

