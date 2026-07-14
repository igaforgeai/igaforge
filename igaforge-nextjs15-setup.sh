#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  IgaForge AI — Next.js 15 Production Setup
#  Usage: chmod +x setup.sh && ./setup.sh
#  Requirements: Node.js 18+, npm 9+
# ═══════════════════════════════════════════════════════════════
set -e
C='\033[0;36m';G='\033[0;32m';Y='\033[0;33m';R='\033[0m';B='\033[1m'
log(){ echo -e "${C}▶${R} $1"; }
ok(){ echo -e "${G}✓${R} $1"; }
hd(){ echo -e "\n${B}${Y}── $1 ──${R}"; }

echo -e "\n${B}${C}"
echo "  ╔═══════════════════════════════════════════════╗"
echo "  ║  🚀  IgaForge AI — Next.js 15 Production     ║"
echo "  ║  Every Culture. Every Language. One Mission.  ║"
echo "  ╚═══════════════════════════════════════════════╝"
echo -e "${R}\n"

P="igaforge-next"
mkdir -p "$P" && cd "$P"
mkdir -p app/legal/\[slug\]
mkdir -p components
mkdir -p contexts
mkdir -p lib
mkdir -p public

# ═══════════════════════════════════════════════════════════════
#  CONFIG FILES
# ═══════════════════════════════════════════════════════════════
hd "Config Files"

cat > package.json << 'EOF'
{
  "name": "igaforge-ai",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev --turbopack",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "15.1.0",
    "react": "19.0.0",
    "react-dom": "19.0.0"
  },
  "devDependencies": {
    "@types/node": "^22",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "autoprefixer": "^10",
    "eslint": "^9",
    "eslint-config-next": "15.1.0",
    "postcss": "^8",
    "tailwindcss": "^3.4.17",
    "typescript": "^5"
  }
}
EOF
ok "package.json"

cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF
ok "tsconfig.json"

cat > next.config.ts << 'EOF'
import type { NextConfig } from 'next'
const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
  compress: true,
}
export default nextConfig
EOF
ok "next.config.ts"

cat > tailwind.config.ts << 'EOF'
import type { Config } from 'tailwindcss'
const config: Config = {
  content: [
    './app/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './contexts/**/*.{ts,tsx}',
    './lib/**/*.ts',
  ],
  theme: {
    extend: {
      colors: {
        void: '#02030a',
        deep: '#050818',
        surface: '#0a0f2e',
        card: '#0d1440',
        electric: '#4d7cff',
        violet: '#a855f7',
        gold: '#ffd700',
        hot: '#ff4d8f',
        body: '#e2e8ff',
        muted: '#7a8ab8',
        cyan: '#00f5ff',
        igagreen: '#00ff88',
      },
      fontFamily: {
        orb: ['var(--font-orbitron)', 'monospace'],
        exo: ['var(--font-exo)', 'sans-serif'],
        mono: ['var(--font-mono)', 'monospace'],
      },
    },
  },
  plugins: [],
}
export default config
EOF
ok "tailwind.config.ts"

cat > postcss.config.mjs << 'EOF'
const config = { plugins: { tailwindcss: {}, autoprefixer: {} } }
export default config
EOF
ok "postcss.config.mjs"

cat > .gitignore << 'EOF'
node_modules/
/.next/
/out/
.env*.local
*.pem
npm-debug.log*
.DS_Store
.vercel
*.tsbuildinfo
next-env.d.ts
EOF
ok ".gitignore"

cat > .env.example << 'EOF'
NEXT_PUBLIC_SITE_URL=https://your-domain.com
EOF
ok ".env.example"

cat > vercel.json << 'EOF'
{
  "framework": "nextjs",
  "regions": ["gru1", "iad1", "lhr1", "sin1", "syd1"],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "Referrer-Policy", "value": "strict-origin-when-cross-origin" },
        { "key": "Strict-Transport-Security", "value": "max-age=63072000; includeSubDomains; preload" },
        { "key": "Permissions-Policy", "value": "camera=(), microphone=(), geolocation=()" }
      ]
    }
  ]
}
EOF
ok "vercel.json"

# ═══════════════════════════════════════════════════════════════
#  lib/types.ts
# ═══════════════════════════════════════════════════════════════
hd "Library: types"
cat > lib/types.ts << 'EOF'
export type Wave = 1 | 2 | 3
export type DemandColor = 'igagreen' | 'gold' | 'electric'
export type TagColor = 'c' | 'g' | 'gold' | 'v' | 'h'
export type LangCode = 'pt' | 'en' | 'es' | 'fr'

export interface Market {
  flag: string; country: string; region: string
  slogan: string; sub: string
  curr: string; pay: string
  demand: string; dc: string; wave: Wave
}
export interface Phase {
  num: string; title: string; color: string; time: string; items: string[]
}
export interface Plan {
  id: string; badge: string; price: string; period: string
  promo: string; original: string; featured: boolean
  borderColor: string; badgeBg: string; badgeColor: string
  items: string[]
}
export interface LegalCard {
  icon: string; title: string; body: string
  tags: { label: string; c: TagColor }[]
}
export interface ComplianceRow {
  region: string; law: string; rights: string; payment: string; status: 'active' | 'planned'
}
export interface ModalConfig {
  icon: string; title: string; desc: string; label: string
}
export interface LegalDoc {
  title: string; date: string; body: string
}
EOF
ok "lib/types.ts"

# ═══════════════════════════════════════════════════════════════
#  lib/data.ts
# ═══════════════════════════════════════════════════════════════
hd "Library: data"
cat > lib/data.ts << 'EOF'
import type { Market, Phase, Plan, LegalCard, ComplianceRow, ModalConfig, LegalDoc } from './types'

export const SLOGANS = [
  { flag:'🇧🇷', s:'Conhecimento que liberta.',              l:'PT · Brasil',        c:'#00f5ff' },
  { flag:'🇺🇸', s:'Learn it. Own it. Scale it.',            l:'EN · USA',           c:'#00ff88' },
  { flag:'🇳🇬', s:'Ìmọ̀ tó yí ayé padà.',                  l:'Yoruba · Nigeria',   c:'#ffd700' },
  { flag:'🇮🇳', s:'ज्ञान जो दुनिया बदले।',                 l:'Hindi · India',      c:'#a855f7' },
  { flag:'🇩🇪', s:'Wissen, das Grenzen sprengt.',           l:'DE · Deutschland',   c:'#ff4d8f' },
  { flag:'🇲🇽', s:'Saber sin límites.',                     l:'ES · México',        c:'#4d7cff' },
  { flag:'🇰🇪', s:'Ujuzi ni nguvu.',                        l:'Swahili · Kenya',    c:'#00f5ff' },
  { flag:'🇸🇦', s:'المعرفة طريق المستقبل.',                l:'AR · السعودية',      c:'#ffd700' },
  { flag:'🇯🇵', s:'知識が、世界を変える。',                 l:'JA · 日本',          c:'#00ff88' },
  { flag:'🇫🇷', s:"Le savoir n'a pas de frontières.",      l:'FR · France',        c:'#a855f7' },
  { flag:'🇿🇦', s:'Ukwazi kuyashintsha izinto.',            l:'Zulu · South Africa',c:'#ff4d8f' },
  { flag:'🇮🇩', s:'Ilmu yang mengubah dunia.',              l:'ID · Indonesia',     c:'#4d7cff' },
  { flag:'🇪🇬', s:'العلم نور.',                            l:'AR · Egypt',         c:'#00f5ff' },
  { flag:'🇵🇱', s:'Wiedza zmienia świat.',                  l:'PL · Poland',        c:'#ffd700' },
  { flag:'🇻🇳', s:'Tri thức thay đổi thế giới.',           l:'VI · Vietnam',       c:'#00ff88' },
  { flag:'🇨🇴', s:'El conocimiento no tiene fronteras.',    l:'ES · Colombia',      c:'#a855f7' },
  { flag:'🇹🇷', s:'Bilgi dünyayı değiştirir.',              l:'TR · Türkiye',       c:'#4d7cff' },
  { flag:'🇵🇹', s:'O saber não tem fronteiras.',            l:'PT · Portugal',      c:'#ff4d8f' },
]

export const MARKETS: Market[] = [
  { flag:'🇧🇷',country:'Brasil',region:'LATAM · South America',slogan:'Conhecimento que liberta.',sub:'Português · Native',curr:'BRL R$',pay:'Pix · Boleto · Card',demand:'🔥 Very High',dc:'#00ff88',wave:1 },
  { flag:'🇺🇸',country:'United States',region:'North America · Largest EdTech',slogan:'Learn it. Own it. Scale it.',sub:'English · Native',curr:'USD $',pay:'Stripe · PayPal · Card',demand:'🔥 Highest Global',dc:'#00ff88',wave:1 },
  { flag:'🇳🇬',country:'Nigeria',region:"West Africa · Africa's Largest Economy",slogan:'Ìmọ̀ tó yí ayé padà.',sub:"Yoruba · 'Knowledge that changes the world'",curr:'NGN ₦',pay:'Flutterwave · Paystack',demand:'🔥 Explosive',dc:'#00ff88',wave:1 },
  { flag:'🇮🇳',country:'India',region:'South Asia · 1.4B People',slogan:'ज्ञान जो दुनिया बदले।',sub:"Hindi · 'Knowledge that changes the world'",curr:'INR ₹',pay:'UPI · Razorpay · Paytm',demand:'🔥 Fastest Growing',dc:'#00ff88',wave:1 },
  { flag:'🇩🇪',country:'Deutschland',region:'Central Europe · Weiterbildung Hub',slogan:'Wissen, das Grenzen sprengt.',sub:'Deutsch · Native',curr:'EUR €',pay:'iDEAL · SEPA · Stripe',demand:'📈 Corporate Training',dc:'#ffd700',wave:2 },
  { flag:'🇲🇽',country:'México',region:'LATAM · North America Gateway',slogan:'Saber sin límites, crecer sin fronteras.',sub:'Español · Native',curr:'MXN $',pay:'OXXO · Conekta · Stripe',demand:'📈 High + Nearshoring',dc:'#ffd700',wave:2 },
  { flag:'🇰🇪',country:'Kenya',region:'East Africa · Silicon Savannah',slogan:'Ujuzi ni nguvu ya kubadilisha dunia.',sub:"Swahili · 'Knowledge is power to change the world'",curr:'KES Ksh',pay:'M-Pesa · Airtel Money',demand:'📈 Growing Fast',dc:'#ffd700',wave:2 },
  { flag:'🇸🇦',country:'المملكة العربية السعودية',region:'Middle East · Vision 2030',slogan:'المعرفة طريق المستقبل.',sub:"Arabic · 'Knowledge is the path to the future'",curr:'SAR ﷼',pay:'Mada · STC Pay · Stripe',demand:'📈 Gov. Backed',dc:'#ffd700',wave:2 },
  { flag:'🇯🇵',country:'日本',region:'East Asia · Premium Market',slogan:'知識が、世界を変える。',sub:"Japanese · 'Knowledge changes the world'",curr:'JPY ¥',pay:'Konbini · PayPay · Stripe',demand:'🌐 Reskilling Wave',dc:'#4d7cff',wave:3 },
  { flag:'🇫🇷',country:'France',region:'Europe · 29-Country Francophone',slogan:"Le savoir n'a pas de frontières.",sub:"Français · 'Knowledge has no borders'",curr:'EUR €',pay:'CB · Lydia · Stripe',demand:'🌐 + Francophonie 321M',dc:'#4d7cff',wave:3 },
  { flag:'🇿🇦',country:'South Africa',region:'Southern Africa · SADC Gateway',slogan:'Ukwazi kuyashintsha izinto.',sub:"Zulu · 'Knowledge changes things'",curr:'ZAR R',pay:'SnapScan · Ozow · PayFast',demand:'🌐 Regional Hub',dc:'#4d7cff',wave:3 },
]

export const WAVE_STYLES = {
  1: { label:'🔥 Wave 1', bg:'rgba(0,255,136,.15)', c:'#00ff88', br:'rgba(0,255,136,.25)' },
  2: { label:'⭐ Wave 2', bg:'rgba(255,215,0,.12)',  c:'#ffd700', br:'rgba(255,215,0,.2)' },
  3: { label:'🌐 Wave 3', bg:'rgba(77,124,255,.12)', c:'#4d7cff', br:'rgba(77,124,255,.2)' },
} as const

export const INSPIRED = [
  { emoji:'🚀', name:'SpaceX',       desc:'Ambitious vision + phased execution' },
  { emoji:'⚡', name:'Tesla',        desc:'Premium D2C + OTA updates' },
  { emoji:'🌐', name:'Google Chrome',desc:'Universal access + global infra' },
  { emoji:'🤖', name:'OpenAI',       desc:'API-first + developer ecosystem' },
  { emoji:'🎬', name:'Netflix',      desc:'Localization + recommendation engine' },
  { emoji:'🎓', name:'Coursera',     desc:'Institutional partnerships + certification' },
  { emoji:'🦜', name:'Duolingo',     desc:'Gamification + local pedagogy' },
  { emoji:'🚗', name:'Uber / 99',    desc:'Local pricing + local payment' },
  { emoji:'🔬', name:'Big Labs',     desc:'Research → real product' },
]

export const TOOLS = [
  { source:'Inspired by: Netflix + Duolingo', name:'🎬 Localization & Content Engine', desc:"Content rewritten — not just translated — to resonate authentically in each culture.", adapt:"↗ Native slogan per country, locally-accented avatar, authentic cultural references." },
  { source:'Inspired by: Uber + 99',          name:'💳 Local Currency & Payment Engine', desc:'Dynamic pricing by country. Pix, M-Pesa, WeChat Pay, iDEAL, UPI — the student pays their way.', adapt:'↗ Zero currency friction. Local payment. Local trust.' },
  { source:'Inspired by: OpenAI + Big Labs',  name:'🤖 AI Orchestration (API-First)',   desc:'Claude, GPT-4o, Gemini and regional models orchestrated per market context.', adapt:'↗ Best model for each market, not just the globally popular one.' },
  { source:'Inspired by: Netflix + Coursera', name:'📊 Demand & Recommendation Engine', desc:'Identifies high-demand niches and qualified leads by region — before building the course.', adapt:'↗ We prioritize highest-ROI countries first, then expand.' },
  { source:'Inspired by: Google Chrome + SpaceX', name:'🌐 Global CDN & Infrastructure', desc:'Video and content delivered with low latency in any country via distributed CDN.', adapt:'↗ Same performance for a student in Lagos or Berlin.' },
  { source:'Inspired by: Duolingo + Tesla',   name:'🎮 Engagement & Retention Engine', desc:"Culturally-adapted gamification, native-language notifications, OTA course updates.", adapt:"↗ A Japanese learner doesn't learn like a Brazilian — the system knows that." },
]

export const PHASES: Phase[] = [
  { num:'PHASE 1 · NOW → 6 MONTHS', title:'🟢 Global MVP', color:'green', time:'Wave 1: Brazil · USA · Nigeria · India',
    items:['Content upload → AI-structured course','Avatar video in PT, EN, IG, HI','Native slogan per country (no translation)','Local currency payment (Pix, Stripe, Flutterwave, UPI)','Auto landing page + checkout','Hotmart, Kiwify, Kajabi integration','Human curriculum review (quality guaranteed)'] },
  { num:'PHASE 2 · 6–18 MONTHS', title:'🟡 Geopolitical Expansion', color:'gold', time:'Wave 2: Germany · Mexico · Kenya · Saudi Arabia',
    items:['AI-assisted deep cultural adaptation','30+ languages with regional models','M-Pesa, Mada, OXXO, iDEAL integrated','Demand Engine — niches by country before building','Auto marketing (Reels, Ads, Email sequences)','White-Label for local institutions','Geopolitically-valid certifications'] },
  { num:'PHASE 3 · 18–48 MONTHS', title:'🟣 Autonomous Global Scale', color:'violet', time:'Wave 3: Japan · France · South Africa · +40 countries',
    items:['Real Self-Learning Engine (50+ markets)','AI-guided autonomous launch (with approval)','Zero-latency CDN for every country','Konbini · SnapScan · Lydia · PayPay integrated','Gov. & institutional partnerships','Global multi-language course marketplace','Public API for partner ecosystem'] },
]

