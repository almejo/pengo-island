{$M 65000,0,650000}

program turbo_pengo_island;

uses
    mapocho,crt;

type

    direccion=(izquierda,derecha);

    coordenadas=record
                      lugarx:integer;
                      lugary:integer;
                end;

    par_de_postes=record
                        poste1:coordenadas;
                        poste2:coordenadas;
                   end;
    mononieve=record
                    numero_monos:integer;
                    inc:array[1..4] of integer;
                    ti:array[1..4] of integer;
                    td:array[1..4] of integer;
                    altura:array[1..4] of integer;
             end;
    monton_de_monos=array[1..20] of mononieve;


var
   coor_pelota                          :coordenadas;

   monos_de_nieve                       :monton_de_monos;
   cangrejos                            :monton_de_monos;
   focas                                :monton_de_monos;
   esquimal                             :monton_de_monos;

   incr_mono                            :array [1..28] of integer;
   postes_level                         :array[1..20] of par_de_postes;
   numposte                             :array[1..33] of integer;
   gemas                                :array[1..20] of coordenadas;
   llaves                               :array[1..20] of coordenadas;
   puertas                              :array[1..20] of coordenadas;

   direccion_de_pengo                   :direccion;
   direccion_bola                       :direccion;
   contador_total                       :integer;

   poste_inicial,poste_final            :integer;
   cc,i,lugarx,lugary                      :integer;
   pengo,puerta                         :integer;
   pelota_de_nieve                      :integer;
   door                                 :integer;
   retrazo_disparo                      :integer;
   anima_disparo                        :integer;
   anima_pengo                          :integer;
   anim_poste                           :integer;
   cont_salto                           :integer;
   cont_poste                           :integer;
   level                                :integer;
   n                                    :integer;
   cont_bola                            :integer;
   vidas                                :integer;

   hay_bola                             :boolean;
   esta_muerto                          :boolean;
   esta_cayendo                         :boolean;
   pabier                               :boolean;
   esta_saltando,saltader               :boolean;
   esta_encendida                       :boolean;
   esta_disparando                      :boolean;
   next                                 :boolean;
   gema                                 :boolean;
   llave                                :boolean;
   cheat                                :boolean;

   c                                    :char;

procedure inicializa(var amonos:monton_de_monos;archivo:string);
var
   monos:text;
   i,f:integer;
   void:string;
begin
   assign(monos,archivo);
   reset(monos);
   for i:=1 to 20 do
   begin
        readln(monos,void);

        readln(monos,amonos[i].numero_monos);
        with amonos[i] do
        begin
             for f:=1 to numero_monos do
                 begin
                 readln(monos,amonos[i].ti[f]);
                 readln(monos,amonos[i].td[f]);
                 readln(monos,amonos[i].altura[f]);
                 readln(monos,amonos[i].inc[f]);
                 end;
        end;
   end;

end;

procedure inipuerta;
begin
     ponfondoxy(90+40,gemas[level].lugarx,gemas[level].lugary);
     ponfondoxy(13+40,llaves[level].lugarx,llaves[level].lugary);
     ponmonoforma(puerta,0);
     ponmonoxy(puerta,1000,0);
     lugarx:=puertas[level].lugarx*16;
     lugary:=puertas[level].lugary*16;
     ponmonoxy(pengo,lugarx,lugary);
     for i:=25 to 29 do
         begin
              ponmonoforma(pengo,i);
              anima;
              delay (300);
              if i=27 then
                 ponmonoxy(puerta,puertas[level].lugarx*16+4,puertas[level].lugary*16);
         end;
     lugarx:=lugarx+4;
     ponmonoxy(pengo,lugarx,lugary);
     ponmonoxy(puerta,puertas[level].lugarx*16,puertas[level].lugary*16);
     ponmonoforma(pengo,0);
     ponmonoforma(puerta,25);
end;
procedure iniarreglos;
var
   g,l,p :text;
   i:integer;

