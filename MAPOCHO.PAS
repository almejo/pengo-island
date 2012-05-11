{$M 65000,0,655360}

{
                                POWERMAPOCHO
                              (Unit  MAP v8.1)

     Novedades de PowerMapocho:

               procedure PonX(x:integer): pone el paisaje en la
               posicion x (x va de 0 a 640)

               procedure LeePaisaje(p,x:integer): lee el nivel p
               y lo pone de inmediato en PonX(x)

               Los monos se pueden usar de fondos

                            "Errare humanum est"

     Cualquier error que le pillen a la unit (yo ya le pill‚ varios) y
     sepan como reproducirlo, es decir, sepan como hacer un programa
     donde sepan cuando, c¢mo y donde se producir  el error, manden un
     mail a KSCHWARZ@ARAUCARIA, CC10A04@ARAUCARIA, publiquen una news
     u otra que se les ocurra. Se aceptan sugerencias de como arreglarlas.

}

{$s-}
{$r-}

unit mapocho;

interface

const
     ESC=chr(27);
     TAB=chr(9);
     SHI='ð';
     SHD='û';
     CON='ò';
     ALT='ó';
     ENT=chr(13);
     F1='ô';
     F2='õ';
     F3='ö';
     F4='÷';
     F5='ø';
     F6='ù';
     F7='ú';
     F8='û';
     F9='ü';
     F10='ý';
     FLARR=' ';
     FLABA='‚';
     FLIZQ='¡';
     FLDER='¢';
     LDA=chr(1);

procedure ponX(x:integer);
procedure niahiconelretrace;
procedure ahiconelretrace;
function sistemaCorrecto:string;
procedure enciendeSistema;
procedure apagaSistema;
procedure modoTexto;
procedure modoGrafico;
procedure ponNumeroMonosActivos(n:integer);
function veNumeroMonosActivos:integer;
procedure sacaMono(n:integer);
procedure ponMonoXY(m,xx,yy:integer);
procedure ponMonoX(m,xx:integer);
procedure ponMonoY(m,yy:integer);
procedure ponMonoForma(m,f:integer);
function veMonoX(m:integer):integer;
function veMonoY(m:integer):integer;
function veMonoForma(m:integer):integer;
procedure leePaisaje(p:integer);
procedure leePaisajex(p,x:integer);
procedure ponFondoXY (f,x,y:integer);
function veFondoXY(x,y:integer):integer;
procedure muevePaisajeIzquierda;
procedure muevePaisajeDerecha;
function posicionPaisaje:integer;
procedure anima;
procedure ponBrillo(b:integer);
procedure aumentaGrises;
procedure disminuyeGrises;
procedure blancoyNegro(b:integer);
procedure cambiaColorRGB(c,r,g,b:integer);
procedure ponColorPixelFondoXY(c:byte;f,x,y:integer);
function veColorPixelFondoXY(f,x,y:integer):byte;
procedure borraTexto;
procedure ponLetraXY(l,x,y:integer);
procedure escribeTextoXY(s:string;x,y:integer);
procedure escribeNumero(n,x,y:integer);
procedure leeMusica (a:string);
procedure enciendeMusica;
procedure apagaMusica;
function leeTecla:char;
procedure sonido(f,d:integer);
implementation

uses dos,crt;

const

     do2=262;
     dosos2=277;
     re2=294;
     resos2=311;
     mi2=330;
     fasos2=370;
     fa2=349;
     sol2=392;
     solsos2=415;
     la2=440;
     lasos2=466;
     si2=494;
     do1=262 div 2;
     dosos1=277 div 2;
     re1=294 div 2;
     resos1=311 div 2;
     mi1=330 div 2;
     fasos1=370 div 2;
     fa1=349 div 2;
     sol1=392 div 2;
     solsos1=415 div 2;
     la1=440 div 2;
     lasos1=466 div 2;
     si1=494 div 2;
     do3=262*2;
     dosos3=277*2;
     re3=294*2;
     resos3=311*2;
     mi3=330*2;
     fasos3=370*2;
     fa3=349*2;
     sol3=392*2;
     solsos3=415*2;
     la3=440*2;
     lasos3=466*2;
     si3=494*2;

     largoPagina=14380;

     seekgraf=0;
     seekpais=33792;
     seekindi=46992;

     memtext=0;
     mempag1=1920;
     mempag2=16300;
     memspri=30680;
     memfond=60120;
     memletr=62680;

     percu=5000;
     largomusica=7000;

type

    arrindice=array [0..29599] of byte;

    tMono=record
               x,y:integer;
               forma:integer;
               exx,exy:integer;
    end;

var
   paisaje:array [0..10,0..59] of byte;
   stackfondos:array [0..3000] of integer;
   tope:integer;
   pescaretrace:boolean;
   colasonido:array [1..10,1..2] of integer;
   topesonido:integer;
   actualsonido:integer;

   f:file;

   INT1CVIEJA: pointer;
   SALIDA1C  : pointer;

   indice:^arrIndice;
   indice2:^arrIndice;
   indice3:^arrIndice;
   indice4:^arrIndice;

   pDos:array [0..7] of integer;
   pDoss:array [0..3] of integer;

   pag,paginaescritura:integer;

   mono:array [1..50] of tMono;

   monosActivos:integer;

   exaddressreg,addressreg:word;
   exhorfino,horfino:integer;
   exposx,posx:word;

   p1,p2,p3,p4,p5,p6,p7,p8:integer;

   muevepantallaizq,muevepantallader:boolean;

   grises:integer;

   musica:array [1..largomusica] of integer;
   indi:integer;
   exnota:integer;
   musicaInstalada:boolean;
   largoCancion:integer;

