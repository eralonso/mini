# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: eralonso <eralonso@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/01/22 10:08:41 by eralonso          #+#    #+#              #
#    Updated: 2023/07/22 12:06:16 by eralonso         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#<--------------------------------->COLORS<----------------------------------->#
DEF_COLOR	:=	\033[1;97m
WHITE_BOLD	:=	\033[1m
BLACK		:=	\033[1;90m
RED			:=	\033[1;91m
GREEN		:=	\033[1;92m
YELLOW		:=	\033[1;93m
BLUE		:=	\033[1;94m
PINK		:=	\033[1;95m
CIAN		:=	\033[1;96m

#<--------------------------------->NAME<------------------------------------>#
NAME		:=	miniRT

#<--------------------------------->VARS<------------------------------------>#
NULL		:=
SPACE		:=	$(NULL) #

#<--------------------------------->ROOTS<----------------------------------->#
LIB_ROOT	:=	lib/

LIBFT_ROOT	:=	$(LIB_ROOT)libft/
MLX_ROOT	:=	$(LIB_ROOT)mlx/

SRC_ROOT	:=	src/
OBJ_ROOT	:=	.objs/
DEP_ROOT	:=	.deps/
INC_ROOT	:=	inc/

#<-------------------------------->LIBRARYS<--------------------------------->#
LIB_A		:=

LIB_ADD_DIR	:=	-L$(LIBFT_ROOT) -L$(MLX_ROOT)

LIB_SEARCH	:=	-lft -lmlx

#<------------------------------->FRAMEWORKS<-------------------------------->#
FRMWK           =       -framework OpenGL -framework Appkit

#<-------------------------------->HEADERS<---------------------------------->#
HEADERS		:=	$(INC_ROOT)
HEADERS		+=	$(addsuffix $(INC_ROOT),$(LIBFT_ROOT))
HEADERS		+=	$(MLX_ROOT)

#<---------------------------------->DIRS<----------------------------------->#
SRC_DIRS	:=	./:utils/
SRC_DIRS	:=	$(subst :,$(SPACE),$(SRC_DIRS))
SRC_DIRS	:=	$(addprefix $(SRC_ROOT),$(SRC_DIRS))
SRC_DIRS	:=	$(subst $(SPACE),:,$(SRC_DIRS))

#<--------------------------------->FILES<---------------------------------->#
FILES		:=	main

#<---------------------------------->LANG<---------------------------------->#
LANG		:=	C
CFLAGS		:=	-Wall -Wextra -Werror

ifeq ($(LANG),C)
	CC := cc
	SUFFIX := c
else ifeq ($(LANG),CPP)
	CC := c++
	SUFFIX := cpp
	CFLAGS += -std=c++98
endif

#<--------------------------------->SRCS<----------------------------------->#
SRCS		:=	$(addsuffix .$(SUFFIX),$(FILES))

#<----------------------------->OBJS && DEPS<------------------------------->#
OBJS		:=	$(addprefix $(OBJ_ROOT),$(subst .$(SUFFIX),.o,$(SRCS)))
DEPS		:=	$(addprefix $(DEP_ROOT),$(subst .$(SUFFIX),.d,$(SRCS)))

#<-------------------------------->COMANDS<---------------------------------->#
INCLUDE		:=	$(addprefix -I,$(HEADERS))
RM			:=	rm -rf
MKD			:=	mkdir -p
MK			:=	Makefile
MKFLAGS		:=	--no-print-directory
MUTE		:=	&> /dev/null

#<--------------------------------->VPATHS<---------------------------------->#

vpath %.$(SUFFIX) $(SRC_DIRS)
vpath %.d $(DEP_ROOT)

#<-------------------------------->FUNCTIONS<-------------------------------->#

define msg_creating
	printf "\r$(3)$(1): $(YELLOW)$(2).$(DEF_COLOR)                                                                 \r"
	sleep 0.01
	printf "\r$(3)$(1): $(YELLOW)$(2)..$(DEF_COLOR)                                                                \r"
	sleep 0.01
	printf "\r$(3)$(1): $(YELLOW)$(2)...$(DEF_COLOR)                                                               \r"
	sleep 0.01
endef

create_dir = $(shell $(MKD) $(1))

#<--------------------------------->RULES<----------------------------------->#

all :
	$(MAKE) $(MKFLAGS) make_libs
	$(MAKE) $(MKFLAGS) $(NAME)

$(DEP_ROOT)%.d : %.$(SUFFIX) | $(call create_dir,$(DEP_ROOT))
	$(call msg_creating,Dependence,$*,$(BLUE))
	$(CC) $(CFLAGS) -MMD -MF $@ $(INCLUDE) -c $< && rm -rf $(addsuffix .o,$*)
	sed -i.tmp '1 s|:| $@ :|' $@ && rm -rf $(addsuffix .tmp,$@)
	sed -i.tmp '1 s|^$*|$(OBJ_ROOT)$*|' $@ && rm -rf $(addsuffix .tmp,$@)

$(OBJ_ROOT)%.o : %.$(SUFFIX) %.d $(LIB_A) | $(call create_dir,$(OBJ_ROOT))
	$(call msg_creating,Object,$*,$(PINK))
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

# $(NAME) : | make_libs

make_libs:
	$(MAKE) $(MKFLAGS) -C $(LIBFT_ROOT)
	$(MAKE) $(MKFLAGS) -C $(MLX_ROOT)


$(NAME) : $(DEPS) $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) $(FRMWK) $(LIB_ADD_DIR) $(LIB_SEARCH) -o $(NAME)
	echo "\n$(GREEN)"$(NAME)" has been compiled\n$(DEF_COLOR)"

clean :
	$(RM) $(OBJ_ROOT) $(DEP_ROOT)
	echo ""
	echo "$(RED)All OBJS && DEPS has been removed$(DEF_COLOR)"
	echo ""

fclean :
	$(MAKE) $(MKFLAGS) clean
	$(MAKE) $(MKFLAGS) fclean -C $(LIBFT_ROOT)
	$(MAKE) $(MKFLAGS) clean -C $(MLX_ROOT)
	$(RM) $(NAME)
	echo ""
	echo "$(RED)Program has been removed$(DEF_COLOR)"

re :
	$(MAKE) $(MKFLAGS) fclean
	$(MAKE) $(MKFLAGS) all
	echo ""
	echo "$(CIAN)$(NAME) has been recompiled$(DEF_COLOR)"

.PHONY : all clean fclean re make_libs

.SILENT :

ifeq (,$(findstring clean,$(MAKECMDGOALS)))
ifeq (,$(findstring re,$(MAKECMDGOALS)))
-include $(DEPS)
endif
endif
