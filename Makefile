BINARY=./bin/getDateRange
CODEDIRS=. ./lib ./lib/C
IDIRS=. ./include # can be a list

CC=gcc
OPT=-O0
# Generate files that encode make rules for the .h dependencies
DEPFLAGS=-MP -MD
# Automatically append -I onto each include directory
INCDIRS=$(foreach D,$(IDIRS),-I$(D)/)
# Compilation flags
CFLAGS=-Wall -Wextra -g $(INCDIRS) $(OPT) $(DEPFLAGS)

# For-style iteration (foreach) and regular expression completions (wildcard)
# Output each filename with a .c suffix in the CODEDIRS directory
CFILES=$(foreach D,$(CODEDIRS),$(wildcard $(D)/*.c))
# Regular expression replacement: output .o and .d from .c files
OBJECTS=$(patsubst %.c,%.o,$(CFILES))     # .o files track changes in .c files
DEPFILES=$(patsubst %.c,%.d,$(CFILES))    # .d files track changes in the .h files called by their rescpective .c files

all: $(BINARY)

# Automatic variables: $@ = target - left hand side of colon; $^ = all dependencies - right hand side of colon
$(BINARY): $(OBJECTS)
	$(CC) -o $@ $^

# Automatic variables: $@ = target - left hand side of colon; $< = first dependency - right hand side of colon
%.o:%.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -rf $(OBJECTS) $(DEPFILES)

# Create a tarball of files for easy distribution
distribute: clean
	tar zcvf dist.tgz *

# include the dependencies
-include $(DEPFILES)

# add .PHONY so that the non-targetfile rules work even if a file with the same name exists.
.PHONY: all clean distribute diff
