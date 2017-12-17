Te=50e-3;
b1=0.09781 % Coefficient numérateur de T0d
a1=-0.599 % Coefficient dénominateur de T0d
p1PID=1.786;
p2PID=-2.302;
p3PID=1;

r0PID=(1-a1+p1PID)/b1;
r1PID=(p2PID+a1)/b1;
r2PID=p3PID/b1;

num4=[r2PID r1PID r0PID];
den4=[1 -1 0];
kPID=tf(num4, den4)
kPIDd=c2d(kPID,Te)