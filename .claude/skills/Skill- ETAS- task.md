# Skill: ETAS Task planeerimisdokument

Sinu ülesanne on koostada ETAS projekti task-ile täielik planeerimisdokument.

Kasutaja annab task numbri argumendina (nt `01`, `02`, `03`). Kui argumenti ei anta, küsi kasutajalt.

---

## Sammud enne kirjutamist

1. **Loe** `docs/tasks/tasks.md` — leia vastav task numbri järgi (branch nimi, raskus, kirjeldus)
2. **Loe** `CLAUDE.md` — API endpointid, rollid, vaadete struktuur, arhitektuuriotsused
3. **Loe** `docs/specs/etas_projektikirjeldus.md` — täpsed DTO struktuurid, JSON näited, veakoodid
4. **Loe** `backend/CLAUDE.md` — entity, mapper, service, controller, repository konventsioonid
5. **Loe** `frontend/CLAUDE.md` — Vue Options API muster, api-services, AuthService, NavigationService
6. **Vaata** kõiki vastavaid Balsamiq PNG faile kaustast `docs/balsamiq/views/` — identifitseeri vaated selle task-i põhjal
7. **Loe** `database/2_create.sql` — vajadusel tabelite struktuur

## Branch loomine

Enne planeerimisdokumendi kirjutamist tuleta kasutajale meelde, et kogu taski töö — nii arendus kui dokumentatsioon — käib eraldi branch-is. Masterisse ei commitita midagi enne kui task on täielikult valmis.

Paluda kasutajal käivitada:
```
git checkout master
git pull
git checkout -b task-XX
```
kus `XX` on tasknumber, nt `task-01`, `task-02`.

Kinnita kasutajalt et branch on loodud enne kui jätkad dokumendi genereerimisega.

---

## Dokumendi loomine

Loo kataloog `docs/tasks/task-XX-nimi/` ning sinna fail `task-XX-nimi.md`.

Kasuta alljärgnevat täpset struktuuri. Täida **kõik** osad konkreetse task info põhjal — ära jäta tühje sektsioone.

---

## Dokumendi struktuur

