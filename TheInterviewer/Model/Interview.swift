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
    
    let title: String
    var parts: [Part]
    
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
                                QuestionPair(question: "Nome da empresa", answer: nil),
                                QuestionPair(question: "Área de atuação", answer: nil),
                                QuestionPair(question: "Quantidade de funcionários", answer: nil),
                                QuestionPair(question: "Contato", answer: nil),
                                QuestionPair(question: "Observações", answer: nil)
                            ]
                        ),
                        Section(title: "Sobre o interlocutor", questionPairs:
                            [
                                QuestionPair(question: "Nome do entrevistado", answer: nil),
                                QuestionPair(question: "Cargo do entrevistado", answer: nil),
                                QuestionPair(question: "Tempo de empresa", answer: nil),
                                QuestionPair(question: "Contato do entrevistado", answer: nil)
                            ]
                        ),
                        Section(title: "Sobre a entrevista", questionPairs:
                            [
                                QuestionPair(question: "Quantos fluxos serão cobertos nessa entrevista", answer: nil),
                                QuestionPair(question: "Quais fluxos serão os fluxos analisados nesta entrevista", answer: nil),
                                QuestionPair(question: "Relação do entrevistado com cada fluxo", answer: nil)
                            ]
                        )
                    ]
                ),
                Part(title: "Análise Qualitativa", sections:
                    [
                        Section(title: "Início", questionPairs:
                            [
                                QuestionPair(question: "Você é a pessoa correta para esclarecer o fluxo que será analisado?", answer: nil),
                                QuestionPair(question: "As suas respostas são 'oficiais'?", answer: nil),
                                QuestionPair(question: "Qual é o objetivo deste fluxo?", answer: nil),
                                QuestionPair(question: "Quem são os atores envolvidos neste processo? (atores primários e secundários)", answer: nil),
                                QuestionPair(question: "Quais são os objetivos de cada ator dentro deste fluxo?", answer: nil),
                                QuestionPair(question: "Suposição inicial (montar cenário)", answer: nil)
                            ]
                        ),
                        Section(title: "Sunny days (caso esperado / normal)", questionPairs:
                            [
                                QuestionPair(question: "Pré-requisitos: o que é necessário para que este fluxo ocorra?", answer: nil),
                                QuestionPair(question: "Caso normal: quais são os processos, dentro da situação esperada?", answer: nil),
                                QuestionPair(question: "(repetir) Para cada atividade, anotar quem faz o quê, com qual pré-condição, e com que objetivo.", answer: nil),
                                QuestionPair(question: "Observações", answer: nil)
                            ]
                        ),
                        Section(title: "Rainy days (exceções)", questionPairs:
                            [
                                QuestionPair(question: "O que pode dar errado?", answer: nil),
                                QuestionPair(question: "(repetir) Para cada caso, que procedimento será tomado?", answer: nil),
                                QuestionPair(question: "Como casos inesperados são resolvidos?", answer: nil),
                                QuestionPair(question: "Observações", answer: nil)
                            ]
                        ),
                        Section(title: "Fechamento / Conclusão", questionPairs:
                            [
                                QuestionPair(question: "Qual é o estado esperado do sistema na conclusão?", answer: nil),
                                QuestionPair(question: "Atividades relacionadas", answer: nil),
                                QuestionPair(question: "Alguma outra pessoa poderia me prestar informações adicionais?", answer: nil),
                                QuestionPair(question: "Eu deveria lhe perguntar algo mais?", answer: nil),
                                QuestionPair(question: "Observações", answer: nil)
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
