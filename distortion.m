classdef distortion < audioPlugin
    properties
        Drive = 5;
    end
    properties (Constant)
        PluginInterface = ...
            audioPluginInterface(...
            audioPluginParameter('Drive',...          
            'Mapping',{'lin',1,10}))
    end
    methods
        function out = process(p,in)
            out = (2/pi) * atan(p.Drive * in);
        end
    end
end