procedure desencriptaPercusion(s:string);
var par,i,k,i2,i3:integer;
var j:string;
begin
     i:=1;
     repeat
           if (s[i]='x') or (s[i]='o') then begin
              if s[i]='x' then

              musica[indi*2]:=percu;


              indi:=indi+1;
              i:=i+1;
           end else begin
               j:='';
               while s[i]<>'(' do begin
                     j:=j+s[i];
                     i:=i+1;
               end;
               val(j,k,i2);
               i2:=i;
               par:=1;
               while (par>0) do begin
                     i2:=i2+1;
                     if s[i2]='(' then par:=par+1;
                     if s[i2]=')' then par:=par-1;
               end;
               i2:=i2+1;
               for i3:=1 to k do
                   desencriptapercusion(copy(s,i+1,i2-i-2));
               i:=i2;
           end;
     until i>length(s);
end;



procedure interMusica; interrupt;
var nota:integer;
begin
     Inline(
            $9C/
            $FF/$1E/>INT1CVIEJA);
     nota:=musica[indi];
     indi:=indi+1;
     if indi=largoCancion then indi:=1;
     if colasonido[actualsonido,2]>0 then begin
        nota:=colasonido[actualsonido,1];
        dec(colasonido[actualsonido,2]);
        if colasonido[actualsonido,2]=0 then begin
           actualsonido:=actualsonido+1;
           if actualsonido=11 then actualsonido:=1;
        end;
     end;
     if nota=0 then begin
        Port[$61] := Port[$61] and $F8;
        exnota:=nota;
     end
     else
     begin
          if exnota<>nota then begin
             Port[$43] := $F6;
             Port[$42] := Lo(nota);
             Port[$42] := Hi(nota);
             Port[$61] := Port[$61] or $03;
             exnota:=nota;
          end;
     end;
end;






function max(a,b:integer):integer;
begin
     if a>b then max:=a else max:=b;
end;



procedure bitplane (p:integer);
begin
     port[$3c4]:=2;
     port[$3c5]:=p;
end;



procedure writemode1;assembler;
asm
     MOV DX,3CEh
     MOV AX,4105h
     OUT DX,AX
end;



procedure writemode0;assembler;
asm
     MOV DX,3CEh
     MOV AX,4005h
     OUT DX,AX
end;



procedure brillo(b:integer);
var
   x,y,z,c:integer;
   paleta:array [0..767] of byte;
begin
     c:=0;
     for x:=0 to 5 do
         for y:=0 to 5 do
             for z:=0 to 5 do begin
                 paleta[c]:=18+x*9;
                 paleta[c+1]:=18+y*9;
		 paleta[c+2]:=18+z*9;
		 c:=c+3;
	     end;

	paleta[0]:=0;
        paleta[1]:=0;
        paleta[2]:=0;

        for x:=3 to 767 do
            if paleta[x]+b<64 then
               paleta[x]:=paleta[x]+b
            else
                paleta[x]:=63;

        port[$3c8]:=216;
        for x:=0 to 24 do begin
            port[$3c9]:=trunc(x*2.7);
            port[$3c9]:=trunc(x*2.7);
            port[$3c9]:=trunc(x*2.7);
        end;

	port[$3c8]:=0;
	for x:=0 to 216*3 do
            port[$3c9]:=paleta[x];
end;



PROCEDURE modoX;assembler;
ASM
    mov ax,0013h            { modo vga estandar }
    int 10h
    mov dx,03c4h            { secuenciador ? }
    mov al,04
    out dx,al
    inc dx
    in  al,dx
    and al,0F7h
    or  al,04
    out dx,al
    mov dx,03c4h
    mov al,02
    out dx,al
    inc dx
    mov al,0Fh
    out dx,al
    mov ax,0a000h         { comienzo pagina ? }
    mov ES,ax
    sub di,di
    mov ax,di
    mov dx,$3d4
    mov al,14h
    out dx,al
    inc dx
    in  al,dx
    and al,0BFh
    out dx,al
    dec dx
    mov al,17h
    out dx,al
    inc dx
    in  al,dx
    or  al,40h
    out dx,al
END;

procedure outreg(por:integer;index,value:byte);
var x:integer;
begin
     if (por=$3C0) then begin
        x:=port[$3da];
        port[$3c0]:=index or 32;
        port[$3c0]:=value;
      end else begin
          port[por]:=index;
          port[por+1]:=value;
      end;
end;


procedure split;
var
   x:integer;
begin
     outreg($3d4,$11,34);
     outreg($3d4,$18,95);
     outreg($3d4,$07,31);
     outreg($3d4,$09,1);
     outreg($3c0,$10,1+32+64);
end;


procedure leeFondos;
var
   fondos:array [0..40*256-1] of byte;
   c,x,y:word;
begin
     assign (f,'mapocho.sis');
     reset (f,1);
     blockread (f,fondos,40*256);
     close (f);
     for c:=0 to 39 do
         for x:=0 to 15 do begin
	     bitplane (pDos[x mod 4]);
	     for y:=0 to 15 do
                 mem[$a000:memfond+c*64+y*4+x div 4]:=fondos[c*256+y*16+x];
         end;
end;



procedure leepaisajee;
begin
     assign (f,'mapocho.sis');
     reset (f,1);
     seek (f,33792);
     blockread (f,paisaje,60*11);
     close (f);
end;



procedure leeMonos;
var
   c,x,y,z:word;
   xaux:byte;
   s:array [0..23551] of byte;
begin
     assign (f,'mapocho.sis');
     reset (f,1);
     seek (f,40*256);
     blockread (f,s,92*256);
     seek (f,seekindi);
     blockread (f,indice^,27600);
     blockread (f,indice2^,27600);
     blockread (f,indice3^,27600);
     blockread (f,indice4^,27600);
     close (f);

     for z:=0 to 3 do
        for c:=0 to 91 do
            for x:=0 to 15 do begin
                xaux:=x+z;
	        bitplane (pDos[xaux mod 4]);
		   for y:=0 to 15 do
                       mem[$a000:memspri+(c+z*92)*80+y*5+xaux div 4]:=
                          s[c*256+y*16+x];
            end;
end;


function no3(x:integer):integer;
begin
     if x=3 then no3:=2 else no3:=x;
end;

procedure leeLetras;
var
   p11,p21:word;
   r:registers;
   k,z,x,y:integer;
