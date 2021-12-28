function out=generateImpulse(t,FrameSize, impulseLength)
signal = NaN(size(t));
NIter = length(t)/FrameSize;
for i=1:NIter
    for j=1:FrameSize
       if impulseLength < FrameSize && j < impulseLength
           tmp_signal(j) = 1*sin(2*pi*0.055*t(j));
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
% for i=1:NIter
%     if mod(i,2) == 0 
%         signal((i-1)*FrameSize:i*FrameSize) = 0;
%     elseif i == 1
%       signal(i:i*FrameSize) = 0.5*sin(2*pi*0.055*t(i:i*FrameSize));
%     else
%       signal((i-1)*FrameSize:i*FrameSize) = 0.5*sin(2*pi*0.055*t((i-1)*FrameSize:i*FrameSize));
%     end
% end
out = signal;
end