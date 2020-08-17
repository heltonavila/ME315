---
title: "Lab08"
date: "10 de outubro de 2018"
output: html_document
---

```{r eval=FALSE}
options(install.packages.check.source = "no")
pkgs = c('tidyverse', 'rmarkdown', 'knitr', 'caTools', 
         'jsonlite', 'magrittr', 'RSQLite')
install.packages(pkgs, type='win.binary')
```

```{r warning=FALSE}
library("tidyverse")
library("RSQLite")
```

#Atividade

##1
Baixe o arquivo uwmadison.sqlite3, e conecte-se a ele usando o pacote RSQLite, armazenando a conexão em uma variável conn.
```{r}
  path <- "C:/Users/137408/Downloads"
  db <- file.path(path, "uwmadison.sqlite3")
    conn <- dbConnect(SQLite(), db)
```

##2
Liste as tabelas existentes no banco de dados. Executando um query, tente olhar o cabeçalho das tabelas. Identifique as tabelas que contém:
 - Nomes das disciplinas (e uuid) – por exemplo, “Cooperative Education Program” tem uuid “a3e3e1c3-543d-3bb5-ae65-5f2aec4ad1de”.
 - Oferecimento das disciplinas (uuid indicando o oferecimento, course_uuid indicando o cursO).
 - Departamentos de disciplinas (code e abreviação) – por exemplo, “Statistics” tem abreviação “STAT”.
 - Conexão entre assunto (subject_code) e oferecimento (course_offering_uuid).
 - Distribuição das notas (conceitos: A, AB, B, BC, C, D, F) e id da oferta do curso.
 - Instrutores da disciplina (e id).
 - Quais instrutores lecionaram para quais seções.

```{r}
#Liste as tabelas existentes no banco de dados.
  dbListTables(conn)

#uuid e nomes das disciplinas
  dbGetQuery(conn, "SELECT * FROM courses LIMIT 6")
  
#Oferecimento das disciplinas
  dbGetQuery(conn, "SELECT * FROM course_offerings LIMIT 6")
  
#Departamentos de disciplinas
  dbGetQuery(conn, "SELECT * FROM subjects LIMIT 6")
  
#Conexão entre assunto
  dbGetQuery(conn, "SELECT * FROM subject_memberships LIMIT 6")
  
#Distribuição das notas
  dbGetQuery(conn, "SELECT * FROM grade_distributions LIMIT 6")

#Instrutores da disciplina
  dbGetQuery(conn, "SELECT * FROM instructors LIMIT 6")
  
#Quais instrutores lecionaram para quais seções
  dbGetQuery(conn, "SELECT * FROM teachings LIMIT 6")
  
#Outros
  dbGetQuery(conn, "SELECT * FROM rooms LIMIT 6")
  dbGetQuery(conn, "SELECT * FROM schedules LIMIT 6")
  dbGetQuery(conn, "SELECT * FROM sections LIMIT 6")

```

##4
Procure a chave code das disciplinas de estatística na tabela subjects, usando uma consulta em SQL.
```{r}
  dbGetQuery(conn, "SELECT code FROM subjects WHERE name = 'Statistics'")

```

##5
Busque na tabela subject_memberships as seções de cursos do departamento de estatística, e escreva no banco de dados essa tabela com o nome statistics_sec. você pode usar o comando "CREATE TABLE statistics_sec AS ...".
```{r}
dbExecute(conn, "DROP TABLE statistics_sec")

  dbExecute(conn, "
  CREATE TABLE statistics_sec AS
    SELECT * FROM subject_memberships
      WHERE subject_code = 932
  ")
  
  dbGetQuery(conn, "SELECT * FROM statistics_sec LIMIT 6")

```

##6
Na tabela course_offerings, faça um INNER JOIN dos resultados da tabela anterior com o uuid da tabela course_offerings, e extraia o  name e uuid da tabela course_offerings (não salve os resultados da tabela anterior no R; faça o LEFT JOIN no SQL, referenciando a tabela que você criou no item anterior). Salve os resultados num objeto cursos, do R.
```{r}
cursos <- dbGetQuery(conn,
           "SELECT name, uuid 
              FROM course_offerings INNER JOIN statistics_sec
                ON course_offerings.uuid = statistics_sec.course_offering_uuid"
           )

```

##7
Faça um INNER JOIN das tabelas sections e statistics_sec, comparando course_offering_uuid em ambas. Guarde numa tabela  stats_sec_only. Faça um INNER JOIN das tabelas teachings e sections, conectando a chave section_uuid com a chave uuid da tabela sections, mas agora guardando a instructor_id da tabela teachings junto com a course_offering_uuid da tabela sections. Salve essa tabela numa nova tabela stats_teachers.
```{r}
dbExecute(conn, "DROP TABLE stats_sec_only")
dbExecute(conn, "
          CREATE TABLE stats_sec_only AS
            SELECT * 
              FROM sections INNER JOIN statistics_sec 
                ON sections.course_offering_uuid = statistics_sec.course_offering_uuid
          ")

dbGetQuery(conn, "SELECT * FROM stats_sec_only LIMIT 6")


dbExecute(conn, "DROP TABLE stats_teachers")
dbExecute(conn, "
          CREATE TABLE stats_teachers AS
            SELECT instructor_id, course_offering_uuid
              FROM teachings INNER JOIN sections
                ON teachings.section_uuid = sections.uuid
          ")

dbGetQuery(conn, "SELECT * from stats_teachers LIMIT 6")
```

##8
Repita o item 6, conecte a id dos instrutores de estatística (estão na tabela instructors) com a instructor_id que ficou na tabela  stats_teachers. Salve a tabela com name e course_offering_uuid num objeto professores, do R.
```{r}
professores <- dbGetQuery(conn, "
                          SELECT name, course_offering_uuid
                            FROM instructors INNER JOIN stats_teachers
                              ON instructors.id = stats_teachers.instructor_id
                          ")
```

Usando um join apropriado do R, faça uma tabela de quem ensinou qual curso na UW-Madison.
```{r}
ProfDisc <- inner_join(professores, cursos, by = c("course_offering_uuid" = "uuid"))
```

Escreva código que destrua as tabelas "stats_teachers". "stats_sec_only" e "statistics_sec". Desconecte do banco de dados.
```{r}
dbExecute(conn, "DROP TABLE stats_teachers")
dbExecute(conn, "DROP TABLE stats_sec_only")
dbExecute(conn, "DROP TABLE statistics_sec")

dbDisconnect(conn)
```

(exercício não-obrigatório): O GPA americano é definido numa escala de 0 a 4, em que A = 4, AB = 3.5, B = 3, BC = 2.5, C = 2, D = 1 e F = 0. As notas estão disponíveis na tabela grade_distributions. Fazendo a ponderação por números, você consegue dizer quem é o professor mais difícil da UW-Madison, no departamento de estatística? E qual o curso mais difícil? E os cursos mais fáceis?
```{r}

```