begin
  with r do begin
       ax:=$1130;
       bh:=$03;
       intr($10,r);
       p11:=es;
       p21:=bp;
  end;
  writemode0;
  for x:=0 to 3 do begin
      bitplane(pdos[x]);
      for y:=32 to 32+177 do begin
          for z:=0 to 7 do begin
              k:=mem[p11:p21+y*8+z] div 16 and pdos[3-x];
              if k<>0 then k:=36*no3((z mod 5)+1) else k:=3*43;
              mem[$a000:memletr+(y-32)*16+z*2]:=k;
              k:=mem[p11:p21+y*8+z] and pdos[3-x];
              if k<>0 then k:=36*no3((z mod 5)+1) else k:=3*43;
              mem[$a000:memletr+(y-32)*16+z*2+1]:=k;
          end;
      end;
  end;
end;

procedure ponMono2 (n,hpos,vpos:integer);
var
   h:integer;
   desde,ptrpixel,indiceh,indicel,limitsup,limitinf:word;
   flag,cinco,bitp:byte;
   ander:array[0..4] of byte;
begin

     if hpos<0 then
        n:=n+92*((4+hpos mod 4) mod 4)
     else
         n:=n+92*(hpos mod 4);

     cinco:=5;
     flag:=0;
     bitp:=15;

     ander[0]:=15;
     ander[1]:=15;
     ander[2]:=15;
     ander[3]:=15;
     ander[4]:=15;

     h:=hpos div 4-posx div 4;

     if h<1 then begin
        if h=-4 then begin
           ander[0]:=0;
           ander[1]:=0;
           ander[2]:=0;
           ander[3]:=0;
           ander[4]:=pdoss[posx mod 4];
        end else
        if h=-3 then begin
           ander[0]:=0;
           ander[1]:=0;
           ander[2]:=0;
           ander[3]:=pdoss[posx mod 4];
        end else
        if h=-2 then begin
           ander[0]:=0;
           ander[1]:=0;
           ander[2]:=pdoss[posx mod 4];
        end else
        if h=-1 then begin
           ander[0]:=0;
           ander[1]:=pdoss[posx mod 4];
        end else
        if h=-0 then
           ander[0]:=pdoss[posx mod 4];
     end;

     if h>75 then begin
        if h=76 then
           ander[4]:=pdos[posx mod 4]-1
        else
        if h=77 then begin
           ander[4]:=0;
           ander[3]:=pdos[posx mod 4]-1;
        end else
        if h=78 then begin
           ander[4]:=0;
           ander[3]:=0;
           ander[2]:=pdos[posx mod 4]-1;
        end else
        if h=79 then begin
           ander[4]:=0;
           ander[3]:=0;
           ander[2]:=0;
           ander[1]:=pdos[posx mod 4]-1;
        end else
        if h=80 then begin
           ander[4]:=0;
           ander[3]:=0;
           ander[2]:=0;
           ander[1]:=0;
           ander[0]:=pdos[posx mod 4]-1;
        end;
     end;

     ptrpixel:=addressreg+h+largopagina*paginaescritura+vpos*80+mempag1;
     bitp:=15;
     desde:=memspri+word(80*n);
     if (n<92) then begin
        indiceh:=seg(indice^[n*300]);
        indicel:=ofs(indice^[n*300]);
     end else
     if (n<183) then begin
        indiceh:=seg(indice2^[(n-92)*300]);
        indicel:=ofs(indice2^[(n-92)*300]);
     end else
     if (n<275) then begin
        indiceh:=seg(indice3^[(n-184)*300]);
        indicel:=ofs(indice3^[(n-184)*300]);
     end else begin
        indiceh:=seg(indice4^[(n-276)*300]);
        indicel:=ofs(indice4^[(n-276)*300]);
     end;

     limitsup:=addressreg+largopagina*paginaescritura+80+mempag1;
     limitinf:=limitsup+175*80; {175}

     writemode1;

     asm
        push ds
	mov bx,desde
	mov si,ptrpixel
	mov ax,indiceh
	mov es,ax
	mov ds,ax
	mov di,indicel
@L2:
        mov ax,es
	mov ds,ax
	mov cl,byte ptr [di]
	cmp cl,0
	jnz @L2b
	inc di
	dec byte ptr bitp
	jne @L2
	pop ds
	jmp @L5
@L2b:
        mov ch,0
	inc di
	mov dx,03c4h
	mov ah,byte ptr bitp
	mov al,2
	out dx,ax
	mov dx,0a000h
@L1:
        mov ax,es
	mov ds,ax
	mov ch,byte ptr [di]
	add bl,ch
	adc bh,0
	push bx
	mov ax,bx
	sub ax,desde
	div byte ptr cinco
	lea bx,byte ptr ander
	add bl,ah
	adc bh,0
	mov ah,ss:[bx]
	cmp ah,15h
	je @L1c
	and ah,bitp
	mov dx,03c4h
	mov al,2
	out dx,ax
	pop bx
	mov dx,0a000h
	mov flag,01h
@L1c:
        inc di
	add si,word ptr [di]
	add di,2
	mov ds,dx
	mov al,byte ptr [bx]
	cmp word ptr limitsup,si
	ja @L1b
	cmp si,word ptr limitinf
	jae @L1b
	mov [si],al
@L1b:
        sub bl,ch
	sbb bh,0
	cmp flag,01h
	jne @L1d
	mov flag,00h
	mov dx,03c4h
	mov ah,byte ptr bitp
	mov al,2
	out dx,ax
	mov dx,0a000h
@L1d:
        mov ch,0
	loop @L1
	dec byte ptr bitp
	je @L1e
	jmp @L2
@L1e:
        pop ds
@L5:
        end;
        writemode1;
	bitplane (15);
end;

procedure ponMono (n,hpos,vpos:integer);
var
   desde,ptrpixel,indiceh,indicel:word;
   bitp:byte;
   h:integer;
