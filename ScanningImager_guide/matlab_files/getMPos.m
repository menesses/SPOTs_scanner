function position = getMPos(serial_port)
% Grab Machine Position (MPos)
    fprintf(serial_port,'?\n');
    pause(0.1)
    response = getResponse(serial_port);
    if contains(response,"MPos")
        out = strsplit(response,'|');
        out = out(contains(out,"MPos"));
        mpos = strsplit(out(end),':');
        position = str2double(strsplit(mpos(2),','));
    else
        position = NaN;
    end
    if isequal(position, [0 0 0])
        error('MACHINE NOT HOMED! POSITION UNRELIABLE!')
    end
end
