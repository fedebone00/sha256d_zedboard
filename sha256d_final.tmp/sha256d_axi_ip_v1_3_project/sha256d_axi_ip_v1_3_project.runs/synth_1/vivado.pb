
>
Refreshing IP repositories
234*coregenZ19-234h px? 
?
 Loaded user IP repository '%s'.
1135*coregen2I
5d:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.02default:defaultZ19-1700h px? 
|
"Loaded Vivado IP repository '%s'.
1332*coregen23
D:/Xilinx/Vivado/2020.2/data/ip2default:defaultZ19-2313h px? 
?
?The host OS only allows 260 characters in a normal path. The IP cache path is more than 80 characters. If you experience issues with IP caching, please consider changing the IP cache to a location with a shorter path. Alternately consider using the OS subst command to map part of the path to a drive letter. 
Current IP cache path is %s 2293*coregen2?
md:/uni/rl/sha256d_zedboard/sha256d_final.tmp/sha256d_axi_ip_v1_3_project/sha256d_axi_ip_v1_3_project.cache/ip2default:defaultZ19-4995h px? 
?
Command: %s
53*	vivadotcl2O
;synth_design -top sha256d_axi_ip_v1_0 -part xc7z020clg484-12default:defaultZ4-113h px? 
:
Starting synth_design
149*	vivadotclZ4-321h px? 
?
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7z0202default:defaultZ17-347h px? 
?
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7z0202default:defaultZ17-349h px? 
?
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
22default:defaultZ8-7079h px? 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px? 
^
#Helper process launched with PID %s4824*oasys2
9962default:defaultZ8-7075h px? 
?
%s*synth2?
rStarting Synthesize : Time (s): cpu = 00:00:06 ; elapsed = 00:00:06 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
?
synthesizing module '%s'638*oasys2'
sha256d_axi_ip_v1_02default:default2g
Qd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0.vhd2default:default2
492default:default8@Z8-638h px? 
j
%s
*synth2R
>	Parameter C_S00_AXI_DATA_WIDTH bound to: 32 - type: integer 
2default:defaulth p
x
? 
i
%s
*synth2Q
=	Parameter C_S00_AXI_ADDR_WIDTH bound to: 7 - type: integer 
2default:defaulth p
x
? 
h
%s
*synth2P
<	Parameter C_S_AXI_DATA_WIDTH bound to: 32 - type: integer 
2default:defaulth p
x
? 
g
%s
*synth2O
;	Parameter C_S_AXI_ADDR_WIDTH bound to: 7 - type: integer 
2default:defaulth p
x
? 
?
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2/
sha256d_axi_ip_v1_0_S00_AXI2default:default2m
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
52default:default24
 sha256d_axi_ip_v1_0_S00_AXI_inst2default:default2/
sha256d_axi_ip_v1_0_S00_AXI2default:default2g
Qd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0.vhd2default:default2
852default:default8@Z8-3491h px? 
?
synthesizing module '%s'638*oasys2/
sha256d_axi_ip_v1_0_S00_AXI2default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
862default:default8@Z8-638h px? 
h
%s
*synth2P
<	Parameter C_S_AXI_DATA_WIDTH bound to: 32 - type: integer 
2default:defaulth p
x
? 
g
%s
*synth2O
;	Parameter C_S_AXI_ADDR_WIDTH bound to: 7 - type: integer 
2default:defaulth p
x
? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
slv_reg82default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5092default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
slv_reg92default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5092default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
	slv_reg102default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5092default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
	slv_reg112default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5092default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
	slv_reg122default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5092default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
	slv_reg132default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5092default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
	slv_reg142default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5092default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
	slv_reg152default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5092default:default8@Z8-614h px? 