begin
     h:=hpos div 4 - posx div 4;

     if (h<-4) or (h>80) then exit;

     if (h<1) or (h>75) or (vpos<0) or (vpos>169) then begin
	     ponMono2(n,hpos,vpos);
	     exit;
     end;

     n:=n+92*(hpos mod 4);

     ptrpixel:=addressreg+h+largopagina*paginaescritura+vpos*80+mempag1;
     bitp:=15;
     desde:=memspri+word(80*n);
     if (n<92) then begin
        indiceh:=seg(indice^[n*300]);
        indicel:=ofs(indice^[n*300]);
     end else
     if (n<183) then begin
        indiceh:=seg(indice2^[(n-92)*300]);
        indicel:=ofs(indice2^[(n-92)*300]);
     end else
     if (n<275) then begin
        indiceh:=seg(indice3^[(n-184)*300]);
        indicel:=ofs(indice3^[(n-184)*300]);
     end else begin
        indiceh:=seg(indice4^[(n-276)*300]);
        indicel:=ofs(indice4^[(n-276)*300]);
     end;
     writemode1;

asm
     push ds
     mov bx,desde
     mov si,ptrpixel
     mov ax,indiceh
     mov es,ax
     mov ds,ax
     mov di,indicel
@L2:
     mov ax,es
     mov ds,ax
     mov cl,byte ptr [di]
     cmp cl,0
     jnz @L2b
     inc di
     dec byte ptr bitp
     jne @L2
     pop ds
     jmp @L5
@L2b:
     mov ch,0
     inc di
     mov dx,03c4h
     mov ah,byte ptr bitp
     mov al,2
     out dx,ax
     mov dx,0a000h
@L1:
     mov ax,es
     mov ds,ax
     mov ch,byte ptr [di]
     add bl,ch
     adc bh,0
     inc di
     add si,word ptr [di]
     add di,2
     mov ds,dx
     mov al,byte ptr [bx]
     mov [si],al
     sub bl,ch
     sbb bh,0
     mov ch,0
     loop @L1
     dec byte ptr bitp
     je @L1e
     jmp @L2
@L1e:
     pop ds

@L5:
     end;

     writemode1;
     bitplane (15);
end;

procedure  ponfondo2 (hpos,vpos:integer);
var
   yr,h,total,totalx,px,py,n:integer;
   ptrpixel,desde:word;
   limitsup,limitinf:word;
   ander0,ander1,ander2,ander3:byte;
   dieciseis:word;
begin
     dieciseis:=16;
     px:=hpos*16;
     py:=vpos*16;

     ander1:=15;
     ander0:=15;
     ander2:=15;
     ander3:=15;

     limitsup:=addressreg+largopagina*paginaescritura+mempag1;
     limitinf:=limitsup+176*80;

     n:=paisaje[vpos,hpos];
     h:=px div 4-posx div 4;

     ptrpixel:=addressreg+py*80+h+largopagina*paginaescritura+mempag1;

        desde:=memfond+64*n;

        writemode1;

        if h<1 then begin
           if h=-3 then begin
              ander0:=0;
              ander1:=0;
              ander2:=0;
              ander3:=pdoss[posx mod 4];
           end else
           if h=-2 then begin
              ander0:=0;
              ander1:=0;
              ander2:=pdoss[posx mod 4];
           end else
           if h=-1 then begin
              ander0:=0;
	      ander1:=pdoss[posx mod 4];
	   end else
           if h=0 then
              ander0:=pdoss[posx mod 4];
        end;

        if h>76 then begin
           if h=77 then
              ander3:=pdos[posx mod 4]-1 else
           if h=78 then begin
              ander2:=pdos[posx mod 4]-1;
	      ander3:=0;
           end else
           if h=79 then begin
              ander1:=pdos[posx mod 4]-1;
	      ander3:=0;
              ander2:=0;
           end else
           if h=80 then begin
	      ander0:=pdos[posx mod 4]-1;
	      ander3:=0;
              ander2:=0;
              ander1:=0;
	   end;
        end;

        if n<40 then begin

        asm
	   push ds;
	   mov ax,0a000h
	   mov ds,ax
	   mov es,ax
	   mov di,ptrpixel
	   mov si,desde
	   mov cx,16
	   mov dx,03c4h
	   mov al,2
	   mov ah,ander0
	   out dx,ax
	   mov cx,word ptr dieciseis
	   cld
   @L5:
	   cmp word ptr limitsup,di
	   ja @L5b
	   cmp di,word ptr limitinf
	   jae @L5b
	   movsb
	   jmp @L5c
   @L5b:
	   inc si
	   inc di
   @L5c:
	   add di,79
	   add si,3
	   loop @L5
	   sub si,63
	   sub di,1279
	   mov ah,ander1
	   out dx,ax
	   mov cx,word ptr dieciseis
   @L6:
	   cmp word ptr limitsup,di
	   ja @L6b
	   cmp di,word ptr limitinf
	   jae @L6b
	   movsb
	   jmp @L6c
   @L6b:
	   inc si
	   inc di
   @L6c:
	   add di,79
	   add si,3
	   loop @L6
	   sub si,63
	   sub di,1279
	   mov ah,ander2
	   out dx,ax
	   mov cx,word ptr dieciseis
   @L7:
	   cmp word ptr limitsup,di
	   ja @L7b
	   cmp di,word ptr limitinf
	   jae @L7b
	   movsb
           jmp @L7c
   @L7b:
	   inc si
	   inc di
   @L7c:
	   add di,79
	   add si,3
	   loop @L7
	   sub si,63
	   sub di,1279
	   mov ah,ander3
	   out dx,ax
	   mov cx,word ptr dieciseis
   @L8:
	   cmp word ptr limitsup,di
	   ja @L8b
	   cmp di,word ptr limitinf
	   jae @L8b
	   movsb
	   jmp @L8c
   @L8b:
	   inc si
	   inc di
   @L8c:
	   add di,79
	   add si,3
	   loop @L8
	   pop ds;
      end;
      end else begin
      desde:=memspri+(n-40)*80;
         asm
	   push ds;
	   mov ax,0a000h
	   mov ds,ax
	   mov es,ax
	   mov di,ptrpixel
	   mov si,desde
	   mov cx,16
	   mov dx,03c4h
	   mov al,2
	   mov ah,ander0
	   out dx,ax
	   mov cx,word ptr dieciseis
	   cld
   @L5:
	   cmp word ptr limitsup,di
	   ja @L5b
	   cmp di,word ptr limitinf
	   jae @L5b
	   movsb
	   jmp @L5c
   @L5b:
	   inc si
	   inc di
   @L5c:
	   add di,79
	   add si,4
	   loop @L5
	   sub si,79
	   sub di,1279
	   mov ah,ander1
	   out dx,ax
	   mov cx,word ptr dieciseis
   @L6:
	   cmp word ptr limitsup,di
	   ja @L6b
	   cmp di,word ptr limitinf
	   jae @L6b
	   movsb
	   jmp @L6c
   @L6b:
	   inc si
	   inc di
   @L6c:
	   add di,79
	   add si,4
	   loop @L6
	   sub si,79
	   sub di,1279
	   mov ah,ander2
	   out dx,ax
	   mov cx,word ptr dieciseis
   @L7:
	   cmp word ptr limitsup,di
	   ja @L7b
	   cmp di,word ptr limitinf
	   jae @L7b
	   movsb
           jmp @L7c
   @L7b:
	   inc si
	   inc di
   @L7c:
	   add di,79
	   add si,4
	   loop @L7
	   sub si,79
	   sub di,1279
	   mov ah,ander3
	   out dx,ax
	   mov cx,word ptr dieciseis
   @L8:
	   cmp word ptr limitsup,di
	   ja @L8b
	   cmp di,word ptr limitinf
	   jae @L8b
	   movsb
	   jmp @L8c
   @L8b:
	   inc si
	   inc di
   @L8c:
	   add di,79
	   add si,4
	   loop @L8
	   pop ds;
      end;
      end;
