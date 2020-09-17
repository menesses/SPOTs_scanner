function registerPoint(serial_port,number)
% For use in jog applet
% Gets Machine Coordinates and modifies global temp_points variable
    global temp_points
    [~,~,position] = getWCoMPos(serial_port);
    temp_points(number,1:2) = position(1:2);
end