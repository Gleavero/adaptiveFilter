function out=generateImpulse(t,FrameSize, impulseLength)
signal = NaN(size(t));
NIter = length(t)/FrameSize;
for i=1:NIter
    for j=1:FrameSize
       if impulseLength < FrameSize && j < impulseLength
           if j > 200 && j < 400
               tmp_signal(j) = 3*sin(2*pi*0.055*t(j));
           elseif j > 100 && j < 500
               tmp_signal(j) = 2*sin(2*pi*0.055*t(j));
           else
%            Sinus imp
           tmp_signal(j) = 1*sin(2*pi*0.055*t(j));
%            Square impulse
%            tmp_signal(j) = 1;
           end
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

% signal(800:1000) = 0;
% signal(2000:2200) = 1*sin(2*pi*0.055*t(2000:2200));

out = signal;
end