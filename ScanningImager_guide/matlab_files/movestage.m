function movestage(serial_port,x_coord,y_coord,feedrate)
% Use this function to send movement commands. Prevents movements that are
% out of ranget as to avoid alarms and resetting mid-run.
    [wco, mpos, position] = getWCoMPos(serial_port);
    movement = [x_coord y_coord 0] - position;
%     disp(['Movement:', num2str(movement)])
%     disp(['-mpos:',num2str(-mpos)])
%     disp(['movement+mpos:',num2str(movement+mpos)])
%     disp(['wco:',num2str(wco)])
    if sum(movement > -mpos)~=0
        % Prevents movement too far in the positive directions. This is
        % related to the soft-limits in GRBL settings.
        error('Movement out of range!')
    elseif sum(movement+mpos < wco-2) ~= 0
        % Prevents movements too far in the negative directions, which
        % would eventually hit the limit switches. Allows for movements
        % -2mm past the homed position. GRBL settings dictate the standoff
        % from the limit switches. We typically run these at 5mm.
        error('Movement out of range!')
    else
        fprintf(serial_port,['G1X',num2str(x_coord,'%0.4f'),'Y',...
            num2str(y_coord,'%0.4f'),'F',num2str(feedrate)])
    end
end

