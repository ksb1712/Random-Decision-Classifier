function mini_max()
close all
delete('datadetected.txt');
display('Prior count');
[ze, one] = find_init();
load('datatx.txt');
%penalize error
y=[1 1];
len=max(length(datatx));
display('prior probability');
%find prior probability of 0
p0 = (len - max(length(find(datatx))))/len;
%probability of false alarm for Neyman Pearson
pfa=[];
%probability of obtaining true positive 0
p00 = ze/(len - max(length(find(datatx))));
%probability of obtaining true positive 1 
p11 = one/(max(length(find(datatx))));
x=[p00 p11];
[datatx,datarx,datadetected,bayesruleselected,pl,ph,val_pl,val_ph,...
pd,gamma,pd_obtained,pfa_obtained]=binarychanneldetection(x,y,2,len,p0,pfa);
display('After count');
find_perf();
end
