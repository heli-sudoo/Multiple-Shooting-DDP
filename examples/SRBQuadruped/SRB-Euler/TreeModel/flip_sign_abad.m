function vec_out = flip_sign_abad(vec_in, legID)
vec_out = vec_in;
vec_out(2) = vec_out(2) * (-1)^(legID+1);
end