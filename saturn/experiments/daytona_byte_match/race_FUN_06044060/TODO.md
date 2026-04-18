# FUN_06044060 TU sanitization progress

Goal: all 196 functions compile cleanly as part of `FUN_06044060.c`. Sanitization = fix Ghidra type issues, add pragmas as needed. Byte-match is a later phase — for now, compile-clean is the bar.

## Status

- Sanitized: 116 / 196
- Remaining: 76
- Skipped (⚠): 4 — #112, #113, #114, #115. Ghidra has de-fused
  SH-2's `mac.l` dot-product idiom into manual 32x32→64 arithmetic;
  resulting ASGNI8(VREGP, MULI8) DAG shapes have no lburg rule.
  rcc emits a clean "unsupported DAG shape" error (`0e503b2`
  replaced the assertion crash). Byte-match path is Gap 18 —
  deferred to byte-match pass. #106-111, #116-117 were
  false-positive cascade skips from a prior session — retested
  clean with no compiler changes.

## Per-function grind workflow

1. Pick the next unchecked function in the checklist below.
2. Open `FUN_06044060.c`, locate the `#if 0 ... #endif` block under the
   section banner for that function (search for the `[NNN/196]` tag).
3. Remove the `#if 0` and `#endif` lines. The raw Ghidra body is now
   active.
4. Attempt to compile the TU:
   ```bash
   wsl bash -c 'cpp -P saturn/experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c /tmp/tu.pp.c && build/rcc -target=sh/hitachi /tmp/tu.pp.c /tmp/tu.s'
   ```
5. Fix the errors in order. Common issues and their fixes:
   - **`undefined reference to DAT_xxxxxxxx`** — add `extern int DAT_xxxxxxxx;` to `ghidra_shim.h`.
   - **`undefined reference to PTR_FUN_xxxxxxxx`** — add `extern code PTR_FUN_xxxxxxxx;` to `ghidra_shim.h`.
   - **`undefined reference to FUN_xxxxxxxx`** — if it's a same-TU call, add a forward declaration at the top of `FUN_06044060.c`. If cross-TU, add `extern int FUN_xxxxxxxx();` to the shim.
   - **`(*(code *)foo)()` pattern errors** — cast issues from Ghidra's function-pointer idiom. Usually resolves once `code` is properly typedef'd in the shim and the symbol is declared.
   - **Type mismatch between Ghidra's `(int)` vs `(void)` return** — align the declaration to what Ghidra emitted; match prod .s later.
   - **Syntax errors from Ghidra's `(*(code *)&X)()`** — may need rewriting. Ghidra sometimes emits syntactically-valid-but-semantically-off C.
6. Once the TU compiles cleanly, check the item off in this file and
   commit (message pattern: `TU sanitize: FUN_<name> (<NNN>/196)`).
7. Do NOT aim for byte-match at this stage — just compile. Byte-match
   is the follow-on phase once all 196 are sanitized.

**Scope discipline:** if a function's Ghidra decomp is deeply broken
(e.g. obvious logic errors, missing hunks), mark the checkbox with a
`⚠` note and move on. We can revisit during byte-match phase. The
goal is breadth first — every function compile-clean — then depth.

**When something surprising happens** (new rcc crash, new landmine,
new pragma needed), add it to `saturn/workstreams/landmines.md` or
open a new workstream note. Don't silently work around.

## Checklist

Prod-order. Check off when the function's `#if 0` block is unwrapped AND the TU compiles cleanly.

