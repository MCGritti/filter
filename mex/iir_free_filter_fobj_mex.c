#include "mex.h"
#include "iir_filter.h"

#ifdef COMPOSITE
#define BUF_LEN 64
#define DELIM(IND, LAG) ((IND) % (LAG+1))

void compositeFcn(double *J, double *w, double *x, double *r, int M, int L) {
    double y[BUF_LEN];
    double ypool;
    double alpha = 0.985;
    double error;
    int lags = L / 2;
    int i, j;
    
    y[0] = x[0];
    *J = 0;
    
    for (i=1; i<lags; i++) {
        y[i] = alpha * y[i-1] + (1 - alpha) * x[i];
        error = (y[i] - r[i]);
        *J += error * error;
    }
    
    for (i=lags; i<M; i++) {
        ypool = 0;
        for (j=0; j<lags; j++) {
            ypool += w[j] * y[ DELIM(i-j-1, lags) ];   
        }
        
        for (j=0; j<lags; j++) {
            ypool += w[j+lags] * x[i-j];
        }
        error = r[i] - ypool;
        *J += error * error;
        y[ DELIM(i, lags) ] = ypool;
    }
    
    *J /= M;
}
#else
void costFunction(double *J, double *y, double *r, int M) {
    double error;
    int i = 0;
    
    *J = 0;
    for (i = 0; i < M; i++) {
        error = (y[i] - r[i]);
        *J += error * error;
    }
    
    *J /= M;
    
}
#endif

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    /* Variable declarations */
    double *w; /* Weigths       (1 In)  */
    double *x; /* Input Vector  (2 In)  */
    double *r; /* Reference     (3 In)  */
    double *J; /* Output cost   (1 Out) */
#ifndef COMPOSITE
    double *y; /* Filter output (Aux)   */
#endif
    int M, L;
    
    if (nlhs != 1) {
        mexErrMsgIdAndTxt("IRR_FREE:nlhs",
                          "At least one output required");
    }
    
    if (nrhs != 3) {
        mexErrMsgIdAndTxt("IRR_FREE:nrhs",
                          "Three arguments required");
    }
    
    L = mxGetNumberOfElements(prhs[0]);
    M = mxGetNumberOfElements(prhs[1]);

    w = mxGetPr(prhs[0]);
    x = mxGetPr(prhs[1]);
    r = mxGetPr(prhs[2]);
    
    if ( L % 2 ) {
        mexErrMsgIdAndTxt("IRR_FREE:args",
                          "Wrong number of W params");
    }
    
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    J = mxGetPr(plhs[0]);
    
#ifdef COMPOSITE
    compositeFcn(J, w, x, r, M, L);
#else
    y = mxMalloc( M * sizeof( double ) );
    iir_filter(y, x, w, M, L);
    costFunction(J, y, r, M);
    mxFree(y);
#endif
    
    
}