% *********************************
Rav1 = 2100E-6;
dR1 = 100E-6;
R1 = Rav1-dR1/2;
R2 = Rav1+dR1/2;
% *********************************
Rav2 = 4300E-6;
dR2 = 200E-6;
R3 = Rav2-dR2/2;
R4 = Rav2+dR2/2;
range = linspace(-1E-2,1E-2,400);
x = range;
y = range;
rho = zeros(length(y),length(x));
tA = zeros(length(y),length(x));
for ii = 1:1:length(x)
   for jj = 1:1:length(y)
      rho(jj,ii) = sqrt(x(ii)^2 + y(jj)^2);
      if (rho(jj,ii)>R1 && rho(jj,ii)<R2)||(rho(jj,ii)>R3 && rho(jj,ii)<R4)
          tA(jj,ii)=1;
      else if rho(jj,ii)==R1 || rho(jj,ii)==R2 || rho(jj,ii)==R3 || rho(jj,ii)==R4
              tA(jj,ii)=0.5;
          end
      end
   end
end
% figure(1),mesh(x,y,tA);
int