program creditos;

uses
    graph,crt;
const
     MAX = 6;
var
   x,y,xold,yold,xfin,yfin : array [1..MAX] of integer;
   letra : array [1..MAX] of char;
   a,b,n,m : integer;
   cursx,cursy : integer;
   texto   : text;

procedure nombre;
var

   se,sp,posx,posxold:array [1..20] of integer;
   n,m:integer;
   mens:string;
   q:real;
   sm:integer;
begin
     mens:='Amos del Reset Soft ';
     for n:=1 to 20 do
     begin
          sp[n]:=-3;
          posx[n]:=(620-(18*(20-n)));
          posxold[n]:=posx[n];
          se[n]:=(n);
     end;
     sm:=0;
     while (sm<100) do
     begin
          q:=q+0.2;
          m:=m+1;
          sm:=sm+1;
          for n:=1 to 20 do
          begin
          posxold[n]:=posx[n];
          posx[n]:=posx[n]+sp[n];
          if (posx[n] < 10) then posx[n]:=getmaxx-12;
          setcolor(Black);
          outtextxy (posxold[n],getmaxy div 2+130 +trunc((cos (se[n]+q-0.2))*20),mens[n]);
          setcolor(white);
          outtextxy (posx[n],getmaxy div 2 +130+trunc((cos (se[n]+q))*20),mens[n]);
          end;
     end;
 nosound;
 end;

begin
     a:=vga;
     b:=vgahi;
     initgraph (a,b,'');
     setcolor(white);
     assign (texto,'creditos.doc');
     reset (texto);

     cursx:=10;
     cursy:=40;

     for n:=1 to MAX do
                    begin
                    read (texto,letra[n]);

                    xfin[n]:=cursx;
                    yfin[n]:=cursy;

                    x[n]:=cursx;
                    cursx:=cursx+10;
                    if cursx>590 then
                                     begin
                                     cursx:=0;
                                     cursy:=cursy+10;
                                     end;
                    y[n]:=yfin[n]+80;
                    xold[n]:=0;
                    yold[n]:=0;
                    if (ord(letra[n]))<32 then begin
                                          letra[n]:=' ';
                                          cursy:=cursy+10;
                                          cursx:=10;
                                          end;
                    end;

     while not keypressed do
           begin
           for n:=1 to MAX do
           if yfin[n]<y[n] then y[n]:=y[n]-2
                           else
                           begin
                           setcolor (0);
                           outtextxy(xold[n],yold[n],letra[n]);
                           setcolor (cyan);
                           outtextxy(xfin[n]+2,yfin[n]+1,letra[n]);
                           setcolor (white);
                           outtextxy(xfin[n],yfin[n],letra[n]);

                           read (texto,letra[n]);

                           xfin[n]:=cursx;
                           yfin[n]:=cursy;

                           x[n]:=cursx;
                           cursx:=cursx+10;
                           if cursx>590 then
                                        begin
                                        cursx:=0;
                                        cursy:=cursy+10;
                                        end;
                           y[n]:=yfin[n]+80;
                           if (ord(letra[n]))<32 then begin
                                                 letra[n]:=' ';
                                                 cursy:=cursy+10;
                                                 cursx:=0;
                                                 end;
                           xold[n]:=0;
                           yold[n]:=0;
                           end;

           setcolor (0);
           outtextxy(xold[n],yold[n],letra[n]);
           setcolor (white);
           outtextxy(x[n],y[n],letra[n]);

           xold[n]:=x[n];
           yold[n]:=y[n];
end;

   nombre;
   restorecrtmode;

end.