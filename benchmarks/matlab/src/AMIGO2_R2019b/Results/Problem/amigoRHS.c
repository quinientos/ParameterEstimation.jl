#include <amigoRHS.h>

#include <math.h>

#include <amigoJAC.h>

#include <amigoSensRHS.h>

#include <amigo_terminate.h>


	/* *** Definition of the states *** */

#define	x1 Ith(y,0)
#define	x2 Ith(y,1)
#define	x3 Ith(y,2)
#define iexp amigo_model->exp_num

	/* *** Definition of the sates derivative *** */

#define	dx1 Ith(ydot,0)
#define	dx2 Ith(ydot,1)
#define	dx3 Ith(ydot,2)

	/* *** Definition of the parameters *** */

#define	a12 (*amigo_model).pars[0]
#define	a13 (*amigo_model).pars[1]
#define	a21 (*amigo_model).pars[2]
#define	a31 (*amigo_model).pars[3]
#define	a01 (*amigo_model).pars[4]

	/* *** Definition of the algebraic variables *** */

/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;
	ctrlcCheckPoint(__FILE__, __LINE__);


	/* *** Equations *** */

	dx1=-(a21+a31+a01)*x1+a12*x2+a13*x3;
	dx2=a21*x1-a12*x2;
	dx3=a31*x1-a13*x3;

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