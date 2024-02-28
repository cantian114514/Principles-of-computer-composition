@echo off
set xv_path=D:\\vivado\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto afcb104e5aaf4a72973e58500631a0f3 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_Single_Cycle_CPU_behav xil_defaultlib.tb_Single_Cycle_CPU xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
