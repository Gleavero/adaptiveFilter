clear all; clc;
% Временной диапазон
t = 1:2400;
% Частота дискретизации (пока условно ширина "щупов")
discreteSize =8;
% Начальное положение рабочего импульса
rI = 10;
% Начальное положение проверочного импульса
pI =19;
% Генерация импульса
impulse = generateImpulse(t,800,600);
% impulse = 2*sin(2*pi*0.055*t);
% impulse = zeros(size(t));
% Генерация шума
noise = generateNoise(t);

iterations = 1:4:40;

graph = zeros(size(iterations));

withPause = zeros(size(iterations));

for i=1:length(iterations)
    noise = noise + iterations(i)*randn(size(t));
    % Смесь импульса с шумом
    additiveMix = impulse+noise;
    % Доля проникновения импульса на опорный вход
    noise = noise+0*impulse;
    %Объект адаптивного фильтра RLS
    ha1 = getRLS(discreteSize);
    ha2 = getRLS(discreteSize);
    % Объекты адаптивного фильтра NLMS
    % ha1 = dsp.LMSFilter('Method', 'Normalized LMS', 'Length', L, 'StepSize',0.2, 'LeakageFactor', 1, 'InitialConditions', 1e-6);
    % ha2 = dsp.LMSFilter('Method', 'Normalized LMS', 'Length', L, 'StepSize',0.2, 'LeakageFactor', 1, 'InitialConditions', 1e-6);

    % Основная функция обработки сигнала
    [x,x1,difference,filters] = filt(noise,additiveMix,discreteSize,rI,pI,ha1,ha2);
    % NLMS
    % [x,x1,difference] = LMSfilt(noise',additiveMix',discreteSize,rI,pI,ha1,ha2);
    % x = x';
    % x1 = x1';
%     difference = difference';
    % Вычисляем разницу между выходами адаптивных фильтров и исходным сигналом
%     resAF1 = quadroDiff(impulse,x,800,2000);
%     resAF2 = quadroDiff(impulse,x1,800,2000);

%     diff = pI-rI;
% 
%     ha = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
%     output = NaN(size(t));
%     WOut = W;
%     [~,output(600:700)] = ha(noise(600:700),additiveMix(600:700));
%     WOut = ha.Coefficients;
%     haOut = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',WOut,'LockCoefficients', true);
% 
%     [~,output(700:length(t))] = haOut(noise(700:length(t))+0.1*impulse(700:length(t)),additiveMix(700:length(t)));
%     resOut = quadroDiff(impulse,output,800,2000);
%     meanDiff = NaN(size(t));
%     meanDiff(1:length(difference)) = movmean(difference, 64);
      diff = quadroDiff(impulse,x,100,2000);
      graph(i) = mean(diff(100:2000));
end

withPause(1:3) = graph(1:3);
withPause(4:length(iterations)) = 1e-12;

figure

subplot(1,1,1); plot(iterations,graph,iterations,withPause); 
axis([min(iterations) max(iterations) 0 max(graph)]);
xlabel('Noise Coeff'); ylabel('Diff');

