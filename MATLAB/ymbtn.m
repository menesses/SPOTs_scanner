function ymbtn(serial_port,increment)
% For use in jog applet
% Button response function for y- movement. Sends command to move stage
% at given increment.
    command = ['G91X0Y-',num2str(increment),'F2000'];
    fprintf(serial_port,command);
    pause(0.1)
    getResponse(serial_port)
end
