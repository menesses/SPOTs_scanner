function stopped = isStopped(serial_port)
% Check position two times and see if we're still moving.
    posA = getMPos(serial_port);
    pause(0.25)
    posB = getMPos(serial_port);
    stopped = isequal(posA,posB);
end
