;; load "~/Skill/mos2fet.il"
setSkillPath(cons("~/../ebecheto/Skill" getSkillPath()))
load "mos2fet.proc.il.v1.il" ;<= defines additional procedures and flipList


procedure(c35toc18(@optional (flip flip) (cv geGetWindowCellView()) )
let((inst A B sA sB Axy newName newLib oldProp newProp flipProp aPoint bPoint special flipPin pA pB pAB mvA mvB netName carPoint mvPoints sideWay transform orient adjust tmp tmp2 samePin)
sideWay='(("R0" "MY")("R90" "MYR90")("R180" "MX")("R270" "MXR90"))
sideWay=append(sideWay foreach(mapcar x sideWay list(cadr(x) car(x)))); and the way around

foreach( inst cv~>instances
printf("___ Changing Instance %s %s" inst~>name inst~>cellName)
Axy=inst~>xy
; ie:fp= ("pmos4" "pfet" "cmrf8sf" ("flipProp" (("w" "wf") ("wtot" "wt") ("ng" "nf"))))
;          car     cadr   caddr
foreach(mapcar fp flip
flipPin='()
when(inst~>cellName==car(fp)
newName=cadr(fp)
newLib=caddr(fp)


;special Case Handling : AST 4th element
when(length(fp)>=4
foreach( special nth(3 fp)
when(car(special)=="flipProp"
foreach(flop cadr(special)
oldProp=car(setof( oldProp   inst~>prop oldProp~>name==car(flop) ))
when(not(setof( newProp   inst~>prop newProp~>name==cadr(flop) )) newProp=dbCreateProp(inst cadr(flop) "string" oldProp~>value))
newProp~>value=oldProp~>value        printf("PROP: %s=%L %s=%L\n" oldProp~>name oldProp~>value newProp~>name newProp~>value)
));special Case flipProp
when(car(special)=="flipPin"
flipPin=cadr(special)
);;special Case flipPin
));special Case Handling

;; A=old B=new
A=dbOpenCellViewByType(inst~>libName inst~>cellName "symbol")
when(not(B=dbOpenCellViewByType(       newLib        newName "symbol")) 
printf("Please add the library of %s to your cds.lib Try somesing like \nDEFINE %s /data/kit/techno/%s\n" newName newLib newLib) )

; #### move nets of pins location modification
sA=sort(A~>terminals~>name nil)
sB=sort(B~>terminals~>name nil)
when(sA==sB flipPin=foreach(mapcar x sA append(flipPin list(x x))));==> when all pin name match

tmp='()
foreach( x sA when(member(x sB) tmp=tconc(tmp x))) tmp=car(tmp);==> get similar names
foreach( x tmp when(not(apply('or foreach(mapcar z flipPin cadr(z)==x))) flipPin=append(flipPin list(list(x x)) )))
;append only if samePin not present in second member of flipPin


when(flipPin 
printf("FLIPPING  %s-%s %L TOFLIP \n" inst~>baseName inst~>cellName flipPin)
foreach( pAB flipPin
pA=car(pAB); ie. pin name "S"
pB=cadr(pAB)
mvA=dbTransformPoint(getMasterTermPoint(A pA) inst~>transform)
transform=inst~>transform
orient=inst~>orient
when(newName=="oprppres" 
foreach(x sideWay when(inst~>orient==car(x) orient=cadr(x)))
transform=list(inst~>xy orient inst~>mag)
)
mvB=dbTransformPoint(getMasterTermPoint(B pB) transform)

netName=getInstNetName(inst pA) ;get net name connected to inst "S" ie. => "net079"
when(mvA!=mvB
foreach(mapcar net cv~>nets
when(netName||net~>name==netName||net~>name==strcat(netName "!")
isBetweenPoints(mvB netName cv); change to 'flight lines' a possible crossing net when netNames are differents
foreach(mapcar fig net~>figs
mvPoints=foreach(mapcar point fig~>points
if(point==mvA then mvB else point); move to same point => not moved
);move old point A to new point B
when(fig~>points!=mvPoints 
printf("\n** changing %L %s form %L to %L\n" fig netName fig~>points mvPoints)
fig~>points=mvPoints)
);end check all nets  rodSubPoints('(2.96875 3.5) '(2.96875 3.5))
);pass unecessary nets
);
); postions pins are != mvA!=mvB
);end check all pins pAB to flip off selected instance   0x0fb18393
); when flipPin list is not nil

; ####CHANGE MASTER###
; inst~>master=dbOpenCellViewByType("cmrf8sf" "pfet" "symbol")
; B=dbOpenCellViewByType("cmrf8sf" "oprppres" "symbol")
inst~>master=B
inst~>orient=orient
printf("-> into  %L ___\n" inst~>cellName)

; ## post instance change TUNNING for pretty print. To addapt for different techno swapping 
when(newName=="oprppres"
aPoint=getTermPoint(inst "S")
foreach(net cv~>nets foreach(fig net~>figs foreach(point fig~>points
when(point==aPoint printf("Moving : %s from %L\n" net~>name  point))
)))
schHiObjectProperty()  ;<== refresh pin term names in order to getTermPoint to have acces to refreshed values
hiFormDone(schObjPropForm)
bPoint=getMasterTermPoint(B "S")
printf("%L %L\n BB=dbOpenCellViewByType(%s %s %L)\n" aPoint bPoint     newLib        newName "symbol")
;; schStretch(list(inst) list(rodSubPoints(aPoint bPoint) "R0"));<== moves with wires
);resistance

when(length(fp)>=4 foreach( special nth(3 fp) when(car(special)=="adjust"
adjust=cadr(special)
xform=list(rodSubPoints(inst~>xy dbTransformPoint(adjust inst~>transform)) "R0" 1)
schStretch(list(inst) dbConcatTransform(dbConcatTransform(list(mapcar('minus inst~>xy) "R0" 1) xform) list(inst~>xy "R0" 1)))
)));adjust => prettier view, this is just tunning, is avoided when not sepcified in the input list flip

));when ;for allinst
) t ;end foreach instances in cellView
));;let proc
printf("c35toc18\n");

c35toc18

;; schStretch(list(inst) list(rodSubPoints(dbTransformPoint(rodAddPoints('(-0.0625 0.0)  inst~>xy) list('(0.0 0.0) inst~>orient inst~>mag )) inst~>xy ) "R0")) 

;;fp='("pmos4" "pfet" "cmrf8sf" (("flipProp" (("w" "wf")  ("wtot" "wt")  ("ng" "nf")   )            )        ))