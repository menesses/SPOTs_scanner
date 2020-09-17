function waituntilstopped(serial_port)
    while ~isStopped(serial_port)
    end
end
