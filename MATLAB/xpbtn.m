function xpbtn(serial_port,increment)
% For use in jog applet
% Button response function for x+ movement. Sends command to move stage
% at given increment.
    movestageincremental(serial_port,increment,0,2000)
    getResponse(serial_port)
end