begin
     assign (g,'gemas.png');
     assign (l,'llaves.png');
     assign (p,'puertas.png');
     reset (g); reset(l); reset (p);
     for i:=1 to 20 do
     begin
          read(g,gemas[i].lugarx,gemas[i].lugary);
          read(l,llaves[i].lugarx,llaves[i].lugary);
          read(p,puertas[i].lugarx,puertas[i].lugary);
     end;
     {aprovecha de  inicializar texto}
     escribetextoxy('Pengos:',1,2);
     escribetextoxy('Nivel:',32,2);
     escribenumero(vidas,8,2);
end;

Procedure pon_peligro;
begin
for i:=26 to 25+monos_de_nieve[level].numero_monos do
                      ponmonoxy(i,
                      (monos_de_nieve[level].ti[i-25]+monos_de_nieve[level].td[i-25]) div 2,
                      monos_de_nieve[level].altura[i-25]);
                  for i:=22 to cangrejos[level].numero_monos+21 do
                      ponmonoxy(i,
                      (cangrejos[level].ti[i-21]+cangrejos[level].td[i-21]) div 2,
                      cangrejos[level].altura[i-21]);
                  for i:=18 to focas[level].numero_monos+17 do
                      ponmonoxy(i,
                      (focas[level].ti[i-17]+focas[level].td[i-17]) div 2,
                      focas[level].altura[i-17]);
                  for i:=14 to esquimal[level].numero_monos+13 do
                      ponmonoxy(i,
                      (esquimal[level].ti[i-13]+esquimal[level].td[i-13]) div 2,
                      esquimal[level].altura[i-13]);
end;



function compara_con_el_piso:boolean;
var
     c,d,e:integer;
begin
     d:=vefondoxy ((lugarx+13) div 16, (lugary+16) div 16);
     c:=vefondoxy ((lugarx+2) div 16, (lugary+16) div 16);
     if (c mod 5=4) or (d mod 5=4)
     or (((c=10) or (c=15) or (d=10) or (d=15)) and (lugary mod 16<2))
     or ((vemonoforma(pengo)>19) and (vemonoforma(pengo)<25))
     then
              compara_con_el_piso:=true
        else
              compara_con_el_piso:=false;
end;


procedure secuencia_de_muerte;
var i:integer;
begin
while ((compara_con_el_piso=false) and (lugary<153)) do
   begin
   lugary:=lugary+1;
   ponmonoy(pengo,lugary);
   anima;
   end;
for i:=pengo+1 to 33 do
    sacamono(i);
anima;
for i:=85 to 86 do
    begin
    delay(100);
    ponmonoforma(pengo,i);
    anima;
    end;
for i:=0 to 20 do
    begin
    if i mod 2=0 then ponmonoforma(pengo,87)
    else ponmonoforma(pengo,88);
    anima;
    delay(50);
    end;
    delay(150);
    ponmonoforma(pengo,89);
    anima;
    delay(2000);
end;


procedure perder;
begin
     vidas:=vidas-1;
     secuencia_de_muerte;
     if vidas=-1 then
        begin
        c:=esc;
        escribetextoxy('Game Over !!!',14,2);
        readln;
        end
     else
         begin
         escribenumero(vidas,8,2);
         next:=false;
         gema:=false;
         llave:=false;
         leepaisaje(level);
         escribenumero(level,38,2);
         ponx(0);
         direccion_de_pengo:=derecha;
         for i:=3 to 33 do
             ponmonox(i,1000);
         esta_disparando:=false;
         esta_encendida:=true;
         esta_saltando:=false;
         pabier:=false;
         esta_cayendo:=false;
         esta_muerto:=false;
         hay_bola:=false;
         next:=false;
         gema:=false;
         llave:=false;
         anima_pengo:=0;
         anima_disparo:=0;
         cont_poste:=0;
         inipuerta;
         pon_peligro;
         end;
end;


{ PELIGROS }

