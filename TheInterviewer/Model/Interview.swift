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
    
    var title: String
    var parts: [Part]
    let date: Date = Date()
    
    init(title: String, parts: [Part] = []) {
        self.title = title
        self.parts = parts
    }
    
    init() {
        self.title = "Entrevista BPM"
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
                                QuestionPair(question: "Tempo de empresa", answer: nil, type: .short),
                                QuestionPair(question: "Contato do entrevistado", answer: nil, type: .short)
                            ]
                        ),
                        Section(title: "Sobre a entrevista", questionPairs:
                            [
                                QuestionPair(question: "Quantos fluxos serão cobertos nessa entrevista", answer: nil, type: .number),
                                QuestionPair(question: "Quais fluxos serão os fluxos analisados nesta entrevista", answer: nil, type: .long),
                                QuestionPair(question: "Relação do entrevistado com cada fluxo", answer: nil, type: .long)
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
                                QuestionPair(question: "Quais são os objetivos de cada ator dentro deste fluxo?", answer: nil, type: .long),
                                QuestionPair(question: "Suposição inicial (montar cenário)", answer: nil, type: .long)
                            ]
                        ),
                        Section(title: "Sunny days (caso esperado / normal)", questionPairs:
                            [
                                QuestionPair(question: "Pré-requisitos: o que é necessário para que este fluxo ocorra?", answer: nil, type: .long),
                                QuestionPair(question: "Caso normal: quais são os processos, dentro da situação esperada?", answer: nil, type: .long),
                                QuestionPair(question: "(repetir) Para cada atividade, anotar quem faz o quê, com qual pré-condição, e com que objetivo.", answer: nil, type: .long),
                                QuestionPair(question: "Observações", answer: nil, type: .long)
                            ]
                        ),
                        Section(title: "Rainy days (exceções)", questionPairs:
                            [
                                QuestionPair(question: "O que pode dar errado?", answer: nil, type: .long),
                                QuestionPair(question: "(repetir) Para cada caso, que procedimento será tomado?", answer: nil, type: .long),
                                QuestionPair(question: "Como casos inesperados são resolvidos?", answer: nil, type: .long),
                                QuestionPair(question: "Observações", answer: nil, type: .long)
                            ]
                        ),
                        Section(title: "Fechamento / Conclusão", questionPairs:
                            [
                                QuestionPair(question: "Qual é o estado esperado do sistema na conclusão?", answer: nil, type: .long),
                                QuestionPair(question: "Atividades relacionadas", answer: nil, type: .long),
                                QuestionPair(question: "Alguma outra pessoa poderia me prestar informações adicionais?", answer: nil, type: .long),
                                QuestionPair(question: "Eu deveria lhe perguntar algo mais?", answer: nil, type: .long),
                                QuestionPair(question: "Observações", answer: nil, type: .long)
                            ]
                        )
                    ]
                )
        ]
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
