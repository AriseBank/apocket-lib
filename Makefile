.PHONY: cover

BIN_PATH:=node_modules/.bin/

all:	apocket-lib.min.js

clean:
	rm apocket-lib.js
	rm apocket-lib.min.js

apocket-lib.js: index.js lib/*.js
	${BIN_PATH}browserify $< > $@

apocket-lib.min.js: apocket-lib.js
	uglify  -s $<  -o $@

cover:
	./node_modules/.bin/istanbul cover ./node_modules/.bin/_mocha -- --reporter spec test
