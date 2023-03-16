%% Discharging Mode
tspan_dis=[0 200];
y0_dis=[];

TdHPo=823.15; TdLPo=1098.2; TxHPo=612.15; TxLPo=668.15;
pi_tHPo=3.818; pi_tLPo=10.856;
eta_tHPm=0.99; eta_tLPm=0.99; eta_tHPi=0.8065; eta_tLPi=0.7926;
Tbo=599.15;
% 热交换的效率,此处近似0.8
eps_r=0.80;
cp=1.055;
Ptmo=280;
gamma=1.4;

dmto=417; dmfo=12;
K4=0.8; K5=0.2;
tauR=25; tau3=15; tau4=2.5;
KTp=7; KTi=5;
tauS=0.05; tauSF=0.4;
Fmax=1.25+0.25; Fmin=0;
c2=0.05; c1=1-c2;
tauAV=0.1; tauTD=0.3;
gmax=1.25+0.25; gmin=0.1;
R=0.04; Ktp=3; Kti=2;
tauTP=0.02;
umax=1.2+0.3; umin=0;
Ht=3.9821;
Dt=2;
KAGC2=60;
Txref=1;
Ptref=0.9;

%% Discharging Mode Simplified Model
dTo=315.73; % 温度单位K
Txo=762.41;
eta_ti=0.7995;
eta_tm=0.9801;
pi_to=41.451;

%% Charging Mode 
Tci1=283.15; Tcout1o=497.6;  eps_hx1=0.8785;
Tci2o=323.15; Tcout2o=420.5;  eps_hx2=0.8;
Tci3o=323.15; Tcout3o=421.5;  eps_hx3=0.8;
Tci4o=323.15; Tcout4o=421.2;  eps_hx4=0.8;
eta_ci1=0.8200; eta_cm1=0.99; pi_c1o=5.4290;
eta_ci2=0.9115; eta_cm2=0.99; pi_c2o=2.3460;
eta_ci3=0.9023; eta_cm3=0.99; pi_c3o=2.3460;
eta_ci4=0.9097; eta_cm4=0.99; pi_c4o=2.3460;
tau_hx1=12; tau_hx2=12; tau_hx3=12; tau_hx4=12;
Hc=12.957; Dc=0;
Pcmo=58.7; gamma=1.4; cp=1.055;
Thxin=298.7; R=0.04;
Kcd=0.214; Kcp=0.4147; Kci=0.1485;
N=1.0792; tauCD=0.2; tauIGV=0.2;
lmax=1.15; lmin=0.6-0.5;
tauDr=1.5; tauCP=0.02;
Kdroop=2000;
% d表示变化率
dmco=108; %kg/s

%% Charging Mode Simplified Model
eta_ci2_simp=0.9142; eta_cm2_simp=0.9703; pi_c2o_simp=12.9117;

%% Cavern
pso=42; % 单位bar
Vs=3e5;
Ts=323.15;
R_cavern=287.058; % J/kg*K
% Cavern内部气体质量基准值mso
mso=(1e5*pso*Vs)/(R_cavern*Ts);

%% System
% 功率单位MW
PGTo=213.4;
PST1o=200;
PST2o=200;
Pwo=200;
% 焓单位s
HGT=18.5;
HST1=3.17;
HST2=3.17;
Hw=3;
KAGC1=20;


%% calculate
x0 = [1,1];
a1=fsolve(@pi_c1,x0);
a2=fsolve(@pi_c2,x0);
a3=a2;
a4=a2;
function F = pi_c1(x)
    F(1) = x(1)*sqrt(1-1/x(2))-1*5.429; % pi_c1o=5.429
    F(2) = x(1)*sqrt(1-0.5/x(2))-1.12*5.429;
end

function F = pi_c2(x)
    F(1) = x(1)*sqrt(1-1/x(2))-1*2.346; % pi_c2o=2.346
    F(2) = x(1)*sqrt(1-0.5/x(2))-1.12*2.346;
end


