clear;
close all;
warning off;
Nfor=100; % Maximum number of hours that the plant will be idle
Nstep=1; % Increase on the idle time after each step of the for loop
for ifor=1:Nfor
end
%% Main parameters
Pmax = 65; % Maximum allowed pressure in the cavern [bar]
Pmin = 46; % Minimum allowed pressure in the cavern [bar]
massflowratio = 2;
% Mass flow of the turbine / Mass flow of the compressor
Tchargeh=85; % Time the compressor will be on [h]
Tdischargeh=85; % Time the turbine will be on [h]
Tidleh1=0.5; % Time the plant will be idle [h]

%% Constants
Tenv=293;
% Ambient temperature [K]
Tcs=293; % Temperature of the cold storage [K]
Patm=1.013*10^5;
% Atmospheric pressure [Pa]
Ra = 286.7;
% Gas constant [J/(kg*K)]
cva=Ra*(5/2); % Cv of air for a diatomic gas []
cpa=cva+Ra; % Cp of air for a diatomic gas []
k=cpa/cva; % Cp/Cv for air as an ideal diatomic gas []
lambda=(k-1)/k;

%% Compressor values
mfac=120; % Massflow from air [kg/s]
polyc=1.6; % Polytropic exponent for compression
lambdac=(polyc-1)/polyc;
etac=0.88; % Compressor efficiency
EnergyC0=0; % Initial energy consu med by the compressor [J]
betac1=3.8; % p_n/p_0 Compression ratio of compressor one
betac2=2.6; % p_n/p_0 Compression ratio of compressor two
betac3=2.4; % p_n/p_0 Compression ratio of compressor three
betac4=Pmax/(betac1*betac2*betac3);
% p_n/p_0 Compression ratio of compressor four
betac=betac1*betac2*betac3*betac4;

%% Heat Exchanger values
effhxc=0.7; % Heat exchanger efficiency
cph2o=4181.3; % Specific heat for water at constant -
% pressure [J/(kg*K)]
% Heat transfer fluid (HTF). Liquid sodium was chosen as HTF
% because of its high temperature range (100C-760C)
cp_HTF=1260;
% Specific heat capacity at constant pressure [J/(kg*K)]
rho_HTF=570;
% Density of the heat transfer fluid [kg/m^3]

%% Cavern
Vc = 560000;
% Cavern volume [m^3] (McIntosh size)
Hc=200;
% Height of the cavern [m]
Ac=Vc/Hc;
% Cross-section area of the cavern [m^2]
dc=(4*Ac/pi)^(1/2);
% Diameter of the cavern [m]
Ae=1.8; % Enlargement factor []
Twa0 = Tenv;
% Temperature of the air sided wall at time 0 [K]
Ta0 = Tenv;
% Temperature of the air at time 0 [K]
Pa0 = 46*10^5;
% Initial pressure of the air in the cavern [Pa]
Minitial = Pa0*Vc/(Ra*Ta0);
% Minimum mass in the cavern [kg]
Aaw=(pi*dc*Hc+2*Ac)*Ae;
% Area of contact between air and -
% cavern [m^2]
l = 5;
% Conductivity of the rock-salt [W/(m*K)]
rho = 2100; % Densitiy of the rock-salt [kg/m^3]
crs = 920; % Specific heat capacity of the rock-salt [J/(kg*K)]
Long = 1.25;
% Deepness of the cavern to explore [m]
dwall = 1; % Thickness of the cavern’s wall through which -
% air will transfer heat [m]
alaw = l/dwall; % heat transfer coefficient fluid-cavern-
% [W/(K*m^2)]

%% Thermal Energy Storage made of concrete (TES)
Ssc_TES=0.66;
% Specific storage capacity of the TES [kWh/(m^3*K)]
rho_TES=2750;
% Density of concrete [kg/m^3]
cp_TES=916;
% Specific Heat capacity of the TES (concrete) [J/(Kg*K)]
TES0=294;
% Starting temperature for the TES [K]
Tin_TES=Tenv;
% Inlet temperature for the TES [K]
Tout_TES=TES0;
% Outlet temperature of the TES [K]
deltaT_TESmin=Tout_TES-Tin_TES;
% Difference between inlet and outlet temperatures from the
% expansion side [K]
h_TES=40; % Height of the TES [m]
r_TES=22/2; % Radius of the TES [m]
V_TES=h_TES*pi*r_TES^2; % Volume of the TES [m^3]
Energy_TESmin=V_TES*Ssc_TES*deltaT_TESmin/1000;
% Maximum amount of thermal energy that will be stored in -
% the TES [MWh]
m_TES=Energy_TESmin*10^6*3600/(cp_TES*deltaT_TESmin);
% Mas of the TES [kg]
Rconcrete=1;
% Thermal conductivity of the concrete [W/(m*K)]
Rwool=0.055;
% Thermal resistance of Glass-wool [W/(m*K)]
dconcrete=1;
% Thickness of the outer concrete wall [m]
dwool=0.10;
% Thickness of the insulation layer for the TES [m]
U_TES=(Rconcrete*Rwool)/(dconcrete*Rwool+dwool*Rconcrete);
% Overall heat transfer coefficient (out) [W/(m^2*K)]
A_TES=2*r_TES*pi*h_TES+pi*r_TES^2;
% Area of the TES exposed to the environment [m^2]
Ar=1.5; % Conversion factor for the heat exchanger inside -
% the TES []
dinnerconcrete=0.005; % Wall of the inner heat exchanger [m]
U1_TES=Rconcrete/dinnerconcrete;
% Overall heat transfer coefficient (in) [W/(m^2*K)]


