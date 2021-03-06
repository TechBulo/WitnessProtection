[d,sr]=wavread('clar.wav'); 
%e = pvoc(d, 0.8); 
%f = resample(e,4,5); % NB: 0.8 = 4/5 
%soundsc(f,sr)

f = 1024;
h = f/4;
r = 1.5;
c = 0;
rr = r;
rind = 1;
interp = 0;

for b = 0:h:(s-f)
    current_frame = d((b+1):(b+f));             %get the next 1024 frame
    current_frame = wind(current_frame);        %apply hann windowing to the frame
    current_frame = fft(current_frame);         %do the fft
    current_frame = current_frame(1:(1+f/2))';  %take half the fft output
    
    while floor(rr) < c
        rr_frac = rr - floor(rr);
        
        %pvsample code here
        bmag = abs(left_frame) * (1-rr_frac) + rr_frac * abs(current_frame) %interpolate
        dp = angle(current_frame) - angle(left_frame) % calculate phase advance
        dp = dp - 2 * pi * round(dp/(2*pi)); %translate to exponential notation
        ph = ph + dp;   %accumulate
        output(rind) = bmag .* exp(j*ph);
        
        rr = rr + r;
        rind = rind + 1;
        inter = 0;
    end;
    
    if floor(rr) == c
        left_frame = current_frame;
        inter = 1;
    end;
    
    c = c + 1;
end;

output;