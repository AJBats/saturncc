# FUN_06044060 TU sanitization progress

Goal: all 196 functions compile cleanly as part of `FUN_06044060.c`. Sanitization = fix Ghidra type issues, add pragmas as needed. Byte-match is a later phase — for now, compile-clean is the bar.

## Status

- Sanitized: 3 / 196
- Remaining: 193

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
- [ ] 003. `FUN_06044138` ⚠ rcc getregnum assert — see `saturn/workstreams/rcc_getregnum_assert_fun_06044138.md`
- [ ] 004. `FUN_06044344`
- [ ] 005. `FUN_06044588`
- [ ] 006. `FUN_060446F4`
- [ ] 007. `FUN_06044788`
- [x] 008. `FUN_06044834` — **byte-identical** (see `byte_match_baselines/`)
- [ ] 009. `FUN_06044848`
- [ ] 010. `FUN_060449A0`
- [ ] 011. `FUN_060449AC`
- [ ] 012. `FUN_060449B6`
- [ ] 013. `FUN_06044A9A`
- [ ] 014. `FUN_06044ADA`
- [ ] 015. `FUN_06044B20`
- [ ] 016. `FUN_06044BCC`
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
- [ ] 112. `FUN_06045FC0`
- [ ] 113. `FUN_060463E4`
- [ ] 114. `FUN_06046478`
- [ ] 115. `FUN_06046520`
- [ ] 116. `FUN_06046602`
- [ ] 117. `FUN_0604660A`
- [ ] 118. `FUN_0604669E`
- [ ] 119. `FUN_060466A0`
- [ ] 120. `FUN_0604670C`
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
