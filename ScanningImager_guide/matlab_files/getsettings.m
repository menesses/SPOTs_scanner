function grblsettings = getsettings(serial_port)
% Get current grbl settings.
fprintf(serial_port,'$$\n');
pause(0.25)
response = strsplit(getResponse(serial_port),'\n');
n = 1;
for i=1:length(response)
    if contains(response(i),'$')
        temp = strsplit(response(i),'=');
        grblsettings.key(n) = temp(1);
        grblsettings.val(n) = double(temp(2));
        n = n + 1;
    end
end
end
