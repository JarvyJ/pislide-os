skiffos/Makefile:
	git submodule update --init skiffos

%: skiffos/Makefile
	@export SKIFF_EXTRA_CONFIGS_PATH=$$(pwd)/configs; \
		cd ./skiffos && make $@

