classdef gainFader < audioPlugin
    properties
        GainFader = 0;
        LastGain = -6;
    end
    properties (Constant)
        PluginInterface = ...
            audioPluginInterface(...
            audioPluginParameter('GainFader',...
            'DisplayName', 'Gain', ...
            'Label', 'dB', ...
            'Mapping',{'lin',-48,12}))
    end
    methods
        function out = process(p,in)
            %gainLin = 10^(plugin.GainDB/20);
            numSamples = length(in);
            out = zeros(size(in));
            for n = 1:numSamples
                if (p.LastGain ~= p.GainFader)
                    p.LastGain = 0.99 * p.LastGain + 0.01 * p.GainFader;
                end
                gainLin = 10^(p.LastGain/20);
                out(n,:) = gainLin * in(n,:);
            end
        end
    end
end