function [WCo,MPos,position] = getWCoMPos(serial_port)
% Returns Working Coordinate (WCo), Machine Position (MPos), and position.
% WCo is returned by controller only every ~1s or so. We thus loop here
% until we have received it. WCo is NOT the actual coordinates to be input
% into GCode commands.
    got_it = false;
    while ~got_it
        fprintf(serial_port,'?\n');
        pause(0.1)
        response = getResponse(serial_port);
		% Parse through response looking for WCO and MPos.
        if contains(response,"WCO")
            response = strsplit(response,'<');
            response = response(end);
            response = strsplit(response(contains(response,'>')),'>');
            out = strsplit(response(1),'|');
            coord = strsplit(out(contains(out,"WCO")),':');
            WCo = str2double(strsplit(coord(2),','));
            pos = strsplit(out(contains(out,"MPos")),':');
            MPos = str2double(strsplit(pos(2),','));
            position = MPos - WCo;
            got_it = true;
        else
            WCo = NaN;
            MPos = NaN;
            position = NaN;
        end
    end
    if isequal(MPos, [0 0 0])
        error('MACHINE NOT HOMED! POSITION UNRELIABLE!')
    end
end
