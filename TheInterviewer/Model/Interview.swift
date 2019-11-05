//
//  Interview.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 29/07/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

final class Interview: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case title
        case parts
    }
    
    enum InterviewModel {
        case bpm
        case test
    }
    
    var title: String
    var parts: [Part]
    let date: Date = Date()
    
    var primaryKey: String {
        return title.convertedToSlug() ?? "Interview"
    }
    
    init(title: String, parts: [Part] = []) {
        self.title = title
        self.parts = parts
    }
    
    init(_ model: InterviewModel) {
        switch model {
        case .bpm:
            self.title = "Minha entrevista"
            self.parts =
                [
                    Part(title: "Análise Quantitativa", sections:
                        [
                            Section(title: "Sobre o negócio", questionPairs:
                                [
                                    QuestionPair(question: "Nome da empresa", answer: nil, type: .name),
                                    QuestionPair(question: "Área de atuação", answer: nil, type: .short),
                                    QuestionPair(question: "Quantidade de funcionários", answer: nil, type: .number),
                                    QuestionPair(question: "Contato", answer: nil, type: .short),
                                    QuestionPair(question: "Observações", answer: nil, type: .long)
                                ]
                            ),
                            Section(title: "Sobre o interlocutor", questionPairs:
                                [
                                    QuestionPair(question: "Nome do entrevistado", answer: nil, type: .name),
                                    QuestionPair(question: "Cargo do entrevistado", answer: nil, type: .short),
                                    QuestionPair(question: "Formação do entrevistado", answer: nil, type: .short),
                                    QuestionPair(question: "Tempo de empresa", answer: nil, type: .short),
                                    QuestionPair(question: "Contato do entrevistado", answer: nil, type: .short)
                                ]
                            ),
                            Section(title: "Sobre a entrevista", questionPairs:
                                [
                                    QuestionPair(question: "Qual(is) fluxo(s) será(ão) analisado(s) nesta entrevista?", answer: nil, type: .long),
                                    QuestionPair(question: "Qual a relação do entrevistado com cada fluxo?", answer: nil, type: .long)
                                ]
                            )
                        ]
                    ),
                    Part(title: "Análise Qualitativa", sections:
                        [
                            Section(title: "Início", questionPairs:
                                [
                                    QuestionPair(question: "Você é a pessoa correta para esclarecer o fluxo que será analisado?", answer: nil, type: .short),
                                    QuestionPair(question: "As suas respostas são 'oficiais'?", answer: nil, type: .short),
                                    QuestionPair(question: "Qual é o objetivo deste fluxo?", answer: nil, type: .long),
                                    QuestionPair(question: "Quem são os atores envolvidos neste processo? (atores primários e secundários)", answer: nil, type: .long),
                                    QuestionPair(question: "Quais são as metas (objetivos) do ator dentro deste fluxo, para cada ator?", answer: nil, type: .long),
                                    QuestionPair(question: "Suposição inicial (montar cenário)", answer: nil, type: .long)
                                ]
                            ),
                            Section(title: "Sunny days (caso esperado / normal)", questionPairs:
                                [
                                    QuestionPair(question: "Pré-requisitos: o que precisa acontecer para que o fluxo em questão ocorra?", answer: nil, type: .long),
                                    QuestionPair(question: "Caso normal: quais são os processos, dentro da situação esperada?", answer: nil, type: .long),
                                    QuestionPair(question: "Quais são as principais tarefas ou funções realizadas por cada ator?", answer: nil, type: .long),
                                    QuestionPair(question: "Para cada atividade, qual é a pré-condição, qual é o objetivo e quem é o ator?", answer: nil, type: .long),
                                    QuestionPair(question: "Observações", answer: nil, type: .long)
                                ]
                            ),
                            Section(title: "Rainy days (exceções)", questionPairs:
                                [
                                    QuestionPair(question: "O que pode dar errado? E que procedimento será tomado, neste caso?", answer: nil, type: .long),
                                    QuestionPair(question: "Descreva novamente o fluxo. Que exceções deveriam ser consideradas, à medida que o fluxo é descrito?", answer: nil, type: .long),
                                    QuestionPair(question: "Como casos inesperados são resolvidos?", answer: nil, type: .long),
                                    QuestionPair(question: "Observações", answer: nil, type: .long)
                                ]
                            ),
                            Section(title: "Fechamento / Conclusão", questionPairs:
                                [
                                    QuestionPair(question: "Qual é o estado esperado do sistema, quando o fluxo terminar? O que mudou?", answer: nil, type: .long),
                                    QuestionPair(question: "Quais são as atividades relacionadas a este processo?", answer: nil, type: .long),
                                    QuestionPair(question: "Alguma outra pessoa poderia me prestar informações adicionais?", answer: nil, type: .long),
                                    QuestionPair(question: "Eu deveria lhe perguntar algo mais?", answer: nil, type: .long),
                                    QuestionPair(question: "Observações", answer: nil, type: .long)
                                ]
                            )
                        ]
                    )
            ]
        case .test:
            self.title = "Entrevista de teste"
            self.parts =
                [
                    Part(title: "Parte 1", sections:
                        [
                            Section(title: "Seção 1", questionPairs:
                                [
                                    QuestionPair(question: "Questão 1", answer: nil, type: .name),
                                    QuestionPair(question: "Questão 2", answer: nil, type: .long)
                                ]),
                            Section(title: "Seção 2", questionPairs:
                                [
                                    QuestionPair(question: "Questão 3", answer: nil, type: .long),
                                ])
                        ]),
                    Part(title: "Parte 2", sections:
                        [
                            Section(title: "Seção 3", questionPairs:
                                [
                                    QuestionPair(question: "Questão 4", answer: nil, type: .long),
                                    QuestionPair(question: "Questão 5", answer: nil, type: .long)
                                ])
                        ])
                ]
        }
    }
    
    static func decode(from data: Data) throws -> Interview {
        let decoder = JSONDecoder()
        return try decoder.decode(Interview.self, from: data)
    }
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}

extension Interview {
    func description() {
        print(title)
        for part in parts {
            print("  " + part.title)
            for section in part.sections {
                print("    " + section.title)
                for question in section.questionPairs {
                    print("      " + question.question + ": " + (question.answer ?? ""))
                }
            }
        }
        
        print("")
    }
}
