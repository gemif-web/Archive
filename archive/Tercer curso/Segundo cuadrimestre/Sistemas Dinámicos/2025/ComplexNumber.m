% === ComplexNumber Class Definition ===
classdef ComplexNumber < handle
    properties
        re
        im
    end
    
    methods
        function obj = ComplexNumber(real_part, imag_part)
            obj.re = real_part;
            obj.im = imag_part;
        end
        
        function multiply(obj, other, factor)
            % Optimized in-place complex multiplication
            a = obj.re;
            b = obj.im;
            c = other.re;
            d = other.im;
            
            obj.re = factor * (a * c - b * d);
            obj.im = factor * (a * d + b * c);
        end
        
        function absSq = absSquared(obj)
            % Squared magnitude without sqrt
            absSq = obj.re^2 + obj.im^2;
        end
    end
end