%% Turbine
mfat=massflowratio*mfac; % Turbine mass flow [kg/s]
polyt=1.1; % Polytropic expansion coefficient []
lambdat=(polyt-1)/polyt;
EnergyE0=0; % Initial energy produced by the turbine [J]
% High Pressure Turbine (HPT)
betaHPT=2.5; % Expansion ratio of the turbines []
etaHPT=0.79; % Efficiency gas turbine []
PopHPT=43;
% Operational pressure so the turbine can start [bar]
% Low Pressure Turbine (LPT)
betaLPT=Pmin/betaHPT;
% Expansion ratio of the turbines []
etaLPT=0.82;
% Efficiency gas turbine []
PopLPT=15;
% Operational pressure so the turbine can start [bar]
betat=betaHPT*betaLPT;
etat=etaHPT*etaLPT;

%% Calculation of Cavern wall temperature
dx=0.11;
x=dx:dx:Long+dx;
N=length(x);
% define the ratio r (Fourier’s number)
r = l/(rho*crs)/dx/dx;
% define the ratio g (dimensionless location)
for i=1:N
    g(i) = dx/(2*x(i));
end
% define the Biot number (left)
Bi = alaw/l*dx;
% Matrix A is a tridiagonal matrix that is obtained through -
% the differential equation:
% dT/dt=r*[T(i+1,m)*(g+1)+T(i-1,m)*(1-g)-2*T(i,m)]
Diagup=zeros(N-1,N-1);
Diagdown=zeros(N-1,N-1);
for i=1:N-1
    Diagup(i,i)=(g(i)+1);
    Diagdown(i,i)=(1-g(i+1));
end
A=[-2*eye(N) + [zeros(N-1,1),Diagup;
zeros(1,N)] + [zeros(N-1,1),Diagdown;
zeros(1,N)]'];
A(1,1) = -2+(1-g(1))*(1-1/(1/Bi+1/2));
% Vector P is the vector that is added to consider the boundary-
% conditions. Since this vector has the value of the wall tempe-
% rature at the beginning and the value of the rock-salt at the -
% end, then we are decomposing it in two vectors P=P1+P2
Twinf=Tenv;
P1=[(1-g(1))/(1/Bi+1/2);zeros(N-1,1)];
P2=[zeros(N-1,1);1+g(N)];
% uinitial is the initial value for the temperature of the wall.
% When the cavern is empty this value is set as the ambient -
% temperature (Tamb).
uinitial=[Twa0*ones(N,1)];
Aux=[1;zeros(N-1,1)]';

%% Running the simulation
Generate=0; % 1 When the plant generates electrity, 0 when it’s not
Compress=1; % 1 When the plant is compressing air, 0 when it’s not
Tcharge=Tchargeh*3600; % Charging time [s]
sim('simCAESlinmod_regP_noE',Tcharge,[],[]) % Loading Simulink Simulation

%% Managing the plant
LPc1=length(Pc);
ltout=length(tout);
PowerC1=PowerC;
PowerAC=PowerC1(1,2);
Ta0=Tc(LPc1,2);
TES0=TESout(LPc1,2);
Pa0=Pc(LPc1,2);
Twa0=Twa(ltout,2);
Minitial=Mc(LPc1,2);
Twacompress=Twa(:,2);
uinitial=xout(ltout,4:N+3)';
Twinf=xout(ltout,N+3);
% Calculating the power consumed
Compress=0;
Generate=1;
% Tidle=Tidleh1*3600;
Tdischarge=Tdischargeh*3600; % Discharge time [s]
sim('simCAESlinmod_regP_noE',Tdischarge,[],[])
% Loading Simulink Simulation
LPc2=length(Pc);
PowerE1=PowerE;
PowerAE=PowerE1(1,2);
EfficiencyPA=PowerAE/PowerAC
% Calculation of the efficiency of the plant

















