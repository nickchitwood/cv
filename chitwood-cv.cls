%% chitwood-cv.cls — Atelier port of Awesome-CV for Nicholas R. Chitwood.
%% Inherits Awesome-CV; overrides fonts, colors, styles, and the page
%% architecture to match the Atelier design system (nrc_design_system / DESIGN.md).
%%
%% Visual tokens come from DESIGN.md §3 (color), §4 (type), §6 (layout),
%% §7 (components), §8.2 (CV-specific). Constraint list §9 is binding.
%%
%% Build: XeLaTeX (variable-axis font support).
%%
%% Notes:
%%  - The sidebar/main 5/7 split is provided by `paracol`. Sidebar fill
%%    uses paracol's native `\backgroundcolor` per-column — more robust than
%%    eso-pic across page breaks (IMPLEMENTATION.md §1.6 warned about this).
%%  - The top accent bar is drawn via `\AddToShipoutPictureFG` so it is
%%    visible on every page including paracol overflow pages.
%%  - All cventry/cvitem geometry is rewritten to use `\linewidth` instead
%%    of `\textwidth` so it adapts to the narrower paracol main column.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{chitwood-cv}[2026/05/17 v0.1 Atelier CV class for N.R. Chitwood]

% Inherit everything from Awesome-CV. All overrides below are by design.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{awesome-cv}}
\ProcessOptions\relax
\LoadClass{awesome-cv}

% Eso-pic for the top accent bar; paracol for 5/7 split; tikz for marker
% squares; zref-savepos so we can capture the y-position of the masthead
% rule and use it as the sidebar fill's top edge (no more guessing).
\RequirePackage{eso-pic}
\RequirePackage{paracol}
\RequirePackage{tikz}
\RequirePackage{zref-savepos}

%-------------------------------------------------------------------------------
% Atelier color tokens (DESIGN.md §3). Override Awesome-CV's palette so
% downstream macros that reference `awesome`, `text`, `graytext`, etc. all
% resolve to Atelier tokens without further plumbing.
%-------------------------------------------------------------------------------
\definecolor{paper}{HTML}{FAF6EC}
\definecolor{bg}{HTML}{F5F1E6}
\definecolor{sidebar}{HTML}{EFE9D8}
\definecolor{atelierText}{HTML}{11140F}
\definecolor{muted}{HTML}{5F6358}
\definecolor{rule}{HTML}{11140F}
\definecolor{rulesoft}{HTML}{C2BEA9}
\definecolor{accent}{HTML}{1F4D2A}

% Override awesome-cv's named colors so inherited macros pick up Atelier tones.
\colorlet{awesome}{accent}
\colorlet{text}{atelierText}
\colorlet{darktext}{atelierText}
\colorlet{graytext}{muted}
\colorlet{lighttext}{muted}
\colorlet{sectiondivider}{rulesoft}

% Make the page itself sit on the warm cream so paracol fills meet correctly.
\pagecolor{paper}

%-------------------------------------------------------------------------------
% Fonts — Inter Tight via fontspec (DESIGN.md §4). Static TTFs are safer
% than variable-axis (IMPLEMENTATION.md §1.6).
%-------------------------------------------------------------------------------
\setmainfont{Inter Tight}[
  Path = fonts/,
  Extension = .ttf,
  UprightFont = InterTight-Regular,
  ItalicFont = InterTight-Italic,
  BoldFont = InterTight-SemiBold,
  BoldItalicFont = InterTight-SemiBoldItalic,
  FontFace = {m}{n}{InterTight-Medium},
  FontFace = {m}{it}{InterTight-MediumItalic},
  Ligatures = TeX,
  Numbers = {Monospaced},
]

\newfontfamily\InterTightSemiBold[Path=fonts/, Extension=.ttf,
  UprightFont = InterTight-SemiBold,
  ItalicFont = InterTight-SemiBoldItalic,
  Ligatures = TeX, Numbers = {Monospaced}]{InterTight}

\newfontfamily\InterTightBold[Path=fonts/, Extension=.ttf,
  UprightFont = InterTight-Bold,
  ItalicFont = InterTight-BoldItalic,
  Ligatures = TeX, Numbers = {Monospaced}]{InterTight}

\newfontfamily\InterTightRegular[Path=fonts/, Extension=.ttf,
  UprightFont = InterTight-Regular,
  ItalicFont = InterTight-Italic,
  Ligatures = TeX, Numbers = {Monospaced}]{InterTight}

