%mira(Persona, Serie).
mira(juan, himym).
mira(juan, futurama).
mira(juan, got).
mira(nico, starWars).
mira(nico, got).
mira(maiu, starWars).
mira(maiu, got).
mira(maiu, onePiece).
mira(gaston, hoc).
mira(pedro,got).

%quiereVer(Persona, Serie).
quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gaston, himym).
quiereVer(aye,got).

%serie(Nombre, Temporadas).
serie(got, temporada(3,12)).
serie(got, temporada(2,10)).
serie(himym, temporada(1,23)).
serie(drHouse ,temporada(8,16)).

%temporada(Numero, CantDeCaps).

% Todo lo que no esta en la base de conocimiento es FALSO, principio de universo cerrado.

%paso(Serie, Temporada, Episodio, Lo que paso).
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).
paso(got,2,5,relacion(amistad,tyrion,dragon)).
paso(got, 3, 2, plotTwist([suenio,sinPiernas])).
paso(got,3,12,plotTwist([fuego,boda])).
paso(superCampeones,9,9,plotTwist([suenio,coma,sinPiernas])).
paso(drHouse,8,7,plotTwist([coma,pastillas])).

%leDijo(Persona, OtraPersona, Serie, Lo que paso).
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)). 
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).
leDijo(nico,juan,futurama,muerte(seymourDiera)).
leDijo(pedro,aye,got,relacion(amistad,tyrion,dragon)).
leDijo(pedro,nico,got,relacion(parentesco,tyrion,dragon)).

%esSpoiler/2:
esSpoiler(Serie, Spoiler):-
        paso(Serie,_,_,Spoiler).

% Se pueden hacer consultar existenciales como:

% ?- esSpoiler(_,_). - Que va a dar TRUE por cada hecho en mi base de conocimiento que satisfaga el predicado esSpoiler/2;
% ?- esSpoiler(Serie,_). - Va a mostrar en pantalla aquellas series de que satisfacen el predicado;
% ?- esSpoiler(_,Spoiler). - Igual que la consulta anterior pero con los Spoiler;
% ?- esSpoiler(Serie,Spoiler). - Esta junta las 2 consultas anteriores en una;

% Al poder hacerse todas estas consultar, demuestra que el predicado esSpoiler/2 es inversible.

%leSpoileo/3:
leSpoileo(Persona, OtraPersona, Serie):-
        leDijo(Persona, OtraPersona, Serie, Spoiler),
        esSpoiler(Serie, Spoiler),
        estaEnSusPlanes(OtraPersona,Serie).

% Se pueden hacer consultar existenciales como:

% ?- leSpoileo(_,_,_). - Que va a dar TRUE por cada hecho en mi base de conocimiento que satisfaga el predicado leSpoileo/3;
% ?- leSpoileo(Persona,_,_). - Va a mostrar en pantalla aquellas personas que le spoilearon algo a alguien;
% ?- leSpoileo(_,OtraPersona,_). - Igual que la consulta anterior pero con aquellos que fueron spoileados por alguien;
% ?- leSpoileo(_,_,Serie). - Esta consulta va a mostrar aquellas series que fueron spoileadas;
% ?- leSpoileo(Persona,OtraPersona,_). - Va a mostrar al spoileador y al spoileado;
% ?- leSpoileo(Persona,_,Serie). - Muestra a las personas que le spoilearon a esa serie a alguien;
% ?- leSpoileo(_,OtraPersona,Serie). - muestra a las personas que le spoilearon esa serie;
% ?- leSpoileo(Persona,OtraPersona,Serie). - combinando las tres primeras, muestra una persona que le spoileo a otra persona, X serie;

% Al poder hacerse todas estas consultar, demuestra que el predicado esSpoiler/2 es inversible.

%televidenteResponsable/1:
televidenteResponsable(Persona):-
        estaEnSusPlanes(Persona,_),
        not(leSpoileo(Persona,_,_)). 
        

%vieneZafando/2:
vieneZafando(Persona,Serie):-
        estaEnSusPlanes(Persona,Serie),
        esPopularOFuerte(Serie),
        not(leSpoileo(_,Persona,Serie)).

%estaEnSusPlanes/2:
estaEnSusPlanes(Persona,Serie):-
        mira(Persona,Serie).

estaEnSusPlanes(Persona,Serie):-
        quiereVer(Persona,Serie).

%esPopularOFuerte/1:
esPopularOFuerte(Serie):-
        esPopular(Serie).

esPopularOFuerte(Serie):-
        serie(Serie,_),
        forall(paso(Serie,_,_,LoQuePaso),esFuerte(Serie,LoQuePaso)).

