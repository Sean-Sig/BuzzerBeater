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

enum PlayerPosition: String {
  case pointGuard = "PG"
  case shootingGuard = "SG"
  case smallForward = "SF"
  case powerForward = "PF"
  case center = "C"
}

struct NBAPlayer: Identifiable {
  var id = UUID()
  var name: String
  var team: String
  var teamColor: String
  var position: PlayerPosition
  var rank: Int
  var ppg: Double
  var rpg: Double
  var apg: Double
  var bio: String
  var age: Int
  var height: String
  var college: String
  var draftYear: Int
  var nationality: String
}

@Observable
class NBAStore {
  var followedPlayerIDs: Set<UUID> = []
  var games: [PlayoffGame] = sampleGames

  var liveGames: [PlayoffGame] { games.filter { $0.status == .live } }
  var upcomingGames: [PlayoffGame] { games.filter { $0.status == .upcoming } }
  var pastGames: [PlayoffGame] { games.filter { $0.status == .final_ } }

  var players: [NBAPlayer] = samplePlayers

  func toggleFollow(_ player: NBAPlayer) {
    if followedPlayerIDs.contains(player.id) {
      followedPlayerIDs.remove(player.id)
    } else {
      followedPlayerIDs.insert(player.id)
    }
  }

  func isFollowing(_ player: NBAPlayer) -> Bool {
    followedPlayerIDs.contains(player.id)
  }
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

let samplePlayers: [NBAPlayer] = [
  NBAPlayer(name: "Nikola Jokić", team: "Denver Nuggets", teamColor: "#0E2240", position: .center, rank: 1, ppg: 29.6, rpg: 13.0, apg: 10.2, bio: "Nikola Jokić is a three-time NBA MVP and widely regarded as the best player in the league. The Serbian center revolutionized the center position with his elite playmaking and passing, becoming the first center in NBA history to lead the league in assists per game.", age: 30, height: "6'11\"", college: "None (Serbia)", draftYear: 2014, nationality: "🇷🇸"),
  NBAPlayer(name: "Shai Gilgeous-Alexander", team: "OKC Thunder", teamColor: "#007AC1", position: .pointGuard, rank: 2, ppg: 32.7, rpg: 5.5, apg: 6.4, bio: "Shai Gilgeous-Alexander has emerged as one of the most unstoppable scorers in the NBA. The Canadian guard possesses elite footwork and a deceptive playing style that makes him nearly impossible to guard, leading OKC to the league's best record.", age: 26, height: "6'6\"", college: "Kentucky", draftYear: 2018, nationality: "🇨🇦"),
  NBAPlayer(name: "Giannis Antetokounmpo", team: "Milwaukee Bucks", teamColor: "#00471B", position: .powerForward, rank: 3, ppg: 30.4, rpg: 11.9, apg: 6.5, bio: "The Greek Freak is a two-time MVP and NBA champion who transformed from an unknown international prospect into the most physically dominant player in the league. His combination of size, speed, and skill is unmatched in NBA history.", age: 30, height: "6'11\"", college: "None (Greece)", draftYear: 2013, nationality: "🇬🇷"),
  NBAPlayer(name: "Jayson Tatum", team: "Boston Celtics", teamColor: "#007A33", position: .smallForward, rank: 4, ppg: 26.9, rpg: 8.1, apg: 4.9, bio: "Jayson Tatum is the cornerstone of Boston's championship core and an NBA Finals MVP. A versatile scorer with an elite mid-range game, Tatum has developed into one of the best two-way players in the league.", age: 27, height: "6'8\"", college: "Duke", draftYear: 2017, nationality: "🇺🇸"),
  NBAPlayer(name: "Luka Dončić", team: "Dallas Mavericks", teamColor: "#00538C", position: .pointGuard, rank: 5, ppg: 28.6, rpg: 9.2, apg: 8.1, bio: "Luka Dončić is one of the most gifted offensive players in NBA history, already cementing himself as a perennial MVP candidate in just his mid-20s. The Slovenian phenom has an unmatched feel for the game and ability to create in the clutch.", age: 26, height: "6'7\"", college: "None (Slovenia)", draftYear: 2018, nationality: "🇸🇮"),
  NBAPlayer(name: "Donovan Mitchell", team: "Cleveland Cavaliers", teamColor: "#860038", position: .shootingGuard, rank: 6, ppg: 26.2, rpg: 5.1, apg: 6.1, bio: "Donovan Mitchell is an explosive scorer who thrives in big moments. Since joining Cleveland, he has led the Cavaliers to back-to-back top seeds and established himself as one of the elite two-way guards in the Eastern Conference.", age: 28, height: "6'1\"", college: "Louisville", draftYear: 2017, nationality: "🇺🇸"),
  NBAPlayer(name: "Anthony Edwards", team: "Minnesota Timberwolves", teamColor: "#0C2340", position: .shootingGuard, rank: 7, ppg: 27.1, rpg: 5.4, apg: 5.1, bio: "Anthony Edwards has blossomed into a franchise cornerstone and the face of the next generation of NBA stars. Ant-Man's explosive athleticism, fearless mentality, and natural charisma make him one of the most exciting players to watch in the league.", age: 23, height: "6'4\"", college: "Georgia", draftYear: 2020, nationality: "🇺🇸"),
  NBAPlayer(name: "LeBron James", team: "Los Angeles Lakers", teamColor: "#552583", position: .smallForward, rank: 8, ppg: 25.7, rpg: 7.3, apg: 8.3, bio: "LeBron James is widely considered one of the two greatest players in NBA history. Entering his 22nd season, King James continues to defy age and perform at an All-Star level while chasing the all-time scoring record he already holds.", age: 40, height: "6'9\"", college: "None (high school)", draftYear: 2003, nationality: "🇺🇸"),
  NBAPlayer(name: "Jalen Brunson", team: "New York Knicks", teamColor: "#006BB6", position: .pointGuard, rank: 9, ppg: 27.4, rpg: 3.6, apg: 6.7, bio: "Jalen Brunson's rise from mid-level exception signing to New York icon is one of the great stories in recent NBA history. A cerebral scorer with elite footwork, Brunson has become the heartbeat of a Knicks team with championship aspirations.", age: 28, height: "6'1\"", college: "Villanova", draftYear: 2018, nationality: "🇺🇸"),
  NBAPlayer(name: "Tyrese Haliburton", team: "Indiana Pacers", teamColor: "#002D62", position: .pointGuard, rank: 10, ppg: 21.4, rpg: 4.3, apg: 10.9, bio: "Tyrese Haliburton is arguably the best pure point guard in the NBA, orchestrating Indiana's fast-paced offense with pinpoint precision. His elite court vision and shooting ability off movement make him one of the most dangerous playmakers in the league.", age: 25, height: "6'5\"", college: "Iowa State", draftYear: 2020, nationality: "🇺🇸"),
]
