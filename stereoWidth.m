classdef stereoWidth < audioPlugin
    properties
        Width = 1;
    end
    properties (Constant)
        PluginInterface = ...
            audioPluginInterface(...
            audioPluginParameter('Width',...
            'Mapping',{'pow',2,0,4}))
    end
    methods
        function out = process(plugin,in)
            mid = (in(:,1) + in(:,2)) / 2;
            side = (in(:,1) - in(:,2)) / 2;
            side = side * plugin.Width;
            out = [mid + side, mid - side];
        end
    end
end