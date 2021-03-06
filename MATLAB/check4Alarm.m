function alarm = check4Alarm(serial_port)
% Look for alarm status
    fprintf(serial_port,'?\n');
    pause(0.01)
    response = getResponse(serial_port);
    if contains(response,"Alarm")
        alarm = true;
        error("Alarm triggered!")
    else
        alarm = false;
    end
end
