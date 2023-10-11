classdef ArrowGraphic
    %UNTITLED28 Summary of this class goes here
    %   Detailed explanation goes here
    properties
        handle
        base
        vec
    end
    methods
        function obj = ArrowGraphic(parent,radius,headRadius, headLen, color,alpha)
            if nargin < 6
                alpha = 1;
            end
            obj.handle = hgtransform('Parent',parent);
            g = hggroup('Parent',obj.handle);
            cylinder(g, [0 0 0; 0 0 1-headLen], radius, color,alpha);
            cone(g,[0 0 1-headLen; 0 0 1], headRadius, color,alpha);
        end
        
        function obj = setArrow(obj, base, vec)
            obj.base = base;
            obj.vec  = vec;
            obj.updateGraphics();
        end
        
        function obj = setVec(obj, vec)
            obj.base = [0 0 0];
            obj.vec = vec;
            obj.updateGraphics();
        end
        
        function obj = updateGraphics(obj)
            base = obj.base;
            vec = obj.vec;
            
            nv = norm(vec);
            if nv < 1e-6
                set(obj.handle,'Visible','off');
            else
                vecn = vec / nv;
                v  = [0 0 1];
                ax = cross(v,vecn);
                if norm(ax) < 1e-6 
                    ax = [0 0 1];
                    ang = 0;
                else 
                    if dot(v,vecn) <-.9999
                        ang = pi;
                    else
                        ang = acos(dot(v,vecn));
                    end
                end
                M = makehgtform('translate',base,'axisrotate',ax,ang,'scale',[1 1 nv]);
                set(obj.handle,'Matrix',M,'Visible','on');
            end
             
        end
    end
    
end

