#include "iir_filter.h"

void iir_filter(double *y, double *x, double *w, int M, int L) {
    double alpha = 0.985;
    int lags = L / 2;
    int i, j;
    
    y[0] = x[0];
    
    for (i=1; i<lags; i++) {
        y[i] = alpha * y[i-1] + (1 - alpha) * x[i];
    }
    
    for (i=lags; i<M; i++) {
        y[i] = 0;
        for (j=0; j<lags; j++) {
            y[i] += w[j] * y[i-j-1];
        }
        for (j=0; j<lags; j++) {
            y[i] += w[j+lags] * x[i-j];
        }
    }
}