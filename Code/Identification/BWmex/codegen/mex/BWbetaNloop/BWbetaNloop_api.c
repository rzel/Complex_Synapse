/*
 * BWbetaNloop_api.c
 *
 * Code generation for function 'BWbetaNloop_api'
 *
 * C source code generated on: Mon Jul 07 15:23:20 2014
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "BWbetaNloop.h"
#include "BWbetaNloop_api.h"
#include "BWbetaNloop_emxutil.h"

/* Function Declarations */
static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y);
static void c_emlrt_marshallIn(const mxArray *updater, const char_T *identifier,
  emxArray_real_T *y);
static void d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y);
static void e_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret);
static void emlrt_marshallIn(const mxArray *beta, const char_T *identifier,
  emxArray_real_T *y);
static void emlrt_marshallOut(emxArray_real_T *u, const mxArray *y);
static void f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret);

/* Function Definitions */
static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y)
{
  e_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallIn(const mxArray *updater, const char_T *identifier,
  emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  d_emlrt_marshallIn(emlrtAlias(updater), &thisId, y);
  emlrtDestroyArray(&updater);
}

static void d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y)
{
  f_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret)
{
  int32_T iv0[2];
  boolean_T bv0[2];
  int32_T i;
  int32_T iv1[2];
  for (i = 0; i < 2; i++) {
    iv0[i] = -1;
    bv0[i] = TRUE;
  }

  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", FALSE, 2U,
    iv0, bv0, iv1);
  ret->size[0] = iv1[0];
  ret->size[1] = iv1[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = FALSE;
  emlrtDestroyArray(&src);
}

static void emlrt_marshallIn(const mxArray *beta, const char_T *identifier,
  emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  b_emlrt_marshallIn(emlrtAlias(beta), &thisId, y);
  emlrtDestroyArray(&beta);
}

static void emlrt_marshallOut(emxArray_real_T *u, const mxArray *y)
{
  mxSetData((mxArray *)y, (void *)u->data);
  mxSetDimensions((mxArray *)y, u->size, 2);
}

static void f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret)
{
  int32_T iv2[3];
  boolean_T bv1[3];
  int32_T i;
  int32_T iv3[3];
  for (i = 0; i < 3; i++) {
    iv2[i] = -1;
    bv1[i] = TRUE;
  }

  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", FALSE, 3U,
    iv2, bv1, iv3);
  ret->size[0] = iv3[0];
  ret->size[1] = iv3[1];
  ret->size[2] = iv3[2];
  ret->allocatedSize = ret->size[0] * ret->size[1] * ret->size[2];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = FALSE;
  emlrtDestroyArray(&src);
}

void BWbetaNloop_api(const mxArray *prhs[2], const mxArray *plhs[1])
{
  emxArray_real_T *beta;
  emxArray_real_T *updater;
  emlrtHeapReferenceStackEnterFcnR2012b(emlrtRootTLSGlobal);
  emxInit_real_T(&beta, 2, TRUE);
  b_emxInit_real_T(&updater, 3, TRUE);
  prhs[0] = emlrtProtectR2012b(prhs[0], 0, TRUE, -1);

  /* Marshall function inputs */
  emlrt_marshallIn(emlrtAlias(prhs[0]), "beta", beta);
  c_emlrt_marshallIn(emlrtAlias(prhs[1]), "updater", updater);

  /* Invoke the target function */
  BWbetaNloop(beta, updater);

  /* Marshall function outputs */
  emlrt_marshallOut(beta, prhs[0]);
  plhs[0] = prhs[0];
  updater->canFreeData = FALSE;
  emxFree_real_T(&updater);
  beta->canFreeData = FALSE;
  emxFree_real_T(&beta);
  emlrtHeapReferenceStackLeaveFcnR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (BWbetaNloop_api.c) */
