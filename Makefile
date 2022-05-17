NAME     = ft_turing
RM       = rm -rf
OC       = ocamlopt
OOPT     = ocamlopt
OFLAG    = 
OPPFLAGS = -I $(SRC_DIR)
LDFLAGS  = -Llibft
LDLIBS   = -lft
INC_NAME =
SRC_DIR  = src
SRC_NAME = \
		   main.ml
OBJ_NAME = $(SRC_NAME:.ml=.cmx)
OBJ_DIR  = src
INC_NAME = 
INC      = $(addprefix $(SRC_DIR)/,$(INC_NAME))
LIB      = 
SRC      = $(addprefix $(SRC_DIR)/,$(SRC_NAME))
OBJ      = $(addprefix $(SRC_DIR)/,$(OBJ_NAME))

all: $(NAME)

$(NAME): $(OBJ)
	$(OC) $(OPPFLAGS) $(OBJ) -o $(NAME)

$(OBJ_DIR)/%.cmx : $(SRC_DIR)/%.ml
	$(OC) $(OPPFLAGS) -c $< 

debug: CPPFLAGS += -g -fsanitize=address
debug: all

check: all
	$(MAKE) -C test
	./test/test

clean:
	$(RM) $(OBJ)

fclean: clean
	$(RM) $(NAME)

re: fclean all

.PHONY: all check clean fclean re
