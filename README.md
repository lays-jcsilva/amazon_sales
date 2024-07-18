# 📊📈 🛒Análise de dados na empresa Amazon

💡 Projeto: Amazon Sales -  Fatores Influenciadores nas Avaliações de Produtos na Amazon

Bem-vindo(a) à ficha técnica da análise de dados!!

A Amazon enfrenta o desafio contínuo de entender os fatores que influenciam a pontuação e a classificação dos produtos em sua plataforma. Com uma vasta gama de produtos e um volume significativo de avaliações de clientes, identificar os padrões e as correlações entre diferentes variáveis pode proporcionar insights valiosos para melhorar a satisfação do cliente e aumentar as vendas.


# Título do Projeto
Fatores Influenciadores nas Avaliações de Produtos


# Objetivo
  
O objetivo desta análise é identificar e compreender os principais fatores que influenciam a pontuação e a classificação dos produtos na plataforma da Amazon, a análise busca revelar correlações entre o preço com desconto o número de avaliações e a classificação dos produtos. Esses insights ajudarão a Amazon a aprimorar suas estratégias de marketing e a melhorar a satisfação do cliente.

Este projeto reveste-se de uma importância crucial para o banco Super Caja pois a equipe de análise de crédito
</details>

# Equipe

* Lays Silva
* Nicole Machado Corrêa

</details>

# 💻📉Ferramentas e Tecnologias


* BigQuery(Linguagem SQL)

* Google Colab(Linguagem Python)
  
* Looker Studio


</details>


# Dados utilizados na análise
* Amazon_product: A tabela amazon_product contém informações detalhadas sobre os produtos disponíveis na plataforma da Amazon. Esta tabela é fundamental para analisar a diversidade de produtos, suas categorias, os preços aplicados, e o impacto dos descontos no comportamento de compra dos consumidores.
* Amazon_review: contém avaliações de usuários sobre os produtos disponíveis na plataforma da Amazon. Esta tabela é essencial para entender a percepção dos clientes sobre os produtos, analisar as classificações e identificar padrões nas avaliações, contribuindo para melhorar a experiência do cliente e a qualidade dos produtos oferecidos.

# Processamento dos dados e técnicas de análise
  
* Manipulação e limpeza dos dados: Utilizando o processo de ETL (Extract, Transform, Load) no BigQuery, realizamos a limpeza e manipulação dos dados. Removemos valores nulos, duplicados e inconsistências, criamos  novas variáveis, o cálculo de quartis e segmentação.  As variáveis foram convertidas em dummies para a construção da análise de sentimento

* Visualização Interativa da Análise: Utilizamos o Power BI para criar gráficos e tabelas interativas que facilitam a visualização e compreensão da análise realizada.
  
* Testes Estatísticos: realizamos o teste de Shapiro-Wilk para verificar a normalidade dos dados, correlação de Spearman, Teste de Significância (Mann-Whitney) e Regressão linear e Regressão logística.
  
* Processamento de Linguagem Natural (PLN): criamos um score de sentimento para a variável review_content, para análise de sentimentos convertendo sentimentos expressos em palavras em valores numéricos

* Se quiser ver mais detalhes sobre essa etapa, [clique aqui](https://tricolor-puck-1da.notion.site/Projeto-4-Ficha-T-cnica-An-lise-de-Dados-aeed49440a6e4377bd9f168c9f0c65b6).


## Resultados

- **Hipótese 1: Produtos com maior desconto aplicado (discount_percentage) são melhor classificados (rating):**

Os resultados mostraram uma correlação significativa, mas negativa, entre o percentual de desconto aplicado e a classificação dos produtos

A hipótese foi **refutada** e as recomendações são:

💡 Recomendações

- **Avaliar Estratégias de Desconto:** Reconsiderar a aplicação de grandes descontos para produtos que já possuem boas avaliações, pois isso pode ser percebido como uma diminuição do valor percebido pelos consumidores.
- **Análise dos feedbacks dos clientes:** Coletar e analisar feedback detalhado dos clientes sobre como os descontos influenciam suas percepções e decisões de compra. Isso pode ajudar a entender melhor a relação entre preço e percepção de qualidade.

  
- **Hipótese 2: Produtos com mais avaliações positivas (score_sentimento) são melhor classificados (rating):**
  
A correlação de Spearman de 0.2652 indica uma correlação positiva moderada entre score_sentimento e rating. Isso sugere que produtos que recebem mais avaliações positivas tendem a obter classificações mais altas. No entanto, a correlação moderada também indica que outros fatores além do número de avaliações positivas podem estar influenciando significativamente a classificação dos produtos.

A hipótese foi **confirmada** e as recomendações são:

💡 Recomendações

- **Incentivar avaliações positivas:** Implementar estratégias para incentivar os clientes satisfeitos a deixarem avaliações positivas. Isso pode incluir lembretes pós-compra, programas de recompensas, ou incentivos como descontos em compras futuras para aqueles que deixam avaliações.

-**Melhorar a experiência do cliente:** Focar em melhorar a experiência do cliente em todas as etapas do processo de compra. Clientes satisfeitos são mais propensos a deixar avaliações positivas, o que pode, por sua vez, melhorar a classificação dos produtos.



- **Hipótese 3: Produtos com mais avaliações (rating_count) são melhor classificados (rating):**
  

Os resultados indicam uma correlação positiva moderada entre quantidade de avaliações e classificação dos produtos

A hipótese foi **confirmada** e as recomendações são:

💡 Recomendações

- **Responder avaliações:** Manter um diálogo ativo com os clientes respondendo às suas avaliações, especialmente as negativas. Demonstrar que a empresa valoriza o feedback dos clientes pode aumentar a satisfação e lealdade.
- **Implementar melhorias:** Usar o feedback das avaliações para identificar áreas de melhoris. Implementar essas melhorias pode resultar em mais avaliações positivas no futuro.



## Links de Interesse:

- [Google Colab Notebook](https://colab.research.google.com/drive/1LlWu4zeubaB6Qro6K12BId4PJGXEVw2Z?authuser=0#scrollTo=1a-4jcr0zJAi)
- [Documentação Completa](https://tricolor-puck-1da.notion.site/Projeto-4-Ficha-T-cnica-An-lise-de-Dados-aeed49440a6e4377bd9f168c9f0c65b6)




