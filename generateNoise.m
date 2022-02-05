function out=generateNoise(t)
%     gaus = wgn(1,length(t),0);
nvar = 1000;
white = nvar*randn(size(t));
% white = zeros(size(t));
    mainNoise =2*sin(2*pi*0.055*t);
% mainNoise = zeros(size(t));
    
    out = mainNoise+white;
end