%tests:
%test punto 1:---------------------------

:- begin_tests(esSpoiler).

test(muerte_del_emperador_es_spoiler_en_starWars, nondet):-
        esSpoiler(starWars,muerte(emperor)).

test(muerte_de_pedro_no_es_spoiler_en_starWars, fail):-
        esSpoiler(starWars,muerte(pedro)).

test(relacion_de_parentesco_de_anakin_y_rey_es_spoiler_en_starWars, nondet):-
        esSpoiler(starWars,relacion(parentesco,anakin,rey)).

test(relacion_de_parentesco_de_anakin_y_lavezzi_no_es_spoiler_en_starWars, fail):-
        esSpoiler(starWars,relacion(parentesco,anakin,lavezzi)).

:-end_tests(esSpoiler).

%test punto 2:---------------------------

:- begin_tests(leSpoileo).

test(gaston_le_spoileo_gameOfThrones_a_maiu, nondet):-
        leSpoileo(gaston,maiu,got).

test(nico_le_spoileo_starWars_a_maiu, nondet):-
        leSpoileo(nico,maiu,starWars).
                                
:-end_tests(leSpoileo).

%test punto 3:---------------------------

:- begin_tests(televidenteResponsable).

test(juan_es_televidenteResponsable, nondet):-
        televidenteResponsable(juan).

test(aye_es_televidenteResponsable, nondet):-
        televidenteResponsable(aye).

test(maiu_es_televidenteResponsable, nondet):-
        televidenteResponsable(maiu).

test(gaston_no_es_televidenteResponsable, fail):-
        televidenteResponsable(gaston).

test(nico_no_es_televidenteResponsable, fail):-
        televidenteResponsable(nico).
                                
:-end_tests(televidenteResponsable).

%test punto 4:---------------------------

:- begin_tests(vieneZafando).

test(maiu_no_vieneZafando_con_ninguna, fail):-
        vieneZafando(maiu,_).

test(juan_VieneZafando_con_himym_got_hoc, set(Serie == [himym, got, hoc])):-
        vieneZafando(juan, Serie).

test(solo_Nico_VieneZafando_Con_StarWars, set(Persona == [nico])):-
        vieneZafando(Persona, starWars).
                                
:-end_tests(vieneZafando).

% ---------------------------------------------------------------------------------------------------------- Fin Parte 1:}

%Parte 2 tp:

%Punto 1: --------------------------

%malaGente/1:
malaGente(Persona):-
        leDijo(Persona,_,_,_),
        forall(leDijo(Persona,OtraPersona,Serie,_),leSpoileo(Persona,OtraPersona,Serie)).

malaGente(Persona):-
        leSpoileo(Persona,_,Serie),
        not(mira(Persona,Serie)).

%Punto 2: --------------------------

%esFuerte/2:
esFuerte(Serie,LoQuePaso):-
        paso(Serie,_,_,LoQuePaso),
        fuerte(LoQuePaso).

%fuerte/1:
fuerte(LoQuePaso):-
        paso(_,_,_,LoQuePaso), 
        esHeavy(LoQuePaso).

fuerte(LoQuePaso):-
        paso(_,_,_,LoQuePaso),
        not(esCliche(LoQuePaso)),
        pasoEnFinalDeSeason(LoQuePaso).


%esCliche/1:
esCliche(plotTwist(PalabrasClaves)):-
        forall(member(UnaClave,PalabrasClaves),apareceEnOtraSerie(UnaClave,PalabrasClaves)).


%apareceEnOtraSerie/2:
apareceEnOtraSerie(LoQuePaso,ListaClave):-
        paso(_,_,_,plotTwist(Lista)),
        Lista \= ListaClave,
        member(LoQuePaso,Lista).

%pasoEnFinalDeSeason/1:
pasoEnFinalDeSeason(LoQuePaso):-       
        paso(Serie,Temporada,Capitulo,LoQuePaso),
        serie(Serie,temporada(Temporada,Capitulo)).


esHeavy(muerte(_)).
esHeavy(relacion(amorosa,_,_)).
esHeavy(relacion(parentesco,_,_)).


%Punto 3: ---------------------------

%cuantosMiranSerie/2:
cuantosMiranSerie(Serie,Cantidad):-
        mira(_,Serie),
        findall(Persona,mira(Persona,Serie),TotalPersonas),
        length(TotalPersonas,Cantidad).

%cuantosHablanDeUnaSerie/2:
cuantosHablanDeUnaSerie(Serie,Cuantos):-
        leDijo(_,_,Serie,_),
        findall(Persona,leDijo(Persona,_,Serie,_),Conversaciones),
        length(Conversaciones,Cuantos).

