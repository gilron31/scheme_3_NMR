function [f,Y,figure_pointer] = getFFT(t,y,to_plot)
% [f,Y,plot_pointer] = getFFT(t,y,to_plot) computes the fourier transform
% of y(t) for t with equal time steps (t=min(t):dt:max(t)) to equal
% frequency steps (f=(-1/(2*dt)):(1/(max(t)-min(t))):(1/(2*dt))) and plots
% the absolute value of the transform abs(Y) vs f if requsted

f = (-1/(2*mean(diff(t)))):(1/(max(t)-min(t))):(1/(2*mean(diff(t))));
Y = fftshift(fft(y));

if ( exist('to_plot','var') && to_plot ) || nargout==3
    if exist('to_plot','var') && ishandle(to_plot)
        if strcmp(get(to_plot,'type'),'figure')
            figure(to_plot); figure_pointer = to_plot;
        elseif strcmp(get(to_plot,'type'),'axes')
            axes(to_plot); figure_pointer = gcf;
        else error('if to_plot is a pointer, than it has to be a figure or axes!');
        end
    else figure_pointer = figure;
    end
    plot(f,abs(Y));
end

end