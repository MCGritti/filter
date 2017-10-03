#include "mex.h"
#include "iir_filter.h"

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    /* Variable declarations */
    double *x;
    double *w;
    double *y;
    int M, L;
    
    if (nlhs != 1) {
        mexErrMsgIdAndTxt("IRR_FREE:nlhs",
                          "At least one output required");
    }
    
    if (nrhs != 2) {
        mexErrMsgIdAndTxt("IRR_FREE:nrhs",
                          "Two arguments required");
    }
    
    
    M = mxGetNumberOfElements(prhs[0]);
    L = mxGetNumberOfElements(prhs[1]);
    x = mxGetPr(prhs[0]);
    w = mxGetPr(prhs[1]);
    
    if ( L % 2 ) {
        mexErrMsgIdAndTxt("IRR_FREE:args",
                          "Wrong number of W params");
    }
    
    plhs[0] = mxCreateDoubleMatrix(M, 1, mxREAL);
    y = mxGetPr(plhs[0]);
    
    /* Code here */
    iir_filter(y, x, w, M, L);
}