function out=generateImpulse(t,FrameSize)
NIter = length(t)/FrameSize;
for i=1:NIter
    if mod(i,2) == 0 
        signal((i-1)*FrameSize:i*FrameSize) = 0;
    elseif i == 1
      signal(i:i*FrameSize) = 0.5*sin(2*pi*0.055*t(i:i*FrameSize));
    else
      signal((i-1)*FrameSize:i*FrameSize) = 0.5*sin(2*pi*0.055*t((i-1)*FrameSize:i*FrameSize));
    end
end
out = signal;
end