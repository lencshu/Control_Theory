clc;
clear;

%{
Te=0.72;
num=[1];
den=[1.562 0.25 1];
gp=tf(num,den);
gz=c2d(gp,Te);
%}

%{
%echelon: 
1/(1-z^-1)
%rampe
Te*z^-1/(1-z^-1)^2
%acceleration
(Te^2*z^-1*(1+z^-1))/(2*(1-z^-1)^2)
%}




%{
解多元方程 方法1
syms theta0 theta1 pi0 pi1;%定义变量
1-0.7345*z^-1+0.1993*z^-2=z^-1*(theta0+theta1*z^-1)+(1∗(1-z^-1))*(pi0+pi1*z^-1)
[Y,Cb,Cr] = solve('','','')

%解多元方程 方法2
% B=[1;-0.7345; 0.1993;0.3228];
% A\B
%}




%{
Te=0.72;
w1=1.4;
m1=0.8;
erreurVitesse=0.5;

syms theta0 theta1 pi0 pi1; %定义变量

w1=0.1*2*pi;
m1=0.5;
num1=[1]; % gain statique
den1=[(1/w1)^2 (2*m1)/w1 1];

num1=[1];
den1=[1 1 0];

%}



% num1=[1];
% den1=[1 1 0];

% erreurVitesse=0;
% Te=1;
% gp=tf(num1,den1);
% gz=c2d(gp,Te)


% %系数确定
% % X=[theta0;theta1;pi0;pi1]
% [P]=gz.den{1};

% %不存在积分器
% % A=[0 0 1 0;1 0 -1 1;0 1 0 -1; 0 0 1 1];

% %存在一个积分器
% A=[1 0 1 0;0 1 -1 1;0 0 0 -1; 0 0 1 1];

% DBF=P(1)+P(2)+P(3);
% Dmoins=1;
% ky=Te;

% p4=erreurVitesse*DBF/(Dmoins*ky);
% B=[P(1);P(2);P(3);p4]

% A\B