export const PLANS: Plan[] = [
  { id:'Starter',    badge:'STARTER',    price:'97',  period:'/mo · USD', promo:'Early Bird', original:'$197',   featured:false, borderColor:'rgba(77,124,255,.3)',  badgeBg:'rgba(77,124,255,.15)',  badgeColor:'#4d7cff',  items:['✓ 5 courses/month','✓ AI Avatar (PT · EN · ES)','✓ 3 languages · 3 countries','✓ Landing page + checkout','✓ LGPD / GDPR compliant'] },
  { id:'Pro Global', badge:'PRO GLOBAL', price:'297', period:'/mo · USD', promo:'Early Bird', original:'$597',   featured:true,  borderColor:'#00f5ff',              badgeBg:'rgba(0,245,255,.15)',   badgeColor:'#00f5ff',  items:['✓ Unlimited courses','✓ Realistic AI Avatar','✓ 10 languages · Full Wave 1','✓ Local currency payments','✓ Marketing Engine','✓ Full data compliance pack'] },
  { id:'Enterprise', badge:'ENTERPRISE', price:'997', period:'/mo · USD', promo:'Early Bird', original:'$1,997', featured:false, borderColor:'rgba(168,85,247,.3)',  badgeBg:'rgba(168,85,247,.15)', badgeColor:'#a855f7',  items:['✓ Everything in Pro Global','✓ White-Label complete','✓ API Access + DPA agreement','✓ SOC 2 audit reports','✓ Dedicated legal compliance'] },
]

export const LEGAL_BADGES = ['🇺🇳 UN SDG 4','📜 UNESCO OER','⚖️ UDHR Art. 26','🔒 GDPR','🔒 LGPD','🔒 CCPA','🔒 POPIA','🔒 PDPA','♿ WCAG 2.1 AA','🛡️ DMCA','👶 COPPA','🤖 Responsible AI']

export const LEGAL_CARDS: LegalCard[] = [
  { icon:'🇺🇳', title:'UN SDG 4 — Quality Education',      body:'Aligned with SDG 4: ensuring inclusive, equitable and lifelong learning for all. Every feature decision is evaluated against this mandate.',                                                tags:[{label:'SDG 4',c:'c'},{label:'UNESCO OER',c:'g'},{label:'Inclusive Design',c:'c'}] },
  { icon:'⚖️', title:'UDHR Article 26 — Right to Education', body:'"Everyone has the right to education." No discriminatory access based on nationality, language, religion, gender or economic status.',                                                      tags:[{label:'UDHR Art. 26',c:'gold'},{label:'Non-Discriminatory',c:'g'}] },
  { icon:'🔒', title:'Global Data Protection & Privacy',     body:'Full compliance with data protection law in every country. Data sovereignty: user data stored in the region where it originates. No data sold. Ever.',                                        tags:[{label:'GDPR',c:'c'},{label:'LGPD',c:'c'},{label:'CCPA',c:'c'},{label:'POPIA',c:'c'}] },
  { icon:'©️', title:'Creator IP Rights',                    body:'Creators own 100% of their content. IgaForge AI claims no ownership. All AI-generated derivatives belong to the creator. DMCA enforced globally.',                                           tags:[{label:'Creator Owns Content',c:'gold'},{label:'DMCA',c:'c'},{label:'IP Protected',c:'g'}] },
  { icon:'♿', title:'Accessibility — WCAG 2.1 AA',          body:'Captions on all AI-generated videos. Screen reader compatibility. High-contrast mode. RTL language support (Arabic, Hebrew, Urdu, Persian).',                                               tags:[{label:'WCAG 2.1 AA',c:'g'},{label:'ADA Compatible',c:'c'},{label:'RTL Support',c:'c'}] },
  { icon:'👶', title:"Children's Safety",                    body:'Full COPPA compliance for users under 13. GDPR-K for EU minors under 16. No behavioral advertising to minors. Parental consent flow enforced.',                                              tags:[{label:'COPPA',c:'h'},{label:'GDPR-K',c:'h'},{label:'No Child Data Mining',c:'g'}] },
  { icon:'🤝', title:'Anti-Discrimination Policy',           body:'Prohibits content that discriminates based on race, ethnicity, gender, religion, disability or sexual orientation. Enforced across all 50+ markets.',                                          tags:[{label:'Zero Discrimination',c:'g'},{label:'Global Moderation',c:'c'}] },
  { icon:'📜', title:'Terms of Service',                     body:"Plain-language Terms in every language we operate — not just English. ICC arbitration for disputes. Local jurisdiction compliance per country.",                                              tags:[{label:'Multi-Language ToS',c:'c'},{label:'ICC Arbitration',c:'gold'}] },
  { icon:'🛡️', title:'Platform Security',                   body:'SOC 2 Type II compliance roadmap. AES-256 encryption at rest and in transit. No training on user content without explicit consent.',                                                          tags:[{label:'AES-256',c:'c'},{label:'SOC 2 Roadmap',c:'gold'},{label:'No AI Training',c:'g'}] },
]

export const RAI_PRINCIPLES = [
  { icon:'🎯', title:'Transparency',     desc:'Users always know when content is AI-generated. No hidden automation.' },
  { icon:'⚖️', title:'Fairness',         desc:'AI models audited for bias across languages, cultures and demographics.' },
  { icon:'🔒', title:'Privacy by Design',desc:'Data minimization from the architecture layer. Built in — not bolted on.' },
  { icon:'🧑‍⚖️',title:'Human Oversight', desc:'Critical decisions always have a human in the loop. AI assists; humans decide.' },
  { icon:'🌱', title:'Do No Harm',       desc:'No AI content that causes misinformation, bias or psychological harm.' },
  { icon:'📖', title:'Explainability',   desc:'Creators can always see why the AI made a recommendation and override it.' },
]

export const DATA_COMPLIANCE: ComplianceRow[] = [
  { region:'🇪🇺 European Union', law:'GDPR (2018)',           rights:'Erasure, portability, consent',  payment:'PSD2 / SCA',       status:'active' },
  { region:'🇧🇷 Brazil',         law:'LGPD (2020)',           rights:'Data minimization, consent',     payment:'BACEN / Pix regs', status:'active' },
  { region:'🇺🇸 United States',  law:'CCPA / COPPA / FERPA', rights:'Opt-out, minor protection',      payment:'PCI-DSS',          status:'active' },
  { region:'🇳🇬 Nigeria',        law:'NDPR (2019)',           rights:'Lawful processing, security',    payment:'CBN regulations',  status:'active' },
  { region:'🇮🇳 India',          law:'DPDP Act (2023)',       rights:'Consent, purpose limitation',    payment:'RBI / UPI regs',   status:'active' },
  { region:'🇿🇦 South Africa',   law:'POPIA (2021)',          rights:'Accountability, subject rights', payment:'SARB regulations', status:'planned' },
  { region:'🇸🇦 Saudi Arabia',   law:'PDPL (2023)',           rights:'Consent, cross-border transfers',payment:'SAMA regulations', status:'planned' },
  { region:'🇯🇵 Japan',          law:'APPI (amended 2022)',   rights:'Third-party transfer limits',    payment:'FSA regulations',  status:'planned' },
]

export const MODAL_CFG: Record<string, ModalConfig> = {
  'Starter':    { icon:'🚀', title:'Starter Spot',          desc:'Early bird with 51% discount. Team confirms within 24h.',                         label:'Secure My Starter Spot →' },
  'Pro Global': { icon:'🌍', title:'Pro Global Spot',       desc:'Most complete plan for multi-market creators. Exclusive founder pricing.',        label:'Secure My Pro Global Spot →' },
  'Enterprise': { icon:'🏢', title:'Enterprise Spot',       desc:'White-Label + API + dedicated DPA. Team contacts you within 24h.',               label:'Secure My Enterprise Spot →' },
  'Investor':   { icon:'💰', title:'Invest in the Mission', desc:'We are in fundraising. Founder will personally share the full pitch deck.',       label:'Request Pitch Deck →' },
  'Partner':    { icon:'🤝', title:'Strategic Partnership', desc:"Let's build the future of global education together.",                            label:'Start the Conversation →' },
}

export const LEGAL_DOCS: Record<string, LegalDoc> = {
  terms: {
    title:'📜 Terms of Service', date:'Effective: January 1, 2025',
    body:`<h3>1. Acceptance of Terms</h3><p>By accessing or using this platform, you agree to these Terms. They apply globally and are supplemented by local legal requirements in each jurisdiction.</p><h3>2. Creator Rights & Content Ownership</h3><p><strong>You own your content.</strong> We claim no ownership over original content you upload. AI-generated derivatives belong exclusively to you. You grant us a limited, non-exclusive, revocable license solely to deliver the platform's services.</p><h3>3. Acceptable Use</h3><p>You agree not to create content that violates applicable laws; discriminates based on race, gender, religion, disability, national origin or sexual orientation; infringes third-party IP; or targets minors inappropriately.</p><h3>4. Payments & Refunds</h3><p>Refund requests within 14 days of charge are reviewed consistent with consumer protection laws in your jurisdiction.</p><h3>5. Dispute Resolution</h3><p>Disputes are subject to binding arbitration under ICC Rules after good-faith negotiation fails.</p><h3>6. Modifications</h3><p>Material changes are communicated 30 days in advance via email and in-platform notification.</p>`,
  },
  privacy: {
    title:'🔒 Privacy Policy', date:'Effective: January 1, 2025 · GDPR · LGPD · CCPA · POPIA · PDPA compliant',
    body:`<h3>1. Data We Collect</h3><p>Account information (name, email, country), content you upload, usage data, and payment information processed by certified processors — never stored by us.</p><h3>2. How We Use Your Data</h3><p>Exclusively to deliver services, improve the product, communicate updates, and comply with legal obligations. <strong>We never sell your data to third parties.</strong></p><h3>3. Data Sovereignty</h3><p>Your data is stored in the region where you are located: EU users → EU servers; Brazilian users → Brazil servers; US users → US servers.</p><h3>4. Your Rights</h3><ul><li><strong>Right to Access:</strong> Request a copy of your data at any time.</li><li><strong>Right to Erasure:</strong> Request deletion (GDPR Art. 17 / LGPD Art. 18).</li><li><strong>Right to Portability:</strong> Export your data in machine-readable format.</li><li><strong>Right to Object:</strong> Opt out of non-essential data processing.</li></ul><h3>5. AI Processing</h3><p><strong>Your content is never used to train AI models</strong> without your explicit written consent.</p><h3>6. Contact</h3><p>Data Protection Officer: <strong>privacy@contact.com</strong> · Response within 30 days as required by law.</p>`,
  },
  cookies: {
    title:'🍪 Cookie Policy', date:'Effective: January 1, 2025',
    body:`<h3>Types of Cookies We Use</h3><p><strong>Essential Cookies:</strong> Required for authentication, security, CSRF protection. Cannot be disabled.</p><p><strong>Functional Cookies:</strong> Remember your preferences (language, currency, accessibility). Enabled by default.</p><p><strong>Analytics Cookies:</strong> Anonymized usage data via privacy-first analytics. Opt-in only.</p><p><strong>We do NOT use:</strong> Third-party advertising cookies, cross-site tracking, or behavioral profiling cookies.</p><h3>Your Choices</h3><p>Manage preferences from account settings or the cookie banner. Withdrawing consent does not affect prior lawful processing.</p><h3>Retention</h3><p>Essential: session-based. Functional: 12 months. Analytics: 6 months anonymized.</p>`,
  },
  'creator-rights': {
    title:'©️ Creator Rights & IP Policy', date:'Effective: January 1, 2025',
    body:`<h3>You Own Your Content — Period.</h3><p>We claim no ownership of any original content you create or upload. This includes text, audio, video, presentations, PDFs, and AI-generated derivatives.</p><h3>License You Grant</h3><p>A limited, non-exclusive, revocable license to process and display your content <strong>solely for delivering our services to you</strong>. Terminates when you delete your content or close your account.</p><h3>AI-Generated Content Ownership</h3><p>All AI-generated materials produced using your source material are owned by you. We retain no rights to these outputs.</p><h3>DMCA Compliance</h3><p>To submit a takedown request: dmca@contact.com. We respond within 48h and action valid requests within 72h.</p>`,
  },
  accessibility: {
    title:'♿ Accessibility Statement', date:'Effective: January 1, 2025 · Target: WCAG 2.1 Level AA',
    body:`<h3>Our Commitment</h3><p>We are committed to ensuring digital accessibility for people with disabilities across all 50+ markets we operate in.</p><h3>Standards We Target</h3><ul><li>WCAG 2.1 Level AA</li><li>ADA Title III (USA)</li><li>EN 301 549 (European Accessibility Standard)</li></ul><h3>Features</h3><ul><li>Screen reader compatibility (NVDA, JAWS, VoiceOver)</li><li>Full keyboard navigation</li><li>Automatic captions on all AI-generated videos</li><li>High-contrast mode and adjustable text size</li><li>RTL language support (Arabic, Hebrew, Urdu, Persian)</li></ul><h3>Feedback</h3><p>accessibility@contact.com · We respond within 5 business days.</p>`,
  },
  dmca: {
    title:'🛡️ DMCA & Copyright Policy', date:'Effective: January 1, 2025',
    body:`<h3>Our Policy</h3><p>We comply with the DMCA, EU Directive 2019/790, and equivalent copyright laws in all markets we operate in.</p><h3>Reporting Infringement</h3><p>Send a written notice to <strong>dmca@contact.com</strong> including: (1) identification of the copyrighted work; (2) location of the infringing material; (3) your contact information; (4) a good faith belief statement; (5) an accuracy statement under penalty of perjury.</p><h3>Response Timeline</h3><p>We acknowledge valid DMCA notices within 48h and remove infringing content within 72h of verification.</p><h3>Repeat Infringers</h3><p>Accounts with repeated valid infringement notices will be terminated per our Terms of Service.</p>`,
  },
  'responsible-ai': {
    title:'🤖 Responsible AI Policy', date:'Effective: January 1, 2025 · EU AI Act · OpenAI Usage Policy aligned',
    body:`<h3>Our Principles</h3><p>We are committed to AI that is transparent, fair, accountable and beneficial. These principles govern every AI system on our platform.</p><h3>Transparency</h3><p>All AI-generated content is clearly labeled. No hidden automation.</p><h3>No Training on User Content</h3><p><strong>We do not use your content to train AI models</strong> without explicit written consent.</p><h3>Bias Auditing</h3><p>AI models are regularly audited for cultural, linguistic and demographic bias.</p><h3>Human Oversight</h3><p>Critical decisions always involve human review. AI assists; humans decide.</p><h3>EU AI Act Alignment</h3><p>Our AI systems are classified as limited-risk under the EU AI Act and comply with its transparency and documentation requirements.</p>`,
  },
  about: {
    title:'🌍 About This Platform', date:'Founded 2024',
    body:`<h3>Mission</h3><p>This platform exists to make high-quality education accessible to every human being on Earth — in their native language, their cultural context, and at a price accessible in their economy.</p><h3>Founder</h3><p><strong>Odette Nduwayezu</strong> — an educator and entrepreneur with a vision of education without borders. The platform was born from the belief that the world's knowledge should reach every corner of the planet, not just English-speaking markets.</p><h3>Humanitarian Commitment</h3><p>We are aligned with UN SDG 4 (Quality Education) and the Universal Declaration of Human Rights, Article 26. Education is not a luxury. It is a right. Everything we build is guided by this principle.</p>`,
  },
}
EOF
ok "lib/data.ts"

