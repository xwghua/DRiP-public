record=Record(1:end,:);
% cmp1=1/((record(:,6)-record(:,5)));
cmp1=1./(record(:,6)--record(:,5))*1e-6;
cmp2=record(:,5);
a=record(:,1);
h=record(:,2);
A=record(:,3);
H=record(:,4);
s=(a.*h+A.*H)./(h.*(a.^3) + H.*(A.^3));

% phi = atan((H.*sqrt(A))./(h.*sqrt(a)));
% phase = (sin(2*pi*a./(a+A)+pi/4+phi)).^2;
% fs = (a+A).*(h.^2.*a+H.^2.*A).*phase;
fs=sqrt(h.^2.*a+H.^2.*A);

% cmpr=[s,cmp1.^2];
figure(1),scatter(s,cmp1.^2);
figure(2),scatter(fs,cmp2);