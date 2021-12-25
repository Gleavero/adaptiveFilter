FrameSize = 200;
impulseLength = 120;
t = 1:1000;
signal = NaN(size(t));
NIter = length(t)/FrameSize;
for i=1:NIter
    for j=1:FrameSize
       if impulseLength < FrameSize && j < impulseLength
           tmp_signal(j) = 0.5*sin(2*pi*0.055*t(j));
       else
           tmp_signal(j) = 0;
       end
    end
    if i == 1
        signal(i:i*FrameSize) = tmp_signal;
    else
        sizeTest = signal((i-1)*FrameSize+1:i*FrameSize);
        signal((i-1)*FrameSize+1:i*FrameSize) = tmp_signal;
    end
end