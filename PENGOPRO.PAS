program rotulos;
uses graph,crt;
const MAX = (8*16*5);
var
   x,y,lar           : array [1..MAX] of integer;
   n,m,a,b,mdx,mdy   : integer;


procedure cuadro (x,y,lar:integer);
begin
     line (x,y,x+lar,y);
     line (x+lar,y,x+lar,y+lar);
     line (x,y+lar,x+lar,y+lar);
     line (x,y,x,y+lar);

end;


procedure texto;

var n:integer;
begin
              for n:=1 to a do
              begin
              setcolor(0);
              cuadro (x[n]-((lar[n]-2) div 2), y[n]-((lar[n]-2) div 2), (lar[n]-2 ));
              setcolor(white);
              cuadro (x[n]-(lar[n] div 2) ,y[n]-(lar[n] div 2) ,(lar[n]) );
              lar[n]:=lar[n]+1;
              if lar[n]>8 then
                           begin
                           setcolor(0);
                           cuadro (x[n]-(lar[n] div 2) ,y[n]-(lar[n] div 2) ,(lar[n]-1) );
                           setcolor(white);
                           lar[n]:=1;
                           end;
              end;
end;

begin
     a:=vga;
     b:=vgahi;
     initgraph (a,b,'');
     mdx:=95;
     mdy:=getmaxy div 2 - 80;
     a:=0;
     setcolor (1);
     outtextxy(1,1,' Pengo');
     outtextxy(1,12,'Island!');
     setcolor(white);
     for n:=1 to 50 do
         begin
         for m:=1 to 10 do
             begin
             if getpixel (n,m)>0 then begin
                                     a:=a+1;
                                     x[a]:=mdx+(8*n);
                                     y[a]:=mdy+(10*m);
                                     lar[a]:=1+(random(7));
                                     putpixel (n,m,black);
                                     end;

         end;
         end;

     for n:=1 to 60 do
         begin
         for m:=12 to 22 do
             begin
             if getpixel (n,m)>0 then begin
                                     for b:=1 to 4 do
                                     begin
                                     setcolor (cyan);
                                     cuadro (mdx+(9*n)-30,mdy+20+(9*m),2*b);
                                     end;
                                     putpixel (n,m,black);
                                     setcolor(white);
                                     end;

         end;
         end;
         outtextxy (150,370,' Copyright 1994 , Amos del Reset Software');

         while not keypressed do texto;
         closegraph;
         restorecrtmode;
 end.






