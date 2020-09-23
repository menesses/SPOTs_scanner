function MPos = getMPos(serial_port)
% Returns Machine Position (MPos). Works much faster than getWCoMPos.
    fprintf(serial_port,'?\n');
    pause(0.1)
    response = getResponse(serial_port);
    % Parse through response looking for MPos.
    if contains(response,"MPos")
        response = strsplit(response,'<');
        response = response(end);
        response = strsplit(response(contains(response,'>')),'>');
        out = strsplit(response(1),'|');
        pos = strsplit(out(contains(out,"MPos")),':');
        MPos = str2double(strsplit(pos(2),','));
    else
        MPos = NaN;
    end
end
