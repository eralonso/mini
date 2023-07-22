/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pixels.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eralonso <eralonso@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/07/22 12:06:32 by eralonso          #+#    #+#             */
/*   Updated: 2023/07/22 12:08:28 by eralonso         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "defines.h"

void	ft_pixel_put(t_pixmap *pixmap, int x, int y, int color)
{
	char	*pixel;
	int		rgb[4];

	if (x < 0 || x >= WIN_WIDTH || y < 0 || y >= WIN_HEIGHT)
		return ;
	pixel = &pixmap->addr[(y * pixmap->line_len) + (x * pixmap->bytes_pp)];
	rgb[0] = color & 0xFF;
	rgb[1] = (color >> 8) & 0xFF;
	rgb[2] = (color >> 16) & 0xFF;
	rgb[3] = color >> 24;
	pixel[0] = rgb[0];
	pixel[1] = rgb[1];
	pixel[2] = rgb[2];
	pixel[3] = rgb[3];
}
