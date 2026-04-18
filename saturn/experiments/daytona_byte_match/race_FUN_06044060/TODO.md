# FUN_06044060 TU byte-match progress

Goal: every function in the 196-function TU produces byte-identical
output against production, measured by tier-1 `.s`-text diff via
`saturn/tools/validate_byte_match.sh`. Sanitize phase is done (see
`TODO_sanitize.md`) — compile-clean is no longer the bar; **zero
diff lines** is.

## Status

Measured as TU compile (`race_FUN_06044060/FUN_06044060.c` vs
prod `race/FUN_06044060.s`), per-function diff after
`asm_normalize.py`. Baselines pinned at
`saturn/experiments/byte_match_baselines/race_FUN_06044060/`.

- Byte-matched (0 diff): 1 / 196 — #008 `FUN_06044834`
- Pinned with non-zero diff: 189 / 196 — aggregate **27,075 diff lines**
- Skipped (⚠): 6 / 196 — #112-115, #124, #127. All Gap 18
  (de-fused `mac.l` dot-product or single-mulhi CSE into
  `ASGNI8(VREGP, ...)`). Deferred until Gap 18 backend work lands.
  See `TODO_sanitize.md` for the per-function skip notes.

## Per-function grind workflow

1. Pick the next unchecked, non-skipped function below.
2. Human review the diff — eyeball what's actually different:
   ```bash
   wsl bash saturn/tools/asmdiff_tu.sh race_FUN_06044060 <FUN_NAME>
   ```
   Emits normalized prod and our slices at
   `build/cmp/<FUN_NAME>.prod.s` and `build/cmp/<FUN_NAME>.our.s`
   for VS Code side-by-side. Also prints the live diff-line count.
3. Classify the divergence. Usually one of:
   - **Known gap** — matches something in
     `saturn/workstreams/gap_catalog.md`. Note the gap number and
     move on unless the gap is worth investing in now.
   - **C source issue** — Ghidra decomp has a dropped deref,
     wrong DAT type, spurious temporary. Fix the C (Gap 0
     philosophy: C source is not sacred).
   - **Backend codegen issue** — lburg rule missing, peephole
     wrong, register allocator suboptimal. File a workstream note
     or extend an existing gap.
   - **New gap** — if it's a pattern we haven't seen before, add
     it to `gap_catalog.md`.
4. After any change, measure the TU and re-pin only the moved
   baselines (pin mode writes every baseline; run `check` first
   to see what moved, then decide):
   ```bash
   wsl bash saturn/tools/validate_byte_match_tu.sh race_FUN_06044060         # check
   wsl bash saturn/tools/validate_byte_match_tu.sh race_FUN_06044060 pin     # re-pin all
   ```
   If the diff closes to 0, tick with `— byte-identical`. If it
   shrinks, tick with `— <N> diff (was <M>)`.
5. Before committing, always:
   ```bash
   wsl bash saturn/tools/validate_build.sh
   ```
   All checks must be green, no stable `.s` drift, no TU regressions.
   See `.claude/rules/validate-before-commit.md`.

**Scope discipline:** don't rabbit-hole on the first function's
gap if it's going to take days. Skim the TU breadth-first once
to understand the gap distribution, then attack by impact (a
single gap fix often closes diffs across dozens of functions).

**When you find a new gap or landmine:** update
`saturn/workstreams/gap_catalog.md` or
`saturn/workstreams/landmines.md`. Don't silently route around.

## Checklist

Prod-order. Tick when tier-1 diff is 0 AND pinned. Partial
progress goes in a trailing annotation (e.g. `— 12 diff (was 438)`).