procedure Pon_Mono_de_Nieve (num_mono,tope_izquierdo,tope_derecho,altura:integer;
                            var incremento:integer);

var x,y,ant,forma_mono,lado:integer;

begin
     forma_mono:=veMonoForma(num_mono) mod 5;
     y:=altura*16;
     x:=vemonoX(num_mono);
     ant:=x;
     if (lugarx>x-13) and (lugarx<x+13) and (lugary>y-16) and (lugary<y+16) then perder;
     if (contador_total) mod 2=0 then
        begin
        x:=x+incremento;
        if (x>tope_derecho) or (x<tope_izquierdo) then
           incremento:=-incremento;
        if (contador_total) mod 10=0 then
           forma_mono:=forma_mono+1;
        if forma_mono>2 then
           forma_mono:=0;
        lado:=45;
        if x>ant then
           lado:=50;
        ponmonoforma(num_mono,forma_mono+lado);
        ponMonoXY(num_mono,x,y);
        end;
     if (coor_pelota.lugarx>x-3) and (coor_pelota.lugarx<x+13)
     and (coor_pelota.lugary+13>y-3) and (coor_pelota.lugary+13<y+13) then
        ponmonoxy(num_mono,1000,y);
end;

procedure Pon_cangrejo(num_mono,tope_izquierdo,tope_derecho,altura:integer;
                            var incremento:integer);

var x,y,ant,forma_mono,lado:integer;

begin
     forma_mono:=veMonoForma(num_mono) mod 2;
     y:=altura*16;
     x:=vemonoX(num_mono);
     ant:=x;
     if (lugarx>x-13) and (lugarx<x+13) and (lugary>y-16) and (lugary<y+16) then perder;
     if (contador_total) mod 2=0 then
        begin
        x:=x+incremento;
        if (x>tope_derecho) or (x<tope_izquierdo) then
           incremento:=-incremento;
        if (contador_total) mod 10=0 then
           forma_mono:=forma_mono+1;
        if forma_mono>1 then
           forma_mono:=0;
        lado:=68;
        ponmonoforma(num_mono,forma_mono+lado);
        ponMonoXY(num_mono,x,y);
        end;
     if (coor_pelota.lugarx>x-3) and (coor_pelota.lugarx<x+13)
     and (coor_pelota.lugary+13>y-3) and (coor_pelota.lugary+13<y+13) then
        ponmonoxy(num_mono,1000,y);
end;


procedure Pon_focas(num_mono,tope_izquierdo,tope_derecho,altura:integer;
                            var incremento:integer);

var x,y,ant,forma_mono,lado:integer;

begin
     forma_mono:=(veMonoForma(num_mono)-3) mod 2;
     y:=altura*16;
     x:=vemonoX(num_mono);
     ant:=x;
     if (lugarx>x-13) and (lugarx<x+13) and (lugary>y-16) and (lugary<y+16) then perder;
     if (contador_total) mod 2=0 then
     begin
        x:=x+incremento;
        if (x>tope_derecho) or (x<tope_izquierdo) then
           incremento:=-incremento;
        if (contador_total) mod 10=0 then
           forma_mono:=forma_mono+1;
        if forma_mono>1 then
           forma_mono:=0;
        lado:=43;
        if x>ant then
           lado:=48;
        ponmonoforma(num_mono,forma_mono+lado);
        ponMonoXY(num_mono,x,y);
        end;

     if (coor_pelota.lugarx>x-3) and (coor_pelota.lugarx<x+13)
     and (coor_pelota.lugary+13>y-3) and (coor_pelota.lugary+13<y+13) then
        ponmonoxy(num_mono,1000,y);
end;

procedure Pon_esquimales(num_mono,tope_izquierdo,tope_derecho,altura:integer;
                            var incremento:integer);

var x,y,ant,forma_mono,lado:integer;

