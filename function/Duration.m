function n1 = Duration(n,x)
time = datetime(n);
fmt = "HH:mm:ss.SSS";
str_time = string(time, fmt);
t1 = duration(str_time);
t2 = duration(24,00,00);
tdiff = t2-t1;
starTime = datetime(x);
d1 = starTime + tdiff;
n1 = second(d1,"secondofday");
end


