function [out1,out2,diff]=LMSfilt(noise,additiveMix, discreteSize,rI,pI,ha1,ha2)
% Создаем массивы выходных данных
x = NaN(size(additiveMix));
x1 = NaN(size(additiveMix));
filts = NaN(size(additiveMix));
difference = zeros(size(additiveMix));
% Разница между отсчетами щупов
diffI = pI-rI;
% Длина смеси сигналов
lenMix = length(additiveMix);
% % % Every iteration learning with detect of change process
for i=rI:lenMix-(3*discreteSize+diffI)
    [~,x_tmp1] = ha1(noise(i:i+discreteSize),additiveMix(i:i+discreteSize));
%     W1 = ha1.Coefficients;
    [~,x_tmp2] = ha2(noise((i+diffI):(i+diffI)+discreteSize),additiveMix((i+diffI):(i+diffI)+discreteSize));
%     W2 = ha2.Coefficients;
    
    x(i:i+discreteSize) = x_tmp1;
    x1((i+diffI):(i+diffI)+discreteSize) = x_tmp2;
    
    difference(i) = mean(quadroDiff(x_tmp1,x_tmp2,1,length(x_tmp1)));
end

out1=x;
out2=x1;
diff=difference;
end