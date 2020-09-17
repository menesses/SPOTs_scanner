function response = getResponse(serial_port)
% Get any response available from the controller.
    response = "";
    if serial_port.BytesAvailable > 0
        while serial_port.BytesAvailable > 0
            response = response + fscanf(serial_port);
        end
        disp(response)
    end
end
