function SRBD = compute_SRBD_inertia(robot)
% recompute the body inertia by considering leg mass properties
% robot:    physical parameter of mini cheetah
% SRBD:     physical parameter of floating base (SRBD)

SRBD = struct('mass', 0, ...
              'RotInertia', eye(3), ...
              'CoM', zeros(3,1)); % assume the reshaped CoM same as the geomeric center
SRBD.mass = robot.bodyMass;
SRBD.RotInertia = robot.bodyRotInertia;
SRBD.mass = SRBD.mass + 4*robot.abadLinkMass;
SRBD.mass = SRBD.mass + 4*robot.hipLinkMass;
SRBD.mass = SRBD.mass + 4*robot.kneeLinkMass;
SRBD.mass = SRBD.mass + 12*robot.rotorMass;

Ry = @(t)[cos(t)   0   sin(t);
            0        1   0     ;
          -sin(t)  0   cos(t)];

% Compute the inertia of abad link (including rotors) using parallel axis
% thm
for leg = 1:4
    pabad = robot.abadLoc{leg};         % assume abad CoM same as abad loc for simplicity
    Sa = skew(pabad);
    SRBD.RotInertia = SRBD.RotInertia + (robot.abadLinkMass + 3*robot.rotorMass) * (Sa*Sa');
    if leg <=2
        phip = pabad + flip_sign_abad(Ry(-pi/2)*robot.hipLinkCoM, leg);
        pknee = phip + Ry(-pi/2)*robot.kneeLinkCoM;
    else
        phip = pabad + flip_sign_abad(Ry(pi/2)*robot.hipLinkCoM, leg);
        pknee = phip + Ry(pi/2)*robot.kneeLinkCoM;
    end
    Sh = skew(phip);
    Sk = skew(pknee);
    SRBD.RotInertia = SRBD.RotInertia + 0.8*robot.hipLinkMass * (Sh*Sh');
    SRBD.RotInertia = SRBD.RotInertia + 0.8*robot.kneeLinkMass * (Sk*Sk');
end
end