end;


procedure ponfondo (hpos,vpos:integer);
var
	h,total,totalx,px,py,n:integer;
	ptrpixel,desde:word;
begin
     px:=hpos*16;
     py:=vpos*16;

     if (hpos>59) or (hpos<0) or (vpos<0) or (vpos>10) then exit;

     n:=paisaje[vpos,hpos];
     h:=px div 4-posx div 4;

     ptrpixel:=addressreg+py*80+h+largopagina*paginaescritura+mempag1;
     if n<40 then
        desde:=memfond+64*n
     else
         desde:=memspri+word(80*(n-40));

     writemode1;

     if not((h<81) and (h>-4) and (py>-15) and (py<176)) then exit;

     if (h<1) or (h>76) or (py<0) or (py>160) then begin
        ponfondo2(hpos,vpos);
        exit;
     end;

     if (n>40) then
     asm
         push ds;
	 mov ax,0a000h
	 mov ds,ax
	 mov es,ax
	 mov di,ptrpixel
	 mov si,desde
	 mov cx,16
	 mov dx,03c4h
	 mov al,2
	 mov ah,15
	 out dx,ax
	 cld
     @L5:
         movsb
	 movsb
	 movsb
	 movsb
	 add di,76
         inc si
	 loop @L5
	 pop ds;
     end
     else
     asm
         push ds;
	 mov ax,0a000h
	 mov ds,ax
	 mov es,ax
	 mov di,ptrpixel
	 mov si,desde
	 mov cx,16
	 mov dx,03c4h
	 mov al,2
	 mov ah,15
	 out dx,ax
	 cld
     @L5:
         movsb
	 movsb
	 movsb
	 movsb
	 add di,76
	 loop @L5
	 pop ds;
     end;
end;



procedure dibujaPaisaje;
var
   x,y:integer;
   r:byte;
begin
     for y:=10 downto 0 do
         for x:=59 downto 0 do begin
            paginaescritura:=0;
            ponfondo(x,y);
            paginaescritura:=1;
             ponfondo(x,y);
         end;
end;



procedure borraMono(x,y:integer);
begin
     ponFondo(x div 16,1+y div 16);
     ponFondo(x div 16,y div 16);
     ponFondo(1+x div 16,1+y div 16);
     ponFondo(1+x div 16,y div 16);
end;

procedure ponpaginaypausa(p:integer);
var
   al,h,l:byte;
   f:integer;
begin
     f:=-horFino*2;
     h:=(addressreg+p*largoPagina+mempag1) div 256;
     l:=(addressreg+p*largoPagina+mempag1) mod 256;

     repeat
           al:=port[$3da];
           al:=al and 1;
     until al=0;

     port[$3d4]:=$c;
     port[$3d5]:=h;

     port[$3d4]:=$d;
     port[$3d5]:=l;

     l:=port[$03DA];
     port[$3C0]:=51;
     port[$3C0]:=f;

     if pescaretrace then
     repeat
           al:=port[$3da];
           al:=al and 8;
     until al<>0;

     repeat
           al:=port[$3da];
           al:=al and 8;
     until al<>0;
     repeat
           al:=port[$3da];
           al:=al and 8;
     until al<>0;
end;



procedure scrollIzq;
begin
     inc(posx);
     dec(horFino);
     if horFino=-4 then begin
        inc(addressreg);
        horFino:=0;
     end;
end;



procedure scrollDer;
begin
     dec(posx);
     inc(horFino);
     if horFino=1 then begin
        horFino:=-3;
	if addressreg>0 then
           dec(addressreg);
     end;
end;

procedure dibujalineaizq;
var
	ptrfondos,basefondos,ptrpixel:word;
        y:integer;
