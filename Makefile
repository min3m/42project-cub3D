# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: youngmch <youngmch@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/02/20 21:27:49 by youngmch          #+#    #+#              #
#    Updated: 2023/03/13 21:15:59 by youngmch         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# ---- NAME ---- #

NAME = cub3d

FT = ./libft/libft.a
FTCC = -L./libft -lft

CC = cc
CFLAGS = -Wall -Wextra -Werror $(DB)
DB = -g3
FA = -fsanitize=address
AR = ar
ARFLAG = ruc
RM = rm -f

MLX_LIB = -Lmlx_mms -lmlx -framework Cocoa -framework Metal -framework MetalKit -framework QuartzCore
MLX_INC = -Imlx_mms

object_dir = ./objects

# ---- escape ---- #

DELINE = \033[K
CURSUP = \033[A

RESET = \033[0m
RESTINT = \033[22m

BOLD = \033[1m

MAGENTA = \033[35m
GREEN = \033[32m
RED = \033[31m

# ---- Mandatory ---- #

sources1 :=

sources1 += main.c
sources1 += path_parsing.c
sources1 += map_parsing.c
sources1 += check_valid.c
sources1 += utils1.c
sources1 += utils2.c
sources1 += game_init.c
sources1 += set_camera.c
sources1 += sprite_init.c
sources1 += key_hook.c
# sources1 += draw_map.c
sources1 += raycasting.c
sources1 += render_wall.c
sources1 += render_sprite.c
sources1 += set_ray_draw.c
sources1 += move_event.c
sources1 += rotate_event.c

# ---- Bonus ---- #

sources2 :=

sources2 +=

# ---- Elements ---- #

all_sources = $(sources1) $(sources2)

objects1 = $(sources1:.c=.o)
objects2 = $(sources2:.c=.o)
all_objects = $(objects1) $(objects2)

define objects_goal
$(addprefix $(object_dir)/, $(call $(if $(filter bonus, $(MAKECMDGOALS)), all_objects, objects1)))
endef

define react
$(if $(filter bonus, $(MAKECMDGOALS)), bonus, all)
endef

# ---- Command ---- #

.PHONY : clean fclean re all bonus

all : $(NAME)

$(NAME) : $(objects_goal) $(FT)
	@make -C mlx_mms
	@cp mlx_mms/libmlx.dylib .
	@$(CC) $(CFLAGS) $(MLX_LIB) -o $@ $(objects_goal) $(FTCC)
	@echo "$(DELINE) $(MAGENTA)$@ $(RESET) is compiled $(GREEN)$(BOLD) OK ??? $(RESET)"

bonus : $(NAME)

$(object_dir)/%.o : %.c
	@#mkdir -p $(object_dir)
	@mkdir -p $(object_dir)/$(dir $^)
	@$(CC) $(CFLAGS) $(MLX_INC) -c $^ -o $@
	@echo " $(MAGENTA)$(NAME) $(RESET)objects file compiling... $(DELINE)$(GREEN) $^ $(RESET)$(CURSUP)"

$(FT) :
	@make -C ./libft all

clean :
	@$(RM) $(all_objects)
	@rm -rf $(object_dir)
	@make -C ./libft clean
	@make -C ./mlx_mms clean
	@echo "$(RED) Delete$(BOLD) objects $(RESTINT)file $(RESET)"

fclean : clean
	@$(RM) $(NAME)
	@make -C ./libft fclean
	@rm -rf libmlx.dylib
	@echo "$(RED) Delete$(BOLD) $(NAME) $(RESTINT)file $(RESET)"

re : fclean
	@make $(react)
