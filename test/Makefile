
all: test_add_signed test_add_unsigned

test_add_signed:
	mkdir -p scratch
	cd scratch && \
	yosys -l test_add_signed.log -s ../test_add_signed_reduce_split.yosys

test_add_unsigned:
	mkdir -p scratch
	cd scratch && \
	yosys -l test_add_unsigned.log -s ../test_add_unsigned_reduce_split.yosys

clean:
	rm -fr scratch

