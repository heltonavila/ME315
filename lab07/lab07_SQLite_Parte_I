---
title: "lab07 RSQLite"
date: "3 de outubro de 2018"
output: html_document
---

```{r, eval=FALSE}
options(install.packages.check.source = "no")
pkgs = c('tidyverse', 'maps', 'RColorBrewer', 
         'rmarkdown', 'knitr', 'caTools', 'tidyr',
         'jsonlite', 'dplyr', 'tibble', 'digest',
         'magrittr', 'tidyr', 'formatR', 'RSQLite')
install.packages(pkgs, type='win.binary')

library("tidyverse")
```

##1
Baixe o arquivo disco.db e armazene na variável path o caminho completo (pasta) na qual o arquivo foi gravado. Utilize o comando  file.path() para combinar a variável path com o nome do arquivo (disco.db) e obter o nome do arquivo com seu respectivo caminho. Armazene este resultado na variável fname.

```{r}
path <- "C:/Users/137408/Downloads"

fname <- file.path(path, "disco.db")
```

##2
Utilizando o pacote RSQLite, conecte-se ao arquivo de banco de dados. Armazene a conexão na variável conn.

```{r}
library("RSQLite")

conn = dbConnect(SQLite(), fname)
```

##3
Liste as tabelas existentes no banco de dados.

```{r}
dbListTables(conn)
```

##4
Identifique os nomes de todas as colunas existentes na tabela customers.

```{r}
dbListFields(conn, "customers")
```

##5
Utilizando apenas SQLite, com o apoio do comando dbGetQuery, identifique quantos clientes estão atualmente cadastrados neste banco de dados.

```{r}
dbGetQuery(conn, "SELECT COUNT(CustomerId) FROM customers")
```

##6
Utilizando apenas SQLite, identifique o número de países diferentes em que moram os clientes encontrados acima.

```{r}
#dbGetQuery(conn, "SELECT COUNT(Country) FROM (SELECT DISTINCT Country FROM customers)")

dbGetQuery(conn, "SELECT COUNT(DISTINCT Country) FROM Customers")
```

##7
Utilizando apenas SQLite, quantos clientes existem por país? A tabela resultante deve conter o nome do país e a respectiva contagem, além de ser ordenada de maneira decrescente pela referida contagem.

```{r}
dbGetQuery(conn, "SELECT Country, COUNT(CustomerId) FROM customers GROUP BY Country ORDER BY -COUNT(CustomerId)")
```

##8
Quais são os 5 países com mais clientes registrados? Use apenas SQLite.

```{r}
dbGetQuery(conn, "SELECT Country, COUNT(CustomerId) FROM customers GROUP BY Country ORDER BY -COUNT(CustomerId) LIMIT 5")
```

##9
Quais são os países registrados que possuem apenas 6 letras no nome?

```{r}
dbGetQuery(conn, "SELECT DISTINCT Country FROM customers WHERE Country GLOB '??????'")
```

##10
Quais foram as músicas compradas por clientes brasileiros?

```{r}
dbGetQuery(conn, "
           SELECT DISTINCT Name 
            FROM tracks
              INNER JOIN invoice_items
                ON tracks.TrackId = invoice_items.TrackId
              INNER JOIN invoices 
                ON invoice_items.InvoiceId = invoices.InvoiceId
              INNER JOIN customers ON invoices.CustomerId = customers.CustomerId
            WHERE customers.Country = 'Brazil'
            ORDER BY Name
           ")

```

##11
Desconecte do banco de dados.

```{r}
dbDisconnect(conn)
```

