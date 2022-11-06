DIR="$(dirname $(readlink -f $0))"
SIM_DIR="$DIR/simplesim-3.0_acx2"
BENCHMARKS_DIR="$DIR/benchmarks"

echo SIM: $SIM_DIR
echo BENCHMARKS: $BENCHMARKS_DIR

for V in 8 32 128 512 2048; do
	RESULTS_DIR="$DIR/results_bimod_${V}"

	echo RESULTS_DIR: $RESULTS_DIR
	mkdir -p $RESULTS_DIR/prog


	## "Se saltaran 50M de ins, y se recolectaran las siguientes 50M"
	SIM_CMD="${SIM_DIR}/sim-outorder \
		-fastfwd 50000000 \
		-max:inst 50000000 \
		-mem:width 32 \
		-mem:lat 300 2 \
		-bpred bimod -bpred:bimod $V"

	## AMMP, EON, EQUAKE, GAP, MESA
	#
	AMMP_DATA_DIR="${BENCHMARKS_DIR}/ammp/data/ref"
	AMMP_EXE="${BENCHMARKS_DIR}/ammp/exe/ammp.exe <ammp.in >ammp.out 2>ammp.err"
	AMMP_CMD="-redir:sim ${RESULTS_DIR}/res_ammp.log -redir:prog ${RESULTS_DIR}/prog/out_ammp.log ${AMMP_EXE}"


	EON_DATA_DIR="${BENCHMARKS_DIR}/eon/data/ref"
	EON_EXE="${BENCHMARKS_DIR}/eon/exe/eon.exe chair.control.cook chair.camera chair.surfaces chair.cook.ppm ppm pixels_out.cook >cook_log.out 2>cook_log.err"
	EON_CMD="-redir:sim ${RESULTS_DIR}/res_eon.log -redir:prog ${RESULTS_DIR}/prog/out_eon.log ${EON_EXE}"

	EQUAKE_DATA_DIR="${BENCHMARKS_DIR}/equake/data/ref"
	EQUAKE_EXE="${BENCHMARKS_DIR}/equake/exe/equake.exe <inp.in >inp.out 2>inp.err"
	EQUAKE_CMD="-redir:sim ${RESULTS_DIR}/res_equake.log -redir:prog ${RESULTS_DIR}/prog/out_equake.log ${EQUAKE_EXE}"

	GAP_DATA_DIR="${BENCHMARKS_DIR}/gap/data/ref"
	GAP_EXE="${BENCHMARKS_DIR}/gap/exe/gap.exe -l ../all -q -m 192M <ref.in >ref.out 2>ref.err"
	GAP_CMD="-redir:sim ${RESULTS_DIR}/res_gap.log -redir:prog ${RESULTS_DIR}/prog/out_gap.log ${GAP_EXE}"

	MESA_DATA_DIR="${BENCHMARKS_DIR}/mesa/data/ref"
	MESA_EXE="${BENCHMARKS_DIR}/mesa/exe/mesa.exe -frames 1000 -meshfile mesa.in -ppmfile mesa.ppm"
	MESA_CMD="-redir:sim ${RESULTS_DIR}/res_mesa.log -redir:prog ${RESULTS_DIR}/prog/out_mesa.log ${MESA_EXE}"


	echo
	echo AMMP: $SIM_CMD $AMMP_CMD
	sh -c "cd $AMMP_DATA_DIR && $SIM_CMD $AMMP_CMD" &

	echo
	echo EON: $SIM_CMD $EON_CMD
	sh -c "cd $EON_DATA_DIR && $SIM_CMD $EON_CMD" &

	echo
	echo EQUAKE: $SIM_CMD $EQUAKE_CMD
	sh -c "cd $EQUAKE_DATA_DIR && $SIM_CMD $EQUAKE_CMD" &

	echo
	echo GAP: $SIM_CMD $GAP_CMD
	sh -c "cd $GAP_DATA_DIR && $SIM_CMD $GAP_CMD" &

	echo
	echo MESA: $SIM_CMD $MESA_CMD
	sh -c "cd $MESA_DATA_DIR && $SIM_CMD $MESA_CMD" &

	wait
	echo DONE
done
exit
