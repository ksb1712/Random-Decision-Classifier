function [datatx,datarx,datadetected,...
    bayesruleselected,pl,ph,val_pl,val_ph,pd,...
    gamma,pd_obtained_beforedetection,...
    pfa_obtained_beforedetection,pd_obtained_afterdetection,...
    pfa_obtained_afterdetection]=binarychanneldetection(x,y,z,len,p0,pfa)
    
%x->vector [p(0/0) p(1/1)]
%y=[c01 c10];
%z->1:Bayes technique.
%z->2:Mini-max technique.
%z->3:Neyman-pearson technique needs probability of false alarm pfa.
%p0->prior probability
%datatx->data transmitted
%datarx->data received
%bayesruleselected
%pl-lower level probability used in mini-max technique
%ph-upper level probability used in mini-max technique
%val_pl-bayes cost at pl
%val_ph-bayes cost at ph
%pd-probability of detection computed for four choices of Neyman-pearson
%technique.
%gamma-probabilities used in four choices of Neyman-pearson
%technique.
%pd_obtained-probability of detection actually obtained in the simulation.
%pfa_obtained-probability of false alarm actually obtained in the
%simulation.
load('datatx.txt');
load('datarx.txt');
p00=x(1);
p10=1-x(1);
p11=x(2);
p01=1-x(2);
[temp1,t1_pos] = max([p0,p00,p10,p01,p11]);
[temp2,t2_pos] = min([p0,p00,p10,p01,p11]);
temp3 = std([p0,p00,p10,p01,p11]);
switch(z)
case 1
  pl=[];ph=[];val_pl=[];val_ph=[];pd=[];gamma=[];
  r1cost=y(2)*p0*p10+y(1)*(1-p0)*p01;
  r2cost=y(2)*p0*p00+y(1)*(1-p0)*p11;
  r3cost=1-p0;
  r4cost=p0;
  [u,v]=min([r1cost r2cost r3cost r4cost]);
  bayesruleselected=v;
  switch(v)
  case 1
  datadetected=datarx;
  case 2
  datadetected=[];
  for i=1:1:length(datarx)
  if(datarx(i)==0)
  datadetected=[datadetected 1];
  else
  datadetected=[datadetected 0];
  end
  end
  case 3
  datadetected=zeros(1,length(datarx));
  case 4
  datadetected=ones(1,length(datarx));
  end
case 2
%Mini-max technique
pd=[];gamma=[];
bayesruleselected=[];
pl=min((p11/(1-p00+p11)),(p01/(1-p10+p01)));
ph=max((p11/(1-p00+p11)),(p01/(1-p10+p01)));
r1costpl=y(2)*pl*p10+y(1)*(1-pl)*p01;
r2costpl=y(2)*pl*p00+y(1)*(1-pl)*p11;
r3costpl=1-pl;
r4costpl=pl;
[val_pl bayes_pl]=min([r1costpl r2costpl r3costpl r4costpl]);
r1costph=y(2)*ph*p10+y(1)*(1-ph)*p01;
r2costph=y(2)*ph*p00+y(1)*(1-ph)*p11;
r3costph=1-ph;
r4costph=ph;
[val_ph bayes_ph]=min([r1costph r2costph r3costph r4costph]);
[minimaxval minimaxpos]=max([val_pl val_ph]);
%Bayes rule corresponding to the p0 ranging between pl and ph
pchoose=(pl+ph)/2;
r1costpchoose=y(2)*pchoose*p10+y(1)*(1-pchoose)*p01;
r2costpchoose=y(2)*pchoose*p00+y(1)*(1-pchoose)*p11;
r3costpchoose=1-pchoose;
r4costpchoose=pchoose;
[val_pchoose bayes_pchoose]=min([r1costpchoose r2costpchoose ...
r3costpchoose r4costpchoose]);
if((ph==pl))
minimaxpos=3;
end
switch(minimaxpos)
case 1
%Randomized decision rule between the region 1 and 2.
%Randomized decision rule between the rule 4 with
%probability rho and rule described
%by the variable bayes_pchoose with probability 1-rho
temp=(val_pl-val_ph+eps)/(ph-pl+eps);
rho=temp/(temp+1)
display('case1');
t1=[rho 1];
datadetected=[];
  for w= 1:len
  u=t1-rand;
  if(u(1) > 0)
  datadetected=[datadetected 1];
  else
  switch(bayes_pchoose)
  case 1
  datadetected=[datadetected datarx(w)];
  case 2
   if(datarx(w)==0)
   datadetected=[datadetected 1];
   else
   datadetected=[datadetected 0];
   endif  
  case 3
  datadetected = [datadetected 0];
  case 4
  datadetected = [datadetected 1];
  end
  end
  end
