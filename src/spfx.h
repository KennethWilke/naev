/*
 * See Licensing and Copyright notice in naev.h
 */



#ifndef SPFX_H
#  define SPFX_H


#include "physics.h"
#include "opengl.h"


#define SPFX_LAYER_FRONT   0
#define SPFX_LAYER_BACK    1

#define SHAKE_DECAY  50. /* decay parameter */
#define SHAKE_MAX    50.*SCREEN_W*SCREEN_H/1024./768. /* max parameter */


/*
 * stack manipulation
 */
int spfx_get( char* name );
void spfx_add( const int effect,
      const double px, const double py,
      const double vx, const double vy,
      const int layer );


/*
 * stack mass manipulation functions
 */
void spfx_update( const double dt );
void spfx_render( const int layer );
void spfx_clear (void);


/*
 * get ready to rumble
 */
void spfx_start( double dt );
void spfx_shake( double mod );


/*
 * other effects
 */
void spfx_cinematic (void);


/*
 * spfx effect loading and freeing
 */
int spfx_load (void);
void spfx_free (void);


#endif /* SPFX_H */
