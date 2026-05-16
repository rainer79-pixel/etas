---
name: skill-spring-vue-projekt-tava
description: Kodeerimistavad Spring Boot + Vue 3 õppeprojektide jaoks — pakettstruktuur, nimetamised, keerukustase. Kasuta alati kui lisad uut koodi projekti või teed koodi review-d.
---

# Spring Boot + Vue 3 projekt — kodeerimistavad

Kasuta neid tavasid järjepidevalt igas sessioonis. Ära paku keerulisemaid lahendusi kui lihtsamatega saab hakkama.

---

## Skill käivitamisel — tee alati esmalt see

**Enne kui midagi teed**, küsi kasutajalt:

> "Tere! Enne kui alustan — kas sul on soove, kommentaare või midagi, millele tahaksid tähelepanu pöörata?"

Oota vastust. Kui kasutaja ütleb midagi konkreetset (nt "tahan review-d" või "lisa uus feature X"), tegutse vastavalt. Kui kasutaja ütleb "ei" või "alusta", liigu edasi.

---

## Review režiim

Kui kasutaja soovib **review-d**, vaata üle järgmised kategooriad ja raporteeri leitud probleemid:

### Mida kontrollida

**1. Failide asukohad ja nimetused**
- Controller on `controller/{domain}/{Domain}Controller.java`?
- DTO-d on `controller/{domain}/dto/` all?
- Service on `service/{Domain}Service.java`?
- Entity, Repository, Mapper on koos `persistence/{domain}/` all?
- Exception klassid on `infrastructure/exception/` all?
- `ApiError`, `ErrorResponse` on `infrastructure/error/` all?
- Vue view-d on `views/{Domain}View.vue`?
- Pinia store-d on `stores/{domain}Store.js`?

**2. Klasside ja failide nimetused**
- Klassid: `PascalCase` — `LoginController`, `LocationService`, `UserMapper`
- Meetodid ja väljad: `camelCase`
- Pakettide nimed: `lowercase` — `controller`, `persistence`, `locationimage`
- DTO nimed: lõpevad `Dto` või `ResponseDto`-ga
- Vue failid: `{Domain}View.vue`, `{Domain}Store.js`, route nimed `{domain}Route`

**3. Struktuur ja seosed**
- Controller süstib ainult Service-t (mitte Repository-t ega Mapper-it)?
- Service süstib Repository-t ja Mapper-it (mitte teisi Service-id ilma põhjuseta)?
- Mapper on `persistence/{domain}/` all, mitte `service/` all?
- `@RequiredArgsConstructor` kasutusel (mitte `@Autowired`)?

**4. Entity tava**
- Lombok: `@Getter @Setter` (mitte `@Data`)?
- Suhteväljad: `FetchType.LAZY`?
- Status väli: `String`, mitte enum?

**5. DTO tava**
- Lombok: `@Data @NoArgsConstructor @AllArgsConstructor`?

**6. Mapper tava**
- `@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE, componentModel = MappingConstants.ComponentModel.SPRING)`?
- Suhteväljad (`id`, seotud entity): `@Mapping(ignore = true, ...)`?

**7. Service meetodite struktuur**
- Avalikud meetodid lühikesed (3–7 rida), delegeerivad privaatsetele?
- Privaatmeetodite nimed järgivad mustreid (`createAndSave*`, `handle*`, `ensure*`, `is*`)?

**8. Exception ja error handling**
- Custom exception laiendab `RuntimeException`, omab `message` ja `errorCode` välju?
- `ErrorResponse` enum sisaldab veakoodid?
- `RestExceptionHandler` käsitleb kõik custom exception-id?

**9. Controller tava**
- Kõigil endpoint-idel `@Operation` + `@ApiResponses`?
- Error response viitab `ApiError.class`?
- URL algab `/api/`?

**10. Vue tava**
- Options API (`data()`, `methods`) — mitte `<script setup>`?
- Axios kasutab `this.$axios`?
- Error catch suunab `/error` route-ile?

### Raporti formaat

Esita leitud probleemid kategooriate kaupa:

```
✅ Failide asukohad ja nimetused — kõik korras
⚠️  Struktuur ja seosed
   - LocationService süstib CityRepository otse, aga CityRepository peaks olema teenuse enda repository
✅ Entity tava — kõik korras
❌ Mapper tava
   - UserMapper puudub componentModel = SPRING
   - UserMapper: id väli pole @Mapping(ignore = true) märgitud
```

