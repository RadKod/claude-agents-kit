# Claude Code Agent Kit

Yeni projeye baslarken ilgili klasoru kopyala, yapistir, basla.

## Kullanim

```bash
# Ornek: React Native oyun projesi
cp -r react-native-game/.claude your-game-project/
cp react-native-game/CLAUDE.md your-game-project/
cp react-native-game/.mcp.json your-game-project/
```

Ayni mantik diger klasorler icin de gecerli:
- `react-native-app/` - Genel RN uygulama
- `laravel/` - Full-stack Laravel
- `nodejs/` - Node.js backend

## Ne var icinde?

Her klasorde:
- **CLAUDE.md** - Proje hafizasi, kurallar, komutlar
- **.claude/agents/** - Uzman sub-agent tanimlari
- **.claude/skills/** - On-demand bilgi paketleri
- **.claude/hooks/** - Otomatik kalite kontrol scriptleri
- **.claude/commands/** - Ozel slash komutlari (`/test`, `/review`)
- **.claude/settings.json** - Izinler ve hook tanimlari
- **.mcp.json** - MCP server entegrasyonlari
