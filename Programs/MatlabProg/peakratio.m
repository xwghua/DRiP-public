function ratio = peakratio(temp_intensity)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[peakvalue,peaksite] = peaksearch(temp_intensity);
ratio = peakvalue(2)/peakvalue(1)*100;
% if ratio<=5
%     disp([num2str(ratio) '%']);
% end
end

