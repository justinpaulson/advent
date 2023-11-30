z,t,h=[230,283,-107,-57],0,0
0.upto(z[1]) do |i|
  z[2].upto(z[1]) do |j|
    x,y,m,e,f=0,0,0,i,j
    while y>=z[2]&&x<=z[1]
      x+=e
      y+=f
      e=e>0?e-1:e+1 if e!=0
      f-=1
      m=y if y>m
      if x>=z[0]&&x<=z[1]&&y>=z[2]&&y<=z[3]
        h=m if m>h
        t+=1
        break 
      end
    end
  end
end
p h,t