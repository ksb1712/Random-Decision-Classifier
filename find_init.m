function [p0,p1] = find_init()
load('datatx.txt');
load('datarx.txt');
p0 = 0;
p1 = 0;
for i = 1:length(datatx)
  if(datatx(i)==1)
    if(datarx(i) == 1)
      p1++;
    end
  else
    if(datarx(i) == 0)
      p0++;
    end
  end
end
display('No of zeros and ones');
p0
p1
(p0+p1) / length(datatx)

end