Lõpus lühike kokkuvõte: mitu probleemi leiti ja mis on kõige kriitilisem.

---

---

## Backend — Spring Boot (Java 21, Gradle)

### Tehnoloogiad
- Spring Boot 4.x, Spring Data JPA, Spring Validation
- PostgreSQL, MapStruct 1.6, Lombok, Springdoc OpenAPI 3.x, p6spy
- Build: Gradle

### Pakettstruktuur

```
ee.bcs.{projekt}/
  controller/
    {domain}/
      {Domain}Controller.java
      dto/
        {Domain}Dto.java
        {Domain}ResponseDto.java
  service/
    {Domain}Service.java
  persistence/
    {domain}/
      {Domain}.java           ← JPA entity
      {Domain}Repository.java
      {Domain}Mapper.java
  infrastructure/
    RestExceptionHandler.java
    error/
      ApiError.java
      ErrorResponse.java      ← enum veakoodidega
    exception/
      {Type}Exception.java
  Status.java                 ← enum (ACTIVE, SOFT_DELETED)
```

### Entity tava
```java
@Getter @Setter @Entity @Table(name = "...", schema = "bank")
public class Foo {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "bar_id", nullable = false)
    private Bar bar;

    @NotNull @Size(max = 255)
    @Column(name = "name", nullable = false)
    private String name;

    @NotNull
    @Column(name = "status", nullable = false, length = Integer.MAX_VALUE)
    private String status;
}
```
- Suhteväljad: `FetchType.LAZY`
- Status: `String` väli, väärtus tuleb `Status` enum-ist (`Status.ACTIVE.getCode()`)
- Lombok: `@Getter @Setter` (mitte `@Data`)

### DTO tava
```java
@Data @NoArgsConstructor @AllArgsConstructor
public class FooResponseDto {
    private Integer fooId;
    private String fooName;
}
```

### Mapper tava (MapStruct)
```java
@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE,
        componentModel = MappingConstants.ComponentModel.SPRING,
        imports = {Status.class})
public interface FooMapper {
    @Mapping(source = "id", target = "fooId")
    @Mapping(source = "name", target = "fooName")
    FooResponseDto toFooResponseDto(Foo foo);

    List<FooResponseDto> toFooResponseDtos(List<Foo> foos);

    @Mapping(ignore = true, target = "id")
    @Mapping(ignore = true, target = "bar")
    @Mapping(expression = "java(Status.ACTIVE.getCode())", target = "status")
    Foo toFoo(FooDto fooDto);
}
```

### Repository tava
```java
public interface FooRepository extends JpaRepository<Foo, Integer> {
    @Query("select f from Foo f where (0 = :barId) OR (f.bar.id = :barId) order by f.name")
    List<Foo> findFoosBy(Integer barId);
}
```
- Kohandatud päringud: JPQL `@Query` + meetod `findXxxBy(param)`

### Service tava — meetodite struktuur

**Avalikud meetodid** on lühikesed (3–7 rida), delegeerivad privaatsetele:
```java
@Transactional
public void addFoo(FooDto fooDto) {
    Foo foo = createAndSaveFoo(fooDto);
    handleFooImage(fooDto, foo);
}

public List<FooResponseDto> findFoos(Integer barId) {
    List<FooResponseDto> dtos = getFooResponseDtos(barId);
    addRelatedData(dtos);
    return dtos;
}
```

**Privaatmeetodite nimetamised:**

| Muster | Kasutus |
|--------|---------|
| `createAndSave{Entity}` | loo + salli (tagastab entity) |
| `create{Entity}` | loo objekt ilma salvestamata |
| `handle{Something}` | tingimuslik toiming (kui X, siis Y) |
| `ensure{Condition}` | valideeri + viska exception |
| `validate{Condition}` | valideeri + viska exception |
| `is{Condition}` (static) | boolean kontroll |
| `get{Something}` | teisenda / kogu andmed |
| `add{Something}To{Entity}` | lisa seos entiteedile |

