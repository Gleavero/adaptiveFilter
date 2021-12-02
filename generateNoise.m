function out=generateNoise(t)
    gaus = wgn(1,1000,-10);
    mainNoise = sin(2*pi*0.035*t);
    
    out = mainNoise+gaus;
end