begin
     forma_mono:=veMonoForma(num_mono) mod 2;
     y:=altura*16;
     x:=vemonoX(num_mono);
     ant:=x;
     if (lugarx>x-13) and (lugarx<x+13) and (lugary>y-16) and (lugary<y+16) then perder;
     if (contador_total) mod 2=0 then
     begin
        x:=x+incremento;
        if (x>tope_derecho) or (x<tope_izquierdo) then
           incremento:=-incremento;
        if (contador_total) mod 10=0 then
           forma_mono:=forma_mono+1;
        if forma_mono>1 then
           forma_mono:=0;
        lado:=53;
        if x>ant then
           lado:=58;
        ponmonoforma(num_mono,forma_mono+lado);
        ponMonoXY(num_mono,x,y);
        end;

     if (coor_pelota.lugarx>x-3) and (coor_pelota.lugarx<x+13)
     and (coor_pelota.lugary+13>y-3) and (coor_pelota.lugary+13<y+13) then
        ponmonoxy(num_mono,1000,y);
end;


{ MOVIMIENTOS }

procedure inicializa_postes;
var
   archivo_postes:text;
   i:integer;
   void:string;
begin
assign(archivo_postes,'postes.png');
reset(archivo_postes);
for i:=1 to 20 do
    begin
          readln(archivo_postes,postes_level[i].poste1.lugarx);
          readln(archivo_postes,postes_level[i].poste1.lugary);
          readln(archivo_postes,postes_level[i].poste2.lugarx);
          readln(archivo_postes,postes_level[i].poste2.lugary);
          readln(archivo_postes,void);
    end;
end;

procedure pon_postes(par:par_de_postes);
var i:integer;
    x1,x2,y1,y2:integer;
begin
     x1:=par.poste1.lugarx*16;
     x2:=par.poste2.lugarx*16;
     y1:=par.poste1.lugary*16;
     y2:=par.poste2.lugary*16;
     ponmonoforma(numposte[poste_inicial],15);
     ponmonoforma(numposte[poste_inicial+1],15);
     for i:=2 to 4 do
              ponmonoforma(numposte[poste_inicial+i],(cont_poste div 4)+16);
     ponmonoxy(numposte[poste_final],x2,y2);
     ponmonoxy(numposte[poste_inicial+1],x2,y2-11);
     ponmonoxy(numposte[poste_inicial],x1,y1-27);
     ponmonoxy(numposte[poste_inicial+2],x1,y1-16);
     ponmonoxy(numposte[poste_final-1],x1,y1);
     cont_poste:=cont_poste+1;
     if cont_poste>15 then
        cont_poste:=0;
end;



procedure mueve_pengo_derecha;
var
   d:integer;
begin
     if compara_con_el_piso then
     begin
          lugarx:=lugarx+2;
          ponmonoforma(pengo,anima_pengo mod 5);
          ponmonoxy(pengo,lugarx,lugary);
          anima_pengo:=anima_pengo+1;
          direccion_de_pengo:=derecha;
          if anima_pengo>9 then anima_pengo:=1;
          if (lugarx>=160) and (lugarx<=790) and (c=flder) then
             begin
                  muevepaisajeizquierda;
                  anima;
                  muevepaisajeizquierda;

             end;
     end;
end;

procedure mueve_pengo_izquierda;
var
   d:integer;
begin
     d:=vefondoxy(lugarx mod 16, (lugary+ 16) mod 16);
     if compara_con_el_piso then
     begin
          if lugarx>0 then lugarx:=lugarx-2;
          ponmonoforma(pengo,anima_pengo mod 5 + 5);
          ponmonoxy(pengo,lugarx,lugary);
          anima_pengo:=anima_pengo+1;
          direccion_de_pengo:=izquierda;
          if anima_pengo>9 then anima_pengo:=1;
          if (lugarx>=158) and (lugarx<=790) and (c=flizq) then
             begin
                  muevepaisajederecha;
                  anima;
                  muevepaisajederecha;

             end;
     end;
end;

