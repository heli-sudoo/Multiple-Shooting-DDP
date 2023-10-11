classdef MyColors < handle
    properties
        blu
        org
        yel
        pup
        grn
        cyn
        red    
    end
    
    methods
        function c = MyColors()
            c.blu = [0 0.4470 0.7410];
            c.org = [0.8500 0.3250 0.0980];
            c.yel = [0.9290 0.6940 0.1250];
            c.pup = [0.4940 0.1840 0.5560];
            c.grn = [0.4660 0.6740 0.1880];
            c.cyn = [0.3010 0.7450 0.9330];
            c.red = [0.6350 0.0780 0.1840];
        end
    end
    
end