begin
     ptrpixel:=addressreg+largopagina*paginaescritura+mempag1;
     bitplane(pdos[posx mod 4]);
     writemode1;

     for y:=0 to 10 do begin
         basefondos:=memfond+(posx mod 16) div 4;
         if paisaje[y,posx div 16]<40 then begin
            ptrfondos:=basefondos+paisaje[y,posx div 16]*64;
            asm
            push ds
            mov ax,0a000h
            mov es,ax
            mov ds,ax
            mov di,ptrpixel
            mov si,ptrfondos
            mov cx,16
            mov bx,3
            mov dx,79
            @L:
            movsb
            add di,dx
            add si,bx
            loop @L
            pop ds
         end; end
         else begin
             ptrfondos:=memspri+(posx mod 16) div 4+(paisaje[y,
                posx div 16]-40)*80;

         asm
            push ds
            mov ax,0a000h
            mov es,ax
            mov ds,ax
            mov di,ptrpixel
            mov si,ptrfondos
            mov cx,16
            mov bx,4
            mov dx,79
         @L:
            movsb
            add di,dx
            add si,bx
            loop @L
            pop ds
         end;
         end;
         ptrpixel:=ptrpixel+80*16;
     end;
end;


procedure dibujalineader;
var
   ptrfondos,basefondos,ptrpixel:word;
   y,nposx:integer;
begin
     nposx:=posx;

     if posx mod 4=0 then
        ptrpixel:=addressreg+79+largopagina*paginaescritura+mempag1
     else
         ptrpixel:=addressreg+80+largopagina*paginaescritura+mempag1;

     if posx mod 4=0 then
        bitplane (8)
     else
         bitplane(pdos[(posx mod 4)-1]);

     posx:=posx+319;
     writemode1;

     for y:=0 to 10 do begin
     if paisaje[y,posx div 16]<40 then begin
         basefondos:=memfond+(posx mod 16) div 4;
         ptrfondos:=basefondos+paisaje[y,posx div 16]*64;
         asm
            push ds
            mov ax,0a000h
            mov es,ax
            mov ds,ax
            mov di,ptrpixel
            mov si,ptrfondos
            mov cx,16
            mov bx,3
            mov dx,79
         @L:
            movsb
            add di,dx
            add si,bx
            loop @L
            pop ds
         end;
     end else
     begin
         basefondos:=memspri+(posx mod 16) div 4;
         ptrfondos:=basefondos+(paisaje[y,posx div 16]-40)*80;
         asm
            push ds
            mov ax,0a000h
            mov es,ax
            mov ds,ax
            mov di,ptrpixel
            mov si,ptrfondos
            mov cx,16
            mov bx,4
            mov dx,79
         @L:
            movsb
            add di,dx
            add si,bx
            loop @L
            pop ds
         end;
     end;
         ptrpixel:=ptrpixel+80*16;
     end;
     posx:=nposx;
end;



{
        *
        *
        *
        *       Publico
        *
        *
        *
}



function sistemaCorrecto:string;
var s:string;
begin
     s:='todo bien';
     {$i-}
     assign (f,'mapocho.sis');
     reset (f);
     {$i+}
     if ioresult<>0 then s:='falta archivo mapocho.sis';
     if memavail<150000 then s:='falta memoria';
     sistemaCorrecto:=s;
end;



procedure enciendeSistema;
begin
     pDos[0]:=1;
     pDos[1]:=2;
     pDos[2]:=4;
     pDos[3]:=8;
     pDos[4]:=16;
     pDos[5]:=32;
     pDos[6]:=64;
     pDos[7]:=128;
     pDoss[0]:=15;
     pDoss[1]:=14;
     pDoss[2]:=12;
     pDoss[3]:=8;

     pag:=0;
     paginaescritura:=0;
     addressreg:=0;
     posx:=0;
     exposx:=0;
     exhorfino:=0;
     exaddressreg:=0;
     horFino:=0;


     new (indice);
     new (indice2);
     new (indice3);
     new (indice4);
     modoX;
     brillo(0);
     bitplane (15);
     fillchar (mem[$a000:0000],64000,0);
     split;
     leeFondos;
     leeMonos;
     borraTexto;
     leepaisajee;
     dibujaPaisaje;
     ponpaginaypausa(0);
     monosActivos:=0;
     grises:=0;
     leeLetras;
     musicaInstalada:=false;
end;



procedure apagaSistema;
begin
     textmode(lastmode);
     dispose (indice);
     dispose (indice2);
     dispose (indice3);
     dispose (indice4);
     if musicaInstalada then apagaMusica;
end;



procedure modoTexto;
var x:integer;
begin
     x:=lastmode;
     textMode(lastmode);
     lastmode:=x;
end;



procedure modoGrafico;
var x,y:integer;
begin
     modoX;
     brillo(0);
     dibujaPaisaje;
     anima;
     anima;
end;



procedure ponNumeroMonosActivos(n:integer);
var x:integer;
begin
     monosActivos:=n;
     for x:=1 to n do with mono[x] do begin
         x:=1000;
         exx:=1000;
         y:=1000;
         exy:=1000;
         forma:=0;
     end;
end;



function veNumeroMonosActivos:integer;
begin
     veNumeroMonosActivos:=monosActivos;
end;



procedure sacaMono(n:integer);
begin
     with mono[n] do begin
          x:=1000;
     end;
end;



procedure ponMonoXY(m,xx,yy:integer);
begin
     with mono[m] do begin
          x:=xx;
          y:=yy;
     end;
end;



procedure ponMonoX(m,xx:integer);
begin
     with mono[m] do
          x:=xx;
end;



procedure ponMonoY(m,yy:integer);
begin
     with mono[m] do
          y:=yy;
end;



procedure ponMonoForma(m,f:integer);
begin
     with mono[m] do
          forma:=f;
end;



function veMonoX(m:integer):integer;
begin
     veMonoX:=mono[m].x;
end;



function veMonoY(m:integer):integer;
begin
     veMonoY:=mono[m].y;
end;



function veMonoForma(m:integer):integer;
begin
     veMonoForma:=mono[m].Forma;
end;

procedure ponX(x:integer);
begin
     while posX<x do scrollizq;
     while posX>x do scrollder;
     exposx:=posx;
     exaddressreg:=addressreg;
     exhorfino:=horfino;
     dibujapaisaje;
     anima;
     anima;
end;



procedure leePaisaje(p:integer);
begin
     assign (f,'mapocho.sis');
     reset (f,1);
     seek (f,33792+(p-1)*60*11);
     blockread (f,paisaje,60*11);
     close (f);
     dibujapaisaje;