procedure mueve_pengo_arriba;
var a,c,d:integer;
begin
     c:=vefondoxy(lugarx div 16,lugary div 16);
     d:=vefondoxy(lugarx div 16,(lugary+16) div 16);
     if ((c=10) or (c=11) or (c=12) or (c=15)
     or (((c=0) or (c=5)) and ((d=10) or (d=11) or (d=12) or (d=15))
     and ((lugary mod 16) <> 0))) and (lugarx mod 16 =0) then
      begin
          if anima_pengo >5 then a:=10-anima_pengo
             else a:= anima_pengo;
          ponmonoforma(pengo,a+19);
          lugary:=lugary-2;
          ponmonoxy(pengo,lugarx,lugary);
          anima_pengo:=anima_pengo+1;
      end;
     if anima_pengo>9 then anima_pengo:=1;
end;

procedure mueve_pengo_abajo;
var a,c,d:integer;
begin
     c:=vefondoxy(lugarx div 16,lugary div 16);
     d:=vefondoxy(lugarx div 16,(lugary+16) div 16);
     if ( (((c=0) or (c=10) or (c=11) or (c=5) or (c=15) or (c=12))
     and ((d=0) or (d=10) or (d=11) or (d=5) or (d=15) or (d=12)))
     and (lugarx mod 16 =0)) then
     begin
          if anima_pengo >5 then a:=10-anima_pengo
             else a:= anima_pengo;
          ponmonoforma (pengo,a+19);
          lugary:=lugary+2;
          ponmonoxy(pengo,lugarx,lugary);
          anima_pengo:=anima_pengo+1;
     end;
     if anima_pengo>9 then anima_pengo:=1;
end;

procedure se_cae_pengo;
var lado:integer;
begin
     lado:=30;
     if direccion_de_pengo=derecha then lado:=10;
     if (esta_cayendo) and (not compara_con_el_piso) and (not esta_saltando) then
        begin
             esta_cayendo:=true;
             ponmonoforma(pengo, anima_pengo mod 3 +lado);
             lugary:=lugary+2;
             ponmonoxy(pengo,lugarx,lugary);
             anima_pengo:=anima_pengo+1;
             if anima_pengo>9 then anima_pengo:=1;
        end
     else
         esta_cayendo:=false;
end;

procedure dispara_bola_de_nieve;
var
   lado:integer;
begin
     if direccion_de_pengo=derecha then
        lado:=35
     else
         lado:=40;

     if (retrazo_disparo mod 10=0) then
          if (esta_disparando) and (anima_disparo<3) and (not esta_saltando)
          and (not esta_cayendo) then
             begin
                  ponmonoforma(pengo,anima_disparo mod 3 + lado);
                  ponmonoxy(pengo,lugarx,lugary);
                  anima_disparo:=anima_disparo+1;
             end;
     retrazo_disparo:=retrazo_disparo+1;
     if anima_disparo=3 then
        begin
             esta_disparando:=false;
             anima_disparo:=0;
             retrazo_disparo:=0;
             if direccion_de_pengo=derecha then
                ponmonoforma(pengo,0)
             else
                 ponmonoforma(pengo,5);
             hay_bola:=true;
             direccion_bola:=direccion_de_pengo;
             if direccion_bola=derecha then
                coor_pelota.lugarx:=lugarx+13
             else
                 coor_pelota.lugarx:=lugarx-1;
             coor_pelota.lugary:=lugary-10;
             cont_bola:=0;
        end;
end;

procedure la_bola_vuela;
var i:integer;
begin
ponmonoforma(pelota_de_nieve,14);
if direccion_bola=derecha then
   i:=1
else
    i:=-1;
cont_bola:=cont_bola+1;
coor_pelota.lugarx:=coor_pelota.lugarx+i;
if cont_bola>16 then
if (contador_total) mod 2=0 then
      coor_pelota.lugary:=coor_pelota.lugary+1;
