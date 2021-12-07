function out=generateNoise(t)
    gaus = wgn(1,1000,0);
    mainNoise = 2*sin(2*pi*0.055*t);
    
    out = mainNoise+gaus;
end