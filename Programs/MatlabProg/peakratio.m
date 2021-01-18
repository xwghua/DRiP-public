function ratio = peakratio(temp_intensity)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[peakvalue,peaksite] = peaksearch(temp_intensity);
ratio = peakvalue(2)/peakvalue(1)*100;
% if ratio<=5
%     disp([num2str(ratio) '%']);
% end
end

