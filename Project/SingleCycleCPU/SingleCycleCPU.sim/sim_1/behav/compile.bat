@echo off
set xv_path=D:\\vivado\\Xilinx\\Vivado\\2017.2\\bin
echo "xvlog -m64 --relax -prj tb_Single_Cycle_CPU_vlog.prj"
call %xv_path%/xvlog  -m64 --relax -prj tb_Single_Cycle_CPU_vlog.prj -log xvlog.log
call type xvlog.log > compile.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
