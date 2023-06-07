#include <amigoRHS.h>

#include <math.h>

#include <amigoJAC.h>

#include <amigoSensRHS.h>

#include <amigo_terminate.h>


	/* *** Definition of the states *** */

#define	x  Ith(y,0)
#define	yy Ith(y,1)
#define	vv Ith(y,2)
#define	w  Ith(y,3)
#define	z  Ith(y,4)
#define iexp amigo_model->exp_num

	/* *** Definition of the sates derivative *** */

#define	dx  Ith(ydot,0)
#define	dyy Ith(ydot,1)
#define	dvv Ith(ydot,2)
#define	dw  Ith(ydot,3)
#define	dz  Ith(ydot,4)

	/* *** Definition of the parameters *** */

#define	lm   (*amigo_model).pars[0]
#define	d    (*amigo_model).pars[1]
#define	beta (*amigo_model).pars[2]
#define	a    (*amigo_model).pars[3]
#define	k    (*amigo_model).pars[4]
#define	uu   (*amigo_model).pars[5]
#define	c    (*amigo_model).pars[6]
#define	q    (*amigo_model).pars[7]
#define	b    (*amigo_model).pars[8]
#define	h    (*amigo_model).pars[9]

	/* *** Definition of the algebraic variables *** */

/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;
	ctrlcCheckPoint(__FILE__, __LINE__);


	/* *** Equations *** */

	dx=lm-d*x-beta*x*vv;
	dyy=beta*x*vv-a*yy;
	dvv=k*yy-uu*vv;
	dw=c*x*yy*w-c*q*yy*w-b*w;
	dz=c*q*yy*w-h*z;

	return(0);

}


/* Jacobian of the system (dfdx)*/
int amigoJAC(long int N, realtype t, N_Vector y, N_Vector fy, DlsMat J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3){
	AMIGO_model* amigo_model=(AMIGO_model*)user_data;
	ctrlcCheckPoint(__FILE__, __LINE__);


	return(0);
}

/* R.H.S of the sensitivity dsi/dt = (df/dx)*si + df/dp_i */
int amigoSensRHS(int Ns, realtype t, N_Vector y, N_Vector ydot, int iS, N_Vector yS, N_Vector ySdot, void *data, N_Vector tmp1, N_Vector tmp2){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	return(0);

}