case 2
%Randomized decision rule between the region 2 and 3.
%Randomized decision rule between the rule described
%by the variable bayes_pchoose and rule 3
temp=(val_ph-val_pl+eps)/(ph-pl+eps);
rho=1/(1+temp)
display('case2');
datadetected=[];
for w=1:1:len
t1=[rho 1];
u=t1-rand;
if(u(1)>0)
switch(bayes_pchoose)
case 1
datadetected=[datadetected datarx(w)];
case 2
if(datarx(w)==0)
datadetected=[datadetected 1];
else
datadetected=[datadetected 0];
end
case 3
datadetected = [datadetected 0];
case 4
datadetected = [datadetected 1];
end
else
datadetected=[datadetected 0];
end
end
case 3
datadetected=[];
for w=1:1:len
t1=[0.5 1];
u=t1-rand;
if(u(1)>0)
datadetected=[datadetected 1];
else
datadetected=[datadetected 0];
end
end
end
case 3
%Neyman-pearson technique
pl=[];ph=[];val_pl=[];val_ph=[];pd=[];
%when the received signal is 1, decide it as in favour of 1 with
%probability 1. when the received signal is 0, decide it as in favour of 1
%with probability gamma(1).
gamma(1)=(pfa-p10)/p00;
pd(1)=p11+gamma(1)*p01;
%when the received signal is 1, decide it as in favour of 1 with
%probability gamma(2). when the received signal is 0, decide it
%as in favour of 1 with probability 0.
gamma(2)=pfa/p10;
pd(2)=gamma(2)*p11;
%when the received signal is 0, decide it as in favour of 1 with
%probability 1. when the received signal is 1, decide it as in favour of 1
%with probability gamma(3).
gamma(3)=(pfa-p00)/p10;
pd(3)=p00+gamma(3)*p10;
%when the received signal is 0, decide it as in favour of 1 with
%probability gamma(4). when the received signal is 1, decide
%it as in favour of 1 with probability 0.
gamma(4)=pfa/p00;
pd(4)=gamma(4)*p00+0*p10;
validpd=[];
for w=1:1:4
if(gamma(w)>=0)
validpd=[validpd pd(w)];
else
validpd=[validpd -1];
end
end
[p,q]=max(validpd);
switch(q)
case 1
datadetected=[];
for c=1:1:length(datarx)
if(datarx(c)==1)
datadetected=[datadetected 1];
else
t1=[gamma(1) 1];
u=t1-rand;
if(u(1)>0)
datadetected=[datadetected 1];
else
datadetected=[datadetected 0];
end
end
end
case 2
datadetected=[];
for c=1:1:length(datarx)
if(datarx(c)==0)
datadetected=[datadetected 0];
else
t1=[gamma(2) 1];
u=t1-rand;
if(u(1)>0)
datadetected=[datadetected 1];
else
datadetected=[datadetected 0];
end
end
end
case 3
datadetected=[];
for c=1:1:length(datarx)
if(datarx(c)==0)
datadetected=[datadetected 1];
else
t1=[gamma(3) 1];
u=t1-rand;
if(u(1)>0)
datadetected=[datadetected 1];
else
datadetected=[datadetected 0];
end
end
end
case 4
datadetected=[];
for c=1:1:length(datarx)
if(datarx(c)==1)
datadetected=[datadetected 0];
else
t1=[gamma(4) 1];
u=t1-rand;
if(u(1)>0)
datadetected=[datadetected 1];
else
datadetected=[datadetected 0];
end
end
end
end
bayesruleselected=[];
pl=[];ph=[];bayes_ph=[];bayes_pl=[];
end
pd_obtained_afterdetection=(length(find((datadetected-datatx)==0))...
/length(datatx));
pd_obtained_beforedetection=(length(find((datarx-datatx)==0))...
/length(datatx));
pfa_obtained_afterdetection=(length(find((datadetected-datatx)==1))...
/length(datatx));
pfa_obtained_beforedetection=(length(find((datarx-datatx)==1))...
/length(datatx));
save('datadetected.txt','datadetected');

figure(1)
subplot(3,1,1)
plot(datatx,'r')
title('data transmmitted');
subplot(3,1,2)
plot(datarx,'g')
title('data received');
subplot(3,1,3)
plot(datadetected,'b')
title('data detected');
