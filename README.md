# Grafos 1

**Número da Lista**: 1<br>
**Conteúdo da Disciplina**: Grafos<br>

## Alunos
|Matrícula | Aluno |
| -- | -- |
| 17/0019098  |  Matheus Felizola Freires |
| 15/0016310  |  Luis Gustavo Avelino |

## Sobre 
Neste repositório você encontrará um editor de grafos que diz se todos os componentes do grafo desenhado são bipartidos ou não. Cada nó é pintado de acordo com sua camada, de forma alternada. Se houverem dois nós da mesma camada com uma aresta entre eles, o algoritmo detecta isso e classifica o grafo como não bipartido.

Como o algoritmo padrão para detectar a bipartição só faz sentido em grafos conectados, e o editor permite desenhar grafos não-conectados, foi feita uma alteração no algoritmo para que detecte se todos os componentes do grafo (não-direcionado) são bipartidos.


## Screenshots

[![Vídeo do funcionamento](https://img.youtube.com/vi/lizohPcGO3A/0.jpg)](https://www.youtube.com/watch?v=lizohPcGO3A)

![Grafo bipartido](Images/Bipartite-true.png)
![Grafo não-bipartido](Images/Bipartite-false.png)

## Instalação 
**Linguagem**: Swift<br>
**Framework**: SpriteKit<br>

**Pré-requisitos**: XCode 10 ou superior.

## Uso
- Para criar um nó, clique na tela com o botão esquerdo do mouse.
- Para criar uma aresta, clique em um nó, arraste até outro nó, e solte o botão.
- Para apagar o grafo, aperte a barra de espaço.
- Para apagar uma aresta, arreste o mouse para cima da aresta a ser deletada e clique com o botão esquerdo do mouse no botão "x" que vai aparecer em cima da aresta

## Outras informações
Para acessar o trabalho 2 [clique aqui](https://github.com/projeto-de-algoritmos/Trabalhos-1-e-2---Grafos---Luis-Gustavo-Avelino-e-Matheus-Felizola/tree/trabalho2).
