%*********************************
%Simulation of the system with 25 rules fuzzy logic controller
%*********************************
clear
%System variables
A=[-3 -3; 1 -9];
B=[1 0;0 1]; C=[1 0]; D=0;
%*********************************
%initial for simulation
x10=0; x20=0; x0=[x10;x20];
u1=100; u2=0; U0=[u1;u2];
dt=0.01; t0=0; tend=10; k=1;
%*******************************
% For inspection
r0=input('Reference input value: ');
tend=input('Simulation end time: ');
%************************************************
% Fuzzy logic controller datas
% boundaries of the universes e,de and du
	EMAX  = 20;        EMIN  = -EMAX;
	DEMAX = r0/50;     DEMIN = -DEMAX;
	DUMAX = 1;         DUMIN =-DUMAX;
% Variables for Membership Functions
    N2Le=EMIN;   N2Te=N2Le;    N2Re=N2Te/2; 
    N1Le=N2Te;   N1Te=N2Re;    N1Re=0;
    SLe=N1Te;    STe=0;        SRe=EMAX/2;
    P1Le=0;      P1Te=SRe;     P1Re=EMAX;
    P2Le=P1Te;   P2Te=P1Re;    P2Re=P1Re;
    
    N2Lde=DEMIN;   N2Tde=N2Lde;    N2Rde=N2Tde/2; 
    N1Lde=N2Tde;   N1Tde=N2Rde;    N1Rde=0;
    SLde=N1Tde;    STde=0;         SRde=DEMAX/2;
    P1Lde=0;       P1Tde=SRde;     P1Rde=DEMAX;
    P2Lde=P1Tde;   P2Tde=P1Rde;    P2Rde=P1Rde;

    N2Ldu=DUMIN;   N2Tdu=N2Ldu;    N2Rdu=N2Tdu/2; 
    N1Ldu=N2Tdu;   N1Tdu=N2Rdu;    N1Rdu=0;
    SLdu=N1Tdu;    STdu=0;         SRdu=DUMAX/2;
    P1Ldu=0;       P1Tdu=SRdu;     P1Rdu=DUMAX;
    P2Ldu=P1Tdu;   P2Tdu=P1Rdu;    P2Rdu=P1Rdu;
     
%*************************************************    
%  Initials for controller
   ee=EMAX;   dee=0;   
   e0=EMAX;   C(1)=0;
%*************************************************    
    % membership rule matrix
     DU=[N2Tdu	N2Tdu	N1Tdu	N1Tdu	STdu
         N2Tdu	N1Tdu	N1Tdu	STdu	P1Tdu
         N1Tdu	N1Tdu	STdu	P1Tdu	P1Tdu
         N1Tdu	STdu	P1Tdu	P1Tdu	P2Tdu
         STdu	P1Tdu	P1Tdu	P2Tdu	P2Tdu];
%*************************************************
%solution
while t0<tend-dt
    % Fuzzification
    E=limiter(EMIN,EMAX,ee); % ---------- limit E
    FSE(1)=triangular(N2Le,N2Te,N2Re,E);
    FSE(2)=triangular(N1Le,N1Te,N1Re,E);
    FSE(3)=triangular(SLe,STe,SRe,E);
    FSE(4)=triangular(P1Le,P1Te,P1Re,E);
    FSE(5)=triangular(P2Le,P2Te,P2Re,E);
    DE=limiter(DEMIN,DEMAX,dee); % --- limit DE
    FSDE(1)=triangular(N2Lde,N2Tde,N2Rde,DE);
    FSDE(2)=triangular(N1Lde,N1Tde,N1Rde,DE);
    FSDE(3)=triangular(SLde,STde,SRde,DE);
    FSDE(4)=triangular(P1Lde,P1Tde,P1Rde,DE);
    FSDE(5)=triangular(P2Lde,P2Tde,P2Rde,DE);
% -----------------------------------------------------------------
   % Defuzzification
    muTOP=0; muDUTOP=0;
    for n=1:5
        for m=1:5
            mu=min(FSE(n),FSDE(m));
            muDU=mu*DU(n,m);
            muTOP=muTOP+mu;
            muDUTOP=muDUTOP+muDU;
        end
    end
    DV=muDUTOP/muTOP;
  % -------------------------------
    C(k+1) = C(k) + DV;     
    CC=limiter(0,DUMAX,C(k+1));   
    u = CC*U0;
    x=runge(A,B,u,x0,dt); %Runge Algorithm
    t(k)=t0+dt;    t0=t(k);
    r(k)=r0;   x0=x;    y(k)=x0(1);  
    x1(k)=x(1); x2(k)=x(2);
    e(k)=r(k)-y(k);    de(k)=e(k)-e0;
    ee=e(k);  dee=de(k);   e0=e(k);
    k=k+1;
end
%**********************************
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