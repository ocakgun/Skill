fn=pv("M0" "fn" ?result "noise") ;;[V�/Hz]
id=pv("M0" "id" ?result "noise") ;;[V�/Hz]
rs=pv("M0" "rs" ?result "noise") ;;[V�/Hz]
rd=pv("M0" "rd" ?result "noise") ;;[V�/Hz]

rn10k=pv("V1" "rn" ?result "noise") ;;[V�/Hz]
fnzero=pv("V1" "fn" ?result "noise") ;;[V�/Hz]

sum=fn+id+rs+rd+rn10k


plot(sum)


zfn=fnzero+fn
plot(zfn)


strip=0

zfn=fnzero+fn
name=list("fn")
wave=list(zfn)
awvPlotWaveform(currentWindow() || newWindow() wave ?expr name ?stripNumber list(strip=strip+1)) ;;plot(zid)  ;;<== la fonction plot ne permet pas de changer le label correctement

zid=fnzero+id
name=list("id")
wave=list(zid)
awvPlotWaveform(currentWindow() || newWindow() wave ?expr name ?stripNumber list(strip=strip+1)) ;;plot(zid)  ;;<== la fonction plot ne permet pas de changer le label correctement

zrs=fnzero+rs
name=list("rs")
wave=list(zrs)
awvPlotWaveform(currentWindow() || newWindow() wave ?expr name ?stripNumber list(strip=strip+1))

z10k=fnzero+rn10k
name=list("Rn_10k")
wave=list(z10k)
awvPlotWaveform(currentWindow() || newWindow() wave ?expr name ?stripNumber list(strip=strip+1))

tot=fn+id+rs+rd+rn10k+fnzero
name=list("tot")
wave=list(tot)
awvPlotWaveform(currentWindow() || newWindow() wave ?expr name ?stripNumber list(strip=strip+1))


