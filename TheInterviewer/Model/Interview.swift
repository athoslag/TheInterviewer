//
//  Interview.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 29/07/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

final class Interview {
    
    typealias Section = (title: String, questions: [QuestionPair])
    
    let title: String
    var parts: [(title: String, sections: [Section])]
    
    init(title: String) {
        self.title = title
        self.parts = []
    }
    
    init() {
        self.title = "Default Interview"
        self.parts = [("Análise Quantitativa",
                       [
                        ("Sobre o negócio",
                         [
                            QuestionPair(question: "Nome da empresa", answer: nil),
                            QuestionPair(question: "Área de atuação", answer: nil),
                            QuestionPair(question: "Quantidade de funcionários", answer: nil),
                            QuestionPair(question: "Contato", answer: nil),
                            QuestionPair(question: "Observações", answer: nil)
                        ]),
                        ("Sobre o interlocutor",
                         [
                            QuestionPair(question: "Nome do entrevistado", answer: nil),
                            QuestionPair(question: "Cargo do entrevistado", answer: nil),
                            QuestionPair(question: "Tempo de empresa", answer: nil),
                            QuestionPair(question: "Contato do entrevistado", answer: nil)
                        ]),
                        ("Sobre a entrevista",
                         [
                            QuestionPair(question: "Quantos fluxos serão cobertos nessa entrevista", answer: nil),
                            QuestionPair(question: "Quais fluxos serão os fluxos analisados nesta entrevista", answer: nil),
                            QuestionPair(question: "Relação do entrevistado com cada fluxo", answer: nil)
                        ])
                    ]),
                    ("Análise Qualitativa",
                     [
                        ("Início",
                         [
                            QuestionPair(question: "Você é a pessoa correta para esclarecer o fluxo que será analisado?", answer: nil),
                            QuestionPair(question: "As suas respostas são 'oficiais'?", answer: nil),
                            QuestionPair(question: "Qual é o objetivo deste fluxo?", answer: nil),
                            QuestionPair(question: "Quem são os atores envolvidos neste processo? (atores primários e secundários)", answer: nil),
                            QuestionPair(question: "Quais são os objetivos de cada ator dentro deste fluxo?", answer: nil),
                            QuestionPair(question: "Suposição inicial (montar cenário)", answer: nil)
                        ]),
                        ("Sunny days (caso esperado / normal)",
                         [
                            QuestionPair(question: "Pré-requisitos: o que é necessário para que este fluxo ocorra?", answer: nil),
                            QuestionPair(question: "Caso normal: quais são os processos, dentro da situação esperada?", answer: nil),
                            QuestionPair(question: "(repetir) Para cada atividade, anotar quem faz o quê, com qual pré-condição, e com que objetivo.", answer: nil),
                            QuestionPair(question: "Observações", answer: nil)
                        ]),
                        ("Rainy days (exceções)",
                         [
                            QuestionPair(question: "O que pode dar errado?", answer: nil),
                            QuestionPair(question: "(repetir) Para cada caso, que procedimento será tomado?", answer: nil),
                            QuestionPair(question: "Como casos inesperados são resolvidos?", answer: nil),
                            QuestionPair(question: "Observações", answer: nil)
                        ]),
                        ("Fechamento / Conclusão",
                         [
                            QuestionPair(question: "Qual é o estado esperado do sistema na conclusão?", answer: nil),
                            QuestionPair(question: "Atividades relacionadas", answer: nil),
                            QuestionPair(question: "Alguma outra pessoa poderia me prestar informações adicionais?", answer: nil),
                            QuestionPair(question: "Eu deveria lhe perguntar algo mais?", answer: nil),
                            QuestionPair(question: "Observações", answer: nil)
                        ])
                    ])
                ]
    }
}
