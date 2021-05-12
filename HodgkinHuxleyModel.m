function [v,I,t,m,n,h] = HHvi(tSTIM_START,tSTIM_DUR,STIM_STRENGTH,endTime,selet)
%% Constant
% Nernst Potentials
Ena = 115; Ek = -12; El = 10.6;

% Maximum Conductances
gna = 120; gk = 36; gl = 0.3;

% Membrane Capacitance
C = 1;

%% functions for this model

an = @(u) (0.1-0.01*u)/(exp(1-0.1*u)-1);
am = @(u) (2.5-0.1*u)/(exp(2.5-0.1*u)-1);
ah = @(u) 0.07*exp(-u/20);

bn = @(u) 0.125*exp(-u/80);
bm = @(u) 4*exp(-u/18);
bh = @(u) 1/(exp(3-0.1*u)+1);

m_inf = @(u) am(u) / ( am(u) + bm(u) );
n_inf = @(u) an(u) / ( an(u) + bn(u) );
h_inf = @(u) ah(u) / ( ah(u) + bh(u) );

Vtf = @(Vx,mx,hx,nx) gl .* (Vx - El) + gna .* (mx^3) .* hx .* (Vx-Ena) + gk .* (nx^4) .*(Vx-Ek);
mtf = @(Vx,mx,hx,nx) am(Vx) .* (1-mx) - bm(Vx) .* mx;
htf = @(Vx,mx,hx,nx) ah(Vx) .* (1-hx) - bh(Vx) .* hx;
ntf = @(Vx,mx,hx,nx) an(Vx) .* (1-nx) - bn(Vx) .* nx;

%% initial for this model
dt = 0.01;
t = 0:dt:endTime;

m = 0*t + m_inf(0);
n = 0*t + n_inf(0);
h = 0*t + h_inf(0);
v = 0*t;
I = 0*t;

%This function is for whether the time in we want to stimulusit.
inRange = @(x,a,b) (x>=a) & (x<b);
%% ode 4 operate

for i = 1:length(t)-1
    
    Istim = 0;
    if tSTIM_DUR ~= -1 && inRange( t(i) , tSTIM_START , tSTIM_START+tSTIM_DUR) 
        Istim = STIM_STRENGTH;
    elseif tSTIM_DUR == -1
        Istim = STIM_STRENGTH;
        
    end

    I(i) = Istim;
    kv1 = (Istim - Vtf( v(i),m(i),h(i),n(i)))/C ;
    km1 = mtf(  v(i),m(i),h(i),n(i) );
    kh1 = htf( v(i),m(i),h(i),n(i) );
    kn1 = ntf( v(i),m(i),h(i),n(i) );
    
    kv2 = (Istim - Vtf( v(i) + kv1 * dt/2,m(i) + dt*km1/2,h(i) + dt*kh1/2,n(i)+dt*kn1/2))/C ;
    km2 = mtf( v(i) + kv1 * dt/2,m(i) + dt*km1/2,h(i) + dt*kh1/2,n(i)+dt*kn1/2) ;
    kh2 = htf( v(i) + kv1 * dt/2,m(i) + dt*km1/2,h(i) + dt*kh1/2,n(i)+dt*kn1/2) ;
    kn2 = ntf( v(i) + kv1 * dt/2,m(i) + dt*km1/2,h(i) + dt*kh1/2,n(i)+dt*kn1/2) ;
    
    kv3 = (Istim - Vtf( v(i) + kv2 * dt/2,m(i) + dt*km2/2,h(i) + dt*kh2/2,n(i)+dt*kn2/2))/C ;
    km3 = mtf(  v(i) + kv2 * dt/2,m(i) + dt*km2/2,h(i) + dt*kh2/2,n(i)+dt*kn2/2) ;
    kh3 = htf(  v(i) + kv2 * dt/2,m(i) + dt*km2/2,h(i) + dt*kh2/2,n(i)+dt*kn2/2) ;
    kn3 = ntf(  v(i) + kv2 * dt/2,m(i) + dt*km2/2,h(i) + dt*kh2/2,n(i)+dt*kn2/2) ;
    
    kv4 = (Istim - Vtf( v(i) + kv3 * dt,m(i) + dt*km3,h(i) + dt*kh3,n(i)+dt*kn3))/C ;
    km4 = mtf( v(i) + kv3 * dt,m(i) + dt*km3,h(i) + dt*kh3,n(i)+dt*kn3) ;
    kh4 = htf( v(i) + kv3 * dt,m(i) + dt*km3,h(i) + dt*kh3,n(i)+dt*kn3) ;
    kn4 = ntf( v(i) + kv3 * dt,m(i) + dt*km3,h(i) + dt*kh3,n(i)+dt*kn3) ;
    
    v(i+1) = v(i) + (kv1 + 2*kv2 + 2*kv3 + kv4) * dt / 6;
    m(i+1) = m(i) + (km1 + 2*km2 + 2*km3 + km4) * dt / 6;
    h(i+1) = h(i) + (kh1 + 2*kh2 + 2*kh3 + kh4) * dt / 6;
    n(i+1) = n(i) + (kn1 + 2*kn2 + 2*kn3 + kn4) * dt / 6;
    
end
% plot the results

if(selet == 1)
    plot(t,v);
elseif(selet == 0)
    return   
else
    subplot(1,2,1),plot(t,v);
    subplot(1,2,2),plot(t,I);
end
axis([t(1) t(end) -80 60]);


end