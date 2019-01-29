classdef lowpass < audioPlugin
    properties
        Fc = 10000;
        Q = 0.707;
    end
    properties (Constant)
        PluginInterface = ...
            audioPluginInterface(...
            audioPluginParameter('Fc',...
            'DisplayName','Low Pass Freq.',...
            'Label','Hz',...
            'Mapping',{'log',1000,20000}),...
            audioPluginParameter('Q',...
            'Mapping',{'lin',0.1,6}))
    end
    properties
        % internal state
        z = zeros(2);
        b = zeros(1,3);
        a = zeros(1,3);
    end
    methods
        function out = process(p,in)
            [out,p.z] = filter(p.b,p.a,in,p.z);
        end
        function reset(p)
            % initialize internal state
            p.z = zeros(2);
            Fs = getSampleRate(p);
            [p.b, p.a] = lowPassCoeffs(p.Fc,p.Q,Fs);
        end
        function set.Fc(p,Fc)
            % initialize internal state
            p.Fc = Fc;
            Fs = getSampleRate(p);
            [p.b, p.a] = lowPassCoeffs(p.Fc,p.Q,Fs);
        end
        function set.Q(p,Q)
            % initialize internal state
            p.Q = Q;
            Fs = getSampleRate(p);
            [p.b, p.a] = lowPassCoeffs(p.Fc,p.Q,Fs);
        end
    end
end

function [b,a] = lowPassCoeffs(Fc,Q,Fs)
    w0 = 2*pi*Fc/Fs;            % Angular Freq. (Radians/sample) 
    alpha = sin(w0)/(2*Q);      % Filter Width

    b0 =  (1 - cos(w0))/2;
    b1 =   1 - cos(w0);
    b2 =  (1 - cos(w0))/2;
    a0 =   1 + alpha;
    a1 =  -2*cos(w0);
    a2 =   1 - alpha;

    b = [b0,b1,b2];
    a = [a0,a1,a2];

end