- [x] 001. `FUN_06044060`
- [x] 002. `FUN_060440E0`
- [x] 003. `FUN_06044138`
- [x] 004. `FUN_06044344`
- [x] 005. `FUN_06044588`
- [x] 006. `FUN_060446F4`
- [x] 007. `FUN_06044788`
- [x] 008. `FUN_06044834` — **byte-identical** (see `byte_match_baselines/`)
- [x] 009. `FUN_06044848`
- [x] 010. `FUN_060449A0`
- [x] 011. `FUN_060449AC`
- [x] 012. `FUN_060449B6`
- [x] 013. `FUN_06044A9A`
- [x] 014. `FUN_06044ADA`
- [x] 015. `FUN_06044B20`
- [x] 016. `FUN_06044BCC`
- [x] 017. `FUN_06044D64`
- [x] 018. `FUN_06044D74`
- [x] 019. `FUN_06044D80`
- [x] 020. `FUN_06044DA8`
- [x] 021. `FUN_06044DB8`
- [x] 022. `FUN_06044E28`
- [x] 023. `FUN_06044E3C`
- [x] 024. `FUN_06045006`
- [x] 025. `FUN_06045008`
- [x] 026. `FUN_06045020`
- [x] 027. `FUN_0604507E`
- [x] 028. `FUN_06045080`
- [x] 029. `FUN_06045098`
- [x] 030. `FUN_060450F2`
- [x] 031. `FUN_060450F4`
- [x] 032. `FUN_0604510C`
- [x] 033. `FUN_06045198`
- [x] 034. `FUN_060451AA`
- [x] 035. `FUN_060451BC`
- [x] 036. `FUN_060451BE`
- [x] 037. `FUN_060451FA`
- [x] 038. `FUN_0604521A`
- [x] 039. `FUN_0604523A`
- [x] 040. `FUN_060452F0`
- [x] 041. `FUN_06045318`
- [x] 042. `FUN_06045340`
- [x] 043. `FUN_06045368`
- [x] 044. `FUN_06045378`
- [x] 045. `FUN_060453B8`
- [x] 046. `FUN_060453C8`
- [x] 047. `FUN_060453CC`
- [x] 048. `FUN_0604556C`
- [x] 049. `FUN_0604559C`
- [x] 050. `FUN_060455D0`
- [x] 051. `FUN_060455E2`
- [x] 052. `FUN_06045614`
- [x] 053. `FUN_06045620`
- [x] 054. `FUN_0604562C`
- [x] 055. `FUN_06045650`
- [x] 056. `FUN_06045664`
- [x] 057. `FUN_06045678`
- [x] 058. `FUN_06045698`
- [x] 059. `FUN_060456AA`
- [x] 060. `FUN_060456AC`
- [x] 061. `FUN_060456C2`
- [x] 062. `FUN_060456CC`
- [x] 063. `FUN_060456EC`
- [x] 064. `FUN_060456F2`
- [x] 065. `FUN_060456FC`
- [x] 066. `FUN_06045714`
- [x] 067. `FUN_06045738`
- [x] 068. `FUN_06045760`
- [x] 069. `FUN_06045784`
- [x] 070. `FUN_060457AA`
- [x] 071. `FUN_060457AC`
- [x] 072. `FUN_060457DC`
- [x] 073. `FUN_060457DE`
- [x] 074. `FUN_060457E2`
- [x] 075. `FUN_060457E4`
- [x] 076. `FUN_06045858`
- [x] 077. `FUN_0604585C`
- [x] 078. `FUN_060458DA`
- [x] 079. `FUN_060458DE`
- [x] 080. `FUN_0604595A`
- [x] 081. `FUN_0604595E`
- [x] 082. `FUN_060459C4`
- [x] 083. `FUN_06045A2C`
- [x] 084. `FUN_06045A7E`
- [x] 085. `FUN_06045AC0`
- [x] 086. `FUN_06045ADC`
- [x] 087. `FUN_06045AF4`
- [x] 088. `FUN_06045B10`
- [x] 089. `FUN_06045B48`
- [x] 090. `FUN_06045B74`
- [x] 091. `FUN_06045BA0`
- [x] 092. `FUN_06045BC4`
- [x] 093. `FUN_06045BC6`
- [x] 094. `FUN_06045C00`
- [x] 095. `FUN_06045C02`
- [x] 096. `FUN_06045C3C`
- [x] 097. `FUN_06045C9C`
- [x] 098. `FUN_06045CCC`
- [x] 099. `FUN_06045D04`
- [x] 100. `FUN_06045D3C`
- [x] 101. `FUN_06045D6A`
- [x] 102. `FUN_06045D80`
- [x] 103. `FUN_06045DAA`
- [x] 104. `FUN_06045DCC`
- [x] 105. `FUN_06045E06`
- [x] 106. `FUN_06045E44`
- [x] 107. `FUN_06045EA8`
- [x] 108. `FUN_06045EC8`
- [x] 109. `FUN_06045EE8`
- [x] 110. `FUN_06045F0C`
- [x] 111. `FUN_06045F46`
- [ ] 112. `FUN_06045FC0` ⚠ returns undefined8; 64-bit local
- [ ] 113. `FUN_060463E4` ⚠ heavy 64-bit CSE
- [ ] 114. `FUN_06046478` ⚠ heavy 64-bit CSE
- [ ] 115. `FUN_06046520` ⚠ heavy 64-bit CSE
- [x] 116. `FUN_06046602`
- [x] 117. `FUN_0604660A`
- [x] 118. `FUN_0604669E`
- [x] 119. `FUN_060466A0`
- [x] 120. `FUN_0604670C`
- [ ] 121. `FUN_0604674E`
- [ ] 122. `FUN_060467B2`
- [ ] 123. `FUN_060467B4`
- [ ] 124. `FUN_0604680C`
- [ ] 125. `FUN_060468AE`
- [ ] 126. `FUN_060468B0`
- [ ] 127. `FUN_06046908`
- [ ] 128. `FUN_0604698C`
- [ ] 129. `FUN_06046990`
- [ ] 130. `FUN_06046A20`
- [ ] 131. `FUN_06046A24`
- [ ] 132. `FUN_06046A90`
- [ ] 133. `FUN_06046AE8`
- [ ] 134. `FUN_06046B3C`
- [ ] 135. `FUN_06046B64`
- [ ] 136. `FUN_06046B70`
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
- [ ] 179. `FUN_06047748`
- [ ] 180. `FUN_06047770`
- [ ] 181. `FUN_060477D4`
- [ ] 182. `FUN_060477D6`
- [ ] 183. `FUN_060477FC`
- [ ] 184. `FUN_06047866`
- [ ] 185. `FUN_0604791A`
- [ ] 186. `FUN_0604796C`
- [ ] 187. `FUN_06047986`
- [ ] 188. `FUN_060479A0`
- [ ] 189. `FUN_060479D6`
- [ ] 190. `FUN_06047A08`
- [ ] 191. `FUN_06047A84`
- [ ] 192. `FUN_06047AE0`
- [ ] 193. `FUN_06047B00`
- [ ] 194. `FUN_06047B34`
- [ ] 195. `FUN_06047D3C`
- [ ] 196. `FUN_06047D46`
