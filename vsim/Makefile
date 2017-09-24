
all: sim

generated_dir=../builds/e300artydevkit
base_dir=../rocket-chip
long_name=sifive.freedom.everywhere.e300artydevkit.E300ArtyDevKitConfig

tb_vsrcs = ..//vsrc/tb.v

bb_vsrcs = $(base_dir)/vsrc/DebugTransportModuleJtag.v \
	$(base_dir)/vsrc/jtag_vpi.v \
	$(base_dir)/vsrc/AsyncResetReg.v \

# $(generated_dir)/$(long_name).behav_srams.v \
# $(base_dir)/vsrc/$(TB).v \
# $(generated_dir)/consts.$(CONFIG).vh \

sim_vsrcs = \
	$(generated_dir)/$(long_name).v \
	$(base_dir)/vsrc/SimDTM.v \
	$(bb_vsrcs) \
	$(tb_vsrcs)

VCS = vcs -full64

VCS_OPTS = -notice -line +lint=all,noVCDE,noONGS,noUI -error=PCWM-L -timescale=1ns/10ps \
        +rad +v2k +vcs+lic+wait \
        +vc+list -CC "-I$(VCS_HOME)/include" \
        -CC "-I$(RISCV)/include" \
        -CC "-std=c++11" \
        -CC "-Wl,-rpath,$(RISCV)/lib" \
        $(RISCV)/lib/libfesvr.so \
        -sverilog \
        +incdir+$(generated_dir) \
        +define+CLOCK_PERIOD=1.0 $(sim_vsrcs) $(sim_csrcs) \
        +define+PRINTF_COND=0 \
        +define+STOP_COND=0 \
        +define+RANDOMIZE_MEM_INIT \
        +define+RANDOMIZE_REG_INIT \
        +define+RANDOMIZE_GARBAGE_ASSIGN \
        +define+RANDOMIZE_INVALID_ASSIGN \
        +libext+.v \
        -y ../sifive-blocks/vsrc \

VCS_OPTS += +vpi
VCS_OPTS += -P $(base_dir)/vsrc/jtag_vpi.tab
VCS_OPTS += -CC "-DVCS_VPI"           

compile:
	$(VCS) $(VCS_OPTS) -l vcs.log \
		+define+DEBUG -debug_pp \

# -P ${DEBUSSY_HOME}/share/PLI/vcs/LINUX/debussy.tab ${DEBUSSY_HOME}/share/PLI/vcs/LINUX/pli.a

sim: compile
	./simv -l simv.log \
		+verbose +vcdplusfile=test.vpd \

dbu: rtl
	debussy -2001 -f vcs_args &
