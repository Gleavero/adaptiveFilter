function out=generateNoise(t)
%     gaus = wgn(1,length(t),0);
nvar = 1;
white = nvar*randn(size(t));
    mainNoise = 2*sin(2*pi*0.055*t);
    
    out = mainNoise+white;
end