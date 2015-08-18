OBJ = parser.beam transpiler.beam main.beam transpilerasm.beam mainasm.beam

.PHONY: clean all
all: init $(OBJ)

%.beam : src/%.erl
	erlc -I include -pa ebin -o ebin $(<)

init:
	mkdir -p ebin

clean:
	rm -rf ebin