# ═══════════════════════════════════════════════════════════════
#  lib/i18n.ts
# ═══════════════════════════════════════════════════════════════
hd "Library: i18n"
cat > lib/i18n.ts << 'EOF'
import type { LangCode } from './types'

export type { LangCode }
export const LANGS: LangCode[] = ['pt', 'en', 'es', 'fr']

export interface DiagOption  { t: string; s: number; n: string }
export interface DiagQuestion{ q: string; opts: DiagOption[] }
export interface Archetype   { e: string; t: string; c: string; d: string; p: string | null }
export interface LangDict {
  flag: string; name: string
  intro: { title: string; sub: string; cta: string }
  prog: string; of: string; loading: string; redo: string; secure: string; rec: string
  qs: DiagQuestion[]
  archs: { high: Archetype; mid: Archetype; low: Archetype }
  needs: Record<string, string>
}

export const I18N: Record<LangCode, LangDict> = {
  pt: {
    flag:'🇧🇷', name:'Português',
    intro:{ title:'Vamos descobrir seu perfil', sub:'Leva menos de 1 minuto. No final você recebe uma recomendação personalizada.', cta:'Começar Diagnóstico →' },
    prog:'PERGUNTA', of:'DE', loading:'Analisando seu perfil...', redo:'Refazer', secure:'Garantir Minha Vaga →', rec:'Recomendação para você:',
    qs:[
      { q:'Você já tem conhecimento ou experiência que poderia transformar em curso?', opts:[{t:'Sim, domino profundamente um assunto',s:3,n:'execution'},{t:'Tenho experiência mas nunca estruturei',s:2,n:'structure'},{t:'Estou aprendendo ainda',s:1,n:'clarity'}] },
      { q:'Qual seu maior obstáculo para criar um curso hoje?', opts:[{t:'Tempo para gravar e editar vídeo',s:3,n:'video'},{t:'Não sei estruturar o conteúdo',s:2,n:'structure'},{t:'Medo de não vender',s:1,n:'marketing'}] },
      { q:'Você gostaria de vender seu curso em outros países/idiomas?', opts:[{t:'Sim, é meu objetivo principal',s:3,n:'global'},{t:'Seria interessante no futuro',s:2,n:'global'},{t:'Só penso no mercado local por agora',s:1,n:'local'}] },
      { q:'Quanto tempo você teria disponível por semana para gerenciar o curso?', opts:[{t:'Menos de 2 horas',s:3,n:'automation'},{t:'Entre 2 e 5 horas',s:2,n:'automation'},{t:'Mais de 5 horas',s:1,n:'hands-on'}] },
    ],
    archs:{ high:{e:'🚀',t:'Founder Global',c:'#00f5ff',d:'Você tem conhecimento sólido e visão global. O gargalo é execução — não conhecimento. A plataforma resolve isso: estrutura, traduz e lança por você.',p:'Pro Global'}, mid:{e:'🌱',t:'Especialista em Construção',c:'#ffd700',d:'Boa base, mas falta estrutura e confiança para escalar. Comece com 1 curso piloto bem feito antes de pensar em global.',p:'Starter'}, low:{e:'🔍',t:'Explorador de Conhecimento',c:'#a855f7',d:'Você ainda está validando sua área. Ótimo momento para organizar ideias com IA antes de pensar em vender.',p:null} },
    needs:{ execution:'Você precisa de: execução rápida, não mais conhecimento', structure:'Você precisa de: estrutura — o Course Builder organiza por você', clarity:'Você precisa de: clareza — defina seu nicho antes de criar', video:'Você precisa de: Avatar IA — sem gravar, sem editar', marketing:'Você precisa de: Marketing Engine — copy e anúncios automáticos', global:'Você precisa de: Localização Multilíngue — slogans nativos por país', local:'Você precisa de: foco no mercado local primeiro, escale depois', automation:'Você precisa de: Autonomous Launch — o sistema cuida da rotina', 'hands-on':'Você precisa de: controle total — comece manual, automatize depois' },
  },
  en: {
    flag:'🇺🇸', name:'English',
    intro:{ title:"Let's find your profile", sub:"Takes under 1 minute. You'll get a personalized recommendation at the end.", cta:'Start Diagnostic →' },
    prog:'QUESTION', of:'OF', loading:'Analyzing your profile...', redo:'Retake', secure:'Secure My Spot →', rec:'Recommended for you:',
    qs:[
      { q:'Do you already have knowledge or experience you could turn into a course?', opts:[{t:'Yes, I deeply master a subject',s:3,n:'execution'},{t:'I have experience but never structured it',s:2,n:'structure'},{t:"I'm still learning",s:1,n:'clarity'}] },
      { q:"What's your biggest obstacle to creating a course today?", opts:[{t:'Time to record and edit video',s:3,n:'video'},{t:"I don't know how to structure the content",s:2,n:'structure'},{t:'Fear of not selling',s:1,n:'marketing'}] },
      { q:'Would you like to sell your course in other countries/languages?', opts:[{t:"Yes, it's my main goal",s:3,n:'global'},{t:'Could be interesting in the future',s:2,n:'global'},{t:"I'm only thinking local for now",s:1,n:'local'}] },
      { q:'How much time per week could you dedicate to managing the course?', opts:[{t:'Less than 2 hours',s:3,n:'automation'},{t:'2 to 5 hours',s:2,n:'automation'},{t:'More than 5 hours',s:1,n:'hands-on'}] },
    ],
    archs:{ high:{e:'🚀',t:'Global Founder',c:'#00f5ff',d:"You have solid knowledge and global vision. The bottleneck is execution — not knowledge. The platform solves exactly that: structures, translates and launches for you.",p:'Pro Global'}, mid:{e:'🌱',t:'Builder in Progress',c:'#ffd700',d:'Good foundation, but you need structure and confidence before scaling globally. Start with one well-built pilot course.',p:'Starter'}, low:{e:'🔍',t:'Knowledge Explorer',c:'#a855f7',d:"You're still validating your area of expertise. Great moment to organize your ideas with AI before thinking about selling.",p:null} },
    needs:{ execution:'You need: fast execution, not more knowledge', structure:'You need: structure — Course Builder organizes it for you', clarity:'You need: clarity — define your niche before creating', video:'You need: AI Avatar — no recording, no editing', marketing:'You need: Marketing Engine — automatic copy and ads', global:'You need: Multilingual Localization — native slogans per country', local:'You need: local market focus first, scale later', automation:'You need: Autonomous Launch — the system handles the routine', 'hands-on':'You need: full control — start manual, automate later' },
  },
  es: {
    flag:'🇲🇽', name:'Español',
    intro:{ title:'Descubramos tu perfil', sub:'Toma menos de 1 minuto. Al final recibes una recomendación personalizada.', cta:'Comenzar Diagnóstico →' },
    prog:'PREGUNTA', of:'DE', loading:'Analizando tu perfil...', redo:'Repetir', secure:'Asegurar Mi Lugar →', rec:'Recomendación para ti:',
    qs:[
      { q:'¿Ya tienes conocimiento o experiencia que podrías convertir en un curso?', opts:[{t:'Sí, domino profundamente un tema',s:3,n:'execution'},{t:'Tengo experiencia pero nunca la estructuré',s:2,n:'structure'},{t:'Todavía estoy aprendiendo',s:1,n:'clarity'}] },
      { q:'¿Cuál es tu mayor obstáculo para crear un curso hoy?', opts:[{t:'Tiempo para grabar y editar video',s:3,n:'video'},{t:'No sé cómo estructurar el contenido',s:2,n:'structure'},{t:'Miedo a no vender',s:1,n:'marketing'}] },
      { q:'¿Te gustaría vender tu curso en otros países/idiomas?', opts:[{t:'Sí, es mi objetivo principal',s:3,n:'global'},{t:'Podría ser interesante en el futuro',s:2,n:'global'},{t:'Solo pienso en el mercado local por ahora',s:1,n:'local'}] },
      { q:'¿Cuánto tiempo por semana podrías dedicar a gestionar el curso?', opts:[{t:'Menos de 2 horas',s:3,n:'automation'},{t:'Entre 2 y 5 horas',s:2,n:'automation'},{t:'Más de 5 horas',s:1,n:'hands-on'}] },
    ],
    archs:{ high:{e:'🚀',t:'Fundador Global',c:'#00f5ff',d:'Tienes conocimiento sólido y visión global. El obstáculo es la ejecución, no el conocimiento. La plataforma resuelve exactamente eso.',p:'Pro Global'}, mid:{e:'🌱',t:'Constructor en Progreso',c:'#ffd700',d:'Buena base, pero falta estructura y confianza para escalar globalmente. Empieza con un curso piloto bien hecho.',p:'Starter'}, low:{e:'🔍',t:'Explorador de Conocimiento',c:'#a855f7',d:'Todavía estás validando tu área. Buen momento para organizar tus ideas con IA antes de pensar en vender.',p:null} },
    needs:{ execution:'Necesitas: ejecución rápida, no más conocimiento', structure:'Necesitas: estructura — Course Builder lo organiza por ti', clarity:'Necesitas: claridad — define tu nicho antes de crear', video:'Necesitas: Avatar IA — sin grabar, sin editar', marketing:'Necesitas: Marketing Engine — copy y anuncios automáticos', global:'Necesitas: Localización Multilingüe — slogans nativos por país', local:'Necesitas: enfoque local primero, escalar después', automation:'Necesitas: Lanzamiento Autónomo — el sistema gestiona la rutina', 'hands-on':'Necesitas: control total — empieza manual, automatiza después' },
  },
  fr: {
    flag:'🇫🇷', name:'Français',
    intro:{ title:'Découvrons votre profil', sub:"Moins d'une minute. Vous recevrez une recommandation personnalisée à la fin.", cta:'Commencer le diagnostic →' },
    prog:'QUESTION', of:'SUR', loading:'Analyse de votre profil...', redo:'Refaire', secure:'Réserver ma place →', rec:'Recommandé pour vous :',
    qs:[
      { q:'Avez-vous déjà des connaissances ou une expérience à transformer en formation ?', opts:[{t:'Oui, je maîtrise profondément un sujet',s:3,n:'execution'},{t:"J'ai de l'expérience mais jamais structurée",s:2,n:'structure'},{t:'Je suis encore en apprentissage',s:1,n:'clarity'}] },
      { q:"Quel est votre plus grand obstacle pour créer une formation aujourd'hui ?", opts:[{t:'Le temps pour filmer et monter la vidéo',s:3,n:'video'},{t:'Je ne sais pas structurer le contenu',s:2,n:'structure'},{t:'La peur de ne pas vendre',s:1,n:'marketing'}] },
      { q:"Souhaitez-vous vendre votre formation dans d'autres pays/langues ?", opts:[{t:"Oui, c'est mon objectif principal",s:3,n:'global'},{t:"Ça pourrait être intéressant plus tard",s:2,n:'global'},{t:'Je pense seulement au marché local pour le moment',s:1,n:'local'}] },
      { q:'Combien de temps par semaine pourriez-vous consacrer à la gestion ?', opts:[{t:'Moins de 2 heures',s:3,n:'automation'},{t:'2 à 5 heures',s:2,n:'automation'},{t:'Plus de 5 heures',s:1,n:'hands-on'}] },
    ],
    archs:{ high:{e:'🚀',t:'Fondateur Global',c:'#00f5ff',d:"Vous avez des connaissances solides et une vision globale. Le frein c'est l'exécution — pas la connaissance. La plateforme résout exactement cela.",p:'Pro Global'}, mid:{e:'🌱',t:'Bâtisseur en Progrès',c:'#ffd700',d:"Bonne base, mais il manque structure et confiance pour passer à l'échelle. Commencez par une formation pilote bien construite.",p:'Starter'}, low:{e:'🔍',t:'Explorateur de Connaissances',c:'#a855f7',d:"Vous validez encore votre domaine. Bon moment pour organiser vos idées avec l'IA avant de penser à vendre.",p:null} },
    needs:{ execution:"Vous avez besoin de : exécution rapide", structure:'Vous avez besoin de : structure — Course Builder organise pour vous', clarity:'Vous avez besoin de : clarté — définissez votre niche avant de créer', video:'Vous avez besoin de : Avatar IA — sans filmer, sans monter', marketing:'Vous avez besoin de : Marketing Engine — copy et publicités automatiques', global:'Vous avez besoin de : Localisation Multilingue — slogans natifs par pays', local:"Vous avez besoin de : focus sur le marché local d'abord", automation:"Vous avez besoin de : Lancement Autonome — le système gère la routine", 'hands-on':"Vous avez besoin de : contrôle total — commencez manuel" },
  },
}

export function detectLang(): LangCode {
  if (typeof navigator === 'undefined') return 'en'
  const nav = navigator.language?.slice(0, 2).toLowerCase()
  return (LANGS.includes(nav as LangCode) ? nav : 'en') as LangCode
}
EOF
ok "lib/i18n.ts"

# ═══════════════════════════════════════════════════════════════
#  contexts/ModalContext.tsx
# ═══════════════════════════════════════════════════════════════
hd "Context: Modal"
cat > contexts/ModalContext.tsx << 'EOF'
'use client'
import { createContext, useContext, useState, type ReactNode } from 'react'

type ModalState =
  | { type: 'contact'; id: string }
  | { type: 'legal'; slug: string }
  | null

interface ModalCtx {
  modal: ModalState
  openContact: (id: string) => void
  openLegal: (slug: string) => void
  close: () => void
}

const Ctx = createContext<ModalCtx>({
  modal: null,
  openContact: () => {},
  openLegal: () => {},
  close: () => {},
})

export function ModalProvider({ children }: { children: ReactNode }) {
  const [modal, setModal] = useState<ModalState>(null)
  const openContact = (id: string) => setModal({ type: 'contact', id })
  const openLegal   = (slug: string) => setModal({ type: 'legal', slug })
  const close       = () => setModal(null)
  return <Ctx.Provider value={{ modal, openContact, openLegal, close }}>{children}</Ctx.Provider>
}

export const useModal = () => useContext(Ctx)
EOF
ok "contexts/ModalContext.tsx"

# ═══════════════════════════════════════════════════════════════
#  app/globals.css
# ═══════════════════════════════════════════════════════════════
hd "CSS"
cat > app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --void: #02030a; --deep: #050818; --surface: #0a0f2e; --card: #0d1440;
  --border: rgba(80,140,255,.18); --cyan: #00f5ff; --electric: #4d7cff;
  --violet: #a855f7; --gold: #ffd700; --hot: #ff4d8f; --green: #00ff88;
  --text: #e2e8ff; --muted: #7a8ab8;
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html { scroll-behavior: smooth; }
body { background: var(--void); color: var(--text); font-family: var(--font-exo), 'Exo 2', sans-serif; overflow-x: hidden; }
button { cursor: pointer; }

/* ── Dividers ── */
.divider { height:1px; background: linear-gradient(90deg, transparent, var(--border), var(--electric), var(--border), transparent); max-width:1200px; margin:0 auto; }
.glow    { height:1px; background: linear-gradient(90deg, transparent, var(--cyan), transparent); max-width:1200px; margin:0 auto; opacity:.3; }

/* ── Section ── */
.sec-label { font-size:.68rem; letter-spacing:.2em; text-transform:uppercase; color:var(--cyan); font-weight:700; margin-bottom:.8rem; font-family: var(--font-mono), monospace; }
.sec-label::before { content:'// '; opacity:.5; }
.sec-title { font-family: var(--font-orbitron), monospace; font-size: clamp(1.5rem,3.5vw,2.6rem); font-weight:900; margin-bottom:1rem; line-height:1.15; }
.sec-desc  { color:var(--muted); font-size:.97rem; line-height:1.7; max-width:640px; }