%popularidadSerie/2:
popularidadSerie(Serie,Total):-
        cuantosMiranSerie(Serie,Espectadores),
        cuantosHablanDeUnaSerie(Serie,Habladores),
        Total is Espectadores * Habladores.


%esPopular(Serie).
esPopular(hoc).

%esPopular/1:
esPopular(Serie):-
        popularidadSerie(Serie,Cantidad),
        popularidadSerie(starWars,PopuStar),
        Cantidad >= PopuStar.


%Punto 4 :---------------------------

%amigo(amigo1,amigo2).
amigo(nico, maiu).
amigo(maiu, gaston).
amigo(maiu, juan).
amigo(juan, aye).

%fullSpoil/2:
fullSpoil(Spoiler,Spoileado):-
        leSpoileo(Spoiler,Spoileado,_),
        Spoiler \= Spoileado.

fullSpoil(Spoiler,Spoileado):-
        hayRelacion(AmigoSpoiler,Spoileado),
        leSpoileo(Spoiler,AmigoSpoiler,_),
        Spoiler \= Spoileado.

%hayRelacion/2:
hayRelacion(Persona,OtraPersona):-
        amigo(Persona,OtraPersona).

hayRelacion(Persona,OtraPersona):-
        amigo(Persona,AmigoDelAmigo),
        hayRelacion(AmigoDelAmigo,OtraPersona).


%tests:
%tests punto 1:------------------------

:- begin_tests(malaGente).

test(gaston_y_nico_son_malaGente, set(Malos = [gaston,nico])):-
        malaGente(Malos).
                                        
test(aye_pedro_maiu_y_juan_no_son_malaGente, set(Buenos = [aye, maiu, pedro, juan])):-
        estaEnSusPlanes(Buenos, _), not(malaGente(Buenos)).
                                
:-end_tests(malaGente).

%tests punto 2:------------------------

:- begin_tests(esFuerte).

test(la_muerte_de_seymourDiera_en_futurama_es_algo_fuerte, nondet):-
        esFuerte(futurama, muerte(seymourDiera)).
                                                        
test(la_muerte_del_emperador_en_starWars_es_algo_fuerte, nondet):-
        esFuerte(starWars, muerte(emperor)).
                                                        
test(la_relacionDeParentesco_entre_anakin_y_rey_en_starWars_es_algo_fuerte, nondet):-
        esFuerte(starWars, relacion(parentesco, anakin, rey)).
                                                        
test(la_relacionDeParentesco_entre_vader_y_luke_en_starWars_es_algo_fuerte, nondet):-
        esFuerte(starWars, relacion(parentesco, vader, luke)).
                                                        
test(la_relacionAmorosa_entre_ted_y_robin_en_himym_es_algo_fuerte, nondet):-
        esFuerte(himym, relacion(amorosa, ted, robin)).
                                                                    
test(la_relacionAmorosa_entre_swarley_y_robin_en_himym_es_algo_fuerte, nondet):-
        esFuerte(himym, relacion(amorosa, swarley, robin)).
                                                        
test(el_plot_que_contiene_fuego_y_boda_en_gameOfThrones_es_algo_fuerte, nondet):-
        esFuerte(got, plotTwist([fuego, boda])).
                                                                        
test(el_plot_que_contiene_suenio_en_gameOfThrones_no_es_algo_fuerte, fail):-
        esFuerte(got, plotTwist([suenio])).
                                                        
test(el_plot_que_contiene_coma_pastillas_en_drHouse_no_es_algo_fuerte, fail):-
        esFuerte(drHouse, plotTwist([coma, pastillas])).
                                                                                   
:-end_tests(esFuerte).

%tests punto 3:------------------------

:- begin_tests(popularidadSerie).

test(son_populares_got_starWars_houseOfCards, set(Populares = [got, starWars, hoc])):-
        esPopular(Populares).
                                
:-end_tests(popularidadSerie).

%tests punto 4:------------------------

:- begin_tests(fullSpoil).
              
test(nico_hizo_fullSpoil_a_aye_juan_maiu_y_gaston, set(Quienes = [gaston, aye, juan, maiu])):-
        fullSpoil(nico, Quienes).
                        
test(gaston_hizo_fullSpoil_a_maiu_juan_y_aye, set(Quienes = [aye, juan, maiu])):-
        fullSpoil(gaston, Quienes).
                        
test(maiu_no_hizo_Spoil_a_nadie, set(Quienes = [])):-
        fullSpoil(maiu, Quienes).

:- end_tests(fullSpoil).
