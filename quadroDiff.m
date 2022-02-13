function [out]=quadroDiff(array1,array2, startPoint, endPoint)
    if length(array1) == length(array2)
        res = NaN(size(array1));
        normArr1 = array1(startPoint:endPoint)/norm(array1(startPoint:endPoint));
        normArr2 = array2(startPoint:endPoint)/norm(array2(startPoint:endPoint));
        res(startPoint:endPoint) = (normArr2-normArr1).^2;
        out = res;
    else 
        out = NaN(size(array1));
    end
end