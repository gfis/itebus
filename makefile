#!make

# makefile fuer Projekt itebus: Impfterminbuchungsservice
# 2021-03-12, Georg Fischer

GITS=../../gits
DBAT=java -jar $(GITS)/dbat/dist/dbat.jar -e UTF-8 -c worddb
MAILS="C:/Users/User/AppData/Roaming/Thunderbird/Profiles/4yg92219.default/Mail/Local Folders/A1_itebus.sbd/kvmails"

all: izent wunsch

izent: # Impfzentren
	$(DBAT) -f sql/izent.create.sql
	grep -E "^[0-9]"    data/izent.txt \
	| $(DBAT) -m tsv -r izent
	$(DBAT) -4444 izent
	$(DBAT) -n izent
wunsch: # Impfwuensche
	$(DBAT) -f sql/wunsch.create.sql 
	grep -E "^[A-Za-z]" data/wunsch.txt \
	| $(DBAT) -m csv -s "\t" -r wunsch
	$(DBAT) -4 wunsch
	$(DBAT) -n wunsch
#----
kv_extrakt: # Informationen aus den KV-Emails extrahieren
	perl mail_extrakt.pl $(MAILS) \
	| sort \
	| tee data/$@.tmp
kvmail: kv_extrakt # Informationen aus den KV-Emails speichern
	$(DBAT) -f sql/kvmail.create.sql 
	grep -E "^[A-Za-z]" data/kv_extrakt.tmp \
	| $(DBAT) -m csv -s "\t" -r kvmail
	$(DBAT) -4 kvmail
	$(DBAT) -n kvmail
#----
check_wunsch:
	$(DBAT) "SELECT SUBSTR(vorname,1,4),vm,status,bemerk FROM wunsch WHERE LENGTH(vm) < 14"
vm_count:
	$(DBAT) -x "SELECT SUBSTR(vm,1,14) FROM wunsch WHERE LENGTH(vm) >= 14" \
	| tee x.tmp \
	| perl -ne 's/\-//g; print join("\n", split(//)) . "\n"; '\
	| grep -E "[A-Z0-9]" | sort | uniq -c
vmc: # Vermittlungscodes
	$(DBAT) -f vmc.create.sql 
	grep -vE "^#" vmc.man \
	| $(DBAT) -r  vmc
	$(DBAT) -4 vmc
	$(DBAT) -n vmc
#----
vms:
	find pending | xargs -l -innn grep -C1 "/suche/" "nnn" | sed -e "s/\-\=//" \
	| tee vms.txt
mails:
	grep -A2 -E "^Date\:|Ihr Impftermin\:|Ihr Vermittlungscode\:|Gebuchter Impfstoff\:" $(MAILS)
show_mails:
	less $(MAILS)
greport:
	grep -P "^  *[0-9]{5} " $(MAILS)

	