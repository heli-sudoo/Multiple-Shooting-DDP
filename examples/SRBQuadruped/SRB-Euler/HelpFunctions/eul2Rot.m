function R = eul2Rot(eul)
% eul2Rot takes body fixed ZYX euler angles to rotation matrix
% Rz Ry Rx are conventional rotation matrices as opposed to Featherstone's
% rotation
R = Rz(eul(1)) * Ry(eul(2)) * Rx(eul(3));
end