program rotulos;
uses
    graph,crt;
const
     MAX = (8*16*30);
var
   x,y,ang                    : array [1..MAX] of integer;
   n,m,a,b,mdx,mdy,rad,an,q   : integer;
   seno                       : array [1..500] of real;


procedure iniseno;
begin
     for n:=1 to 500 do seno[n]:=sin(n*pi/180);
end;

procedure cuadro (an:integer);
var a,b: integer;
begin
setcolor (black);
a:=trunc(rad*seno[an+90-(1*q)]);
b:=trunc(2*rad*seno[an-(1*q)]);
line (x[n]+a,y[n]+b,x[n]-a,y[n]-b);

setcolor (white);
a:=trunc(rad*seno[an+90]);
b:=trunc(2*rad*seno[an]);
line (x[n]+a,y[n]+b,x[n]-a,y[n]-b);


end;

begin
     iniseno;
     rad:=4;
     q:=10;
     a:=vga;
     b:=vgahi;
     initgraph (a,b,'');
     mdx:=30;
     mdy:=getmaxy div 2 - 80;
     a:=0;
     outtextxy(1,1,'Game Over');

     for n:=1 to 200 do
         begin
         for m:=1 to 20 do
             begin
             if getpixel (n,m)>1 then begin
                                     a:=a+1;
                                     x[a]:=mdx+(8*n);
                                     y[a]:=mdy+(12*m);
                                     ang[a]:=2*a;
                                     putpixel (n,m,black);
                                     end;

         end;
         end;

         while not keypressed do
         begin
              for n:=1 to a do
              begin
              an:=ang[n];
              cuadro(an);
              ang[n]:=ang[n]+q;
              if ang[n]>190 then
                           begin
                           ang[n]:=ang[n]-180;
                           end;
              end;
 end;
 restorecrtmode;
 end.






