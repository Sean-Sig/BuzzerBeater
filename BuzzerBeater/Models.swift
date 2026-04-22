//
//  Models.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/22/26.
//

import Foundation
import Observation

enum GameStatus {
  case live, upcoming, final_
}

enum PlayoffRound: String {
  case firstRound = "First Round"
  case secondRound = "Conference Semifinals"
  case confFinals = "Conference Finals"
  case finals = "NBA Finals"
}

struct TeamScore: Identifiable {
  var id = UUID()
  var name: String
  var abbreviation: String
  var primaryColor: String
  var score: Int
  var seriesWins: Int
  var record: String
  var seed: Int
}

struct PlayoffGame: Identifiable {
  var id = UUID()
  var homeTeam: TeamScore
  var awayTeam: TeamScore
  var status: GameStatus
  var round: PlayoffRound
  var gameNumber: Int
  var seriesLabel: String
  var arena: String
  var tipoff: String
  var quarter: String
  var clock: String
  var broadcast: String
}

@Observable
class NBAStore {
  var games: [PlayoffGame] = sampleGames

  var liveGames: [PlayoffGame] { games.filter { $0.status == .live } }
  var upcomingGames: [PlayoffGame] { games.filter { $0.status == .upcoming } }
  var pastGames: [PlayoffGame] { games.filter { $0.status == .final_ } }
}

let sampleGames: [PlayoffGame] = [
  // LIVE
  PlayoffGame(
    homeTeam: TeamScore(name: "Boston Celtics", abbreviation: "BOS", primaryColor: "#007A33", score: 94, seriesWins: 3, record: "61-21", seed: 1),
    awayTeam: TeamScore(name: "Miami Heat", abbreviation: "MIA", primaryColor: "#98002E", score: 88, seriesWins: 1, record: "46-36", seed: 8),
    status: .live,
    round: .firstRound,
    gameNumber: 5,
    seriesLabel: "BOS leads 3-1",
    arena: "TD Garden, Boston",
    tipoff: "7:30 PM ET",
    quarter: "Q3",
    clock: "4:22",
    broadcast: "ESPN"
  ),
  PlayoffGame(
    homeTeam: TeamScore(name: "Oklahoma City Thunder", abbreviation: "OKC", primaryColor: "#007AC1", score: 112, seriesWins: 3, record: "68-14", seed: 1),
    awayTeam: TeamScore(name: "Dallas Mavericks", abbreviation: "DAL", primaryColor: "#00538C", score: 107, seriesWins: 2, record: "49-33", seed: 4),
    status: .live,
    round: .firstRound,
    gameNumber: 6,
    seriesLabel: "OKC leads 3-2",
    arena: "Paycom Center, OKC",
    tipoff: "9:30 PM ET",
    quarter: "Q4",
    clock: "1:48",
    broadcast: "TNT"
  ),

  // UPCOMING
  PlayoffGame(
    homeTeam: TeamScore(name: "Cleveland Cavaliers", abbreviation: "CLE", primaryColor: "#860038", score: 0, seriesWins: 3, record: "64-18", seed: 1),
    awayTeam: TeamScore(name: "Orlando Magic", abbreviation: "ORL", primaryColor: "#0077C0", score: 0, seriesWins: 1, record: "47-35", seed: 4),
    status: .upcoming,
    round: .firstRound,
    gameNumber: 5,
    seriesLabel: "CLE leads 3-1",
    arena: "Rocket Mortgage FieldHouse",
    tipoff: "Tomorrow · 7:00 PM ET",
    quarter: "",
    clock: "",
    broadcast: "ESPN"
  ),
  PlayoffGame(
    homeTeam: TeamScore(name: "Denver Nuggets", abbreviation: "DEN", primaryColor: "#0E2240", score: 0, seriesWins: 2, record: "50-32", seed: 3),
    awayTeam: TeamScore(name: "LA Clippers", abbreviation: "LAC", primaryColor: "#C8102E", score: 0, seriesWins: 2, record: "47-35", seed: 6),
    status: .upcoming,
    round: .firstRound,
    gameNumber: 5,
    seriesLabel: "Series tied 2-2",
    arena: "Ball Arena, Denver",
    tipoff: "Tomorrow · 9:30 PM ET",
    quarter: "",
    clock: "",
    broadcast: "TNT"
  ),
  PlayoffGame(
    homeTeam: TeamScore(name: "New York Knicks", abbreviation: "NYK", primaryColor: "#006BB6", score: 0, seriesWins: 3, record: "51-31", seed: 2),
    awayTeam: TeamScore(name: "Detroit Pistons", abbreviation: "DET", primaryColor: "#C8102E", score: 0, seriesWins: 0, record: "42-40", seed: 7),
    status: .upcoming,
    round: .firstRound,
    gameNumber: 4,
    seriesLabel: "NYK leads 3-0",
    arena: "Madison Square Garden",
    tipoff: "Thu · 7:30 PM ET",
    quarter: "",
    clock: "",
    broadcast: "ABC"
  ),

  // FINAL
  PlayoffGame(
    homeTeam: TeamScore(name: "Boston Celtics", abbreviation: "BOS", primaryColor: "#007A33", score: 110, seriesWins: 3, record: "61-21", seed: 1),
    awayTeam: TeamScore(name: "Miami Heat", abbreviation: "MIA", primaryColor: "#98002E", score: 98, seriesWins: 0, record: "46-36", seed: 8),
    status: .final_,
    round: .firstRound,
    gameNumber: 4,
    seriesLabel: "BOS leads 3-1",
    arena: "TD Garden, Boston",
    tipoff: "Apr 21",
    quarter: "Final",
    clock: "",
    broadcast: "ESPN"
  ),
  PlayoffGame(
    homeTeam: TeamScore(name: "Oklahoma City Thunder", abbreviation: "OKC", primaryColor: "#007AC1", score: 118, seriesWins: 3, record: "68-14", seed: 1),
    awayTeam: TeamScore(name: "Dallas Mavericks", abbreviation: "DAL", primaryColor: "#00538C", score: 104, seriesWins: 1, record: "49-33", seed: 4),
    status: .final_,
    round: .firstRound,
    gameNumber: 4,
    seriesLabel: "OKC leads 3-1",
    arena: "American Airlines Center",
    tipoff: "Apr 21",
    quarter: "Final",
    clock: "",
    broadcast: "TNT"
  ),
  PlayoffGame(
    homeTeam: TeamScore(name: "Indiana Pacers", abbreviation: "IND", primaryColor: "#002D62", score: 121, seriesWins: 1, record: "50-32", seed: 5),
    awayTeam: TeamScore(name: "Milwaukee Bucks", abbreviation: "MIL", primaryColor: "#00471B", score: 116, seriesWins: 2, record: "48-34", seed: 4),
    status: .final_,
    round: .firstRound,
    gameNumber: 4,
    seriesLabel: "MIL leads 2-1",
    arena: "Gainbridge Fieldhouse",
    tipoff: "Apr 20",
    quarter: "Final",
    clock: "",
    broadcast: "ESPN"
  ),
]

