# pandoc-bbcode: Write vBulletin forum posts in Markdown (or anything else)

## Introduction to Kerbas_ad_astra's modifications

Kerbal Space Program players (and especially addon authors) have to manage a lot of websites -- the official forums, Kerbal CurseForge, and a variety of unofficial but popular sites, like GitHub, KerbalStuff, and KerbalX.  The latter all ingest markdown just fine, but the first two don't -- the forums run on BBCode, while CurseForge works natively with HTML.  [Pandoc](pandoc.org) is handy for converting markdown into HTML, but it doesn't produce BBCode natively (probably because there's no single BBCode standard).  Like 2ion, I don't much like typing in BBCode or using the native forum editor, so I was extremely happy to find 2ion's converter.  I've made some modifications so that its output works with forums that run on vBulletin (as the KSP forum does), but really, I just built a little on top of his work.

One nice thing that this conversion gets us: vBulletin's implementation of BBCode supports native tables, so we don't have to hack around with "columnation" like 2ion does.