### Exception tava
```java
@Getter
public class ForbiddenException extends RuntimeException {
    private final String message;
    private final Integer errorCode;
    public ForbiddenException(String message, Integer errorCode) {
        super(message);
        this.message = message;
        this.errorCode = errorCode;
    }
}
```
```java
@Getter
public enum ErrorResponse {
    INCORRECT_CREDENTIALS("Vale kasutajanimi või parool", 111),
    DATA_NOT_FOUND("Andmeid ei leitud", 222);

    private final String message;
    private final Integer errorCode;
    ErrorResponse(String message, Integer errorCode) { ... }
}
```
- Veakoodid on numbrid (111, 222, 333...)
- `RestExceptionHandler extends ResponseEntityExceptionHandler` käsitleb kõik

### Controller tava
```java
@RestController @RequestMapping("/api") @RequiredArgsConstructor
public class FooController {
    private final FooService fooService;

    @PostMapping("/foo")
    @Operation(summary = "...", description = "...")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "403", description = "...",
                    content = @Content(schema = @Schema(implementation = ApiError.class)))})
    public void addFoo(@RequestBody FooDto fooDto) {
        fooService.addFoo(fooDto);
    }
}
```
- Kõigil endpoint-idel on `@Operation` + `@ApiResponses`
- Error response alati `ApiError.class` schemaga
- URL: `/api/{resource}` (ilma versiooninumbrita)

---

## Frontend — Vue 3 + Vite

### Tehnoloogiad
- Vue 3 (Options API — `data()`, `methods`, `computed`, `watch`)
- Vue Router 5, Pinia 3, Axios
- Bootstrap 5, @phosphor-icons/vue
- Build: Vite, dev port 8081

### Vue komponent — kirjutamise tava

**Kasuta alati Options API** — mitte `<script setup>` ega Composition API:
```vue
<template>
  <div class="container">
    ...
  </div>
</template>

<script>
export default {
  name: 'FooView',
  data() {
    return {
      foos: [],
      selectedId: null,
    }
  },
  methods: {
    async loadFoos() {
      const response = await this.$axios.get('/api/foos')
      this.foos = response.data
    },
  },
  async mounted() {
    await this.loadFoos()
  },
}
</script>
```

### Failistruktuur
```
src/
  App.vue              ← navbar + RouterView
  main.js              ← app init, Pinia, Router, Bootstrap, Axios globalprops
  router/
    index.js           ← route nimed: {domain}Route (nt loginRoute, homeRoute)
  stores/
    {domain}Store.js   ← Pinia store
  views/
    {Domain}View.vue   ← lehekülje komponent
  components/          ← (lisatakse vajaduse korral)
    {Domain}{Type}.vue
  assets/
    style.css
```

### Router tava
```js
{
  path: '/foo',
  name: 'fooRoute',
  component: FooView,
}
```
- Route nimed: camelCase + `Route` lõpus (`loginRoute`, `homeRoute`)

### Pinia store tava
```js
export const useFooStore = defineStore('foo', () => {
  const userId = ref(null)
  const roleName = ref(null)

  function setUser(id, role) {
    userId.value = id
    roleName.value = role
  }

  return { userId, roleName, setUser }
})
```

### Axios tava
- Axios on `app.config.globalProperties.$axios` kaudu saadaval
- Proxy: `/api` → backend (`http://localhost:8080` või mock URL)
- Error handling: `try/catch` koos `this.$router.push('/error')`

```js
async addFoo(fooDto) {
  try {
    await this.$axios.post('/api/foo', fooDto)
  } catch (error) {
    this.$router.push('/error')
  }
},
```

### Bootstrap 5 tava
- Layout: `container > row > col`
- Komponendid: `card`, `form`, `table table-striped`, `btn btn-primary`
- Navbar: `navbar navbar-expand-lg navbar-dark bg-dark`

---

## Üldised keerukuse reeglid

1. **Esmalt lihtne** — for-each > stream, eksplitsiitne > lühike
2. **Meetodid väikesed** — avalik meetod 3–7 rida, delegeerib privaatsetele
3. **Keerulisem lahendus ainult siis** kui lihtsam ei kata vajadust
4. **Ei kasuta** static utiliidiklasse, factory patternt, DI konfiguratsioone kui pole hädavajalik
5. **Kommentaarid** ainult kui "miks" pole koodist arusaadav — vaikimisi ei kirjuta

---

## Kombineeritud projekt (back + front koos)

Ühe IntelliJ projekti puhul kus on nii back kui front:
- Backend: `src/main/java/...` (Spring Boot struktuur)
- Frontend: `frontend/src/...` või eraldi moodul
- Proxy seadistus: Vite proxy `/api` → `http://localhost:8080`
- Back käivitub port 8080, front port 8081
