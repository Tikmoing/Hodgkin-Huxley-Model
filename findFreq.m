
I = 0 : 0.001 : 30;
W = 0*I;

for i = 1 : length(I)
    v = HHvi(0,1500,I(i),1500,0);
    num = findMaxiumV(v);
    W(i) = num/1.5;
end

plot(I,W);


function res = findMaxiumV(v)
res = 0;
for i = 2 : length(v)-1
    if( v(i) > v(i+1) && v(i) > v(i-1) && v(i) > 80 )

        res = res + 1;
    end
end

end