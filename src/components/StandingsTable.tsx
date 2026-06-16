import type { PlayerStanding } from "../lib/sweepstakes";
import { Avatar } from "./Avatar";
import { Flag } from "./Flag";

interface Props {
  rows: PlayerStanding[];
}

export function StandingsTable({ rows }: Props) {
  if (rows.length === 0) {
    return (
      <p className="text-sm opacity-60 px-4">
        No players yet — drop a sweepstakes JSON into <code>public/players/</code>.
      </p>
    );
  }

  return (
    <section>
      <div className="border-b border-ink-900/15 dark:border-ink-50/15 bg-white/40 dark:bg-ink-800/40">
        <table className="w-full text-left">
          <thead>
            <tr className="font-mono text-[10px] uppercase tracking-wider text-ink-900/55 dark:text-ink-50/55 border-b border-ink-900/15 dark:border-ink-50/15">
              <th className="w-1 p-0"></th>
              <th className="px-2 py-2" colSpan={2}></th>
              <th className="px-1.5 py-2 text-center w-9">MP</th>
              <th className="px-1.5 py-2 text-center w-8 hidden sm:table-cell">W</th>
              <th className="px-1.5 py-2 text-center w-8 hidden sm:table-cell">D</th>
              <th className="px-1.5 py-2 text-center w-8 hidden sm:table-cell">L</th>
              <th className="px-1.5 py-2 text-center w-10 hidden md:table-cell">GD</th>
              <th className="px-3 py-2 text-right w-12 font-bold">PTS</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row, idx) => {
              const live = row.hasLiveMatch
                ? "bg-brick-500/[0.08] dark:bg-brick-500/15"
                : idx % 2 === 1
                  ? "bg-ink-900/[0.025] dark:bg-ink-50/[0.025]"
                  : "";
              return (
                <tr
                  key={row.player.name}
                  className={`border-t border-ink-900/10 dark:border-ink-50/10 ${live}`}
                >
                  <td className="relative p-0 w-1">
                    {row.hasLiveMatch && (
                      <span
                        title="Live match"
                        className="absolute inset-y-0 left-0 w-1 bg-brick-500 animate-pulse"
                      />
                    )}
                  </td>
                  <td className="pl-3 pr-2 py-3 whitespace-nowrap">
                    <div className="flex items-center gap-2.5">
                      {row.player.image && (
                        <Avatar
                          src={row.player.image}
                          alt={row.player.name}
                          className="w-9 h-9 shrink-0 ring-1 ring-ink-900/15 dark:ring-ink-50/20"
                        />
                      )}
                      <span className="font-semibold uppercase tracking-wide text-base sm:text-lg leading-none text-ink-900 dark:text-ink-50">
                        {row.player.name}
                      </span>
                    </div>
                  </td>
                  <td className="px-2 py-3">
                    <div className="flex items-center gap-1 sm:gap-1.5">
                      {row.teams.map((t) => (
                        <Flag
                          key={t.code}
                          code={t.code}
                          className={`h-4 sm:h-5 w-auto ${t.isLive ? "ring-2 ring-brick-500" : ""}`}
                        />
                      ))}
                    </div>
                  </td>
                  <td className="px-1.5 py-3 text-center font-mono font-medium tab-num text-sm text-ink-900/70 dark:text-ink-50/70">
                    {row.played}
                  </td>
                  <td className="px-1.5 py-3 text-center font-mono font-medium tab-num text-sm text-ink-900/70 dark:text-ink-50/70 hidden sm:table-cell">
                    {row.won}
                  </td>
                  <td className="px-1.5 py-3 text-center font-mono font-medium tab-num text-sm text-ink-900/70 dark:text-ink-50/70 hidden sm:table-cell">
                    {row.drawn}
                  </td>
                  <td className="px-1.5 py-3 text-center font-mono font-medium tab-num text-sm text-ink-900/70 dark:text-ink-50/70 hidden sm:table-cell">
                    {row.lost}
                  </td>
                  <td className="px-1.5 py-3 text-center font-mono font-medium tab-num text-sm text-ink-900/70 dark:text-ink-50/70 hidden md:table-cell">
                    {row.goalDifference > 0 ? `+${row.goalDifference}` : row.goalDifference}
                  </td>
                  <td className="px-3 py-3 text-right font-mono font-bold tab-num text-lg sm:text-xl text-ink-900 dark:text-ink-50">
                    {row.points}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </section>
  );
}

