function unlockcontroller(serial_port)
    fprintf(serial_port,'$H\n')
    pause(0.1)
    if check4Alarm(serial_port)
        error('Unlock failed!')
    end
end
