% Генерация объекта обычного RLS фильтра
function [out] = getRLS(discreteSize)
    L = discreteSize;
    lam = 1;
    sigma = 0.1;
    w0 = zeros(L,1)';
    P0 = (1/sigma)*eye(L,L);
    %Объект адаптивного фильтра RLS
    out = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
end

