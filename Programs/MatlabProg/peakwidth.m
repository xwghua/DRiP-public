function [peak_width] = peakwidth(temp_intensity)
%PEAKWID �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[peakvalue,peaksite] = peaksearch(temp_intensity);
in_AOI = temp_intensity(100,101:(100+peaksite(2)));
[M,I] = min(in_AOI);
peak_width = min(I)/200*(1E-2);
end