if vefondoxy((coor_pelota.lugarx) div 16,(coor_pelota.lugary+16) div 16) mod 5=4 then

   begin
        coor_pelota.lugarx:=1000;
        hay_bola:=false;
   end;
   ponmonoxy(pelota_de_nieve,coor_pelota.lugarx,coor_pelota.lugary);
end;

procedure salta;
var a:integer;
begin
if direccion_de_pengo=derecha then
   begin
   if esta_saltando then
       begin
       cont_salto:=cont_salto+2;
       if cont_salto > 29 then
          begin
          ponmonoforma(pengo,0);
          anima;
          esta_saltando := false
          end
       else
           begin
           ponmonoforma(pengo,(cont_salto mod 3)+10);
           lugarx:=lugarx +2 ;
           if cont_salto<16 then   {was 18}
              lugary:=lugary-1
           else
               lugary:=lugary+1;

               ponmonoxy(pengo,lugarx,lugary);
               if (lugarx>=160) and (lugarx<=790) then
                  begin
                  muevepaisajeizquierda;
                  anima;
                  muevepaisajeizquierda;
                  end;
           end;
       end
   else
       begin
       esta_saltando:= true;
       saltader:=true;
       cont_salto:= 0;
       end;
   end


else
    begin

    if esta_saltando then
       begin
       cont_salto:= cont_salto +2;
       if cont_salto > 29 then
          begin
          ponmonoforma(pengo,5);
          anima;
          esta_saltando := false
          end
       else
           begin
           ponmonoforma(pengo,(cont_salto mod 3)+30);
           lugarx:=lugarx -2 ;
           if cont_salto<16 then
              lugary:=lugary-1
           else
               lugary:=lugary+1;

           ponmonoxy(pengo,lugarx,lugary);
           if (lugarx>=158) and (lugarx<=790) then
              begin
              muevepaisajederecha;
              anima;
              muevepaisajederecha;
              end;
           end;
       end
    else
        begin
        esta_saltando:= true;
        saltader:=false;
        cont_salto:= 0;
        end;
    end;
END;


procedure final;
begin
     escribetextoxy('Felicitaciones!!!',1,1);
     escribetextoxy('Has rescatado a Rockford!!!',1,2);
     c:=esc;
     readln;
end;


procedure vigilanext;
var
   x:integer;
begin
     x:=vefondoxy(lugarx div 16, lugary div 16);

     if x=26 then final;

     if (x=90+40) or (x=91+40) then
        begin
           gema:=true;
           ponfondoxy(0,gemas[level].lugarx,gemas[level].lugary);
        end;
     if (x=13+40) then
        begin
             llave:=true;
             ponfondoxy(0,llaves[level].lugarx,llaves[level].lugary);
        end;
     if ((x=6) or (x=16)) and gema and llave then
        next:=true;
end;


procedure finpuerta;
begin

     for i:=25 to 29 do
         begin
              ponmonoforma(puerta,i);
              anima;
              delay (300);
         end;
     if direccion_de_pengo=derecha then
        for i:=1 to 4 do
            begin
                 mueve_pengo_derecha;
                 anima;
                 delay(100);
            end;

         for i:=1 to 4 do
             begin
                  mueve_pengo_izquierda;
                  anima;
                  delay(100);
             end;
     ponmonoxy(pengo,1000,0);
     for i:=29 downto 25 do
         begin
              ponmonoforma(puerta,i);
              anima;
              delay (300);
         end;
end;



