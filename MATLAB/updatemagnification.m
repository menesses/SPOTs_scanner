function updatemagnification(magnification_field_handle,mag_obj_field,f_obj_dd,f_tube_dd)
% Updates magnification value
magnification_field_handle.Value = mag_obj_field.Value*f_tube_dd.Value/f_obj_dd.Value;

end