end;



procedure leePaisajex(p,x:integer);
begin
     assign (f,'mapocho.sis');
     reset (f,1);
     seek (f,33792+(p-1)*60*11);
     blockread (f,paisaje,60*11);
     close (f);
     ponX(x);
end;



procedure ponFondoXY (f,x,y:integer);
begin
     stackFondos [tope]:=f;
     stackFondos [tope+1]:=x;
     stackFondos [tope+2]:=y;
     tope:=tope+3;
end;



function veFondoXY(x,y:integer):integer;
begin
     veFondoXY:=paisaje[y,x];
end;



procedure muevePaisajeIzquierda;
begin
     if posx<640 then begin
        muevepantallaizq:=true;
        muevepantallader:=false;
     end;
end;



procedure muevePaisajeDerecha;
begin
     if posx>0 then begin
        muevepantallader:=true;
        muevepantallaizq:=false;
     end;
end;



function posicionPaisaje:integer;
begin
     posicionPaisaje:=posx;
end;



procedure anima;
var
   i:integer;
begin
   if pag=0 then paginaescritura:=1 else
      paginaescritura:=0;

   if muevepantallaizq then scrollizq;
   if muevepantallader then scrollder;

   if tope>0 then
      for i:=1 to tope div 3 do begin
          paisaje[stackfondos[i*3-1],stackfondos[i*3-2]]:=
                  stackfondos[i*3-3];
          ponFondo(stackfondos[i*3-2],stackfondos[i*3-1]);
      end;

   for i:=1 to monosActivos do
       with mono[i] do
            ponMono(forma,x,y);

   ponpaginaypausa (paginaescritura);

   p1:=posx;
   p2:=addressreg;
   p3:=horFino;

   posx:=exposx;
   addressreg:=exaddressreg;
   horfino:=exhorfino;

   paginaescritura:=pag;

   if tope>0 then
      for i:=1 to tope div 3 do begin
          paisaje[stackfondos[i*3-1],stackfondos[i*3-2]]:=
                  stackfondos[i*3-3];
          ponFondo(stackfondos[i*3-2],stackfondos[i*3-1]);
      end;

   tope:=0;

   for i:=1 to monosActivos do begin
       with mono[i] do begin
            borraMono(exx,exy);
            exx:=x;
            exy:=y;
       end;
   end;

   exhorfino:=p3;
   horfino:=p3;
   exaddressreg:=p2;
   addressreg:=p2;

   exposx:=p1;
   posx:=p1;

   if muevepantallader then begin
      p1:=paginaescritura;
      paginaescritura:=0;
      dibujalineaizq;
      paginaescritura:=1;
      dibujalineaizq;
      paginaescritura:=p1;
   end;

   if muevepantallaizq then begin
      p1:=paginaescritura;
      paginaescritura:=0;
      dibujalineader;
      paginaescritura:=1;
      dibujalineader;
      paginaescritura:=p1;
   end;

   muevepantallaizq:=false;
   muevepantallader:=false;

   if pag=0 then pag:=1 else pag:=0;
end;



procedure ponBrillo(b:integer);
begin
     brillo(b);
end;


procedure aumentaGrises;
var x:integer;
begin
     inc (grises);
     port[$3c8]:=216;
     for x:=0 to 23 do begin
         port[$3c9]:=trunc(x*2.7)+grises;
         port[$3c9]:=trunc(x*2.7)+grises;
         port[$3c9]:=trunc(x*2.7)+grises;
     end;
end;



procedure disminuyeGrises;
var x:integer;
begin
     dec (grises);
     port[$3c8]:=216;
     for x:=0 to 23 do begin
         port[$3c9]:=trunc(x*2.7)+grises;
         port[$3c9]:=trunc(x*2.7)+grises;
         port[$3c9]:=trunc(x*2.7)+grises;
     end;
end;



procedure blancoyNegro(b:integer);
var
   x,y,z,c:integer;
   paleta:array [0..767] of byte;
begin
     c:=0;
     for x:=0 to 5 do
         for y:=0 to 5 do
             for z:=0 to 5 do begin
                 paleta[c]:=18+max(x,max(y,z))*9;
                 paleta[c+1]:=18+max(x,max(y,z))*9;
		 paleta[c+2]:=18+max(x,max(y,z))*9;
		 c:=c+3;
	     end;

	paleta[0]:=0;
        paleta[1]:=0;
        paleta[2]:=0;

        for x:=3 to 215*3 do
            if paleta[x]+b<64 then
               paleta[x]:=paleta[x]+b
            else
                paleta[x]:=63;

	port[$3c8]:=0;
	for x:=0 to 215*3 do
            port[$3c9]:=paleta[x];
end;




procedure cambiaColorRGB(c,r,g,b:integer);
begin
     port[$3c8]:=c;
     port[$3c9]:=r;
     port[$3c9]:=g;
     port[$3c9]:=b;
end;



procedure ponColorPixelFondoXY(c:byte;f,x,y:integer);
begin
     writemode0;
     bitplane(pdos[x mod 4]);
     mem[$a000:memfond+f*64+x div 4 + y*4]:=c;
     bitplane (15);
end;



function veColorPixelFondoXY(f,x,y:integer):byte;
begin
     writemode0;
     port[$3ce]:=4;
     port[$3cf]:=x mod 4;
     veColorPixelFondoXY:=mem[$a000:memfond+f*64+x div 4 + y*4];
end;



procedure borraTexto;
begin
     bitplane(15);
     writemode0;
     fillchar(mem[$a000:0],24*80,43*3);
end;



procedure ponLetraXY(l,x,y:integer);
var
   z,w:integer;
   desde,hacia:word;
begin
     writemode1;
     bitplane(15);
     desde:=memletr+(l-32)*16;
     hacia:=(y-1)*8*80+x*2-2;
     asm
        push ds
        mov ax,0a000h
        mov es,ax
        mov ds,ax
        mov di,hacia
        mov si,desde
        cld
        mov cx,8
        mov bx,78
     @L:
        movsb;
        movsb;
        add di,bx
        loop @L
        pop ds
     end;
