# Hodgkin-Huxley-Model

​		Hodgkin-Huxley-Model是模拟神经元行为的一个重要模型，该代码库利用Matlab利用龙格库塔四阶算法来求解该微分方程组

## HodgkinHuxleyModel.m: 解微分方程

​		文件中的HHvi.m为一个求解该微分方程封装好的函数。对于不同的输入时间，强度等进行求解。具体参数如下：

```matlab
function [v,I,t,m,n,h] = HodgkinHuxleyModel(tSTIM_START,tSTIM_DUR,STIM_STRENGTH,endTime,selet)
%v : t时间内的电势差
%I : t时间内的电流
%t ： 时间
%m,n,h : 参数

%tSTIM_START ： 刺激开始时间
%tSTIM_DUR ： 刺激持续时间
%STIM_STRENGTH ： 刺激强度
%endTime ： 程序结束时间
%selet ： 选择项

```

selet含义：

```matlab
% plot the results

if(selet == 1) % 直接画出电势随时间的变化
    plot(t,v);
elseif(selet == 0) % 不做画图处理
    return   
else % 画出电势和电流的图形
    subplot(1,2,1),plot(t,v);
    subplot(1,2,2),plot(t,I);
end
axis([t(1) t(end) -10 100]);
```
如：
```matlab
HodgkinHuxleyModel(0,20,10,20,1)
```
结果为：
![https://raw.githubusercontent.com/Tikmoing/Hodgkin-Huxley-Model/main/png/1.png]



## 找寻极大值点

```matlab
function res = findMaxiumV(v)
res = 0;
for i = 2 : length(v)-1
    if( v(i) > v(i+1) && v(i) > v(i-1) && v(i) > 50 )

        res = res + 1;
    end
end

end
```

