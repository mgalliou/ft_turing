NAME      = ft_turing
CHECK     = check
RM        = rm -rf
OCAMLOPT  = ocamlopt
OCAMLFIND = ocamlfind
INCLUDES = -I $(SRC_DIR) -I $(TST_DIR) -I $(OBJ_DIR)
OCAMLTOPFLAGS = $(INCLUDES) -linkpkg -package ounit2,base,yojson,core
SRC_DIR  = src
TST_DIR  = test
OBJ_DIR  = obj
SRC_NAME = \
		   one_transition.ml\
		   transitions.ml\
		   read_json.ml\
		   run_machine.ml\
		   get_args.ml\
		   main.ml
TST_NAME = \
		   test.ml
OBJ_NAME = $(SRC_NAME:.ml=.cmx)
TST_OBJ_NAME = $(TST_NAME:.ml=.cmx)
INC_NAME = 
INC      = $(addprefix $(SRC_DIR)/,$(INC_NAME))
LIB      = 
SRC      = $(addprefix $(SRC_DIR)/,$(SRC_NAME))
TST      = $(addprefix $(TST_DIR)/,$(TST_NAME))
OBJ      = $(addprefix $(OBJ_DIR)/,$(OBJ_NAME))
TST_OBJ  = $(addprefix $(OBJ_DIR)/,$(TST_OBJ_NAME))

all: $(NAME)

$(NAME): $(OBJ)
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

debug: 
debug:

clean:
	$(RM) $(OBJ_DIR)

fclean: clean
	$(RM) $(NAME)
	$(RM) $(CHECK)

re: fclean all

.PHONY: all check clean fclean re
