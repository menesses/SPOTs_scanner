function ypbtn(serial_port,increment)
% For use in jog applet
% Button response function for y+ movement. Sends command to move stage
% at given increment.
    movestageincremental(serial_port,0,increment,2000)
    getResponse(serial_port)
end