% Overwrite Awesome-CV's font-command shims so all inherited macros use Inter Tight.
\renewcommand*{\headerfont}{\InterTightSemiBold}
\renewcommand*{\headerfontlight}{\InterTightRegular}
\renewcommand*{\footerfont}{\InterTightRegular}
\renewcommand*{\bodyfont}{\InterTightRegular}
\renewcommand*{\bodyfontlight}{\InterTightRegular}

%-------------------------------------------------------------------------------
% Page geometry — DESIGN.md §6: 0.6" outer, 0.55" top/bottom on CV pages.
% We also reserve a bit of footer skip for the wordmark / page-number band.
%-------------------------------------------------------------------------------
\geometry{letterpaper, left=0.6in, right=0.6in, top=0.7in, bottom=0.75in,
          headheight=0pt, headsep=0pt, footskip=0.35in}

% Page architecture:
%   1. 2bp forest-green accent bar flush to the top edge of every page
%   2. Sidebar fill (page 1 only) — drawn via eso-pic so it bleeds to the
%      left page edge and extends from below the masthead rule down to
%      just above the footer rule. Paracol's native column background
%      doesn't bleed past the column box, so eso-pic is the right tool.
% Fill geometry. Width must END BEFORE the paracol main column's text
% begins, otherwise the right side of the fill bleeds behind main col
% text. With columnratio 0.42/0.58, columnsep 24pt, and 0.6in outer
% margins, the main column text starts at ~3.86in from page left. So
% 3.75in fill width sits cleanly in the gap (~0.22in padding past
% sidebar text right edge, ~0.1in before main col text starts).
\newlength{\atelierFillBottom}
\setlength{\atelierFillBottom}{0.5in}
\newlength{\atelierFillWidth}
\setlength{\atelierFillWidth}{3.75in}

\AddToShipoutPictureBG{%
  \ifnum\value{page}=1\relax
    \AtPageLowerLeft{%
      % Fill top y = position of masthead rule (captured via zsavepos).
      % First compile pass — ref undefined, fall back to a placeholder so
      % layout completes. Second pass reads .aux and aligns exactly.
      \zref@ifrefundefined{atelier-masthead-rule}{%
        \put(0pt, \atelierFillBottom){%
          \color{sidebar}\rule{\atelierFillWidth}{8.5in}%
        }%
      }{%
        \put(0pt, \atelierFillBottom){%
          \color{sidebar}\rule{\atelierFillWidth}{%
            \dimexpr \zposy{atelier-masthead-rule}sp - \atelierFillBottom \relax%
          }%
        }%
      }%
    }%
  \fi
}
\AddToShipoutPictureFG{%
  \AtPageUpperLeft{%
    \put(0,-2){\color{accent}\rule{\paperwidth}{2bp}}%
  }%
}