/* ── Buttons ── */
.btn-p { background: linear-gradient(135deg,var(--electric),var(--violet)); color:#fff; border:none; padding:.92rem 2.3rem; font-family: var(--font-orbitron), monospace; font-size:.8rem; font-weight:700; border-radius:6px; letter-spacing:.08em; box-shadow:0 0 36px rgba(77,124,255,.4); transition:transform .2s,box-shadow .2s; }
.btn-p:hover { transform:translateY(-3px); box-shadow:0 0 56px rgba(77,124,255,.6); }
.btn-s { background:transparent; color:var(--cyan); border:1px solid rgba(0,245,255,.3); padding:.92rem 2.3rem; font-family: var(--font-orbitron), monospace; font-size:.8rem; font-weight:700; border-radius:6px; letter-spacing:.08em; transition:background .3s,border-color .3s; }
.btn-s:hover { background:rgba(0,245,255,.08); border-color:var(--cyan); }

/* ── Cards ── */
.card { background:var(--card); border:1px solid var(--border); border-radius:12px; padding:1.5rem; transition:transform .3s,border-color .3s,box-shadow .3s; }
.card:hover { transform:translateY(-4px); border-color:rgba(77,124,255,.4); box-shadow:0 20px 60px rgba(0,0,0,.4); }

/* ── Tags ── */
.tag     { font-size:.62rem; padding:.16rem .52rem; border-radius:4px; font-weight:700; font-family: var(--font-mono), monospace; border:1px solid; display:inline-block; margin:.12rem; }
.tag-c   { color:var(--cyan);   border-color:rgba(0,245,255,.2);   background:rgba(0,245,255,.06); }
.tag-g   { color:var(--green);  border-color:rgba(0,255,136,.2);   background:rgba(0,255,136,.06); }
.tag-gold{ color:var(--gold);   border-color:rgba(255,215,0,.2);   background:rgba(255,215,0,.06); }
.tag-v   { color:var(--violet); border-color:rgba(168,85,247,.2);  background:rgba(168,85,247,.06);}
.tag-h   { color:var(--hot);    border-color:rgba(255,77,143,.2);  background:rgba(255,77,143,.06);}

/* ── Gradient text ── */
.grad-full { background: linear-gradient(135deg,var(--cyan),var(--electric),var(--violet)); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; }
.grad-cyan { background: linear-gradient(135deg,var(--cyan),var(--electric)); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; }

/* ── Stars background ── */
.stars-bg {
  position:fixed; inset:0; z-index:0; pointer-events:none;
  background: radial-gradient(ellipse 80% 50% at 20% 10%,rgba(77,124,255,.07),transparent 60%),
    radial-gradient(ellipse 60% 40% at 80% 90%,rgba(168,85,247,.07),transparent 60%), var(--void);
}
.stars-bg::after {
  content:''; position:absolute; inset:0;
  background-image:
    radial-gradient(1px 1px at 8% 12%,rgba(255,255,255,.8),transparent),
    radial-gradient(1px 1px at 25% 40%,rgba(200,220,255,.5),transparent),
    radial-gradient(2px 2px at 50% 22%,rgba(0,245,255,.5),transparent),
    radial-gradient(1px 1px at 72% 65%,rgba(255,255,255,.7),transparent),
    radial-gradient(2px 2px at 15% 78%,rgba(0,245,255,.35),transparent),
    radial-gradient(1px 1px at 62% 88%,rgba(77,124,255,.5),transparent),
    radial-gradient(1px 1px at 82% 32%,rgba(255,255,255,.6),transparent),
    radial-gradient(1px 1px at 93% 55%,rgba(0,255,136,.4),transparent);
  background-size:500px 500px,700px 700px,400px 400px,600px 600px,350px 350px,480px 480px,420px 420px,390px 390px;
  animation:twinkle 10s infinite alternate;
}

/* ── Ticker ── */
.ticker-track { display:flex; gap:3rem; animation:ticker 45s linear infinite; width:max-content; }
.ticker-mask  { mask-image:linear-gradient(90deg,transparent,black 8%,black 92%,transparent); -webkit-mask-image:linear-gradient(90deg,transparent,black 8%,black 92%,transparent); }

/* ── Market card ── */
.mcard { background:var(--card); border:1px solid var(--border); border-radius:12px; padding:1.5rem; position:relative; overflow:hidden; transition:transform .3s,border-color .3s,box-shadow .3s; }
.mcard::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:linear-gradient(90deg,var(--electric),var(--violet)); transform:scaleX(0); transform-origin:left; transition:transform .4s; }
.mcard:hover::before { transform:scaleX(1); }
.mcard:hover { transform:translateY(-4px); border-color:rgba(77,124,255,.4); box-shadow:0 20px 60px rgba(0,0,0,.4); }

/* ── Phase card ── */
.phase-list { list-style:none; display:flex; flex-direction:column; gap:.38rem; }
.phase-list li { font-size:.81rem; color:var(--muted); display:flex; gap:.45rem; line-height:1.4; }

/* ── Diagnostic ── */
.diag-box      { max-width:540px; margin:2.5rem auto 0; background:var(--card); border:1px solid var(--border); border-radius:20px; padding:2.5rem; box-shadow:0 20px 60px rgba(0,0,0,.4); position:relative; min-height:360px; }
.diag-lang-row { position:absolute; top:1rem; right:1rem; display:flex; gap:.3rem; }
.d-lang        { background:transparent; border:1px solid rgba(80,140,255,.2); border-radius:5px; padding:.22rem .4rem; font-size:.9rem; line-height:1; transition:border-color .2s,background .2s; }
.d-lang.active { border-color:var(--cyan); background:rgba(0,245,255,.12); }
.d-detect      { font-family: var(--font-mono), monospace; font-size:.62rem; color:var(--muted); text-align:center; margin-bottom:1rem; }
.d-prog        { display:flex; gap:5px; margin-bottom:1.8rem; }
.d-bar         { flex:1; height:4px; border-radius:4px; background:rgba(80,140,255,.15); transition:background .3s; }
.d-bar.done    { background:linear-gradient(90deg,var(--cyan),var(--electric)); }
.d-step-lbl    { font-size:.67rem; color:var(--cyan); font-weight:700; letter-spacing:.1em; margin-bottom:.5rem; font-family: var(--font-mono), monospace; }
.d-qtext       { font-size:1.05rem; font-weight:700; margin-bottom:1.4rem; line-height:1.4; padding-right:3.5rem; }
.d-opt         { display:block; width:100%; text-align:left; background:var(--surface); border:1px solid var(--border); color:var(--text); padding:.88rem 1.1rem; border-radius:10px; font-size:.84rem; margin-bottom:.6rem; transition:border-color .2s,background .2s; font-family: var(--font-exo), sans-serif; }
.d-opt:hover   { border-color:var(--electric); background:rgba(77,124,255,.08); }
.d-emoji       { font-size:2.8rem; margin-bottom:.5rem; text-align:center; }
.d-arch-title  { font-size:1.2rem; font-weight:900; margin-bottom:1rem; text-align:center; }
.d-arch-desc   { color:var(--muted); font-size:.87rem; line-height:1.7; margin-bottom:1.2rem; max-width:380px; margin-left:auto; margin-right:auto; text-align:center; }
.d-need        { background:rgba(168,85,247,.08); border:1px solid rgba(168,85,247,.25); border-radius:10px; padding:.85rem 1.1rem; margin-bottom:.85rem; font-size:.81rem; font-weight:600; }
.d-plan        { background:rgba(77,124,255,.08); border:1px solid rgba(77,124,255,.25); border-radius:10px; padding:.85rem 1.1rem; margin-bottom:1.4rem; font-size:.83rem; font-weight:700; color:var(--cyan); text-align:center; }
.d-btns        { display:flex; gap:.7rem; justify-content:center; flex-wrap:wrap; }
.d-analyzing   { text-align:center; padding:3.5rem 0; }

