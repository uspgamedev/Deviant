extends Control

const FF = preload("res://resources/scenes/minigames/hack/flowfreeCanvas.tscn")
const PB = preload("res://resources/scenes/minigames/hack/passBreaker.tscn")

const MAXLINES = 10
const FFHelp = "Conecte os quadrados coloridos clicando\nem cima deles e arrastando pelos quadrados brancos.\n\nPara completar o minigame é preciso pintar\ntodos os quadrados e conectar todos os de mesma cor!"
const PBHelp = "Tente descobrir a senha.\nAlgumas dicas estão disponíveis, como:\nC -> Quantidade de consoantes\nV -> Quantidade de vogais\nN -> Quantidade de números\nAzul -> O caractere certo pertence ao mesmo grupo do atual\nAmarelo -> O caractere pertence à senha mas está no lugar errado\nVerde/Vermelho -> O caractere está certo/errado"
const DelWinLog = "Você consegue hackear Roberto\ne deleta o relatório dele"
const CopyWinLog = "Vecê consgue hackear Roberto\ne copia o relatório dele"
const LoseLog = "Você não consegue hackear Roberto"

export var won = false

var Terminal
var Time
var Dialog

var tLines
var minigame = "FF"

func _ready():
	Terminal = get_node("Terminal")
	Time = get_node("Timer")
	Dialog = get_node("AcceptDialog")
	tLines = []
	for i in range(MAXLINES):
		tLines.append("")
	get_node("Panel").set_pos(Vector2(10000, 10000))
	get_node("Polygon2D").set_pos(Vector2(10000, 10000))
	get_node("HelpButton").set_pos(Vector2(10000, 10000))
	Time.start()
	yield(Time, "timeout")
	get_node("Panel").set_pos(Vector2(0, 0))
	get_node("Polygon2D").set_pos(Vector2(338, 0))
	get_node("HelpButton").set_pos(Vector2(650, 10))
	run_minigame()

func run_minigame():
	log_append(" -- Iniciando IMESec Hack Master 2.0....")
	Time.start()
	yield(Time, "timeout")
	log_append(" -- Programa iniciado com sucesso!!!")
	log_append(" -- Conecte os cabos para conectar-se ao servidor")
	var ins = FF.instance()
	add_child(ins)
	yield(ins, "ended")
	ins.queue_free()
	log_append(" -- Conectado ao servidor!!")
	log_append(" -- Descubra a senha antes que eles te descubram!!")
	ins = PB.instance()
	add_child(ins)
	minigame = "PB"
	yield(ins, "ended")
	Dialog.set_pos(Vector2(120, 100))
	if ins.victory:
		if won:
			Dialog.set_text(DelWinLog)
		else:
			Dialog.set_text(CopyWinLog)
		get_parent().change_dialogue("Rafael", "Rafael_after_report_good")
	else:
		Dialog.set_text(LoseLog)
		get_parent().change_dialogue("Rafael", "Rafael_after_report_bad")
	Dialog.popup()
	#get_node("Mail").recieveMail()
	
func log_append(s):
	for i in range(MAXLINES-1):
		tLines[i] = tLines[i+1]
	tLines[MAXLINES-1] = s
	log_update()

func log_update():
	var res = ""
	for i in range(MAXLINES-1):
		res += tLines[i] + "\n"
	res += tLines[MAXLINES-1]
	Terminal.set_text(res)

func _on_Button_pressed():
	var HD = get_node("HelpDialog")
	if minigame == "FF":
		HD.set_pos(Vector2(200, 150))
		HD.set_text(FFHelp)
	else:
		HD.set_pos(Vector2(120, 100))
		HD.set_text(PBHelp)
	HD.popup()

func _on_AcceptDialog_confirmed():
	var num
	var p = get_parent()
	for i in range(p.SCENES["Workroom"]["Items"].size()):
		if p.SCENES["Workroom"]["Items"][i]["Name"] == "Door2":
			num = i
			break
	p.SCENES["Workroom"]["Items"][num]["Args"] = ["MeetingRoom1"]
	p.change_scene("Workroom")
