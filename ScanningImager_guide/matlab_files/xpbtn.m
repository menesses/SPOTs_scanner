function xpbtn(serial_port,increment)
% For use in jog applet
% Button response function for x+ movement. Sends command to move stage
% at given increment.
    command = ['G91X',num2str(increment),'Y0F2000'];
    fprintf(serial_port,command);
    pause(0.1)
    getResponse(serial_port)
end
