/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   path_parsing1.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: youngmch <youngmch@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/02/22 17:07:27 by youngmch          #+#    #+#             */
/*   Updated: 2023/02/24 19:14:34 by youngmch         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "cub3d.h"

t_arg	*init_arg(t_arg *arg)
{
	arg->res.width = 0;
	arg->res.height = 0;
	arg->root.no = NULL;
	arg->root.so = NULL;
	arg->root.we = NULL;
	arg->root.ea = NULL;
	arg->root.item = NULL;
	arg->floor_rgb = 0;
	arg->ceiling_rgb = 0;
	return (arg);
}

bool	check_arg(t_arg *arg)
{
	if (arg->res.width == 0 || arg->res.height == 0)
		return (false);
	if (!arg->root.no || !arg->root.so || !arg->root.we || !arg->root.ea
		|| !arg->root.item)
		return (false);
	if (!arg->floor_rgb || !arg->ceiling_rgb)
		return (false);
	return (true);
}

bool	get_path(char *tmp, t_arg **arg)
{
	char	**split;

	split = ft_split(tmp, ' ');
	if (!ft_strncmp("R", split[0], 2) && !split[3])
	{
		if (!get_res(split[1], split[2], arg))
			return (free_split(split, 0));
	}
	else if (!ft_strncmp("NO", split[0], 3) && !split[2])
		(*arg)->root.no = ft_strdup(split[1]);
	else if (!ft_strncmp("SO", split[0], 3) && !split[2])
		(*arg)->root.so = ft_strdup(split[1]);
	else if (!ft_strncmp("WE", split[0], 3) && !split[2])
		(*arg)->root.we = ft_strdup(split[1]);
	else if (!ft_strncmp("EA", split[0], 3) && !split[2])
		(*arg)->root.ea = ft_strdup(split[1]);
	else if (!ft_strncmp("S", split[0], 2) && !split[2])
		(*arg)->root.item = ft_strdup(split[1]);
	else if (!ft_strncmp("F", split[0], 2) && !split[2])
		(*arg)->floor_rgb = get_rgb(split[1]);
	else if (!ft_strncmp("C", split[0], 2) && !split[2])
		(*arg)->ceiling_rgb = get_rgb(split[1]);
	else
		return (free_split(split, 0));
	return (free_split(split, 1));
}

void	path_parsing(t_arg *arg, int fd)
{
	char	*tmp;

	arg = init_arg(arg);
	tmp = get_next_line(fd);
	if (tmp == 0)
		exit(ft_putendl_fd("Gnl error!", 1));
	while (tmp)
	{
		if ((!get_path(tmp, &arg) || arg->floor_rgb < 0 || arg->ceiling_rgb < 0)
			&& !(*tmp == '\n'))
		{
			free(tmp);
			free_arg(arg);
			close(fd);
			exit(ft_putendl_fd("Wrong map file argument!", 1));
		}
		free(tmp);
		if (check_arg(arg))
			break ;
		tmp = get_next_line(fd);
		if (tmp == 0)
			exit(ft_putendl_fd("Gnl error!", 1));
	}
}
