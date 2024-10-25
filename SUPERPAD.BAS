DIM SHARED InterFeld(0 TO 34) AS INTEGER
DIM SHARED OutregBx AS INTEGER
DIM SHARED OutregCx AS INTEGER
DIM SHARED OutregDx AS INTEGER
DIM pad(1 TO 149)  AS INTEGER
DIM padbg(1 TO 149)  AS INTEGER
DIM ball(1 TO 29)  AS INTEGER
DIM ballbg(1 TO 29)  AS INTEGER
DECLARE SUB InitInterrupt ()
DECLARE SUB INTERRUPT (Nr%, iax%, ibx%, icx%, idx%)

CALL InitInterrupt

SCREEN 13
PALETTE 100, 20
PALETTE 101, 28
PALETTE 102, 32
PALETTE 103, 36
PALETTE 104, 40
PALETTE 105, 44
PALETTE 106, 48
PALETTE 107, 52
PALETTE 108, 56
PALETTE 109, 60
CALL INTERRUPT(&H33, &H7, 0, 28, 610)
CALL INTERRUPT(&H33, &H8, 0, 0, 199)

PSET (1, 0), 25
PSET (2, 0), 24
PSET (3, 0), 23
PSET (0, 1), 25
PSET (1, 1), 28
PSET (2, 1), 27
PSET (3, 1), 24
PSET (4, 1), 23
PSET (0, 2), 24
PSET (1, 2), 27
PSET (2, 2), 26
PSET (3, 2), 24
PSET (4, 2), 21
PSET (0, 3), 23
PSET (1, 3), 24
PSET (2, 3), 24
PSET (3, 3), 22
PSET (4, 3), 21
PSET (1, 4), 23
PSET (2, 4), 21
PSET (3, 4), 21
GET (0, 0)-(4, 4), ball

LINE (3, 180)-(25, 184), 46, B
LINE (3, 181)-(25, 183), 45, B
LINE (3, 182)-(25, 182), 44
LINE (0, 180)-(2, 184), 55, BF
PSET (1, 181), 53
PSET (2, 181), 54
PSET (1, 182), 54

LINE (28, 180)-(26, 184), 55, BF
PSET (27, 181), 53
PSET (26, 181), 54
PSET (27, 182), 54
GET (0, 180)-(28, 184), pad

10
DEF SEG = &HA000
BLOAD "backgrn.dat", 0
DEF SEG
xold = 14
GET (xold - 14, 180)-(xold + 14, 184), padbg
bx = 160
by = 174
xb = 160
yb = 174
GET (xbalt, ybalt)-(xbalt + 4, ybalt + 4), ballbg
hor = 0
ver = 0
an = 0
DO
taste$ = INKEY$
CALL INTERRUPT(&H33, &H3, 0, 0, 0)
IF OutregBx = 1 AND an = 0 THEN hor = -1: ver = -1: an = 1
IF OutregBx = 2 AND an = 0 THEN hor = 1: ver = -1: an = 1
x = OutregCx / 2
IF x <> xold THEN
        PUT (xold - 14, 180), padbg, PSET
        GET (x - 14, 180)-(x + 14, 184), padbg
        PUT (x - 14, 180), pad, PSET
        DEF SEG = &HA000
        posit = 57586 + x
        POKE (posit), padbg(3)
        POKE (posit + 28), padbg(17)
        POKE (posit + 1280), padbg(61)
        POKE (posit + 1308), padbg(75)
        DEF SEG
        END IF

bx = bx + hor
by = by + ver
IF an = 0 AND x <> xold THEN
        PUT (xbalt, ybalt), ballbg, PSET
        GET (x - 2, 174)-(x + 2, 178), ballbg
        PUT (x - 2, 174), ball, PSET
        posit = 55678 + x
        DEF SEG = &HA000
        POKE (posit), ballbg(3)
        POKE (posit + 4), ballbg(5)
        POKE (posit + 1280), ballbg(13)
        POKE (posit + 1284), ballbg(15)
        DEF SEG
        xbalt = x - 2
        ybalt = 174
        bx = x - 2
        by = 174
        END IF
xb = CINT(bx)
yb = CINT(by)
IF an = 1 THEN
        PUT (xbalt, ybalt), ballbg, PSET
        GET (xb, yb)-(xb + 4, yb + 4), ballbg
        PUT (xb, yb), ball, PSET
        posit = yb * 320 + xb
        DEF SEG = &HA000
        POKE (posit), ballbg(3)
        POKE (posit + 4), ballbg(5)
        POKE (posit + 1280), ballbg(13)
        POKE (posit + 1284), ballbg(15)
        DEF SEG
        xbalt = xb
        ybalt = yb
        END IF
IF xb >= 315 OR xb <= 0 THEN hor = hor * -1: SOUND 100, 1
IF yb <= 0 THEN ver = ver * -1: SOUND 100, 1

IF yb = 175 AND x - 15 < xb + 2 AND x + 15 > xb + 2 THEN ver = ver * -1: SOUND 150, 1
IF yb > 190 THEN GOTO 10

