function out = smoothMean(signal)
%SMOOTHMEAN Summary of this function goes here
%   Detailed explanation goes here

out = smoothdata(signal,'movmean',32);
end

