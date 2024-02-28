@echo off
set xv_path=D:\\vivado\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto eb3083f3f5e94470b6d51761613ab66a -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot Sim_behav xil_defaultlib.Sim xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
