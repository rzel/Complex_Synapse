/*
 * BWalphaNloop_emxutil.h
 *
 * Code generation for function 'BWalphaNloop_emxutil'
 *
 * C source code generated on: Mon Jul 07 15:22:55 2014
 *
 */

#ifndef __BWALPHANLOOP_EMXUTIL_H__
#define __BWALPHANLOOP_EMXUTIL_H__
/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blas.h"
#include "rtwtypes.h"
#include "BWalphaNloop_types.h"

/* Function Declarations */
extern void b_emxInit_real_T(emxArray_real_T **pEmxArray, int32_T numDimensions, boolean_T doPush);
extern void c_emxInit_real_T(emxArray_real_T **pEmxArray, int32_T numDimensions, boolean_T doPush);
extern void emxEnsureCapacity(emxArray__common *emxArray, int32_T oldNumel, int32_T elementSize);
extern void emxFree_real_T(emxArray_real_T **pEmxArray);
extern void emxInit_real_T(emxArray_real_T **pEmxArray, int32_T numDimensions, boolean_T doPush);
#endif
/* End of code generation (BWalphaNloop_emxutil.h) */
