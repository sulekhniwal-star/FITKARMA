import ifct from 'ifct2017';
import fs from 'fs';

await ifct.compositions.load();
await ifct.languages.load();

const allCompositions = ifct.compositions('');
const langs = ifct.languages();

console.log(`✅ Loaded ${allCompositions.length} compositions`);
console.log(`✅ Loaded ${langs.length} languages`);

const output = allCompositions.map(c => ({
  code: c.code,
  name: c.name,
  group: c.group,
  lang: c.lang || {},
  nutrients: {
    enerc: c.enerc,
    water: c.water,
    prot: c.prot,
    nt: c.nt,
    f18d2cn6: c.f18d2cn6,
    f18d3n3: c.f18d3n3,
    fams: c.fams,
    fapu: c.fapu,
    fasat: c.fasat,
    foldfe: c.foldfe,
    folfd: c.folfd,
    folac: c.folac,
    ribf: c.ribf,
    thia: c.thia,
    vitb12: c.vitb12,
    vitb6: c.vitb6,
    vitc: c.vitc,
    vita: c.vita,
    vite: c.vite,
    vitk: c.vitk,
    ca: c.ca,
    fe: c.fe,
    mg: c.mg,
    p: c.p,
    k: c.k,
    na: c.na,
    zn: c.zn,
    cu: c.cu,
    mn: c.mn,
    se: c.se,
    chol: c.chol,
    fibtg: c.fibtg,
    fibts: c.fibts,
    fibc: c.fibc,
    choavl: c.choavl,
    sugar: c.sugar,
    starch: c.starch,
    fat: c.fat,
  },
  source: 'ifct2017'
}));

fs.writeFileSync('./data/raw/ifct2017_extracted.json', JSON.stringify(output, null, 2));
console.log(`✨ Extracted ${output.length} items to data/raw/ifct2017_extracted.json`);
