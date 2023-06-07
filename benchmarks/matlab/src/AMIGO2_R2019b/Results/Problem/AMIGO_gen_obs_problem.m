function ms=AMIGO_gen_obs_problem(y,inputs,par,iexp)
	x1=y(:,1);
	x2=y(:,2);
	x3=y(:,3);
	a12=par(1);
	a13=par(2);
	a21=par(3);
	a31=par(4);
	a01=par(5);
 

switch iexp

case 1
y1=x1;
y2=x2;
ms(:,1)=y1;ms(:,2)=y2;
end

return