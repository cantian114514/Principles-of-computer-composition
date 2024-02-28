@echo off
set xv_path=D:\\vivado\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim tb_Single_Cycle_CPU_behav -key {Behavioral:sim_1:Functional:tb_Single_Cycle_CPU} -tclbatch tb_Single_Cycle_CPU.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