{ MAIN }
begin

     level:=1;

     direccion_de_pengo:=derecha;

     inicializa_postes;
     inicializa(cangrejos,'jaiva.png');
     inicializa(monos_de_nieve,'nieve.png');
     inicializa(focas,'focas.png');
     inicializa(esquimal,'esqui.png');

     lugarx:=160;
     lugary:=128;

     pengo:=2;
     puerta:=1;
     pelota_de_nieve:=15;
     poste_inicial:=3;
     poste_final:=7;
     vidas:=3;

     esta_disparando:=false;
     esta_encendida:=true;
     esta_saltando:=false;
     pabier:=false;
     esta_cayendo:=false;
     esta_muerto:=false;
     hay_bola:=false;
     next:=false;
     gema:=false;
     llave:=false;

     anima_pengo:=0;
     anima_disparo:=0;
     cont_poste:=0;

     for i:=poste_inicial to poste_final do
         numposte[i]:=i;



     enciendesistema;
     leemusica('cano.64');
     leepaisaje(level);
     escribenumero(level,38,2);
     enciendemusica;
     ponnumeromonosactivos(31); {era 30}

     iniarreglos;
     inipuerta;

     pon_peligro;
     anima;

     c:=leetecla;

     while (c<>esc) do
     begin
          contador_total:=contador_total+1;
          if contador_total>99 then contador_total:=0;

          pon_postes(postes_level[level]);


          { MOVIENDOSE }

          c:=leetecla;

          { PELIGROS POR NIVEL }

          for n:=26 to monos_de_nieve[level].numero_monos + 25 do
             begin
             pon_mono_de_nieve(n,monos_de_nieve[level].ti[n-25],
             monos_de_nieve[level].td[n-25],monos_de_nieve[level].altura[n-25],
             monos_de_nieve[level].inc[n-25]);
             end;

          for n:=22 to cangrejos[level].numero_monos + 21 do
             begin
             pon_cangrejo(n,cangrejos[level].ti[n-21],
             cangrejos[level].td[n-21],cangrejos[level].altura[n-21],
             cangrejos[level].inc[n-21]);
             end;

          for n:=18 to focas[level].numero_monos + 17 do
             begin
             pon_focas(n,focas[level].ti[n-17],
             focas[level].td[n-17],focas[level].altura[n-17],
             focas[level].inc[n-17]);
             end;

          for n:=14 to esquimal[level].numero_monos + 13 do
             begin
             pon_esquimales(n,esquimal[level].ti[n-13],
             esquimal[level].td[n-13],esquimal[level].altura[n-13],
             esquimal[level].inc[n-13]);
             end;

          esta_cayendo:=true;
          se_cae_pengo;

          if c='@' then
             begin
             cheat:=true;
             escribetextoxy('!',1,1);
             cc:=0;
             end;

          if cheat then  {Revision Rapida de Pantallas en Cheat Mode}
             begin
             if c='o' then
                begin
                cc:=cc-1;
                if cc=-1 then cc:=2;
                ponx(320*cc);
                end;
             if c='p' then
                begin
                cc:=cc+1;
                if cc=3 then cc:=0;
                ponx(320*cc);
                end;
             end;



          if (c=' ') and (not hay_bola) and (not esta_disparando) then
             esta_disparando:=true;

          if esta_disparando then
             dispara_bola_de_nieve;

          if (c='s') and (not esta_encendida) then
             begin
                  enciendemusica;
                  esta_encendida:=true;
             end
             else
                 if (c='s') and (esta_encendida) then
                    begin
                         apagamusica;
                         esta_encendida:=false;
                    end;


             if (c=flder) and (not esta_saltando) then mueve_pengo_derecha;
             if (c=flizq) and (not esta_saltando) then mueve_pengo_izquierda;
             if (c=con) and (not esta_saltando) and (not esta_cayendo) then salta;
             if (c=flarr) then                     mueve_pengo_arriba;
             if (c=flaba) then                     mueve_pengo_abajo;
             if (lugary>158) then perder;

          if next or (c='+') then
             begin
                  next:=false;
                  gema:=false;
                  llave:=false;
                  finpuerta;
                  level:=level+1;
                  if level=21 then level:=1;
                  leepaisaje(level);
                  escribenumero(level,38,2);
                  direccion_de_pengo:=derecha;
                  for i:=3 to 33 do
                      ponmonox(i,1000);
                  inipuerta;

                  pon_peligro;

            end;

          if esta_saltando then salta;
          if hay_bola then la_bola_vuela;
          anima;
          vigilanext;
     end;
     apagasistema;
end.
