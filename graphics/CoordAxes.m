classdef CoordAxes
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        z
    end
    
    methods
        function obj = CoordAxes(parent,radius, headRadius, headLen, colors,alpha, len)
            
            obj.x = ArrowGraphic(parent,radius,headRadius, headLen, colors{1} ,alpha);
            obj.y = ArrowGraphic(parent,radius,headRadius, headLen, colors{2} ,alpha);
            obj.z = ArrowGraphic(parent,radius,headRadius, headLen, colors{3} ,alpha);
            
            obj.x = obj.x.setArrow([0 0 0],[1 0 0]'*len); obj.x.updateGraphics();
            
            obj.y = obj.y.setArrow([0 0 0],[0 1 0]'*len); obj.y.updateGraphics();
            
            obj.z = obj.z.setArrow([0 0 0],[0 0 1]'*len); obj.z.updateGraphics();
        end
        
        function obj = show(obj)
            obj.x.handle.Visible = 'on';
            obj.y.handle.Visible = 'on';
            obj.z.handle.Visible = 'on';
        end
        
        function obj = hide(obj)
            obj.x.handle.Visible = 'off';
            obj.y.handle.Visible = 'off';
            obj.z.handle.Visible = 'off';
        end
    end
end


