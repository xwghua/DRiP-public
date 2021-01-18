function [peakvalue,peaksite] = peaksearch(temp_intensity)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
% [peakvalue,peaksite] = [[],[]];
temp_array = temp_intensity(100,101:end);
num = length(temp_array);
peakvalue = [];
peaksite =[];
for i=1:(num-1)
%     if length(peakvalue)==2
%         break
%     end
    if i ==1
        peakvalue = [peakvalue;temp_array(i)];
        peaksite = [peaksite;i];
    else
        if (temp_array(i)>temp_array(i+1))&&(temp_array(i)>temp_array(i-1))
            peakvalue = [peakvalue;temp_array(i)];
            %        peaksite = [peaksite;i*1.0/200*1E-4];
            peaksite = [peaksite;i];
        end
    end
    
end

end

