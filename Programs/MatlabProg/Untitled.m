clear,clc
% for m=-5:0.01:5
%     for n=-5:0.01:5
%         x=round((m+5)/0.01+1);
%         y=round((n+5)/0.01+1);
%         r(x,y)=m^2+n^2;
%     end
% end
% m=-5:0.01:5;
% n=-5:0.01:5;
% I=(besselj(1,r)./r).^2;
% I=I/max(max(I));
% figure(1),imshow(I);
% figure(2),mesh(m,n,I);
% figure(3),plot(m,I(500,:))

% if true
% [r,t]=meshgrid(0:1/10:10, (0:.5:360)*pi/180);
% P = 40;			% AUFFORDERUNG ZUM EINTIPPEN der Anzahl der schw Balken (=Anzahl Perioden)	
% Z = 255 .* (0.5 + 0.5 .*sin(P*t+pi/2));
% [X,Y,Z] = pol2cart(t,r,Z);
% colormap(gray)
% grid off
% star3d = surf(X,Y,Z,'linestyle','none');
% view([0 -90])
% set(gca,'XTickLabel',[],'YTickLabel',[]); 
% axis off 
% end

n = 50000;
x = randn(1,n) ;
y = zeros(1,n);
parpool('local',4)
    tic
    for i = 1 : n
        y(i) = std(x(1:i));
    end
    fprintf('\n Normal for: %f secs',toc);
    tic
    parfor i = 1 : n
        y(i) = std(x(1:i));
    end
    fprintf('\n     parFor: %f secs\n\n',toc);
delete(gcp);