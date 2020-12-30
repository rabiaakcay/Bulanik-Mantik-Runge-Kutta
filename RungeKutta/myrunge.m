%*******************************************
% State Equation Solution with Runge Kutta
clear; 
% Part 1: Data and initial conditions
A=[ -3 -3; 1 -9 ];
B=[1 0; 0 1]; 
C=[ 1 0]; 
D=0;
%*******************************************
% initials for simulation
x10=0; x20=0; 
u1=100; u2=0; 
dt=0.01;
tend=6; 
t0=0;
k=1; % k is dimension counter.
%*******************************************

%******************************************
% Initial Values
U0=[u1;u2];    
SIZE=size(A);  
LS=SIZE(1); 
LK=SIZE(2);

for n=1:LS
    x0(n)=0;
end

% For inspection
r0=input('Reference input value: ');
tend=input('Simulation end time: ');
%************************************************
% Fuzzy controller inputs
% e, de and du the limits of their exact spaces
	EMAX  = r0;        EMIN  = -EMAX;
	DEMAX = EMAX/10;   DEMIN = -DEMAX;
	DUMAX = 1;         DUMIN = -1;
    
% Data for membership functions
   NLe=EMIN;   NTe=NLe;    NRe=0; 
   ZLe=NTe;    ZTe=0;      ZRe=EMAX;
   PLe=ZTe;    PTe=EMAX;   PRe=PTe;
 
   NLde=DEMIN;     NTde=NLde;     NRde=0;
   ZLde=NTde;      ZTde=0;        ZRde=DEMAX;
   PLde=ZTde;      PTde=DEMAX;    PRde=PTde;
 
   NLdu=DUMIN;       NTdu=DUMIN;    NRdu=0;
   ZLdu=NTdu;        ZTdu=0;        ZRdu=DUMAX;
   PLdu=ZTdu;        PTdu=DUMAX;    PRdu=PTdu;
%*************************************************

% Initial values for error and controller
   ee=EMAX;   dee=0;  E=EMAX;  dE=0;    
   e0=EMAX;   e(1)=0; e(2)=0;  de=e(2)-e(1); 
   C(1)=0;
%*************************************************

% membership matrix 
     DU=[ ZTdu PTdu PTdu
          NTdu ZTdu PTdu
          NTdu NTdu ZTdu ];
%*************************************************

% iterative solution
while t0<tend-dt
      E=limiter(EMIN,EMAX,ee);% limit E 
     
      % Fuzzification
      FSE(1)=triangular(PLe,PTe,PRe,E); 
      FSE(2)=triangular(ZLe,ZTe,ZRe,E); 
      FSE(3)=triangular(NLe,NTe,NRe,E);
      DE=limiter(DEMIN,DEMAX,dee); % --- limit DE
      FSDE(1)=triangular(NLde,NTde,NRde,DE); 
      FSDE(2)=triangular(ZLde,ZTde,ZRde,DE); 
      FSDE(3)=triangular(PLde,PTde,PRde,DE);

     % Defuzzification
     N1=length(FSE);
     N2=length(FSDE);
     NM=N1*N2;
     nn=1;
     for mm=1:N1
        for qq=1:N2
            FSDU(nn)=min( [FSE(mm) FSDE(qq)] );
            nn=nn+1;
        end
     end
     nn=1;
     for mm=1:N1
         for qq=1:N2
             DDU(nn)=FSDU(nn)*DU(mm,qq);
             nn=nn+1;
         end
      end
      DUTOP1 = sum(DDU) ;            
      DUTOP2 = sum(FSDU);
      DV = (DUTOP1/DUTOP2);

   % PI effect
     C(k+1) = C(k) + DV;
     CC=limiter(0,DUMAX,C(k+1));                    
     UU0 = CC*U0;
     [x]=runge(A,B,UU0,x0,dt);%Solve equations with Runge function
     UU(k)=UU0(1);
     t(k)=t0+dt;    t0=t(k);
     r(k)=r0;       y(k)=x0(1);
     x1(k)=x(1); x2(k)=x(2);
     e(k)=r(k)-y(k);    de(k)=e(k)-e0;
     ee=e(k);  dee=de(k);   e0=e(k);   duty(k)=CC;
      for n=1:LS
           x0(n)=x(n);  XX(k,n)=x(n); 
      end
      k=k+1;
end;

% Graphics
subplot(311)
plot(t,x1);
title('x1');
xlabel('Time in seconds'); 
ylabel('x1');
grid
 
subplot(312)
plot(t,x2);
title('x2');
xlabel('Time in seconds');  
ylabel('x2'); 
grid
 
subplot(313)
plot(t,y,t,r,t,e); 
xlabel('Time in seconds'); 
ylabel('y');
grid

