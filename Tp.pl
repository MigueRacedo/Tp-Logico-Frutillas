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

%quiereVer(Persona, Serie).
quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gaston, himym).

%popular(Serie).
popular(got).
popular(hoc).
popular(starWars).

%serie(Nombre, Temporadas).
serie(got, temporada(3,12)).
serie(got, temporada(2,10)).
serie(hymym, temporada(1,23)).
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

%leDijo(Persona, OtraPersona, Serie, Lo que paso).
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)). 
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

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
        mira(OtraPersona, Serie).
              
leSpoileo(Persona, OtraPersona, Serie):-
        leDijo(Persona, OtraPersona, Serie, Spoiler),
        esSpoiler(Serie, Spoiler),
        quiereVer(OtraPersona, Serie).

%Faltan consultas de lesSpoileo.

%televidenteResponsable/1:
televidenteResponsable(Persona):-
        mira(Persona,_),
        not(leSpoileo(Persona,_,_)). 

televidenteResponsable(Persona):-
        quiereVer(Persona,_),
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
        popular(Serie).

esPopularOFuerte(Serie):-
        forall(paso(Serie,))

esFuerte(muerte(_)).
esFuerte(relacion(amorosa,_,_)).
esFuerte(relacion(parentesco,_,_)).


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