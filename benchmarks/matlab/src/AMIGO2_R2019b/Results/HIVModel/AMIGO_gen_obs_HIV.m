function ms=AMIGO_gen_obs_HIV(y,inputs,par,iexp)
	x =y(:,1);
	yy=y(:,2);
	vv=y(:,3);
	w =y(:,4);
	z =y(:,5);
	lm  =par(1);
	d   =par(2);
	beta=par(3);
	a   =par(4);
	k   =par(5);
	uu  =par(6);
	c   =par(7);
	q   =par(8);
	b   =par(9);
	h   =par(10);
 

switch iexp

case 1
Y1=w    ;
Y2=z    ;
Y3=x    ;
Y4=yy+vv;
ms(:,1)=Y1;ms(:,2)=Y2;ms(:,3)=Y3;ms(:,4)=Y4;
end

return