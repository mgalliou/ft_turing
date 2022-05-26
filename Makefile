NAME      = ft_turing
CHECK     = check
RM        = rm -rf
OCAMLOPT  = ocamlopt
OCAMLFIND = ocamlfind
INCLUDES = -I $(SRC_DIR) -I $(TST_DIR) -I $(OBJ_DIR)
OCAMLTOPFLAGS = $(INCLUDES) -linkpkg -package ounit2,yojson,core
LIB_DIR  = $(OPAM_SWITCH_PREFIX)/lib/
BIN_DIR  = $(OPAM_SWITCH_PREFIX)/bin/
LIB_NAME = core\
		   yojson\
		   ounit2
BIN_NAME = ocamlfind
SRC_DIR  = src
TST_DIR  = test
OBJ_DIR  = obj
GEN_NAME  = \
		   utm_generator.ml\
		   write_json.ml
SRC_NAME = \
		   types.ml\
		   get_args.ml\
		   read_json.ml\
		   print_machine.ml\
		   tape.ml\
		   check_machine.ml\
		   run_machine.ml\
		   main.ml
TST_NAME = \
           suite_check_machine.ml\
		   suite_check_args.ml\
		   suite_read_json.ml\
		   test.ml
OBJ_NAME = $(SRC_NAME:.ml=.cmx)
TST_OBJ_NAME = $(TST_NAME:.ml=.cmx)
GEN_OBJ_NAME = $(GEN_NAME:.ml=.cmx)
LIB      = $(addprefix $(LIB_DIR)/,$(LIB_NAME))
BIN      = $(addprefix $(BIN_DIR)/,$(BIN_NAME))
SRC      = $(addprefix $(SRC_DIR)/,$(SRC_NAME))
GEN      = $(addprefix $(SRC_DIR)/,$(GEN_NAME))
TST      = $(addprefix $(TST_DIR)/,$(TST_NAME))
OBJ      = $(addprefix $(OBJ_DIR)/,$(OBJ_NAME))
TST_OBJ  = $(addprefix $(OBJ_DIR)/,$(TST_OBJ_NAME))
GEN_OBJ  = $(addprefix $(OBJ_DIR)/,$(GEN_OBJ_NAME))

all: $(NAME)

$(NAME):  $(BIN) $(LIB) $(OBJ)
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLTOPFLAGS) $(OBJ) -o $(NAME)

$(OBJ_DIR)/%.cmx : $(SRC_DIR)/%.ml
	mkdir -p $(dir $@)
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLTOPFLAGS) -c $< -o $@

$(OBJ_DIR)/%.cmx : $(TST_DIR)/%.ml
	mkdir -p $(dir $@)
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLTOPFLAGS) -c $< -o $@

check: $(OBJ) $(TST_OBJ)
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLTOPFLAGS) $(subst $(OBJ_DIR)/main.cmx, ,$(OBJ)) $(TST_OBJ) -o $(CHECK)
	./$(CHECK)
gen: $(GEN_OBJ)
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLTOPFLAGS) $(GEN_OBJ) -o gen
	./gen > machine/utm.json

$(BIN):
	opam install $(BIN_NAME)

$(LIB):
	opam install $(LIB_NAME)

clean:
	$(RM) $(OBJ_DIR)

fclean: clean
	$(RM) $(NAME)
	$(RM) $(CHECK)

re: fclean all

.PHONY: all check clean fclean re