```markdown
# Task-XX: [Taski pealkiri]

## Mis selles taskis teeme?

[3–5 lausega vabas vormis: mida arendatakse, miks see on vajalik, kuidas see süsteemi tervikusse sobib. Kirjelda nii backend kui frontend poolt — mida kasutaja näeb ja mis toimub taustal. Sobib ka loetelu kui on mitu selget osa.]

**Backend:** [1 lause — millised endpointid / loogika]
**Frontend:** [1 lause — milline vaade / milliseid toiminguid kasutaja teeb]

---

## Ülevaade

| Väli | Väärtus |
|------|---------|
| Branch | `task-XX-nimi` |
| Raskus | X/5 |
| Sõltuvused | [loetelu eelnevatest taskidest millele tugineb] |
| Seisund | Planeeritud |

## Eesmärk

[1–2 lausega: mida see task teeb ja miks see on vajalik süsteemi tervikus]

---

## UI ülevaade

> Põhineb Balsamiq wireframe-il: `docs/balsamiq/views/XxxView.vue.png`

### [XxxView.vue] — `/xxx`

**Lehe struktuur:**
[Kirjelda lehe ülesehitust — pealkiri, sektsioonid, paigutus]

**UI elemendid:**

| Element | Tüüp | Toiming |
|---------|------|---------|
| "Lisa uus X" | Nupp (roheline) | Avab vormi / navigeerib lisamisvaatesse |
| "Salvesta" | Nupp (sinine) | Saadab POST/PUT päringu |
| "Tühista" | Nupp (hall) | Tühistab ja navigeerib tagasi |
| Otsingukast | Input | Filtreerib nimekirja reaalajas |
| Nimekiri | Tabel | Kuvab kirjeid koos tegevusnuppudega |

**Rollipõhised erinevused:**
- Admin näeb: [loetelu]
- User näeb: [loetelu, mis on peidetud]

**Navigatsioon sellest vaatest:**
- [Nupp / link] → [Sihtvaade]

---

## Backend

### Uued failid

| Fail | Kirjeldus |
|------|-----------|
| `controller/xxx/XxxController.java` | REST endpointid |
| `controller/xxx/dto/XxxDto.java` | Sisend DTO |
| `controller/xxx/dto/XxxResponseDto.java` | Vastus DTO |
| `service/XxxService.java` | Äriloogika |
| `persistence/xxx/XxxRepository.java` | Andmebaasi päringud |
| `persistence/xxx/XxxMapper.java` | Entity ↔ DTO teisendus |

### API endpointid

| Meetod | Endpoint | Sisend DTO | Vastus DTO | Õnnestub |
|--------|----------|-----------|-----------|----------|
| POST | `/api/xxx` | `XxxDto` | — | 201 Created |
| GET | `/api/xxx/{id}` | — | `XxxResponseDto` | 200 OK |

### DTO struktuurid

#### [XxxDto] — sisend
```json
{
  "field1": "väärtus",
  "field2": 0
}
```

#### [XxxResponseDto] — vastus
```json
{
  "xxxId": 1,
  "field1": "väärtus"
}
```

### Veateated

| HTTP kood | Olukord | Kasutajale kuvatav sõnum |
|-----------|---------|--------------------------|
| 400 Bad Request | Kohustuslik väli puudub | "Palun täitke kõik kohustuslikud väljad" |
| 403 Forbidden | Puudub roll/õigus | "Teil pole selleks õigust" |
| 404 Not Found | Kirjet ei leitud | "Xxx ei leitud" |
| 409 Conflict | Duplikaat | "Xxx on juba olemas" |

### Olulised ärireeglid backend-is

- [konkreetsed reeglid mis backend peab jõustama]
- [rollide kontroll vajadusel: ainult Admin / kõik kasutajad]

---

## Frontend

### Uued failid

| Fail | URL / asukoht | Kirjeldus |
|------|---------------|-----------|
| `views/XxxView.vue` | `/xxx` | [kirjeldus] |
| `api-services/XxxService.js` | — | API kutsed |

### Wireframe viide

`docs/balsamiq/views/XxxView.vue.png`

[Lühike kirjeldus mida wireframe näitab — põhilised UI elemendid, nupud, tabelid, vormid]

### Komponendi data() struktuur

```javascript
data() {
  return {
    errorMessage: '',
    successMessage: '',
    // konkreetsed andmeväljad selle vaate jaoks
  }
}
```

### API teenuse meetodid (XxxService.js)

| Meetodi nimi | HTTP kutse | Kirjeldus |
|-------------|-----------|-----------|
| `sendGetXxxs()` | `GET /api/xxx` | Laeb nimekirja |
| `sendPostXxx(xxx)` | `POST /api/xxx` | Lisab uue |

### Navigatsioon

- [Kuhu navigeeritakse pärast õnnestumist]
- [Kuhu navigeeritakse tagasi nupul]
- [Millised nupud/lingid viivad siia vaatesse]

### Rollipõhised erinevused UI-s

[Kirjelda mis on nähtav/peidetud Admin vs User rolliga — ainult kui erinev]

---

## Valmiduse kriteeriumid

### Backend
- [ ] Kõik endpointid vastavad Swagger UI-s dokumenteeritud spetsifikatsioonile
- [ ] Mapper teisendab entity ↔ DTO õigesti (kõik väljad kaardistatud)
- [ ] Õiged HTTP vastuskoodid kõigil juhtudel (200/201/400/403/404/409)
- [ ] Rollide kontroll toimib (Admin / User eristus)
- [ ] `@Transactional` kirjutusoperatsioonidel

### Frontend
- [ ] Andmed laadivad korrektselt (`beforeMount`)
- [ ] Vead kuvatakse kasutajale (`errorMessage`)
- [ ] Spinner nähtav päringu ajal
- [ ] Navigatsioon toimib (tagasi, edasi, pärast salvestamist)
- [ ] Rollipõhised nupud peidetud/nähtavad õigesti

---

## Märkused

[Erijuhud, arhitektuuriotsused, teadaolevad keerukused, sõltuvused teistest taskidest]
```

---

## Pärast faili loomist

1. Näita kasutajale loodud faili asukoht
2. Too välja peamised küsimused või kohad mis vajavad täpsustamist
3. Küsi kas dokument on heaks kiidetud enne kui arendusega alustada
4. Tuleta meelde: kogu arendus käib selles branch-is — masterisse läheb kõik koos alles siis kui task on täielikult valmis (backend + frontend + dokumentatsioon)

**NB!** Kui `docs/tasks/task-XX-nimi/` kataloog või fail juba eksisteerib, küsi kasutajalt enne ülekirjutamist.