[
%s
*synth2C
/	Parameter SIZE bound to: 352 - type: integer 
2default:defaulth p
x
? 
?
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
sha256d2default:default2Y
Ed:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256d.vhd2default:default2
342default:default2 
sha256d_inst2default:default2
sha256d2default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5762default:default8@Z8-3491h px? 
?
synthesizing module '%s'638*oasys2
sha256d2default:default2[
Ed:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256d.vhd2default:default2
472default:default8@Z8-638h px? 
[
%s
*synth2C
/	Parameter SIZE bound to: 352 - type: integer 
2default:defaulth p
x
? 
?
synthesizing module '%s'638*oasys2
sha2562default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
492default:default8@Z8-638h px? 
[
%s
*synth2C
/	Parameter SIZE bound to: 352 - type: integer 
2default:defaulth p
x
? 
?
synthesizing module '%s'638*oasys2
counter2default:default2[
Ed:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/counter.vhd2default:default2
332default:default8@Z8-638h px? 
Y
%s
*synth2A
-	Parameter SIZE bound to: 7 - type: integer 
2default:defaulth p
x
? 
Z
%s
*synth2B
.	Parameter START bound to: 0 - type: integer 
2default:defaulth p
x
? 
]
%s
*synth2E
1	Parameter TERMINAL bound to: 0 - type: integer 
2default:defaulth p
x
? 
?
%done synthesizing module '%s' (%s#%s)256*oasys2
counter2default:default2
12default:default2
12default:default2[
Ed:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/counter.vhd2default:default2
332default:default8@Z8-256h px? 
?
synthesizing module '%s'638*oasys2+
counter__parameterized02default:default2[
Ed:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/counter.vhd2default:default2
332default:default8@Z8-638h px? 
Y
%s
*synth2A
-	Parameter SIZE bound to: 7 - type: integer 
2default:defaulth p
x
? 
Z
%s
*synth2B
.	Parameter START bound to: 0 - type: integer 
2default:defaulth p
x
? 
^
%s
*synth2F
2	Parameter TERMINAL bound to: 63 - type: integer 
2default:defaulth p
x
? 
?
%done synthesizing module '%s' (%s#%s)256*oasys2+
counter__parameterized02default:default2
12default:default2
12default:default2[
Ed:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/counter.vhd2default:default2
332default:default8@Z8-256h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
words2default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
T12default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
T22default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
smallS02default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
smallS12default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
%done synthesizing module '%s' (%s#%s)256*oasys2
sha2562default:default2
22default:default2
12default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
492default:default8@Z8-256h px? 
?
synthesizing module '%s'638*oasys2*
sha256__parameterized02default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
492default:default8@Z8-638h px? 
[
%s
*synth2C
/	Parameter SIZE bound to: 256 - type: integer 
2default:defaulth p
x
? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
words2default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
T12default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
T22default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
smallS02default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
smallS12default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
1372default:default8@Z8-614h px? 
?
%done synthesizing module '%s' (%s#%s)256*oasys2*
sha256__parameterized02default:default2
22default:default2
12default:default2Z
Dd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256.vhd2default:default2
492default:default8@Z8-256h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
ready12default:default2[
Ed:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256d.vhd2default:default2
882default:default8@Z8-614h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
ready22default:default2[
Ed:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256d.vhd2default:default2
882default:default8@Z8-614h px? 
?
%done synthesizing module '%s' (%s#%s)256*oasys2
sha256d2default:default2
32default:default2
12default:default2[
Ed:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/src/sha256d.vhd2default:default2
472default:default8@Z8-256h px? 
?
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2!
sha256d_ready2default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
5792default:default8@Z8-614h px? 
?
%done synthesizing module '%s' (%s#%s)256*oasys2/
sha256d_axi_ip_v1_0_S00_AXI2default:default2
42default:default2
12default:default2o
Yd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0_S00_AXI.vhd2default:default2
862default:default8@Z8-256h px? 
?
%done synthesizing module '%s' (%s#%s)256*oasys2'
sha256d_axi_ip_v1_02default:default2
52default:default2
12default:default2g
Qd:/Uni/RL/sha256d_zedboard/ip_repo/sha256d_axi_ip_1.0/hdl/sha256d_axi_ip_v1_0.vhd2default:default2
492default:default8@Z8-256h px? 
?
%s*synth2?
rFinished Synthesize : Time (s): cpu = 00:00:08 ; elapsed = 00:00:08 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
}Finished Constraint Validation : Time (s): cpu = 00:00:08 ; elapsed = 00:00:09 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
J
%s
*synth22
Loading part: xc7z020clg484-1
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Loading Part and Timing Information : Time (s): cpu = 00:00:08 ; elapsed = 00:00:09 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
V
Loading part %s157*device2#
xc7z020clg484-12default:defaultZ21-403h px? 
?
3inferred FSM for state register '%s' in module '%s'802*oasys2$
currentstate_reg2default:default2
sha256d2default:defaultZ8-802h px? 
?
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth p
x
? 
?
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2s
_                   reset |                          0000001 |                              110
2default:defaulth p
x
? 
?
%s
*synth2s
_                 waiting |                          0000100 |                              000
2default:defaulth p
x
? 
?
%s
*synth2s
_                  round1 |                          0000010 |                              001
2default:defaulth p
x
? 
?
%s
*synth2s
_           waitinground1 |                          1000000 |                              010
2default:defaulth p
x
? 
?
%s
*synth2s
_                  round2 |                          0100000 |                              011
2default:defaulth p
x
? 
?
%s
*synth2s
_           waitinground2 |                          0010000 |                              100
2default:defaulth p
x
? 
?
%s
*synth2s
_                finished |                          0001000 |                              101
2default:defaulth p
x
? 
?
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2$
currentstate_reg2default:default2
one-hot2default:default2
sha256d2default:defaultZ8-3354h px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:12 ; elapsed = 00:00:11 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
? 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
? 
X
%s
*synth2@
,	   4 Input   32 Bit       Adders := 2     
2default:defaulth p
x
? 
X
%s
*synth2@
,	   5 Input   32 Bit       Adders := 2     
2default:defaulth p
x
? 
X
%s
*synth2@
,	   2 Input   32 Bit       Adders := 6     
2default:defaulth p
x
? 
X
%s
*synth2@
,	   2 Input    8 Bit       Adders := 8     
2default:defaulth p
x
? 
X
%s
*synth2@
,	   2 Input    7 Bit       Adders := 6     
2default:defaulth p
x
? 
8
%s
*synth2 
+---XORs : 
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   3 Input     32 Bit         XORs := 10    
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   2 Input     32 Bit         XORs := 2     
2default:defaulth p
x
? 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
? 
Z
%s
*synth2B
.	               32 Bit    Registers := 42    
2default:defaulth p
x
? 
Z
%s
*synth2B
.	                7 Bit    Registers := 8     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	                4 Bit    Registers := 2     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	                2 Bit    Registers := 2     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	                1 Bit    Registers := 6     
2default:defaulth p
x
? 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
? 
X
%s
*synth2@
,	   2 Input   32 Bit        Muxes := 19    
2default:defaulth p
x
? 
X
%s
*synth2@
,	   4 Input   32 Bit        Muxes := 2     
2default:defaulth p
x
? 
X
%s
*synth2@
,	   9 Input   32 Bit        Muxes := 16    
2default:defaulth p
x
? 
X
%s
*synth2@
,	  18 Input   32 Bit        Muxes := 17    
2default:defaulth p
x
? 
X
%s
*synth2@
,	   2 Input    7 Bit        Muxes := 12    
2default:defaulth p
x
? 
X
%s
*synth2@
,	   7 Input    7 Bit        Muxes := 1     
2default:defaulth p
x
? 
X
%s
*synth2@
,	   2 Input    4 Bit        Muxes := 4     
2default:defaulth p
x
? 
X
%s
*synth2@
,	   2 Input    3 Bit        Muxes := 2     
2default:defaulth p
x
? 
X
%s
*synth2@
,	   8 Input    1 Bit        Muxes := 2     
2default:defaulth p
x
? 
X
%s
*synth2@
,	   2 Input    1 Bit        Muxes := 29    
2default:defaulth p
x
? 
X
%s
*synth2@
,	   9 Input    1 Bit        Muxes := 8     
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2k
WPart Resources:
DSPs: 220 (col length:60)
BRAMs: 280 (col length: RAMB18 60 RAMB36 30)
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:38 ; elapsed = 00:00:37 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth px? 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px? 
M
%s*synth25
!
ROM: Preliminary Mapping	Report
2default:defaulth px? 
q
%s*synth2Y
E+--------------------+------------+---------------+----------------+
2default:defaulth px? 
r
%s*synth2Z
F|Module Name         | RTL Object | Depth x Width | Implemented As | 
2default:defaulth px? 
q
%s*synth2Y
E+--------------------+------------+---------------+----------------+
2default:defaulth px? 
r
%s*synth2Z
F|sha256              | K[63]      | 64x32         | LUT            | 
2default:defaulth px? 
r
%s*synth2Z
F|sha256              | K[63]      | 64x32         | LUT            | 
2default:defaulth px? 
r
%s*synth2Z
F|sha256d_axi_ip_v1_0 | K[63]      | 64x32         | LUT            | 
2default:defaulth px? 
r
%s*synth2Z
F|sha256d_axi_ip_v1_0 | K[63]      | 64x32         | LUT            | 
2default:defaulth px? 
r
%s*synth2Z
F+--------------------+------------+---------------+----------------+

2default:defaulth px? 
j
%s*synth2R
>
Distributed RAM: Preliminary Mapping	Report (see note below)
2default:defaulth px? 
?
%s*synth2x
d+--------------------+------------+-----------+----------------------+----------------------------+
2default:defaulth px? 
?
%s*synth2y
e|Module Name         | RTL Object | Inference | Size (Depth x Width) | Primitives                 | 
2default:defaulth px? 
?
%s*synth2x
d+--------------------+------------+-----------+----------------------+----------------------------+
2default:defaulth px? 
?
%s*synth2y
e|sha256d_axi_ip_v1_0 | W_reg      | Implied   | 64 x 32              | RAM64X1D x 10	RAM64M x 50	 | 
2default:defaulth px? 
?
%s*synth2y
e|sha256d_axi_ip_v1_0 | W_reg      | Implied   | 64 x 32              | RAM64X1D x 10	RAM64M x 50	 | 
2default:defaulth px? 
?
%s*synth2y
e+--------------------+------------+-----------+----------------------+----------------------------+

2default:defaulth px? 
?
%s*synth2?
?Note: The table above is a preliminary report that shows the Distributed RAMs at the current stage of the synthesis flow. Some Distributed RAMs may be reimplemented as non Distributed RAM primitives later in the synthesis flow. Multiple instantiated RAMs are reported only once.
2default:defaulth px? 
?
%s*synth2?
?---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth px? 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
{Finished Timing Optimization : Time (s): cpu = 00:00:38 ; elapsed = 00:00:37 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2?
?---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
S
%s
*synth2;
'
Distributed RAM: Final Mapping	Report
2default:defaulth p
x
? 
?
%s
*synth2x
d+--------------------+------------+-----------+----------------------+----------------------------+
2default:defaulth p
x
? 
?
%s
*synth2y
e|Module Name         | RTL Object | Inference | Size (Depth x Width) | Primitives                 | 
2default:defaulth p
x
? 
?
%s
*synth2x
d+--------------------+------------+-----------+----------------------+----------------------------+
2default:defaulth p
x
? 
?
%s
*synth2y
e|sha256d_axi_ip_v1_0 | W_reg      | Implied   | 64 x 32              | RAM64X1D x 10	RAM64M x 50	 | 
2default:defaulth p
x
? 
?
%s
*synth2y
e|sha256d_axi_ip_v1_0 | W_reg      | Implied   | 64 x 32              | RAM64X1D x 10	RAM64M x 50	 | 
2default:defaulth p
x
? 
?
%s
*synth2y
e+--------------------+------------+-----------+----------------------+----------------------------+

2default:defaulth p
x
? 
?
%s
*synth2?
?---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
zFinished Technology Mapping : Time (s): cpu = 00:00:40 ; elapsed = 00:00:39 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
tFinished IO Insertion : Time (s): cpu = 00:00:46 ; elapsed = 00:00:45 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Renaming Generated Instances : Time (s): cpu = 00:00:46 ; elapsed = 00:00:45 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:46 ; elapsed = 00:00:45 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Renaming Generated Ports : Time (s): cpu = 00:00:46 ; elapsed = 00:00:45 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Handling Custom Attributes : Time (s): cpu = 00:00:46 ; elapsed = 00:00:45 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
Finished Renaming Generated Nets : Time (s): cpu = 00:00:46 ; elapsed = 00:00:45 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
? 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
? 
J
%s
*synth22
| |BlackBox name |Instances |
2default:defaulth p
x
? 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
? 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
? 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px? 
F
%s*synth2.
+------+---------+------+
2default:defaulth px? 
F
%s*synth2.
|      |Cell     |Count |
2default:defaulth px? 
F
%s*synth2.
+------+---------+------+
2default:defaulth px? 
F
%s*synth2.
|1     |BUFG     |     1|
2default:defaulth px? 
F
%s*synth2.
|2     |CARRY4   |   224|
2default:defaulth px? 
F
%s*synth2.
|3     |LUT1     |     7|
2default:defaulth px? 
F
%s*synth2.
|4     |LUT2     |   681|
2default:defaulth px? 
F
%s*synth2.
|5     |LUT3     |   886|
2default:defaulth px? 
F
%s*synth2.
|6     |LUT4     |   128|
2default:defaulth px? 
F
%s*synth2.
|7     |LUT5     |   182|
2default:defaulth px? 
F
%s*synth2.
|8     |LUT6     |   800|
2default:defaulth px? 
F
%s*synth2.
|9     |MUXF7    |    97|
2default:defaulth px? 
F
%s*synth2.
|10    |MUXF8    |    33|
2default:defaulth px? 
F
%s*synth2.
|11    |RAM64M   |   100|
2default:defaulth px? 
F
%s*synth2.
|12    |RAM64X1D |    20|
2default:defaulth px? 
F
%s*synth2.
|13    |FDCE     |    62|
2default:defaulth px? 
F
%s*synth2.
|14    |FDPE     |     5|
2default:defaulth px? 
F
%s*synth2.
|15    |FDRE     |  1563|
2default:defaulth px? 
F
%s*synth2.
|16    |FDSE     |   278|
2default:defaulth px? 
F
%s*synth2.
|17    |IBUF     |    53|
2default:defaulth px? 
F
%s*synth2.
|18    |OBUF     |    41|
2default:defaulth px? 
F
%s*synth2.
+------+---------+------+
2default:defaulth px? 
E
%s
*synth2-

Report Instance Areas: 
2default:defaulth p
x
? 
}
%s
*synth2e
Q+------+-----------------------------------+----------------------------+------+
2default:defaulth p
x
? 
}
%s
*synth2e
Q|      |Instance                           |Module                      |Cells |
2default:defaulth p
x
? 
}
%s
*synth2e
Q+------+-----------------------------------+----------------------------+------+
2default:defaulth p
x
? 
}
%s
*synth2e
Q|1     |top                                |                            |  5161|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|2     |  sha256d_axi_ip_v1_0_S00_AXI_inst |sha256d_axi_ip_v1_0_S00_AXI |  5066|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|3     |    sha256d_inst                   |sha256d                     |  4264|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|4     |      sha1                         |sha256                      |  2065|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|5     |        hash_round_counter         |counter__parameterized0_1   |   121|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|6     |        message_block_counter      |counter_2                   |    27|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|7     |        w_counter                  |counter__parameterized0_3   |   209|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|8     |      sha2                         |sha256__parameterized0      |  2191|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|9     |        hash_round_counter         |counter__parameterized0     |   121|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|10    |        message_block_counter      |counter                     |   253|
2default:defaulth p
x
? 
}
%s
*synth2e
Q|11    |        w_counter                  |counter__parameterized0_0   |    78|
2default:defaulth p
x
? 
}
%s
*synth2e
Q+------+-----------------------------------+----------------------------+------+
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Writing Synthesis Report : Time (s): cpu = 00:00:46 ; elapsed = 00:00:45 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
s
%s
*synth2[
GSynthesis finished with 0 errors, 0 critical warnings and 21 warnings.
2default:defaulth p
x
? 
?
%s
*synth2?
}Synthesis Optimization Runtime : Time (s): cpu = 00:00:46 ; elapsed = 00:00:45 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth p
x
? 
?
%s
*synth2?
~Synthesis Optimization Complete : Time (s): cpu = 00:00:46 ; elapsed = 00:00:45 . Memory (MB): peak = 1108.641 ; gain = 0.000
2default:defaulth p
x
? 
B
 Translating synthesized netlist
350*projectZ1-571h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0932default:default2
1109.4652default:default2
0.0002default:defaultZ17-268h px? 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
4742default:defaultZ29-17h px? 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px? 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px? 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0022default:default2
1170.1762default:default2
0.0002default:defaultZ17-268h px? 
?
!Unisim Transformation Summary:
%s111*project2?
?  A total of 120 instances were transformed.
  RAM64M => RAM64M (RAMD64E(x4)): 100 instances
  RAM64X1D => RAM64X1D (RAMD64E(x2)): 20 instances
2default:defaultZ1-111h px? 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
332default:default2
222default:default2
02default:default2
02default:defaultZ4-41h px? 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
synth_design: 2default:default2
00:00:552default:default2
00:00:552default:default2
1170.1762default:default2
61.5352default:defaultZ17-268h px? 
?
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2?
?d:/Uni/RL/sha256d_zedboard/sha256d_final.tmp/sha256d_axi_ip_v1_3_project/sha256d_axi_ip_v1_3_project.runs/synth_1/sha256d_axi_ip_v1_0.dcp2default:defaultZ17-1381h px? 
?
%s4*runtcl2?
|Executing : report_utilization -file sha256d_axi_ip_v1_0_utilization_synth.rpt -pb sha256d_axi_ip_v1_0_utilization_synth.pb
2default:defaulth px? 
?
Exiting %s at %s...
206*common2
Vivado2default:default2,
Tue Aug 17 12:17:28 20212default:defaultZ17-206h px? 


End Record