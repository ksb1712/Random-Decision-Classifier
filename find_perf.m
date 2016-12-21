function find_perf()
load('datatx.txt');
load('datadetected.txt');
p0 = 0;
p1 = 0;
for i = 1:length(datatx)
  if(datatx(i)==1)
    if(datadetected(i) == 1)
      p1++;
    end
  else
    if(datadetected(i) == 0)
      p0++;
    end
  end
end
p0
p1
(p0+p1) / length(datatx)
end

