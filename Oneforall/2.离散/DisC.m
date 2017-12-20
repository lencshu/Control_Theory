clc;
clear;



% 定义符号
s=tf('s');
g=1/(s+1);
% step(g)

%斜坡函数ramp
% step(g/s)
% step(1/s-g/s)

%lag 补偿 c
c=(500*s+50)/(100*s^2+s)
cl=feedback(c*g,1)
% step(1/s-cl/s)
% bode(c*g)

%c2d() 默认的转换方式是ZOH(BOZ)
Te=0.1;
cz=c2d(c,Te);

%% 数字化会使高频信号损失，同时丢失了phase margin的稳定性
%%%因为Tes的采样增加了系统的phase lag
% bode(c,cz)

% 数字化的方法'zoh','foh','impulse','tustin','matched' 如果采样时间足够小，那么几种方法差别不大
gz=c2d(g,Te,'zoh');
gf=c2d(g,Te,'foh');
gi=c2d(g,Te,'impulse');
gt=c2d(g,Te,'tustin');
gm=c2d(g,Te,'matched');
% bode(g,gz,gf,gi,gt,gm)
% legend('continus','zoh','foh','impulse','tustin','matched')
% figure;step(g,gz,gf,gi,gt,gm)
% legend('continus','zoh','foh','impulse','tustin','matched')


