classdef tremolo < audioPlugin
    properties 
        Depth = 1;
        Rate = 1;
    end
    properties (Constant)
        PluginInterface = ...
            audioPluginInterface(...
            audioPluginParameter('Depth'),...
            audioPluginParameter('Rate',...
            'Mapping',{'log',0.1,10}))
    end
    properties
        currentPhase = 0;
        angleChange = 0.1 * (1/44100) * 2 * pi;
    end
    methods
        function out = process(p,in)
            [numSamples,numChannels] = size(in);
            out = zeros(numSamples,numChannels);
            for s = 1:numSamples
                amp = (p.Depth/2) * sin(p.currentPhase) + (1-(p.Depth/2));
                out(s,:) = amp * in(s,:);
                p.currentPhase = p.currentPhase + p.angleChange;
                if p.currentPhase > 2*pi
                    p.currentPhase = p.currentPhase - 2*pi;
                end
            end
        end
        function reset(p)
            Fs = getSampleRate(p);
            p.angleChange = p.Rate * (1/Fs) * 2 * pi;
        end
        function set.Rate(p,Rate)
            p.Rate = Rate;
            Fs = getSampleRate(p);
            p.angleChange = p.Rate * (1/Fs) * 2 * pi;
        end
    end
end