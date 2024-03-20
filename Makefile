.PHONY: build-static-lib-debug
build-static-lib-debug:
	cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Debug
	cmake --build build

.PHONY: build-static-lib-release
build-static-lib-release:
	cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
	cmake --build build

.PHONY: build-shared-lib-debug
build-shared-lib-debug:
	cmake -S. -Bbuild -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Debug
	cmake --build build

.PHONY: build-shared-lib-release
build-shared-lib-release:
	cmake -S. -Bbuild -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release
	cmake --build build

.PHONY: build-example
build-example:
	cmake -S. -Bbuild -DBUILD_EXAMPLE=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo
	cmake --build build

.PHONY: test
test:
	cmake -S. -Bbuild -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo
	cmake --build build
	./build/test/sha3iuf_test

.PHONY: run-fuzzer
run-fuzzer:
	cmake -S. -Bbuild -DBUILD_FUZZER=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo
	cmake --build build
	./build/test/sha3iuf_fuzz ./fuzz/seeds -max_total_time=100

.PHONY: clean
clean:
	rm -rf build
