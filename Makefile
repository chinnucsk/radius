REBAR = ./rebar

all: compile

compile:
	@$(REBAR) compile

clean:
	@$(REBAR) clean

test: compile
	@$(REBAR) eunit xref