- [ ] 001. `FUN_06044060`
- [ ] 002. `FUN_060440E0`
- [ ] 003. `FUN_06044138`
- [ ] 004. `FUN_06044344`
- [ ] 005. `FUN_06044588`
- [ ] 006. `FUN_060446F4`
- [ ] 007. `FUN_06044788`
- [x] 008. `FUN_06044834` — byte-identical (pinned)
- [ ] 009. `FUN_06044848`
- [ ] 010. `FUN_060449A0`
- [ ] 011. `FUN_060449AC`
- [ ] 012. `FUN_060449B6`
- [ ] 013. `FUN_06044A9A`
- [ ] 014. `FUN_06044ADA`
- [ ] 015. `FUN_06044B20`
- [ ] 016. `FUN_06044BCC` — 446 diff (pinned baseline)
- [ ] 017. `FUN_06044D64`
- [ ] 018. `FUN_06044D74`
- [ ] 019. `FUN_06044D80`
- [ ] 020. `FUN_06044DA8`
- [ ] 021. `FUN_06044DB8`
- [ ] 022. `FUN_06044E28`
- [ ] 023. `FUN_06044E3C`
- [ ] 024. `FUN_06045006`
- [ ] 025. `FUN_06045008`
- [ ] 026. `FUN_06045020`
- [ ] 027. `FUN_0604507E`
- [ ] 028. `FUN_06045080`
- [ ] 029. `FUN_06045098`
- [ ] 030. `FUN_060450F2`
- [ ] 031. `FUN_060450F4`
- [ ] 032. `FUN_0604510C`
- [ ] 033. `FUN_06045198`
- [ ] 034. `FUN_060451AA`
- [ ] 035. `FUN_060451BC`
- [ ] 036. `FUN_060451BE`
- [ ] 037. `FUN_060451FA`
- [ ] 038. `FUN_0604521A`
- [ ] 039. `FUN_0604523A`
- [ ] 040. `FUN_060452F0`
- [ ] 041. `FUN_06045318`
- [ ] 042. `FUN_06045340`
- [ ] 043. `FUN_06045368`
- [ ] 044. `FUN_06045378`
- [ ] 045. `FUN_060453B8`
- [ ] 046. `FUN_060453C8`
- [ ] 047. `FUN_060453CC`
- [ ] 048. `FUN_0604556C`
- [ ] 049. `FUN_0604559C`
- [ ] 050. `FUN_060455D0`
- [ ] 051. `FUN_060455E2`
- [ ] 052. `FUN_06045614`
- [ ] 053. `FUN_06045620`
- [ ] 054. `FUN_0604562C`
- [ ] 055. `FUN_06045650`
- [ ] 056. `FUN_06045664`
- [ ] 057. `FUN_06045678`
- [ ] 058. `FUN_06045698`
- [ ] 059. `FUN_060456AA`
- [ ] 060. `FUN_060456AC`
- [ ] 061. `FUN_060456C2`
- [ ] 062. `FUN_060456CC`
- [ ] 063. `FUN_060456EC`
- [ ] 064. `FUN_060456F2`
- [ ] 065. `FUN_060456FC`
- [ ] 066. `FUN_06045714`
- [ ] 067. `FUN_06045738`
- [ ] 068. `FUN_06045760`
- [ ] 069. `FUN_06045784`
- [ ] 070. `FUN_060457AA`
- [ ] 071. `FUN_060457AC`
- [ ] 072. `FUN_060457DC`
- [ ] 073. `FUN_060457DE`
- [ ] 074. `FUN_060457E2`
- [ ] 075. `FUN_060457E4`
- [ ] 076. `FUN_06045858`
- [ ] 077. `FUN_0604585C`
- [ ] 078. `FUN_060458DA`
- [ ] 079. `FUN_060458DE`
- [ ] 080. `FUN_0604595A`
- [ ] 081. `FUN_0604595E`
- [ ] 082. `FUN_060459C4`
- [ ] 083. `FUN_06045A2C`
- [ ] 084. `FUN_06045A7E`
- [ ] 085. `FUN_06045AC0`
- [ ] 086. `FUN_06045ADC`
- [ ] 087. `FUN_06045AF4`
- [ ] 088. `FUN_06045B10`
- [ ] 089. `FUN_06045B48`
- [ ] 090. `FUN_06045B74`
- [ ] 091. `FUN_06045BA0`
- [ ] 092. `FUN_06045BC4`
- [ ] 093. `FUN_06045BC6`
- [ ] 094. `FUN_06045C00`
- [ ] 095. `FUN_06045C02`
- [ ] 096. `FUN_06045C3C`
- [ ] 097. `FUN_06045C9C`
- [ ] 098. `FUN_06045CCC`
- [ ] 099. `FUN_06045D04`
- [ ] 100. `FUN_06045D3C`
- [ ] 101. `FUN_06045D6A`
- [ ] 102. `FUN_06045D80`
- [ ] 103. `FUN_06045DAA`
- [ ] 104. `FUN_06045DCC`
- [ ] 105. `FUN_06045E06`
- [ ] 106. `FUN_06045E44`
- [ ] 107. `FUN_06045EA8`
- [ ] 108. `FUN_06045EC8`
- [ ] 109. `FUN_06045EE8`
- [ ] 110. `FUN_06045F0C`
- [ ] 111. `FUN_06045F46`
- [ ] 112. `FUN_06045FC0` ⚠ Gap 18 (skipped in sanitize)
- [ ] 113. `FUN_060463E4` ⚠ Gap 18 (skipped in sanitize)
- [ ] 114. `FUN_06046478` ⚠ Gap 18 (skipped in sanitize)
- [ ] 115. `FUN_06046520` ⚠ Gap 18 (skipped in sanitize)
- [ ] 116. `FUN_06046602`
- [ ] 117. `FUN_0604660A`
- [ ] 118. `FUN_0604669E`
- [ ] 119. `FUN_060466A0`
- [ ] 120. `FUN_0604670C`
- [ ] 121. `FUN_0604674E`
- [ ] 122. `FUN_060467B2`
- [ ] 123. `FUN_060467B4`
- [ ] 124. `FUN_0604680C` ⚠ Gap 18 (skipped in sanitize)
- [ ] 125. `FUN_060468AE`
- [ ] 126. `FUN_060468B0`
- [ ] 127. `FUN_06046908` ⚠ Gap 18 (skipped in sanitize)
- [ ] 128. `FUN_0604698C`
- [ ] 129. `FUN_06046990`
- [ ] 130. `FUN_06046A20`
- [ ] 131. `FUN_06046A24`
- [ ] 132. `FUN_06046A90`
- [ ] 133. `FUN_06046AE8`
- [ ] 134. `FUN_06046B3C`
- [ ] 135. `FUN_06046B64` (Gap 15 void sanitize — reconstruct r0:r1 return)
- [ ] 136. `FUN_06046B70` (Gap 15 void sanitize — reconstruct r0:r1 return)
- [ ] 137. `FUN_06046B96`
- [ ] 138. `FUN_06046BD4`
- [ ] 139. `FUN_06046BF4`
- [ ] 140. `FUN_06046C14`
- [ ] 141. `FUN_06046CD0`
- [ ] 142. `FUN_06046CF0`
- [ ] 143. `FUN_06046D10`
- [ ] 144. `FUN_06046D30`
- [ ] 145. `FUN_06046D78`
- [ ] 146. `FUN_06046D98`
- [ ] 147. `FUN_06046E0E`
- [ ] 148. `FUN_06046E64`
- [ ] 149. `FUN_06046EBC`
- [ ] 150. `FUN_06046FD4`
- [ ] 151. `FUN_06047014`
- [ ] 152. `FUN_0604708C`
- [ ] 153. `FUN_060470A8`
- [ ] 154. `FUN_060470C4`
- [ ] 155. `FUN_060470D6`
- [ ] 156. `FUN_060470EC`
- [ ] 157. `FUN_060470FE`
- [ ] 158. `FUN_06047118`
- [ ] 159. `FUN_06047140`
- [ ] 160. `FUN_06047184`
- [ ] 161. `FUN_060471F0`
- [ ] 162. `FUN_0604720C`
- [ ] 163. `FUN_06047228`
- [ ] 164. `FUN_0604723A`
- [ ] 165. `FUN_06047250`
- [ ] 166. `FUN_06047262`
- [ ] 167. `FUN_06047270`
- [ ] 168. `FUN_0604727C`
- [ ] 169. `FUN_0604728E`
- [ ] 170. `FUN_060472CC`
- [ ] 171. `FUN_06047332`
- [ ] 172. `FUN_0604737A`
- [ ] 173. `FUN_060473CA`
- [ ] 174. `FUN_06047414`
- [ ] 175. `FUN_06047460`
- [ ] 176. `FUN_060474D4`
- [ ] 177. `FUN_06047548`
- [ ] 178. `FUN_06047588`
- [ ] 179. `FUN_06047748` — 27 diff (pinned baseline)
- [ ] 180. `FUN_06047770`
- [ ] 181. `FUN_060477D4`
- [ ] 182. `FUN_060477D6`
- [ ] 183. `FUN_060477FC` (Gap 15 CONCAT44 dispatch stripped — reconstruct)
- [ ] 184. `FUN_06047866`
- [ ] 185. `FUN_0604791A`
- [ ] 186. `FUN_0604796C`
- [ ] 187. `FUN_06047986`
- [ ] 188. `FUN_060479A0` (Gap 15 void sanitize — reconstruct r0:r1 return)
- [ ] 189. `FUN_060479D6`
- [ ] 190. `FUN_06047A08`
- [ ] 191. `FUN_06047A84`
- [ ] 192. `FUN_06047AE0`
- [ ] 193. `FUN_06047B00`
- [ ] 194. `FUN_06047B34`
- [ ] 195. `FUN_06047D3C`
- [ ] 196. `FUN_06047D46`
