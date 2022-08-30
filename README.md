# dhr2_love_drawscaledtext_lua
8x8 scaleable text drawing routine library for lua+love2d ( https://love2d.org/ )

  This library for love2d provides a function 'drawscaledtext( x, y, xs, ys, string )' that draws an ASCII text string to the screen using an 8x8 1bit bitmap font.

  It will draw text string 'string' at screen position x,y with independent width and height scaling factors xs,ys.
  For instance, xs=1 ys=1 will set the font size to 8x8. xs=1 ys=2 will set the font size to 8x16, etc.
  Scaling factors below 1 will be clamped to 1.

  TO DO:
   * Some support for unicode could potentially be added.
   * Perhaps an optimisation could be added where the we check if the X position goes outside of the screen/canvas bounds and exit the function if so.

  This software is licensed under GPLv3. You can use the software but ONLY if you want to and ONLY under the terms described under the GPL version 3