/* ── Plan card ── */
.plan-btn-f { background:linear-gradient(135deg,var(--electric),var(--violet)); border:none; color:#fff; box-shadow:0 8px 24px rgba(77,124,255,.35); }
.plan-btn-f:hover { box-shadow:0 12px 36px rgba(77,124,255,.5); }

/* ── Legal card ── */
.lcard { background:var(--card); border:1px solid var(--border); border-radius:12px; padding:1.5rem; border-right:3px solid var(--cyan); transition:transform .3s; }
.lcard:hover { transform:translateY(-3px); }

/* ── Compliance table ── */
.comp-table     { width:100%; border-collapse:collapse; font-size:.79rem; }
.comp-table th  { background:var(--card); color:var(--cyan); font-family: var(--font-orbitron), monospace; font-size:.64rem; letter-spacing:.1em; text-transform:uppercase; padding:.72rem 1rem; text-align:left; border-bottom:1px solid var(--border); white-space:nowrap; }
.comp-table td  { padding:.68rem 1rem; border-bottom:1px solid rgba(80,140,255,.07); color:var(--muted); }
.comp-table tr:hover td { background:rgba(77,124,255,.04); color:var(--text); }
.ls-a           { background:rgba(0,255,136,.15); color:var(--green); font-family: var(--font-mono), monospace; font-size:.63rem; font-weight:700; padding:.18rem .55rem; border-radius:100px; }
.ls-p           { background:rgba(255,215,0,.12); color:var(--gold); font-family: var(--font-mono), monospace; font-size:.63rem; font-weight:700; padding:.18rem .55rem; border-radius:100px; }

/* ── Modals ── */
.overlay      { display:none; position:fixed; inset:0; background:rgba(0,0,0,.88); backdrop-filter:blur(10px); z-index:999; align-items:center; justify-content:center; padding:1rem; }
.overlay.open { display:flex; }
.mbox         { background:var(--card); border:1px solid var(--border); border-radius:16px; padding:2.5rem; max-width:480px; width:100%; position:relative; animation:fadeUp .4s ease; }
.minput       { width:100%; background:var(--surface); border:1px solid var(--border); border-radius:8px; padding:.8rem 1.1rem; color:var(--text); font-size:.87rem; outline:none; margin-bottom:.7rem; font-family: var(--font-exo), sans-serif; transition:border-color .2s; }
.minput:focus { border-color:var(--cyan); }
.legal-modal-content h3 { font-family: var(--font-orbitron), monospace; font-size:.78rem; color:var(--electric); margin:1.4rem 0 .4rem; text-transform:uppercase; letter-spacing:.07em; }
.legal-modal-content p, .legal-modal-content li { font-size:.82rem; color:var(--muted); line-height:1.7; margin-bottom:.4rem; }
.legal-modal-content li { margin-left:1.2rem; }
.legal-modal-content strong { color:var(--text); }

/* ── Cookie banner ── */
.cookie-bar { position:fixed; bottom:0; left:0; right:0; z-index:998; background:rgba(10,15,46,.97); border-top:1px solid var(--border); padding:.9rem 2rem; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1rem; backdrop-filter:blur(20px); transform:translateY(100%); transition:transform .5s ease; }
.cookie-bar.show { transform:translateY(0); }

/* ── Progress bar ── */
.prog-track { background:var(--card); border-radius:100px; height:8px; overflow:hidden; border:1px solid var(--border); }
.prog-fill  { width:47%; height:100%; background:linear-gradient(90deg,var(--electric),var(--violet)); border-radius:100px; }

/* ── Nav logo ── */
.nav-logo-mark { width:32px; height:32px; border-radius:8px; background:linear-gradient(135deg,var(--cyan),var(--electric),var(--violet)); display:flex; align-items:center; justify-content:center; font-size:1rem; font-weight:900; color:#000; font-family: var(--font-orbitron), monospace; }

/* ── Pill ── */
.pill       { display:flex; align-items:center; gap:.4rem; background:var(--card); border:1px solid var(--border); border-radius:8px; padding:.52rem .95rem; font-size:.77rem; font-weight:700; transition:border-color .3s; }
.pill:hover { border-color:var(--electric); }

/* ── Fade-in on scroll ── */
.fi       { opacity:0; transform:translateY(18px); transition:opacity .7s ease,transform .7s ease; }
.fi.vis   { opacity:1; transform:translateY(0); }

/* ── Animations ── */
@keyframes twinkle  { 0%{opacity:.4} 50%{opacity:.9} 100%{opacity:.4} }
@keyframes ticker   { 0%{transform:translateX(0)} 100%{transform:translateX(-50%)} }
@keyframes fadeUp   { from{opacity:0;transform:translateY(28px)} to{opacity:1;transform:translateY(0)} }
@keyframes fadeDown { from{opacity:0;transform:translateY(-20px)} to{opacity:1;transform:translateY(0)} }
@keyframes pulse    { 0%,100%{opacity:1} 50%{opacity:.35} }

/* ── Scrollbar ── */
::-webkit-scrollbar { width:5px; }
::-webkit-scrollbar-track { background:var(--deep); }
::-webkit-scrollbar-thumb { background:var(--electric); border-radius:3px; }

@media(max-width:640px) { .nav-links-desktop { display:none !important; } }
EOF
ok "app/globals.css"

# ═══════════════════════════════════════════════════════════════
#  app/layout.tsx
# ═══════════════════════════════════════════════════════════════
hd "App: layout"
cat > app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Orbitron, Exo_2, Share_Tech_Mono } from 'next/font/google'
import './globals.css'

const orbitron = Orbitron({
  subsets: ['latin'], variable: '--font-orbitron',
  weight: ['400','700','900'], display: 'swap',
})
const exo2 = Exo_2({
  subsets: ['latin'], variable: '--font-exo',
  weight: ['300','400','600','700'], display: 'swap',
})
const mono = Share_Tech_Mono({
  subsets: ['latin'], variable: '--font-mono',
  weight: '400', display: 'swap',
})

export const metadata: Metadata = {
  title: 'Every Culture. Every Language. One Platform.',
  description: 'The first AI education platform with native geopolitical intelligence. Local currency, local slogans, cultural AI for 50+ countries.',
  robots: { index: true, follow: true },
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${orbitron.variable} ${exo2.variable} ${mono.variable}`}>
      <body className="antialiased">{children}</body>
    </html>
  )
}
EOF
ok "app/layout.tsx"

# ═══════════════════════════════════════════════════════════════
#  app/page.tsx
# ═══════════════════════════════════════════════════════════════
hd "App: page"
cat > app/page.tsx << 'EOF'
import { ModalProvider } from '@/contexts/ModalContext'
import Stars        from '@/components/Stars'
import Nav          from '@/components/Nav'
import Hero         from '@/components/Hero'
import InspiredBy   from '@/components/InspiredBy'
import Markets      from '@/components/Markets'
import Diagnostic   from '@/components/Diagnostic'
import Phases       from '@/components/Phases'
import LegalShield  from '@/components/LegalShield'
import Waitlist     from '@/components/Waitlist'
import CTA          from '@/components/CTA'
import Footer       from '@/components/Footer'
import CookieBanner from '@/components/CookieBanner'
import ContactModal from '@/components/ContactModal'
import LegalModal   from '@/components/LegalModal'

export default function Page() {
  return (
    <ModalProvider>
      <main className="min-h-screen" style={{ background:'var(--void)', color:'var(--text)' }}>
        <Stars />
        <Nav />
        <Hero />
        <div className="divider" />
        <InspiredBy />
        <div className="glow" />
        <Markets />
        <div className="divider" />
        <Diagnostic />
        <div className="glow" />
        <Phases />
        <div className="glow" />
        <LegalShield />
        <div className="glow" />
        <Waitlist />
        <CTA />
        <Footer />
        <CookieBanner />
        <ContactModal />
        <LegalModal />
      </main>
    </ModalProvider>
  )
}
EOF
ok "app/page.tsx"

# ═══════════════════════════════════════════════════════════════
#  app/legal/[slug]/page.tsx
# ═══════════════════════════════════════════════════════════════
hd "App: legal routes"
cat > "app/legal/[slug]/page.tsx" << 'EOF'
import { notFound } from 'next/navigation'
import { LEGAL_DOCS } from '@/lib/data'
import type { Metadata } from 'next'

interface Props { params: Promise<{ slug: string }> }

export async function generateStaticParams() {
  return Object.keys(LEGAL_DOCS).map(slug => ({ slug }))
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params
  const doc = LEGAL_DOCS[slug]
  if (!doc) return { title: 'Not Found' }
  return { title: `${doc.title}` }
}

export default async function LegalPage({ params }: Props) {
  const { slug } = await params
  const doc = LEGAL_DOCS[slug]
  if (!doc) notFound()

  return (
    <main className="min-h-screen px-6 pt-32 pb-20" style={{ background:'var(--void)', color:'var(--text)' }}>
      <div className="max-w-3xl mx-auto">
        <div className="sec-label mb-4">Legal Document</div>
        <h1 className="font-orb font-black text-3xl mb-2"
          style={{ fontFamily:'var(--font-orbitron)' }}
          dangerouslySetInnerHTML={{ __html: doc.title }} />
        <p className="text-xs mb-8" style={{ color:'var(--muted)', fontFamily:'var(--font-mono)' }}>{doc.date}</p>
        <div className="legal-modal-content" dangerouslySetInnerHTML={{ __html: doc.body }} />
        <div className="mt-12 pt-6" style={{ borderTop:'1px solid var(--border)' }}>
          <p style={{ fontSize:'.77rem', color:'var(--muted)' }}>
            Questions? <a href="mailto:legal@contact.com" style={{ color:'var(--cyan)' }}>legal@contact.com</a>
          </p>
          <a href="/" style={{ display:'inline-block', marginTop:'1rem', color:'var(--electric)', fontSize:'.9rem' }}>← Back to Platform</a>
        </div>
      </div>
    </main>
  )
}
EOF
ok "app/legal/[slug]/page.tsx"

# ═══════════════════════════════════════════════════════════════
#  COMPONENTS
# ═══════════════════════════════════════════════════════════════
hd "Components"

cat > components/Stars.tsx << 'EOF'
export default function Stars() {
  return <div className="stars-bg" aria-hidden="true" />
}
EOF
ok "Stars.tsx"

cat > components/Nav.tsx << 'EOF'
'use client'
import { useState } from 'react'
import { useModal } from '@/contexts/ModalContext'
import { LANGS, I18N } from '@/lib/i18n'

function scrollTo(id: string) {
  document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
}

export default function Nav() {
  const [mob, setMob] = useState(false)
  const { openLegal } = useModal()

  const links = [
    { href:'#inspired', label:'DNA' },
    { href:'#markets',  label:'Markets' },
    { href:'#diagnostic', label:'Diagnostic' },
    { href:'#phases',   label:'Roadmap' },
    { href:'#legal',    label:'Legal' },
    { href:'#waitlist', label:'Access' },
  ]

  return (
    <nav style={{
      position:'fixed', top:0, left:0, right:0, zIndex:100,
      padding:'.85rem 2rem', display:'flex', alignItems:'center',
      justifyContent:'space-between', gap:'1rem',
      background:'rgba(2,3,10,.85)', backdropFilter:'blur(20px)',
      borderBottom:'1px solid var(--border)'
    }}>
      <div style={{ display:'flex', alignItems:'center', gap:'.5rem' }}>
        <div className="nav-logo-mark">⚡</div>
        <span style={{ fontFamily:'var(--font-orbitron)', fontWeight:900, fontSize:'1rem',
          background:'linear-gradient(135deg,var(--cyan),var(--electric))',
          WebkitBackgroundClip:'text', WebkitTextFillColor:'transparent' }}>IGA</span>
      </div>

      {/* Desktop links */}
      <ul className="nav-links-desktop" style={{ display:'flex', gap:'1.5rem', listStyle:'none', flexWrap:'wrap' }}>
        {links.map(l => (
          <li key={l.href}>
            <a href={l.href} style={{ color:'var(--muted)', fontSize:'.76rem', fontWeight:600,
              letterSpacing:'.08em', textTransform:'uppercase', textDecoration:'none' }}
              onMouseOver={e => (e.currentTarget.style.color = 'var(--cyan)')}
              onMouseOut={e  => (e.currentTarget.style.color = 'var(--muted)')}>
              {l.label}
            </a>
          </li>
        ))}
      </ul>

      <div style={{ display:'flex', alignItems:'center', gap:'.7rem' }}>
        <button className="btn-p" style={{ padding:'.55rem 1.3rem', fontSize:'.68rem', letterSpacing:'.1em' }}
          onClick={() => scrollTo('waitlist')}>
          Launch Platform
        </button>
        <button onClick={() => setMob(!mob)}
          style={{ display:'none', background:'none', border:'none', color:'var(--muted)', fontSize:'1.5rem', padding:'.3rem' }}
          className="ham-btn">
          ☰
        </button>
      </div>

      {/* Mobile menu */}
      {mob && (
        <div style={{ position:'absolute', top:'100%', left:0, right:0, background:'var(--deep)',
          borderBottom:'1px solid var(--border)', padding:'1rem 1.5rem', display:'flex',
          flexDirection:'column', gap:'.8rem', zIndex:99 }}>
          {links.map(l => (
            <a key={l.href} href={l.href} onClick={() => setMob(false)}
              style={{ color:'var(--muted)', fontSize:'.9rem', padding:'.5rem 0',
                borderBottom:'1px solid var(--border)', textDecoration:'none' }}>
              {l.label}
            </a>
          ))}
          <button className="btn-p" style={{ fontSize:'.78rem', padding:'.8rem', marginTop:'.3rem' }}
            onClick={() => { setMob(false); scrollTo('waitlist') }}>
            Launch Platform
          </button>
        </div>
      )}
    </nav>
  )
}
EOF
ok "Nav.tsx"

cat > components/SloganTicker.tsx << 'EOF'
'use client'
import { SLOGANS } from '@/lib/data'
const doubled = [...SLOGANS, ...SLOGANS]

export default function SloganTicker() {
  return (
    <div className="ticker-mask" style={{ width:'100%', maxWidth:'940px', overflow:'hidden',
      marginBottom:'2.2rem', animation:'fadeUp 1s .15s ease both' }}>
      <div className="ticker-track">
        {doubled.map((s, i) => (
          <div key={i} style={{ display:'flex', alignItems:'center', gap:'.55rem',
            whiteSpace:'nowrap', fontSize:'.83rem', fontWeight:600 }}>
            <span style={{ fontSize:'1.05rem' }}>{s.flag}</span>
            <span style={{ fontStyle:'italic', color: s.c }}>{s.s}</span>
            <span style={{ fontSize:'.59rem', color:'var(--muted)', fontFamily:'var(--font-mono)' }}>{s.l}</span>
          </div>
        ))}
      </div>
    </div>
  )
}
EOF
ok "SloganTicker.tsx"

cat > components/Hero.tsx << 'EOF'
'use client'
import SloganTicker from './SloganTicker'
function scrollTo(id: string) { document.getElementById(id)?.scrollIntoView({ behavior:'smooth' }) }

export default function Hero() {
  return (
    <header style={{ position:'relative', zIndex:1, minHeight:'100vh', display:'flex',
      flexDirection:'column', alignItems:'center', justifyContent:'center',
      textAlign:'center', padding:'8rem 2rem 4rem', overflow:'hidden' }}>
      <div style={{ position:'absolute', width:'700px', height:'700px', borderRadius:'50%',
        background:'radial-gradient(circle,rgba(77,124,255,.12),transparent 70%)',
        filter:'blur(80px)', top:'-250px', left:'-250px', pointerEvents:'none' }} />
      <div style={{ position:'absolute', width:'600px', height:'600px', borderRadius:'50%',
        background:'radial-gradient(circle,rgba(168,85,247,.1),transparent 70%)',
        filter:'blur(80px)', bottom:'-150px', right:'-150px', pointerEvents:'none' }} />

      <div style={{ display:'inline-flex', alignItems:'center', gap:'.5rem',
        background:'rgba(77,124,255,.1)', border:'1px solid rgba(77,124,255,.3)',
        borderRadius:'100px', padding:'.4rem 1.2rem', fontSize:'.73rem', fontWeight:600,
        letterSpacing:'.12em', textTransform:'uppercase', color:'var(--cyan)',
        marginBottom:'2rem', animation:'fadeDown .8s ease both' }}>
        🌍 Every Culture. Every Language. One Platform.
      </div>

      <SloganTicker />

      <h1 style={{ fontFamily:'var(--font-orbitron)', fontSize:'clamp(2rem,5.5vw,4.5rem)',
        fontWeight:900, lineHeight:1.1, marginBottom:'1.5rem', animation:'fadeUp 1s .3s ease both' }}>
        <span style={{ display:'block', color:'var(--text)' }}>One Platform.</span>
        <span className="grad-full" style={{ display:'block' }}>Every Culture. Every Market.</span>
      </h1>

      <p style={{ maxWidth:'700px', fontSize:'1.05rem', lineHeight:1.7, color:'var(--muted)',
        marginBottom:'2.5rem', animation:'fadeUp 1s .5s ease both' }}>
        Education that <strong style={{ color:'var(--text)' }}>speaks natively</strong> to every country — with local currency,
        local slogans, geopolitical intelligence and AI built like the world&apos;s biggest platforms.
      </p>

      <div style={{ display:'flex', gap:'1rem', flexWrap:'wrap', justifyContent:'center',
        animation:'fadeUp 1s .7s ease both' }}>
        <button className="btn-p" onClick={() => scrollTo('waitlist')}>🚀 Join the Mission</button>
        <button className="btn-s" onClick={() => scrollTo('markets')}>See Global Markets</button>
      </div>
    </header>
  )
}
EOF
ok "Hero.tsx"

cat > components/InspiredBy.tsx << 'EOF'
import { INSPIRED, TOOLS } from '@/lib/data'

export default function InspiredBy() {
  return (
    <section id="inspired" style={{ position:'relative', zIndex:1, padding:'5.5rem 2rem' }}>
      <div style={{ maxWidth:'1200px', margin:'0 auto' }}>
        <div className="sec-label fi">Platform DNA</div>
        <h2 className="sec-title fi">
          Built on the <span style={{ color:'var(--cyan)' }}>&ldquo;Mother Tools&rdquo; of the Giants</span>
        </h2>
        <p className="sec-desc fi">
          Uses the <strong style={{ color:'var(--text)' }}>same DNA</strong> as the world&apos;s biggest platforms — adapted for AI-powered education and geopolitical intelligence.
        </p>

        <div className="fi" style={{ display:'flex', flexWrap:'wrap', gap:'.65rem', marginTop:'1.8rem' }}>
          {INSPIRED.map(p => (
            <div key={p.name} className="pill">
              {p.emoji} {p.name}
              <span style={{ fontSize:'.61rem', color:'var(--muted)', fontWeight:400 }}>· {p.desc}</span>
            </div>
          ))}
        </div>

        <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fill,minmax(260px,1fr))', gap:'1.2rem', marginTop:'2.5rem' }}>
          {TOOLS.map((t, i) => (
            <div key={i} className="card fi">
              <p style={{ fontSize:'.59rem', color:'var(--muted)', fontFamily:'var(--font-mono)', marginBottom:'.3rem' }}>{t.source}</p>
              <p style={{ fontFamily:'var(--font-orbitron)', color:'var(--cyan)', fontSize:'.78rem', fontWeight:700, marginBottom:'.45rem' }}>{t.name}</p>
              <p style={{ fontSize:'.81rem', color:'var(--muted)', lineHeight:1.5 }}>{t.desc}</p>
              <p style={{ fontSize:'.71rem', color:'var(--green)', marginTop:'.65rem' }}>{t.adapt}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}
EOF
ok "InspiredBy.tsx"

cat > components/Markets.tsx << 'EOF'
import { MARKETS, WAVE_STYLES } from '@/lib/data'

export default function Markets() {
  return (
    <section id="markets" style={{ position:'relative', zIndex:1, padding:'5.5rem 2rem', background:'var(--deep)' }}>
      <div style={{ maxWidth:'1200px', margin:'0 auto' }}>
        <div className="sec-label fi">Geopolitics &amp; Market Intelligence</div>
        <h2 className="sec-title fi">
          Priority Markets — <span style={{ color:'var(--gold)' }}>High Demand · Qualified Leads</span>
        </h2>
        <p className="sec-desc fi" style={{ marginBottom:'2.5rem' }}>
          Each country has its native slogan, local currency and geopolitical strategy. The message lands without loss — because it was born there.
        </p>

        <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fill,minmax(260px,1fr))', gap:'1.2rem' }}>
          {MARKETS.map(m => {
            const ws = WAVE_STYLES[m.wave]
            return (
              <div key={m.country} className="mcard fi">
                <div style={{ position:'absolute', top:'.75rem', right:'.75rem', fontSize:'.56rem',
                  fontWeight:700, letterSpacing:'.07em', textTransform:'uppercase',
                  padding:'.2rem .55rem', borderRadius:'100px', fontFamily:'var(--font-orbitron)',
                  background:ws.bg, color:ws.c, border:`1px solid ${ws.br}` }}>
                  {ws.label}
                </div>
                <div style={{ fontSize:'2rem', marginBottom:'.6rem' }}>{m.flag}</div>
                <div style={{ fontFamily:'var(--font-orbitron)', fontSize:'.86rem', fontWeight:700, marginBottom:'.2rem' }}>{m.country}</div>
                <div style={{ fontSize:'.64rem', color:'var(--muted)', fontFamily:'var(--font-mono)', marginBottom:'.7rem' }}>{m.region}</div>
                <div style={{ fontSize:'.92rem', fontWeight:700, color:'var(--cyan)', fontStyle:'italic', marginBottom:'.22rem', lineHeight:1.3 }}>{m.slogan}</div>
                <div style={{ fontSize:'.59rem', color:'var(--muted)', marginBottom:'.8rem' }}>{m.sub}</div>
                <div style={{ borderTop:'1px solid var(--border)', paddingTop:'.75rem', marginTop:'.75rem', display:'flex', flexDirection:'column', gap:'.32rem' }}>
                  {[
                    { label:'Currency', val: <span style={{ background:'rgba(255,215,0,.1)', border:'1px solid rgba(255,215,0,.2)', borderRadius:'4px', padding:'.1rem .5rem', fontSize:'.64rem', color:'var(--gold)', fontFamily:'var(--font-mono)' }}>{m.curr}</span> },
                    { label:'Payment', val: <span style={{ fontFamily:'var(--font-mono)', fontSize:'.72rem' }}>{m.pay}</span> },
                    { label:'Demand', val: <span style={{ color: m.dc, fontWeight:600, fontSize:'.72rem' }}>{m.demand}</span> },
                  ].map(row => (
                    <div key={row.label} style={{ display:'flex', justifyContent:'space-between', alignItems:'center', fontSize:'.74rem' }}>
                      <span style={{ color:'var(--muted)' }}>{row.label}</span>
                      <span>{row.val}</span>
                    </div>
                  ))}
                </div>
              </div>
            )
          })}
          {/* +40 card */}
          <div className="mcard fi" style={{ borderColor:'rgba(77,124,255,.2)' }}>
            <div style={{ position:'absolute', top:'.75rem', right:'.75rem', fontSize:'.56rem', fontWeight:700, letterSpacing:'.07em', textTransform:'uppercase', padding:'.2rem .55rem', borderRadius:'100px', fontFamily:'var(--font-orbitron)', background:'rgba(77,124,255,.12)', color:'#4d7cff', border:'1px solid rgba(77,124,255,.2)' }}>🌐 Wave 3</div>
            <div style={{ fontSize:'2rem', marginBottom:'.6rem' }}>🌏</div>
            <div style={{ fontFamily:'var(--font-orbitron)', fontSize:'.86rem', fontWeight:700, marginBottom:'.2rem' }}>+40 Countries</div>
            <div style={{ fontSize:'.64rem', color:'var(--muted)', fontFamily:'var(--font-mono)', marginBottom:'.7rem' }}>Global Expansion · All Continents</div>
            <p style={{ fontSize:'.77rem', color:'var(--muted)', lineHeight:1.6 }}>Indonesia · Colombia · Poland · Turkey · Pakistan · Egypt · Vietnam · Ghana · Portugal · Argentina · Chile · Morocco…</p>
            <div style={{ borderTop:'1px solid var(--border)', paddingTop:'.75rem', marginTop:'.75rem' }}>
              <div style={{ display:'flex', justifyContent:'space-between', fontSize:'.74rem' }}>
                <span style={{ color:'var(--muted)' }}>Principle</span>
                <span style={{ color:'var(--cyan)', fontFamily:'var(--font-mono)', fontSize:'.72rem' }}>Geopolitics before launch</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
EOF
ok "Markets.tsx"

cat > components/Diagnostic.tsx << 'EOF'
'use client'
import { useState, useEffect } from 'react'
import { I18N, LANGS, detectLang, type LangCode } from '@/lib/i18n'

interface Answer { score: number; need: string }

export default function Diagnostic() {
  const [lang, setLang]     = useState<LangCode>('en')
  const [detected, setDet]  = useState(false)
  const [step, setStep]     = useState(-1)
  const [answers, setAns]   = useState<Answer[]>([])
  const [loading, setLoad]  = useState(false)
  const [done, setDone]     = useState(false)

  useEffect(() => { const d = detectLang(); setLang(d); setDet(true) }, [])

  const t   = I18N[lang]
  const max = t.qs.length * 3

  const reset = (lc?: LangCode) => {
    if (lc) setLang(lc)
    setStep(-1); setAns([]); setLoad(false); setDone(false)
  }

  const select = (score: number, need: string) => {
    const next = [...answers, { score, need }]
    setAns(next)
    if (step + 1 < t.qs.length) { setStep(step + 1) }
    else {
      setLoad(true)
      setTimeout(() => {
        setLoad(false); setDone(true)
        const total = next.reduce((a, b) => a + b.score, 0)
        const pct   = total / max
        const arch  = pct >= 0.75 ? t.archs.high : pct >= 0.5 ? t.archs.mid : t.archs.low
        try { localStorage.setItem('iga_diag', JSON.stringify({ lang, pct, plan: arch.p, ts: Date.now() })) } catch {}
      }, 380)
    }
  }

  const total  = answers.reduce((a, b) => a + b.score, 0)
  const pct    = total / max
  const arch   = pct >= 0.75 ? t.archs.high : pct >= 0.5 ? t.archs.mid : t.archs.low
  const nc: Record<string,number> = {}
  answers.forEach(a => { nc[a.need] = (nc[a.need] || 0) + 1 })
  const topNeed = Object.entries(nc).sort((a, b) => b[1] - a[1])[0]?.[0]

  return (
    <section id="diagnostic" style={{ position:'relative', zIndex:1, padding:'5.5rem 2rem' }}>
      <div style={{ maxWidth:'1200px', margin:'0 auto' }}>
        <div className="sec-label fi">Find Your Profile · Encontre Seu Perfil</div>
        <h2 className="sec-title fi">
          Diagnóstico <span style={{ color:'var(--cyan)' }}>Global</span>
        </h2>
        <p className="sec-desc fi" style={{ marginBottom:0 }}>{detected ? t.intro.sub : 'Takes under 1 minute. Get a personalized plan recommendation.'}</p>

        <div className="diag-box fi">
          {/* Language switcher */}
          <div className="diag-lang-row">
            {LANGS.map(lc => (
              <button key={lc} onClick={() => reset(lc)} className={`d-lang${lc === lang ? ' active' : ''}`} title={I18N[lc].name}>
                {I18N[lc].flag}
              </button>
            ))}
          </div>

          {detected && <div className="d-detect">🌍 <strong style={{ color:'var(--cyan)' }}>{t.name}</strong> — switch above</div>}

          {/* INTRO */}
          {step === -1 && (
            <div style={{ textAlign:'center', paddingTop:'1.5rem' }}>
              <div className="d-emoji">🧭</div>
              <h3 style={{ fontFamily:'var(--font-orbitron)', fontWeight:900, fontSize:'1.2rem', marginBottom:'.8rem' }}>{t.intro.title}</h3>
              <p style={{ color:'var(--muted)', fontSize:'.87rem', lineHeight:1.6, marginBottom:'2rem', maxWidth:'340px', marginLeft:'auto', marginRight:'auto' }}>{t.intro.sub}</p>
              <button className="btn-p" onClick={() => setStep(0)}>{t.intro.cta}</button>
            </div>
          )}

          {/* QUESTION */}
          {step >= 0 && step < t.qs.length && !loading && !done && (
            <div>
              <div className="d-prog">
                {t.qs.map((_, i) => <div key={i} className={`d-bar${i <= step ? ' done' : ''}`} />)}
              </div>
              <div className="d-step-lbl">{t.prog} {step + 1} {t.of} {t.qs.length}</div>
              <div className="d-qtext">{t.qs[step].q}</div>
              <div>
                {t.qs[step].opts.map((opt, i) => (
                  <button key={i} className="d-opt" onClick={() => select(opt.s, opt.n)}>{opt.t}</button>
                ))}
              </div>
            </div>
          )}

          {/* LOADING */}
          {loading && (
            <div className="d-analyzing">
              <div style={{ fontSize:'2.4rem', animation:'pulse 1s infinite' }}>🧠</div>
              <p style={{ color:'var(--muted)', fontSize:'.87rem', marginTop:'.8rem' }}>{t.loading}</p>
            </div>
          )}

          {/* RESULT */}
          {done && (
            <div>
              <div className="d-emoji">{arch.e}</div>
              <div className="d-arch-title" style={{ color: arch.c }}>{arch.t}</div>
              <p className="d-arch-desc">{arch.d}</p>
              {topNeed && t.needs[topNeed] && <div className="d-need">🎯 {t.needs[topNeed]}</div>}
              {arch.p && (
                <div className="d-plan">
                  {t.rec} <strong style={{ color:'var(--text)' }}>{arch.p}</strong>
                </div>
              )}
              <div className="d-btns">
                <button className="btn-s" style={{ fontSize:'.78rem', padding:'.75rem 1.4rem' }} onClick={() => reset()}>{t.redo}</button>
                <button className="btn-p" style={{ fontSize:'.78rem', padding:'.75rem 1.4rem' }}
                  onClick={() => document.getElementById('waitlist')?.scrollIntoView({ behavior:'smooth' })}>
                  {t.secure}
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </section>
  )
}
EOF
ok "Diagnostic.tsx"

cat > components/Phases.tsx << 'EOF'
import { PHASES } from '@/lib/data'
const STYLES = {
  green:  { border:'rgba(0,255,136,.3)',  bg:'rgba(0,255,136,.04)',  num:'#00ff88', icon:'✓' },
  gold:   { border:'rgba(255,215,0,.25)', bg:'rgba(255,215,0,.04)',  num:'#ffd700', icon:'⏳' },
  violet: { border:'rgba(168,85,247,.3)', bg:'rgba(168,85,247,.04)', num:'#a855f7', icon:'🗺' },
}
export default function Phases() {
  return (
    <section id="phases" style={{ position:'relative', zIndex:1, padding:'5.5rem 2rem' }}>
      <div style={{ maxWidth:'1200px', margin:'0 auto' }}>
        <div className="sec-label fi">Honest Roadmap</div>
        <h2 className="sec-title fi">3 Phases of <span style={{ color:'var(--green)' }}>Global Construction</span></h2>
        <p className="sec-desc fi" style={{ marginBottom:'2.5rem' }}>Built like SpaceX — maximum vision, phased execution, real delivery at every step.</p>
        <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(280px,1fr))', gap:'1.4rem' }}>
          {PHASES.map(p => {
            const s = STYLES[p.color as keyof typeof STYLES]
            return (
              <div key={p.num} className="fi" style={{ borderRadius:'12px', padding:'1.8rem', border:`1px solid ${s.border}`, background:s.bg }}>
                <div style={{ fontFamily:'var(--font-orbitron)', fontSize:'.61rem', fontWeight:700, marginBottom:'.5rem', letterSpacing:'.15em', color:s.num }}>{p.num}</div>
                <div style={{ fontFamily:'var(--font-orbitron)', fontSize:'.9rem', fontWeight:700, marginBottom:'.3rem', color:'var(--text)' }}>{p.title}</div>
                <div style={{ fontSize:'.67rem', color:'var(--muted)', marginBottom:'1rem', fontFamily:'var(--font-mono)' }}>{p.time}</div>
                <ul className="phase-list">
                  {p.items.map((item, i) => (
                    <li key={i}><span>{s.icon}</span><span>{item}</span></li>
                  ))}
                </ul>
              </div>
            )
          })}
        </div>
      </div>
    </section>
  )
}
EOF
ok "Phases.tsx"

cat > components/LegalShield.tsx << 'EOF'
'use client'
import { LEGAL_BADGES, LEGAL_CARDS, RAI_PRINCIPLES, DATA_COMPLIANCE } from '@/lib/data'
import { useModal } from '@/contexts/ModalContext'

const TAG_MAP: Record<string,string> = { c:'tag-c', g:'tag-g', gold:'tag-gold', v:'tag-v', h:'tag-h' }

export default function LegalShield() {
  const { openLegal } = useModal()
  return (
    <section id="legal" style={{ position:'relative', zIndex:1, padding:'5.5rem 2rem', background:'var(--deep)' }}>
      <div style={{ maxWidth:'1200px', margin:'0 auto' }}>
        <div className="sec-label fi">Protection · Compliance · Ethics</div>
        <h2 className="sec-title fi">Legal Shield &amp; <span style={{ color:'var(--cyan)' }}>Humanitarian Foundation</span></h2>
        <p className="sec-desc fi" style={{ marginBottom:'2.5rem' }}>
          Every major global platform is built on a legal and ethical foundation. <strong style={{ color:'var(--text)' }}>Protected, compliant and guided by international humanitarian principles from Day 1.</strong>
        </p>

        {/* Hero banner */}
        <div className="fi" style={{ background:'linear-gradient(135deg,rgba(0,245,255,.04),rgba(168,85,247,.04))', border:'1px solid rgba(0,245,255,.15)', borderRadius:'16px', padding:'2rem', marginBottom:'2.5rem' }}>
          <h3 style={{ fontFamily:'var(--font-orbitron)', fontSize:'.97rem', color:'var(--cyan)', marginBottom:'.5rem' }}>🏛️ Legally Protected. Ethically Grounded.</h3>
          <p style={{ fontSize:'.84rem', color:'var(--muted)', lineHeight:1.6 }}>Aligned with international humanitarian law, UN declarations, and data protection standards of every market we operate in. Education is a human right.</p>
          <div style={{ display:'flex', flexWrap:'wrap', gap:'.45rem', marginTop:'.9rem' }}>
            {LEGAL_BADGES.map(b => (
              <div key={b} style={{ background:'var(--card)', border:'1px solid var(--border)', borderRadius:'7px', padding:'.37rem .82rem', fontSize:'.68rem', fontWeight:700, fontFamily:'var(--font-mono)' }}>{b}</div>
            ))}
          </div>
        </div>

        {/* Legal cards */}
        <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fill,minmax(290px,1fr))', gap:'1.2rem', marginBottom:'3rem' }}>
          {LEGAL_CARDS.map((c, i) => (
            <div key={i} className="lcard fi">
              <div style={{ fontSize:'1.5rem', marginBottom:'.6rem' }}>{c.icon}</div>
              <div style={{ fontFamily:'var(--font-orbitron)', fontSize:'.76rem', fontWeight:700, color:'var(--cyan)', marginBottom:'.45rem', textTransform:'uppercase', letterSpacing:'.06em' }}>{c.title}</div>
              <div style={{ fontSize:'.81rem', color:'var(--muted)', lineHeight:1.6 }}>{c.body}</div>
              <div style={{ display:'flex', flexWrap:'wrap', marginTop:'.75rem' }}>
                {c.tags.map(t => <span key={t.label} className={`tag ${TAG_MAP[t.c]}`}>{t.label}</span>)}
              </div>
            </div>
          ))}
        </div>

        {/* Compliance table */}
        <div className="fi" style={{ marginBottom:'3rem' }}>
          <div className="sec-label">Data Protection by Region</div>
          <h3 style={{ fontFamily:'var(--font-orbitron)', fontSize:'1.05rem', fontWeight:700, marginBottom:'1rem' }}>Compliance per Market</h3>
          <div style={{ overflowX:'auto', border:'1px solid var(--border)', borderRadius:'12px' }}>
            <table className="comp-table">
              <thead>
                <tr>{['Region','Law','Key Rights','Payment','Status'].map(h => <th key={h}>{h}</th>)}</tr>
              </thead>
              <tbody>
                {DATA_COMPLIANCE.map((r, i) => (
                  <tr key={i}>
                    <td>{r.region}</td>
                    <td style={{ fontFamily:'var(--font-mono)', fontSize:'.72rem' }}>{r.law}</td>
                    <td style={{ fontSize:'.75rem' }}>{r.rights}</td>
                    <td style={{ fontSize:'.75rem' }}>{r.payment}</td>
                    <td><span className={r.status === 'active' ? 'ls-a' : 'ls-p'}>{r.status === 'active' ? '✓ Active' : '⏳ Planned'}</span></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* RAI */}
        <div className="fi">
          <div className="sec-label">AI Ethics</div>
          <h3 style={{ fontFamily:'var(--font-orbitron)', fontSize:'1.05rem', fontWeight:700, marginBottom:'.5rem' }}>Responsible AI Principles</h3>
          <p style={{ color:'var(--muted)', fontSize:'.83rem', marginBottom:'1.2rem' }}>Aligned with EU AI Act · OpenAI Usage Policy · Google AI Principles</p>
          <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fill,minmax(155px,1fr))', gap:'.9rem' }}>
            {RAI_PRINCIPLES.map((p, i) => (
              <div key={i} className="card" style={{ textAlign:'center' }}>
                <div style={{ fontSize:'1.6rem', marginBottom:'.5rem' }}>{p.icon}</div>
                <div style={{ fontFamily:'var(--font-orbitron)', fontSize:'.67rem', fontWeight:700, color:'var(--electric)', marginBottom:'.3rem', textTransform:'uppercase', letterSpacing:'.07em' }}>{p.title}</div>
                <div style={{ fontSize:'.74rem', color:'var(--muted)', lineHeight:1.4 }}>{p.desc}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  )
}
EOF
ok "LegalShield.tsx"

cat > components/CountdownTimer.tsx << 'EOF'
'use client'
import { useState, useEffect } from 'react'
const TARGET = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)

export default function CountdownTimer() {
  const [t, setT] = useState({ d:'30', h:'00', m:'00', s:'00' })
  useEffect(() => {
    const tick = () => {
      const diff = TARGET.getTime() - Date.now()
      if (diff <= 0) return
      setT({
        d: String(Math.floor(diff / 86400000)).padStart(2,'0'),
        h: String(Math.floor((diff % 86400000) / 3600000)).padStart(2,'0'),
        m: String(Math.floor((diff % 3600000) / 60000)).padStart(2,'0'),
        s: String(Math.floor((diff % 60000) / 1000)).padStart(2,'0'),
      })
    }
    tick(); const id = setInterval(tick, 1000); return () => clearInterval(id)
  }, [])

  const units = [['Days',t.d],['Hours',t.h],['Min',t.m],['Sec',t.s]] as const
  return (
    <div style={{ display:'flex', gap:'1.2rem', justifyContent:'center', flexWrap:'wrap', marginBottom:'1.8rem' }}>
      {units.map(([label, val], i) => (
        <div key={label} style={{ display:'flex', alignItems:'center', gap:'1.2rem' }}>
          <div style={{ textAlign:'center' }}>
            <span style={{ fontFamily:'var(--font-orbitron)', fontSize:'2.4rem', fontWeight:900,
              background:'linear-gradient(135deg,var(--cyan),var(--electric))',
              WebkitBackgroundClip:'text', WebkitTextFillColor:'transparent',
              display:'block', minWidth:'60px' }}>{val}</span>
            <div style={{ fontSize:'.58rem', color:'var(--muted)', textTransform:'uppercase', letterSpacing:'.12em', marginTop:'.25rem' }}>{label}</div>
          </div>
          {i < 3 && <span style={{ fontFamily:'var(--font-orbitron)', fontSize:'1.8rem', color:'var(--electric)', opacity:.4, marginTop:'-8px' }}>:</span>}
        </div>
      ))}
    </div>
  )
}
EOF
ok "CountdownTimer.tsx"

cat > components/Waitlist.tsx << 'EOF'
'use client'
import { useState } from 'react'
import { PLANS } from '@/lib/data'
import { useModal } from '@/contexts/ModalContext'
import CountdownTimer from './CountdownTimer'

export default function Waitlist() {
  const [email, setEmail] = useState('')
  const [joined, setJoined] = useState(false)
  const { openContact } = useModal()

  const join = () => {
    if (!email.includes('@')) return
    setJoined(true)
  }

  return (
    <section id="waitlist" style={{ position:'relative', zIndex:1, padding:'5.5rem 2rem' }}>
      <div style={{ maxWidth:'920px', margin:'0 auto' }}>
        <div style={{ textAlign:'center', marginBottom:'3rem' }}>
          <div className="sec-label" style={{ display:'flex', justifyContent:'center' }}>Early Access · Global</div>
          <h2 className="sec-title" style={{ textAlign:'center' }}>
            Founders Who <span style={{ color:'var(--gold)' }}>Believe in the Mission</span>
          </h2>
          <p style={{ color:'var(--muted)', fontSize:'.88rem', marginBottom:'1.8rem' }}>Launch pricing · Lifetime access · Voice on the roadmap</p>
          <CountdownTimer />
          <div style={{ maxWidth:'420px', margin:'.8rem auto 0' }}>
            <div style={{ display:'flex', justifyContent:'space-between', fontSize:'.7rem', color:'var(--muted)', marginBottom:'.4rem' }}>
              <span>🔥 <strong style={{ color:'var(--hot)' }}>47 founders</strong> confirmed</span>
              <span><strong style={{ color:'var(--cyan)' }}>53 spots left</strong> / 100</span>
            </div>
            <div className="prog-track"><div className="prog-fill" /></div>
          </div>
        </div>

        {/* Plans */}
        <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(240px,1fr))', gap:'1.2rem', marginBottom:'2.5rem' }}>
          {PLANS.map(p => (
            <div key={p.id} style={{ background:'var(--card)', border:`1px solid ${p.borderColor}`,
              borderRadius:'14px', padding:'1.8rem', position:'relative',
              boxShadow: p.featured ? `0 0 36px rgba(0,245,255,.1)` : undefined,
              transition:'transform .3s,box-shadow .3s' }}>
              {p.featured && (
                <div style={{ position:'absolute', top:'-12px', left:'50%', transform:'translateX(-50%)',
                  background:'linear-gradient(135deg,#00f5ff,#4d7cff)', color:'#000',
                  fontSize:'.6rem', fontWeight:900, padding:'.25rem 1rem', borderRadius:'100px',
                  whiteSpace:'nowrap', fontFamily:'var(--font-orbitron)', letterSpacing:'.08em' }}>
                  ⭐ MOST POPULAR
                </div>
              )}
              <div style={{ display:'inline-block', fontSize:'.65rem', fontWeight:700, padding:'.2rem .8rem',
                borderRadius:'100px', marginBottom:'.9rem', fontFamily:'var(--font-orbitron)',
                letterSpacing:'.1em', background:p.badgeBg, color:p.badgeColor }}>{p.badge}</div>
              <div style={{ fontFamily:'var(--font-orbitron)', fontSize:'2rem', fontWeight:900, marginBottom:'.2rem' }}>
                <span style={{ fontSize:'.9rem', verticalAlign:'super' }}>$</span>{p.price}
                <span style={{ fontSize:'.67rem', color:'var(--muted)', fontWeight:400 }}>{p.period}</span>
              </div>
              <div style={{ fontSize:'.73rem', color:'var(--green)', marginBottom:'1.2rem' }}>
                {p.promo} — <s style={{ color:'var(--muted)' }}>{p.original}</s>
              </div>
              <ul style={{ listStyle:'none', display:'flex', flexDirection:'column', gap:'.42rem', marginBottom:'1.5rem' }}>
                {p.items.map(item => <li key={item} style={{ fontSize:'.8rem', color:'var(--muted)' }}>{item}</li>)}
              </ul>
              <button onClick={() => openContact(p.id)}
                className={p.featured ? 'plan-btn-f' : ''}
                style={{ width:'100%', padding:'.88rem', borderRadius:'8px', fontFamily:'var(--font-orbitron)',
                  fontSize:'.67rem', fontWeight:700, letterSpacing:'.05em', transition:'all .3s',
                  ...(p.featured ? {} : { background:'var(--surface)', border:'1px solid var(--border)', color:'var(--text)' }) }}>
                Secure {p.badge} Spot
              </button>
            </div>
          ))}
        </div>

        {/* Waitlist form */}
        <div style={{ background:'var(--card)', border:'1px solid var(--border)', borderRadius:'16px', padding:'2rem', textAlign:'center', marginBottom:'2rem' }}>
          <div style={{ fontSize:'1.4rem', marginBottom:'.45rem' }}>📬</div>
          <h3 style={{ fontFamily:'var(--font-orbitron)', fontSize:'.97rem', marginBottom:'.4rem' }}>Free Global Waitlist</h3>
          <p style={{ color:'var(--muted)', fontSize:'.83rem', marginBottom:'1rem' }}>
            First to know at launch + <strong style={{ color:'var(--cyan)' }}>30% founder discount</strong>
          </p>
          {!joined ? (
            <>
              <div style={{ display:'flex', gap:'.7rem', maxWidth:'500px', margin:'1.2rem auto', flexWrap:'wrap', justifyContent:'center' }}>
                <input type="email" value={email} placeholder="your@email.com"
                  onChange={e => setEmail(e.target.value)}
                  className="minput" style={{ flex:1, minWidth:'210px', margin:0 }} />
                <button className="btn-p" style={{ padding:'.8rem 1.6rem', fontSize:'.75rem' }} onClick={join}>🌍 Join Mission</button>
              </div>
              <p style={{ color:'var(--muted)', fontSize:'.67rem', marginTop:'.7rem' }}>🔒 GDPR/LGPD compliant · No spam · Unsubscribe anytime</p>
            </>
          ) : (
            <p style={{ color:'var(--green)', fontWeight:700, fontSize:'.95rem', padding:'1rem 0' }}>✅ You&apos;re on the mission list!</p>
          )}
        </div>

        {/* Investor */}
        <div style={{ background:'linear-gradient(135deg,rgba(255,215,0,.06),rgba(168,85,247,.06))', border:'1px solid rgba(255,215,0,.2)', borderRadius:'16px', padding:'2.5rem', textAlign:'center' }}>
          <div style={{ fontSize:'1.8rem', marginBottom:'.7rem' }}>🌍</div>
          <h3 style={{ fontFamily:'var(--font-orbitron)', fontSize:'.97rem', color:'var(--gold)', marginBottom:'.7rem' }}>Investors &amp; Strategic Partners</h3>
          <p style={{ color:'var(--muted)', fontSize:'.85rem', maxWidth:'530px', margin:'0 auto 1.5rem', lineHeight:1.7 }}>
            Building the first education platform with <strong style={{ color:'var(--text)' }}>native geopolitical intelligence</strong> — from Brazil to India, Nigeria to Japan. Seeking partners who think at planetary scale.
          </p>
          <div style={{ display:'flex', gap:'.9rem', justifyContent:'center', flexWrap:'wrap' }}>
            <button onClick={() => openContact('Investor')}
              style={{ background:'linear-gradient(135deg,var(--gold),#ff9500)', color:'#000', border:'none',
                borderRadius:'8px', padding:'1rem 2.2rem', fontFamily:'var(--font-orbitron)',
                fontSize:'.77rem', fontWeight:900, boxShadow:'0 0 36px rgba(255,215,0,.3)', cursor:'pointer' }}>
              💰 I Want to Invest
            </button>
            <button onClick={() => openContact('Partner')}
              style={{ background:'transparent', color:'var(--violet)', border:'1px solid rgba(168,85,247,.4)',
                borderRadius:'8px', padding:'1rem 2.2rem', fontFamily:'var(--font-orbitron)',
                fontSize:'.77rem', fontWeight:700, cursor:'pointer' }}>
              🤝 Strategic Partnership
            </button>
          </div>
        </div>
      </div>
    </section>
  )
}
EOF
ok "Waitlist.tsx"

cat > components/CTA.tsx << 'EOF'
'use client'
import { useModal } from '@/contexts/ModalContext'
function scrollTo(id: string) { document.getElementById(id)?.scrollIntoView({ behavior:'smooth' }) }

export default function CTA() {
  const { openContact } = useModal()
  return (
    <section style={{ textAlign:'center', background:'linear-gradient(180deg,var(--deep),var(--void))', padding:'7rem 2rem', position:'relative', zIndex:1 }}>
      <div style={{ maxWidth:'720px', margin:'0 auto' }}>
        <div style={{ display:'inline-block', background:'rgba(168,85,247,.12)', border:'1px solid rgba(168,85,247,.3)',
          borderRadius:'100px', padding:'.38rem 1.1rem', fontSize:'.7rem', color:'var(--violet)',
          fontWeight:700, letterSpacing:'.12em', textTransform:'uppercase', marginBottom:'1.5rem' }}>
          Global One-Line Pitch
        </div>
        <h2 style={{ fontFamily:'var(--font-orbitron)', fontSize:'clamp(1.6rem,4vw,2.8rem)', fontWeight:900, marginBottom:'1.2rem', lineHeight:1.2 }}>
          Every Culture.<br />
          <span className="grad-full">One Platform. Real Impact.</span>
        </h2>
        <blockquote style={{ fontSize:'.97rem', color:'var(--muted)', lineHeight:1.7, borderLeft:'3px solid var(--violet)', paddingLeft:'1.5rem', textAlign:'left', margin:'2rem auto', maxWidth:'600px', fontStyle:'italic' }}>
          The platform that delivers education natively to every culture — with local currency, local slogans, geopolitical intelligence, full legal compliance, and AI built like SpaceX builds rockets: ambitious vision, real execution, phase by phase.
        </blockquote>
        <div style={{ display:'flex', gap:'1rem', justifyContent:'center', flexWrap:'wrap' }}>
          <button className="btn-p" onClick={() => scrollTo('waitlist')}>🚀 Join the Global Mission</button>
          <button className="btn-s" onClick={() => openContact('Partner')}>📞 Talk to the Team</button>
        </div>
      </div>
    </section>
  )
}
EOF
ok "CTA.tsx"

cat > components/ContactModal.tsx << 'EOF'
'use client'
import { useState, useEffect } from 'react'
import { useModal } from '@/contexts/ModalContext'
import { MODAL_CFG } from '@/lib/data'

export default function ContactModal() {
  const { modal, close } = useModal()
  const [name, setName]   = useState('')
  const [email, setEmail] = useState('')
  const [phone, setPhone] = useState('')
  const [sent, setSent]   = useState(false)

  useEffect(() => {
    if (modal?.type === 'contact') { setSent(false); setName(''); setEmail(''); setPhone('') }
  }, [modal])

  if (modal?.type !== 'contact') return null
  const cfg = MODAL_CFG[modal.id] ?? { icon:'📩', title:modal.id, desc:'Fill in and we will be in touch.', label:'Send →' }

  const submit = () => {
    if (!name.trim() || !email.includes('@')) return
    setSent(true)
  }

  return (
    <div style={{ display:'flex', position:'fixed', inset:0, background:'rgba(0,0,0,.88)', backdropFilter:'blur(10px)', zIndex:999, alignItems:'center', justifyContent:'center', padding:'1rem' }}
      onClick={e => { if (e.target === e.currentTarget) close() }}>
      <div style={{ background:'var(--card)', border:'1px solid var(--border)', borderRadius:'16px', padding:'2.5rem', maxWidth:'480px', width:'100%', position:'relative', animation:'fadeUp .4s ease' }}>
        <button onClick={close} style={{ position:'absolute', top:'1rem', right:'1rem', background:'none', border:'none', color:'var(--muted)', fontSize:'1.4rem', cursor:'pointer', lineHeight:1 }}>✕</button>
        {!sent ? (
          <>
            <div style={{ fontSize:'2rem', textAlign:'center', marginBottom:'.7rem' }}>{cfg.icon}</div>
            <h3 style={{ fontFamily:'var(--font-orbitron)', fontSize:'1rem', textAlign:'center', marginBottom:'.4rem' }}>{cfg.title}</h3>
            <p style={{ color:'var(--muted)', fontSize:'.81rem', textAlign:'center', marginBottom:'1.5rem', lineHeight:1.6 }}>{cfg.desc}</p>
            <input type="text"  value={name}  onChange={e=>setName(e.target.value)}  className="minput" placeholder="Full name" />
            <input type="email" value={email} onChange={e=>setEmail(e.target.value)} className="minput" placeholder="Best email" />
            <input type="tel"   value={phone} onChange={e=>setPhone(e.target.value)} className="minput" placeholder="WhatsApp / phone" />
            <button onClick={submit} style={{ width:'100%', background:'linear-gradient(135deg,var(--electric),var(--violet))', color:'#fff', border:'none', borderRadius:'8px', padding:'1rem', fontFamily:'var(--font-orbitron)', fontSize:'.77rem', fontWeight:700, letterSpacing:'.06em', marginTop:'.3rem', cursor:'pointer' }}>
              {cfg.label}
            </button>
          </>
        ) : (
          <div style={{ textAlign:'center', padding:'2rem 0' }}>
            <div style={{ fontSize:'3rem', marginBottom:'.8rem' }}>✅</div>
            <p style={{ color:'var(--green)', fontWeight:700, fontSize:'1rem' }}>Received! We&apos;ll be in touch shortly.</p>
          </div>
        )}
      </div>
    </div>
  )
}
EOF
ok "ContactModal.tsx"

cat > components/LegalModal.tsx << 'EOF'
'use client'
import { useModal } from '@/contexts/ModalContext'
import { LEGAL_DOCS } from '@/lib/data'

export default function LegalModal() {
  const { modal, close } = useModal()
  if (modal?.type !== 'legal') return null
  const doc = LEGAL_DOCS[modal.slug]
  if (!doc) return null

  return (
    <div style={{ display:'flex', position:'fixed', inset:0, background:'rgba(0,0,0,.92)', backdropFilter:'blur(12px)', zIndex:1000, alignItems:'flex-start', justifyContent:'center', padding:'2rem 1rem', overflowY:'auto' }}
      onClick={e => { if (e.target === e.currentTarget) close() }}>
      <div style={{ background:'var(--card)', border:'1px solid rgba(0,245,255,.2)', borderRadius:'16px', padding:'2.5rem', maxWidth:'760px', width:'100%', position:'relative', animation:'fadeUp .4s ease', margin:'auto' }}>
        <button onClick={close} style={{ position:'absolute', top:'1rem', right:'1rem', background:'none', border:'none', color:'var(--muted)', fontSize:'1.4rem', cursor:'pointer', lineHeight:1 }}>✕</button>
        <h2 style={{ fontFamily:'var(--font-orbitron)', fontSize:'1.1rem', color:'var(--cyan)', marginBottom:'.3rem' }} dangerouslySetInnerHTML={{ __html: doc.title }} />
        <p style={{ fontSize:'.68rem', color:'var(--muted)', fontFamily:'var(--font-mono)', marginBottom:'1.5rem' }}>{doc.date}</p>
        <div className="legal-modal-content" dangerouslySetInnerHTML={{ __html: doc.body }} />
        <div style={{ marginTop:'1.8rem', paddingTop:'1rem', borderTop:'1px solid var(--border)' }}>
          <p style={{ fontSize:'.77rem', color:'var(--muted)' }}>
            Questions? <a href="mailto:legal@contact.com" style={{ color:'var(--cyan)' }}>legal@contact.com</a>
          </p>
        </div>
      </div>
    </div>
  )
}
EOF
ok "LegalModal.tsx"

cat > components/CookieBanner.tsx << 'EOF'
'use client'
import { useState, useEffect } from 'react'
import { useModal } from '@/contexts/ModalContext'

export default function CookieBanner() {
  const [visible, setVisible] = useState(false)
  const { openLegal } = useModal()

  useEffect(() => {
    try { if (!localStorage.getItem('iga_ck')) setTimeout(() => setVisible(true), 1500) }
    catch { setVisible(true) }
  }, [])

  const accept = () => {
    try { localStorage.setItem('iga_ck', '1') } catch {}
    setVisible(false)
  }

  if (!visible) return null
  return (
    <div className={`cookie-bar${visible ? ' show' : ''}`}>
      <p style={{ fontSize:'.77rem', color:'var(--muted)', maxWidth:'680px', lineHeight:1.5, flex:1 }}>
        <strong style={{ color:'var(--text)' }}>We use cookies</strong> to improve your experience and comply with GDPR, LGPD and CCPA. Your data is never sold.{' '}
        <button onClick={() => openLegal('privacy')} style={{ color:'var(--cyan)', background:'none', border:'none', cursor:'pointer', fontSize:'.77rem', fontFamily:'var(--font-exo)' }}>Privacy Policy</button>
        {' · '}
        <button onClick={() => openLegal('cookies')} style={{ color:'var(--violet)', background:'none', border:'none', cursor:'pointer', fontSize:'.77rem', fontFamily:'var(--font-exo)' }}>Cookie Policy</button>
      </p>
      <div style={{ display:'flex', gap:'.6rem' }}>
        <button onClick={() => openLegal('cookies')} style={{ background:'transparent', color:'var(--muted)', border:'1px solid var(--border)', borderRadius:'6px', padding:'.55rem 1.1rem', fontSize:'.74rem', cursor:'pointer' }}>Manage</button>
        <button onClick={accept} style={{ background:'linear-gradient(135deg,var(--electric),var(--violet))', color:'#fff', border:'none', borderRadius:'6px', padding:'.55rem 1.3rem', fontFamily:'var(--font-orbitron)', fontSize:'.67rem', fontWeight:700, cursor:'pointer' }}>Accept All</button>
      </div>
    </div>
  )
}
EOF
ok "CookieBanner.tsx"

cat > components/Footer.tsx << 'EOF'
'use client'
import { useModal } from '@/contexts/ModalContext'

export default function Footer() {
  const { openLegal, openContact } = useModal()

  const trustBadges = ['🔒 SSL','🇺🇳 SDG 4','⚖️ GDPR','♿ WCAG 2.1','🤖 Responsible AI','©️ DMCA']
  const legalLinks  = [
    { label:'Terms',          slug:'terms' },
    { label:'Privacy',        slug:'privacy' },
    { label:'Cookies',        slug:'cookies' },
    { label:'Creator Rights', slug:'creator-rights' },
    { label:'Accessibility',  slug:'accessibility' },
    { label:'DMCA',           slug:'dmca' },
  ]

  return (
    <footer style={{ position:'relative', zIndex:1, background:'var(--void)', borderTop:'1px solid var(--border)', padding:'3rem 2rem 2rem' }}>
      <div style={{ maxWidth:'1200px', margin:'0 auto' }}>
        <div style={{ display:'grid', gridTemplateColumns:'2fr 1fr 1fr', gap:'2rem', marginBottom:'2.5rem' }}>
          <div>
            <div style={{ display:'flex', alignItems:'center', gap:'.5rem', marginBottom:'.5rem' }}>
              <div className="nav-logo-mark">⚡</div>
              <span style={{ fontFamily:'var(--font-orbitron)', fontWeight:900, fontSize:'1.1rem',
                background:'linear-gradient(135deg,var(--cyan),var(--electric))',
                WebkitBackgroundClip:'text', WebkitTextFillColor:'transparent' }}>IGA</span>
            </div>
            <p style={{ fontSize:'.77rem', color:'var(--muted)', lineHeight:1.6, maxWidth:'260px' }}>
              The first education platform with native geopolitical intelligence. Every culture. Every language. One mission.
            </p>
            <div style={{ display:'flex', flexWrap:'wrap', gap:'.45rem', marginTop:'1.1rem' }}>
              {trustBadges.map(b => (
                <div key={b} style={{ background:'var(--card)', border:'1px solid var(--border)', borderRadius:'5px', padding:'.33rem .65rem', fontSize:'.62rem', fontWeight:700, color:'var(--muted)', fontFamily:'var(--font-mono)' }}>{b}</div>
              ))}
            </div>
          </div>

          <div>
            <h4 style={{ fontFamily:'var(--font-orbitron)', fontSize:'.68rem', color:'var(--text)', fontWeight:700, letterSpacing:'.1em', textTransform:'uppercase', marginBottom:'.9rem' }}>Company</h4>
            <ul style={{ listStyle:'none', display:'flex', flexDirection:'column', gap:'.42rem' }}>
              {[['About',      () => openLegal('about')],
                ['Partnerships',() => openContact('Partner')],
                ['Investors',   () => openContact('Investor')],
                ['Responsible AI',() => openLegal('responsible-ai')]].map(([l, fn]) => (
                <li key={String(l)}><button onClick={fn as ()=>void} style={{ background:'none', border:'none', color:'var(--muted)', fontSize:'.77rem', cursor:'pointer', fontFamily:'var(--font-exo)', padding:0 }}
                  onMouseOver={e=>(e.currentTarget.style.color='var(--cyan)')} onMouseOut={e=>(e.currentTarget.style.color='var(--muted)')}>{l}</button></li>
              ))}
            </ul>
          </div>

          <div>
            <h4 style={{ fontFamily:'var(--font-orbitron)', fontSize:'.68rem', color:'var(--text)', fontWeight:700, letterSpacing:'.1em', textTransform:'uppercase', marginBottom:'.9rem' }}>Legal</h4>
            <ul style={{ listStyle:'none', display:'flex', flexDirection:'column', gap:'.42rem' }}>
              {legalLinks.map(l => (
                <li key={l.slug}><button onClick={() => openLegal(l.slug)} style={{ background:'none', border:'none', color:'var(--muted)', fontSize:'.77rem', cursor:'pointer', fontFamily:'var(--font-exo)', padding:0 }}
                  onMouseOver={e=>(e.currentTarget.style.color='var(--cyan)')} onMouseOut={e=>(e.currentTarget.style.color='var(--muted)')}>{l.label}</button></li>
              ))}
            </ul>
          </div>
        </div>

        <div style={{ borderTop:'1px solid var(--border)', paddingTop:'1.5rem', display:'flex', flexWrap:'wrap', gap:'1rem', alignItems:'center', justifyContent:'space-between' }}>
          <div style={{ fontSize:'.68rem', color:'var(--muted)' }}>
            © 2025 · Founder: <strong style={{ color:'var(--cyan)' }}>Odette Nduwayezu</strong><br />
            <span style={{ opacity:.6, fontSize:'.64rem' }}>Every Culture. One Platform. Education is a Human Right. — UDHR Article 26</span>
          </div>
          <div style={{ display:'flex', gap:'.9rem', flexWrap:'wrap' }}>
            {legalLinks.map(l => (
              <button key={l.slug} onClick={() => openLegal(l.slug)} style={{ background:'none', border:'none', color:'var(--muted)', fontSize:'.67rem', cursor:'pointer', fontFamily:'var(--font-exo)' }}
                onMouseOver={e=>(e.currentTarget.style.color='var(--cyan)')} onMouseOut={e=>(e.currentTarget.style.color='var(--muted)')}>{l.label}</button>
            ))}
          </div>
        </div>
      </div>
    </footer>
  )
}
EOF
ok "Footer.tsx"

# ═══════════════════════════════════════════════════════════════
#  README.md
# ═══════════════════════════════════════════════════════════════
hd "README"
cat > README.md << 'EOF'
# 🚀 IGA — Every Culture. Every Language. One Platform.

> AI-powered education platform with native geopolitical intelligence.

## Stack
- **Framework**: Next.js 15.1 (App Router + Turbopack)
- **Language**: TypeScript 5
- **Styling**: Tailwind CSS 3 + CSS Custom Properties
- **React**: 19
- **Deploy**: Vercel (multi-region: gru1, iad1, lhr1, sin1)

## Quick Start

```bash
npm install
npm run dev
# → http://localhost:3000
```

## Build & Deploy

```bash
npm run build   # production build
npm run start   # production server
```

## Deploy to Vercel

### Option A — CLI
```bash
npx vercel
```

### Option B — GitHub + Dashboard
1. Push to GitHub
2. vercel.com → New Project → Import repo
3. Auto-deploy on every push ✓

### Option C — Drag & Drop
Drag the `.next/` folder into vercel.com/new

## Custom Domain
In Vercel Dashboard → Project → Domains → Add your domain.
Vercel provisions SSL automatically.

## Project Structure

```
├── app/
│   ├── layout.tsx          # Root layout, fonts, metadata
│   ├── page.tsx            # Home (all sections)
│   ├── globals.css         # Design system, CSS variables, animations
│   └── legal/[slug]/       # 7 legal document pages (static)
├── components/
│   ├── Stars.tsx           # Starfield background
│   ├── Nav.tsx             # Responsive navigation
│   ├── Hero.tsx            # Hero + animated ticker
│   ├── SloganTicker.tsx    # 18-language animated slogans
│   ├── InspiredBy.tsx      # Big players DNA section
│   ├── Markets.tsx         # 12 geopolitical markets
│   ├── Diagnostic.tsx      # Multilingual quiz (PT/EN/ES/FR)
│   ├── Phases.tsx          # 3-phase honest roadmap
│   ├── LegalShield.tsx     # Legal + compliance table + RAI
│   ├── Waitlist.tsx        # Plans + countdown + investor CTA
│   ├── CountdownTimer.tsx  # Live 30-day countdown
│   ├── CTA.tsx             # Final call to action
│   ├── Footer.tsx          # Footer with legal links
│   ├── CookieBanner.tsx    # GDPR/LGPD/CCPA cookie consent
│   ├── ContactModal.tsx    # Contact/purchase modal
│   └── LegalModal.tsx      # In-page legal document modal
├── contexts/
│   └── ModalContext.tsx    # Global modal state (contact + legal)
└── lib/
    ├── types.ts            # TypeScript interfaces
    ├── data.ts             # All platform data (markets, plans, legal docs)
    └── i18n.ts             # Diagnostic i18n (PT/EN/ES/FR)
```

## Legal Documents Included
- Terms of Service
- Privacy Policy (GDPR · LGPD · CCPA · POPIA · PDPA)
- Cookie Policy
- Creator Rights & IP Policy
- Accessibility Statement (WCAG 2.1 AA)
- DMCA & Copyright Policy
- Responsible AI Policy (EU AI Act)

## Humanitarian Foundation
- 🇺🇳 UN SDG 4 — Quality Education
- 📜 UNESCO Open Educational Resources
- ⚖️ UDHR Article 26 — Right to Education
- 🤖 Responsible AI — EU AI Act aligned

---

**Founder**: Odette Nduwayezu  
*Education is a Human Right. — UDHR Article 26*
EOF
ok "README.md"

# ═══════════════════════════════════════════════════════════════
#  Scroll observer (client util)
# ═══════════════════════════════════════════════════════════════
cat > components/ScrollObserver.tsx << 'EOF'
'use client'
import { useEffect } from 'react'
export default function ScrollObserver() {
  useEffect(() => {
    const obs = new IntersectionObserver(
      entries => entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('vis') }),
      { threshold: 0.07 }
    )
    const observe = () => document.querySelectorAll('.fi:not([data-ob])').forEach(el => {
      el.setAttribute('data-ob','1'); obs.observe(el)
    })
    observe()
    const mo = new MutationObserver(observe)
    mo.observe(document.body, { childList:true, subtree:true })
    return () => { obs.disconnect(); mo.disconnect() }
  }, [])
  return null
}
EOF
ok "ScrollObserver.tsx"

# Add ScrollObserver to page.tsx
sed -i "s|import LegalModal   from '@/components/LegalModal'|import LegalModal      from '@/components/LegalModal'\nimport ScrollObserver from '@/components/ScrollObserver'|" app/page.tsx
sed -i "s|        <LegalModal />|        <LegalModal />\n        <ScrollObserver />|" app/page.tsx
ok "ScrollObserver injected into page.tsx"

# ═══════════════════════════════════════════════════════════════
#  GIT
# ═══════════════════════════════════════════════════════════════
hd "Git"
git init -q
git add .
git commit -q -m "🚀 feat: production-ready Next.js 15 — IGA Platform

Stack: Next.js 15.1 + React 19 + TypeScript 5 + Tailwind CSS 3
- Multilingual Diagnostic (PT/EN/ES/FR) with auto-detect + localStorage
- 12 geopolitical markets with native slogans + local currencies
- 18-language animated slogan ticker
- Big Players DNA section (SpaceX, OpenAI, Netflix, Duolingo, Uber…)
- 3-phase honest roadmap
- Legal Shield: GDPR, LGPD, CCPA, POPIA, PDPA + 7 full legal documents
- UDHR Art. 26 + UN SDG 4 + Responsible AI (EU AI Act)
- Cookie consent banner (GDPR/LGPD/CCPA)
- Modal context (contact + legal) — no prop drilling
- Countdown timer + founder spots progress bar
- Multi-region Vercel deploy (gru1, iad1, lhr1, sin1)
- Security headers: HSTS, X-Frame-Options, CSP, Permissions-Policy
- WCAG 2.1 AA accessibility targets
- Scroll fade-in animations (IntersectionObserver)
- Founder: Odette Nduwayezu"
ok "Git initialized"

# ═══════════════════════════════════════════════════════════════
echo -e "\n${B}${G}"
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║  ✅  Project created: igaforge-next/         ║"
echo "  ╚══════════════════════════════════════════════╝"
echo -e "${R}"
echo -e "${G}Run locally:${R}"
echo "  cd igaforge-next"
echo "  npm install"
echo "  npm run dev  →  http://localhost:3000"
echo ""
echo -e "${G}Deploy to Vercel:${R}"
echo "  npx vercel          # CLI deploy"
echo "  # OR push to GitHub and import at vercel.com"
echo ""
echo -e "${G}Add custom domain in Vercel:${R}"
echo "  Dashboard → Project → Domains → Add domain"
echo "  Vercel provisions SSL automatically."
echo ""
echo -e "${B}${C}  Every Culture. One Platform. Education is a Human Right.${R}\n"