FOR z = 1 TO 10: NEXT z
xold = x
LOOP UNTIL taste$ = CHR$(27)

CALL INTERRUPT(&H33, &H2, 0, 0, 0)
END

SUB InitInterrupt
PoiSeg% = VARSEG(OutregBx)
PoiPos% = VARPTR(OutregBx)
bxSLow% = (PoiSeg% MOD 256)
bxSHigh% = INT(PoiSeg% / 256)
bxPLow% = (PoiPos% MOD 256)
bxPHigh% = INT(PoiPos% / 256)
PoiSeg% = VARSEG(OutregCx)
PoiPos% = VARPTR(OutregCx)
cxSLow% = (PoiSeg% MOD 256)
cxSHigh% = INT(PoiSeg% / 256)
cxPLow% = (PoiPos% MOD 256)
cxPHigh% = INT(PoiPos% / 256)
PoiSeg% = VARSEG(OutregDx)
PoiPos% = VARPTR(OutregDx)
dxSLow% = (PoiSeg% MOD 256)
dxSHigh% = INT(PoiSeg% / 256)
dxPLow% = (PoiPos% MOD 256)
dxPHigh% = INT(PoiPos% / 256)
DEF SEG = VARSEG(InterFeld(0))
Poi% = VARPTR(InterFeld(0))
POKE Poi%, &HB8
POKE Poi% + 1, &H0
POKE Poi% + 2, &H0
POKE Poi% + 3, &HBB
POKE Poi% + 4, &H0
POKE Poi% + 5, &H0
POKE Poi% + 6, &HB9
POKE Poi% + 7, &H0
POKE Poi% + 8, &H0
POKE Poi% + 9, &HBA
POKE Poi% + 10, &H0
POKE Poi% + 11, &H0
POKE Poi% + 12, &HCD
POKE Poi% + 13, &H0
POKE Poi% + 14, &H6
POKE Poi% + 15, &H56
POKE Poi% + 16, &HB8
POKE Poi% + 17, cxSLow%
POKE Poi% + 18, cxSHigh%
POKE Poi% + 19, &H8E
POKE Poi% + 20, &HC0
POKE Poi% + 21, &HB8
POKE Poi% + 22, cxPLow%
POKE Poi% + 23, cxPHigh%
POKE Poi% + 24, &H8B
POKE Poi% + 25, &HF0
POKE Poi% + 26, &H26
POKE Poi% + 27, &H88
POKE Poi% + 28, &HC
POKE Poi% + 29, &H26
POKE Poi% + 30, &H88
POKE Poi% + 31, &H6C
POKE Poi% + 32, &H1
POKE Poi% + 33, &HB8
POKE Poi% + 34, dxSLow%
POKE Poi% + 35, dxSHigh%
POKE Poi% + 36, &H8E
POKE Poi% + 37, &HC0
POKE Poi% + 38, &HB8
POKE Poi% + 39, dxPLow%
POKE Poi% + 40, dxPHigh%
POKE Poi% + 41, &H8B
POKE Poi% + 42, &HF0
POKE Poi% + 43, &H26
POKE Poi% + 44, &H88
POKE Poi% + 45, &H14
POKE Poi% + 46, &H26
POKE Poi% + 47, &H88
POKE Poi% + 48, &H74
POKE Poi% + 49, &H1
POKE Poi% + 50, &HB8
POKE Poi% + 51, bxSLow%
POKE Poi% + 52, bxSHigh%
POKE Poi% + 53, &H8E
POKE Poi% + 54, &HC0
POKE Poi% + 55, &HB8
POKE Poi% + 56, bxPLow%
POKE Poi% + 57, bxPHigh%
POKE Poi% + 58, &H8B
POKE Poi% + 59, &HF0
POKE Poi% + 60, &H26
POKE Poi% + 61, &H88
POKE Poi% + 62, &H1C
POKE Poi% + 63, &H26
POKE Poi% + 64, &H88
POKE Poi% + 65, &H7C
POKE Poi% + 66, &H1
POKE Poi% + 67, &H5E
POKE Poi% + 68, &H7
POKE Poi% + 69, &HCB
DEF SEG
END SUB

SUB INTERRUPT (Nr%, iax%, ibx%, icx%, idx%)
ah% = INT(iax% / 256)
bh% = INT(ibx% / 256)
ch% = INT(icx% / 256)
dh% = INT(idx% / 256)
al% = (iax% MOD 256)
bl% = (ibx% MOD 256)
cl% = (icx% MOD 256)
dl% = (idx% MOD 256)
DEF SEG = VARSEG(InterFeld(0))
Poi% = VARPTR(InterFeld(0))
POKE Poi% + 1, al%
POKE Poi% + 2, ah%
POKE Poi% + 4, bl%
POKE Poi% + 5, bh%
POKE Poi% + 7, cl%
POKE Poi% + 8, ch%
POKE Poi% + 10, dl%
POKE Poi% + 11, dh%
POKE Poi% + 13, Nr%
CALL ABSOLUTE(Poi%)
DEF SEG
END SUB