%-------------------------------------------------------------------------------
% Atelier marker square (DESIGN.md §7.2). The signature mark.
% Usage: \atmarker (default 7pt, accent) or \atmarker[size=4pt] for bullets.
%-------------------------------------------------------------------------------
\newcommand{\atmarker}[1][7pt]{%
  \tikz[baseline=-0.18ex]\fill[accent] (0,0) rectangle (#1,#1);%
}
\newcommand{\atmarkerinline}{%
  \tikz[baseline=-0.4ex]\fill[accent] (0,0) rectangle (7pt,7pt);\hspace{6pt}%
}

%-------------------------------------------------------------------------------
% Restyle Awesome-CV element commands with Atelier scale (DESIGN.md §4).
% Sizes are in pt to match the print scale column.
%-------------------------------------------------------------------------------
% Masthead pieces
\renewcommand*{\headerfirstnamestyle}[1]{{\fontsize{26}{30}\InterTightSemiBold\color{atelierText}#1}}
\renewcommand*{\headerlastnamestyle}[1]{{\fontsize{26}{30}\InterTightSemiBold\color{atelierText}#1}}
\renewcommand*{\headerpositionstyle}[1]{{\fontsize{10.5}{14}\InterTightRegular\color{muted}#1}}
\renewcommand*{\headeraddressstyle}[1]{{\fontsize{9}{12}\InterTightRegular\color{muted}#1}}
\renewcommand*{\headersocialstyle}[1]{{\fontsize{9}{12}\InterTightRegular\color{muted}#1}}
\renewcommand*{\headerquotestyle}[1]{{\fontsize{10}{14}\InterTightRegular\itshape\color{muted}#1}}

% Footer wordmark style
\renewcommand*{\footerstyle}[1]{{\fontsize{9}{12}\InterTightRegular\color{muted}#1}}

% Section/sub-section in main column
\renewcommand*{\sectionstyle}[1]{{\fontsize{14}{18}\InterTightSemiBold\color{atelierText}#1}}
\renewcommand*{\subsectionstyle}[1]{{\fontsize{11}{14}\InterTightSemiBold\color{atelierText}#1}}
\renewcommand*{\paragraphstyle}{\fontsize{10.5}{15}\InterTightRegular\color{atelierText}}

% Entry styles (used inside cventry / cvhonor)
\renewcommand*{\entrytitlestyle}[1]{{\fontsize{11}{14}\InterTightSemiBold\color{atelierText}#1}}
\renewcommand*{\entrypositionstyle}[1]{{\fontsize{10}{13}\InterTightRegular\color{muted}#1}}
\renewcommand*{\entrydatestyle}[1]{{\fontsize{9.5}{13}\InterTightRegular\color{muted}#1}}
\renewcommand*{\entrylocationstyle}[1]{{\fontsize{9.5}{13}\InterTightRegular\itshape\color{muted}#1}}
\renewcommand*{\descriptionstyle}[1]{{\fontsize{10}{13.5}\InterTightRegular\color{atelierText}#1}}

\renewcommand*{\honortitlestyle}[1]{{\fontsize{9.5}{13}\InterTightRegular\color{muted}#1}}
\renewcommand*{\honorpositionstyle}[1]{{\fontsize{9.5}{13}\InterTightSemiBold\color{atelierText}#1}}
\renewcommand*{\honordatestyle}[1]{{\fontsize{9.5}{13}\InterTightRegular\color{muted}#1}}
\renewcommand*{\honorlocationstyle}[1]{{\fontsize{9.5}{13}\InterTightRegular\itshape\color{muted}#1}}

%-------------------------------------------------------------------------------
% Atelier masthead — replaces \makecvheader. No social/contact line here:
% per DESIGN.md §8.2, Contact lives in the sidebar.
%
% Layout:
%   eyebrow (optional version stamp) ---> right
%   NAME with accent period          --- left
%   role line                         --- left (muted)
%-------------------------------------------------------------------------------
\newcommand*{\cvversion}[1]{\def\@cvversion{#1}}
\def\@cvversion{}

\renewcommand*{\makecvheader}[1][L]{%
  \begingroup
  % Version stamp eyebrow, top-right
  \ifx\@cvversion\@empty\else
    \noindent\hfill{\fontsize{9}{11}\InterTightSemiBold\color{muted}%
      \MakeUppercase{\@cvversion}}\\[2mm]
  \fi
  % Name, with accent period
  \noindent\headerlastnamestyle{\@firstname\acvHeaderNameDelim\@lastname}%
  {\fontsize{26}{30}\InterTightSemiBold\color{accent}.}\\[1mm]
  % Role line
  \ifx\@position\@empty\else
    \noindent\headerpositionstyle{\@position}\\[2mm]
  \fi
  % Strong rule beneath masthead (DESIGN.md §7.4)
  \noindent\color{rule}\rule{\linewidth}{0.6pt}\par
  % Capture the y-position of this rule for the sidebar fill below.
  % \zposy returns scaled points from page bottom; multi-pass compile
  % needed (first pass writes .aux, second pass reads it).
  \zsavepos{atelier-masthead-rule}%
  \endgroup
  \vspace{4mm}
}

%-------------------------------------------------------------------------------
% Atelier footer — soft hairline above, wordmark left (period in accent),
% page number right (eyebrow style).
%-------------------------------------------------------------------------------
\renewcommand*{\makecvfooter}[3]{%
  \fancyfoot{}%
  \renewcommand{\footrulewidth}{0pt}%
  \fancyfoot[L]{%
    {\color{rulesoft}\rule{\linewidth}{0.4pt}}\\[1.5mm]%
    \makebox[\linewidth][l]{%
      {\fontsize{9}{11}\InterTightSemiBold\color{atelierText}%
        Nicholas R. Chitwood\textcolor{accent}{.}}\hfill
      {\fontsize{9}{11}\InterTightSemiBold\color{muted}%
        \thepage\ / \pageref*{LastPage}}%
    }%
  }%
}
\RequirePackage{lastpage}

%-------------------------------------------------------------------------------
% Sections — two flavors:
%   \cvsection{name}     — main column. Marker square + 14pt SemiBold name +
%                          soft hairline.
%   \cvsidesection{name} — sidebar. ALL CAPS eyebrow in accent.
%-------------------------------------------------------------------------------
\renewcommand{\cvsection}[1]{%
  \par\vspace{6mm}%
  \noindent\atmarker[7pt]\hspace{6pt}\sectionstyle{#1}\par
  \vspace{1mm}%
  \noindent{\color{rulesoft}\rule{\linewidth}{0.4pt}}\par
  \vspace{1.5mm}%
}

\newcommand{\cvsidesection}[1]{%
  \par\vspace{5mm}%
  \noindent{\fontsize{9}{12}\InterTightSemiBold\color{accent}%
    \addfontfeature{LetterSpace=10}\MakeUppercase{#1}}\par
  \vspace{1mm}%
  \noindent{\color{rulesoft}\rule{\linewidth}{0.4pt}}\par
  \vspace{1.5mm}%
}

\renewcommand{\cvsubsection}[1]{%
  \par\vspace{2.5mm}%
  \noindent\subsectionstyle{#1}\par
  \vspace{0.5mm}%
}

%-------------------------------------------------------------------------------
% Entries — rewritten so that the bullet body (#5) lives OUTSIDE the header
% tabular. The original awesome-cv put #5 inside a multicolumn cell, which
% made each cventry a single unbreakable table — fine in a full-width column,
% disastrous in a 7/12 paracol main column where entries grow tall enough to
% straddle pages.
%-------------------------------------------------------------------------------
\renewenvironment{cventries}{%
  \par\vspace{1mm}%
}{%
  \par
}

% Stacked variant of cventry for narrow columns (e.g. the page-1 paracol
% hero). Date sits on its own line below the org line — keeps the bold
% title from fighting the date for horizontal space when wrapping.
\newcommand*{\cvheroentry}[5]{%
  \par\vspace{2mm}%
  {\entrytitlestyle{#1}}\par\vspace{0.4mm}
  {\entrypositionstyle{#2\ \textperiodcentered\ #3}}\par\vspace{0.2mm}
  {\entrydatestyle{#4}}\par\nopagebreak[3]
  \ifstrempty{#5}{}{#5\par}%
  \vspace{1mm}%
}

% Args: \cventry{job-title}{organization}{location}{date}{body}
%   Bold (entrytitle): the job title (#1)  — what the role was
%   Muted line below:  org · location  (#2 · #3)
%   Date right-aligned: #4
%   Body (#5) flows separately, breakable.
\renewcommand*{\cventry}[5]{%
  \par\vspace{2mm}%
  \setlength\tabcolsep{0pt}%
  \setlength{\extrarowheight}{0pt}%
  \begin{tabular*}{\linewidth}{@{\extracolsep{\fill}} L{\linewidth - 3.0cm} R{3.0cm}}
    \entrytitlestyle{#1} & \entrydatestyle{#4} \\
    \entrypositionstyle{#2\ \textperiodcentered\ #3} &
  \end{tabular*}%
  \par\nopagebreak[3]
  \ifstrempty{#5}{}{#5\par}%
  \vspace{1mm}%
}

% cvhonors — use the narrower available width. Original uses fixed 2cm + 2.5cm
% columns which busted in paracol's main column. Rewrite to grow date column
% modestly and let middle text wrap.
\renewenvironment{cvhonors}{%
  \par\vspace{1mm}%
  \setlength\tabcolsep{0pt}%
  \setlength{\extrarowheight}{0pt}%
  \begin{tabular*}{\linewidth}{@{\extracolsep{\fill}} L{2.4cm} L{\linewidth - 5.4cm} R{3.0cm}}
}{%
  \end{tabular*}\par
}
\renewcommand*{\cvhonor}[4]{%
  \honordatestyle{#4} & \honorpositionstyle{#1}\ifempty{#2}{}{,} \honortitlestyle{#2} & \honorlocationstyle{#3} \\
}

% Sidebar honor variant — stacked, no fixed columns. For Education / Honors /
% Credentials / Professional service when rendered in the 5/12 column.
\newenvironment{cvsidehonors}{%
  \par\vspace{0.5mm}%
  \begin{list}{}{%
    \setlength{\leftmargin}{0pt}%
    \setlength{\labelwidth}{0pt}%
    \setlength{\labelsep}{0pt}%
    \setlength{\itemindent}{0pt}%
    \setlength{\itemsep}{2.5mm}%
    \setlength{\parsep}{0pt}%
    \setlength{\topsep}{0pt}%
  }%
}{%
  \end{list}\par
}
% Usage: \cvsidehonor{title (e.g. Degree)}{org/event}{location}{dates}
\newcommand*{\cvsidehonor}[4]{%
  \item\relax
  % \rightskip=0.25in shrinks the effective sidebar text width by 0.25in
  % so long credential / degree titles wrap before reaching the fill edge.
  % Hyphenation suppression keeps "Policy" from breaking to "Pol-icy".
  \rightskip=0.25in
  \hyphenpenalty=10000\exhyphenpenalty=10000\emergencystretch=3em
  {\fontsize{9.5}{12}\InterTightSemiBold\color{atelierText}#1}\\[0.5mm]
  \ifempty{#2}{}{{\fontsize{8.5}{11}\InterTightRegular\color{muted}#2}\\}%
  \ifempty{#3#4}{}{%
    {\fontsize{8.5}{11}\InterTightRegular\color{muted}%
      \ifempty{#3}{}{#3}\ifempty{#3#4}{}{\ifempty{#3}{}{\ \textperiodcentered\ }}\ifempty{#4}{}{#4}}%
  }%
}

% Sidebar credential variant — just a single styled line.
\newcommand*{\cvsidecredential}[1]{%
  \item\relax
  \rightskip=0.25in
  \hyphenpenalty=10000\exhyphenpenalty=10000\emergencystretch=3em
  {\fontsize{10}{13}\InterTightRegular\color{atelierText}#1}%
}

%-------------------------------------------------------------------------------
% Bullets — marker squares replace disc bullets (DESIGN.md §7.6).
% The 4pt accent square uses tikz, baseline-aligned so text doesn't jump.
%-------------------------------------------------------------------------------
\renewenvironment{cvitems}{%
  \vspace{-1mm}%
  \begin{list}{%
    \tikz[baseline=-0.6ex]\fill[accent] (0,0) rectangle (4pt,4pt);%
  }{%
    \setlength{\leftmargin}{12pt}%
    \setlength{\labelwidth}{8pt}%
    \setlength{\labelsep}{4pt}%
    \setlength{\itemindent}{0pt}%
    \setlength{\itemsep}{1.5mm}%
    \setlength{\parsep}{0pt}%
    \setlength{\topsep}{0.5mm}%
    \setlength{\rightmargin}{0pt}%
    \linespread{1.18}\selectfont
  }%
}{%
  \end{list}%
  \vspace{0.5mm}%
}

% Publication items — hanging indent, no bullet, slightly tighter.
% Apply pubitemstyle directly (not via \descriptionstyle{...} which scopes the
% font setting too narrowly) so Inter Tight reaches every item body.
\newcommand*{\pubitemstyle}{\fontsize{10.5}{14}\InterTightRegular\color{atelierText}}
\renewenvironment{pubitems}{%
  \vspace{0.5mm}%
  \pubitemstyle
  \begin{list}{}{%
    \setlength{\leftmargin}{1.4em}%
    \setlength{\labelwidth}{0pt}%
    \setlength{\labelsep}{0pt}%
    \setlength{\itemindent}{-1.4em}%
    \setlength{\itemsep}{2mm}%
    \setlength{\parsep}{0pt}%
    \setlength{\topsep}{0pt}%
  }%
}{%
  \end{list}%
}

%-------------------------------------------------------------------------------
% Body layout — paracol 5/7 split. Wrap section content between
% \beginbody and \endbody. Sidebar fill is paracol-native (per-column
% background) so it survives page breaks without eso-pic gymnastics.
%
% Column 0: sidebar (5/12 ≈ 0.417). Background: sidebar.
% Column 1: main    (7/12 ≈ 0.583). Background: paper.
%-------------------------------------------------------------------------------
\setlength{\columnseprule}{0pt}
\setcolumnwidth{0.39\textwidth, 0.58\textwidth}
\setlength{\columnsep}{0.03\textwidth}

\newenvironment{atelierbody}{%
  \columnratio{0.42, 0.58}%
  \setlength{\columnsep}{24pt}%
  \begin{paracol}{2}%
  \setlength{\parindent}{0pt}%
}{%
  \end{paracol}%
}

% Convenience: switch from sidebar to main and vice versa.
\newcommand{\tomain}{\switchcolumn}
\newcommand{\tosidebar}{\switchcolumn*}