end;


procedure escribeTextoXY(s:string;x,y:integer);
var z:integer;
begin
     for z:=x to x+length(s)-1 do
         ponLetraXY(ord(s[z-x+1]),z,y);
end;



procedure escribeNumero(n,x,y:integer);
var s:string;
begin
     str (n,s);
     escribeTextoXY(s,x,y);
end;



procedure leeMusica(a:string);
var
   t:text;
   b,s:string;
   x:integer;
   b1:string;
   frec,c,i:integer;
begin
     for x:=1 to largomusica do
         musica[x]:=0;

     assign (t,a);
     reset (t);
     readln(t,s);
     indi:=1;
     while not(eof(t)) do begin
           readln (t,s);
           if s[1]<>'{' then begin
           b1:=copy(s,1,pos(' ',s)-1);
           val(copy(s,pos(' ',s)+1,length(s)-pos(' ',s)),c,i);
           if b1= 'sil' then frec:=0;
           if b1= 'do1' then frec:=do1;
           if b1= 're1' then frec:=re1;
           if b1= 'mi1' then frec:=mi1;
           if b1= 'fa1' then frec:=fa1;
           if b1= 'sol1' then frec:=sol1;
           if b1= 'la1' then frec:=la1;
           if b1= 'si1' then frec:=si1;
           if b1= 'dosos1' then frec:=dosos1;
           if b1= 'resos1' then frec:=resos1;
           if b1= 'fasos1' then frec:=fasos1;
           if b1= 'solsos1' then frec:=solsos1;
           if b1= 'lasos1' then frec:=lasos1;
           if b1= 'do2' then frec:=do2;
           if b1= 're2' then frec:=re2;
           if b1= 'mi2' then frec:=mi2;
           if b1= 'fa2' then frec:=fa2;
           if b1= 'sol2' then frec:=sol2;
           if b1= 'la2' then frec:=la2;
           if b1= 'si2' then frec:=si2;
           if b1= 'dosos2' then frec:=dosos2;
           if b1= 'resos2' then frec:=resos2;
           if b1= 'fasos2' then frec:=fasos2;
           if b1= 'solsos2' then frec:=solsos2;
           if b1= 'lasos2' then frec:=lasos2;
           if b1= 'do3' then frec:=do3;
           if b1= 're3' then frec:=re3;
           if b1= 'mi3' then frec:=mi3;
           if b1= 'fa3' then frec:=fa3;
           if b1= 'sol3' then frec:=sol3;
           if b1= 'la3' then frec:=la3;
           if b1= 'si3' then frec:=si3;
           if b1= 'dosos3' then frec:=dosos3;
           if b1= 'resos3' then frec:=resos3;
           if b1= 'fasos3' then frec:=fasos3;
           if b1= 'solsos3' then frec:=solsos3;
           if b1= 'lasos3' then frec:=lasos3;
           for i:=indi to indi+c-1 do
               if frec=0 then musica[i]:=0 else
               musica[i]:=1193180 div (frec-(i-indi));
           if indi>1 then if musica[indi]=musica[indi-1] then
              musica[indi]:=musica[indi]+20;
           indi:=indi+c;
           end;
     end;
     largoCancion:=indi-1;
end;



procedure enciendeMusica;
var
  i : word;
  r1, r2 : real;
begin
     indi:=1;
     GetIntVec($1C,INT1CVIEJA);
     SetIntVec($1C,@interMusica);
     SALIDA1C := ExitProc;
     ExitProc := @apagaMusica;
     musicaInstalada:=true;
end;



{$F+}
procedure apagaMusica;
begin
     if musicainstalada then begin
     Port[$61] := Port[$61] and $F8;
     ExitProc :=SALIDA1C;
     SetIntVec($1C,INT1CVIEJA);
     musicaInstalada:=false;
     end;
end;
{$F-}

function leeTecla;
var
   aux,ch:char;
   b:byte;
begin
     b:=mem[0:$417];
     if (b and 8=8) then aux:=ALT else if (b and 4=4) then aux:=CON
     else if (b and 2=2) then aux:=SHI else if (b and 1=1) then aux:=SHD
     else aux:=LDA;
     if keyPressed then begin
        ch:=readkey;
        aux:=ch;
        if ch=chr(0) then begin
           ch:=readkey;
           if ch='H' then aux:=FLARR;
           if ch='K' then aux:=FLIZQ;
           if ch='P' then aux:=FLABA;
           if ch='M' then aux:=FLDER;
           if ch=';' then aux:=F1;
           if ch='<' then aux:=F2;
           if ch='=' then aux:=F3;
           if ch='>' then aux:=F4;
           if ch='?' then aux:=F5;
           if ch='@' then aux:=F6;
           if ch='A' then aux:=F7;
           if ch='B' then aux:=F8;
           if ch='C' then aux:=F9;
           if ch='D' then aux:=F10;
        end;
     end;
     leeTecla:=aux;

end;

procedure niahiconelretrace;
begin
     pescaretrace:=false;
end;

procedure ahiconelretrace;
begin
     pescaretrace:=true;
end;

procedure sonido(f,d:integer);
begin
     colasonido[topesonido,1]:=f;
     colasonido[topesonido,2]:=d;
     inc(topesonido);
     if topesonido=11 then topesonido:=1;
end;


var s:string;
x:integer;

begin
     clrscr;
{
     for x:=1 to 37 do begin
         gotoxy (x,12);
         writeln (' Power');
         gotoxy (74-x,14);
         writeln ('Mapocho ');
         sound (x*30);
         delay (10);
     end;
     nosound;

     delay (1000);
}     tope:=0;
     pescaretrace:=true;
     for topesonido:=1 to 10 do begin
         colasonido[topesonido,1]:=0;
         colasonido[topesonido,2]:=0;
     end;
     actualsonido:=1;
     topesonido:=1;
end.

Universidad de Chile Campeon 19941