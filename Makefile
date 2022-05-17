NAME      = ft_turing
CHECK     = check
RM        = rm -rf
OCAMLOPT  = ocamlopt
OCAMLFIND = ocamlfind
INCLUDES = -I $(SRC_DIR) -I $(TST_DIR)
OCAMLTOPFLAGS = $(INCLUDES) -linkpkg -package ounit2
SRC_DIR  = src
TST_DIR  = test
SRC_NAME = \
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
OBJ      = $(addprefix $(SRC_DIR)/,$(OBJ_NAME))
TST_OBJ  = $(addprefix $(TST_DIR)/,$(TST_OBJ_NAME))

all: $(NAME)

$(NAME): $(OBJ)
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLTOPFLAGS) $(OBJ) -o $(NAME)

$(SRC_DIR)/%.cmx : $(SRC_DIR)/%.ml
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLTOPFLAGS) -c $< 

$(TST_DIR)/%.cmx : $(TST_DIR)/%.ml
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLTOPFLAGS) -c $< 

check: $(OBJ) $(TST_OBJ)
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLTOPFLAGS) $(OBJ) $(TST_OBJ) -o $(CHECK)

debug: 
debug:

clean:
	$(RM) $(OBJ) $(TST_OBJ)

fclean: clean
	$(RM) $(NAME)
	$(RM) $(CHECK)

re: fclean all

.PHONY: all check clean fclean re
