function  h = crystalball( parent )

% CRYSTALBALL  make a transparent sphere to facilitate rotation via mouse
% h=crystalball(parent)  creates a transparent sphere that is used to guide
% the rotation of showmotion scenes via the mouse.

h = hgtransform( 'Parent', parent );

s = sphere( h, [0 0 0], 1, [0.7 0.7 0.7], 48 );

sc = get( s, 'Children' );		% handles of the 8 patches that
                                        % make the sphere
set( sc, 'FaceAlpha', 0.35 );
set( sc, 'SpecularExponent', 4 );
set( sc, 'SpecularStrength', 0.4 );
set( h, 'Visible', 'off' );




