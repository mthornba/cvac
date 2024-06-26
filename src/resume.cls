\ProvidesClass{resume}[2024/06/02 v1.0 My custom resume class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
\pagestyle{empty}

%%%
% Load Packages
%%%
\usepackage[parfill]{parskip}
\usepackage{array}
\usepackage{ifthen}
\usepackage{tabularx}
\usepackage{xcolor}
\usepackage{hyperref}
\usepackage{fontawesome5}
\usepackage{fancyhdr}
\usepackage{lastpage} % To get the total number of pages

%%%
% Set margins
%%%
\usepackage{geometry}
\geometry{
  top=0.5in,
  bottom=0.5in,
  left=0.6in,
  right=0.6in,
}

%%%
% Define data inputs and styles
%%%
\newcommand{\name}[1]{\renewcommand{\name}{#1}}
\newcommand{\email}[1]{\renewcommand{\email}{#1 {\faIcon{envelope-square}}}}
\newcommand{\linkedin}[1]{\renewcommand{\linkedin}{\formaturl{#1} {\faIcon{linkedin}}}}
\newcommand{\github}[1]{\renewcommand{\github}{\formaturl{#1} {\faIcon{github-square}}}}
\newcommand{\phone}[1]{\renewcommand{\phone}{#1 {\faIcon{phone-square}}}}
\newcommand{\location}[1]{\renewcommand{\location}{#1 {\faIcon{map-marker-alt}}}}
\newcommand{\separator}{\\}

\newcommand{\lightgrey}{\color{black!30}}
\newcommand{\grey}{\color{black!70}}

% Redefine \UrlFont to maintain the documnet font
% \renewcommand{\UrlFont}{\normalfont}

% Custom command to format URL
\newcommand{\formaturl}[1]{%
  \begingroup
  \def\UrlLeft{}%
  \def\UrlRight{}%
  \urlstyle{same}
  \href{https://#1}{#1}%
  \endgroup
}

% Set up the fancyhdr package
\pagestyle{fancy}
\fancyhf{} % Clear all header and footer fields
\fancyfootinit{%
  \lightgrey
}
\renewcommand{\footrulewidth}{0.4pt}
\renewcommand{\headrulewidth}{0pt}

% Customize the footer
\ifdefined\githash
\else
  \def\githash{}
\fi
\fancyfoot[L]{%
\ifthenelse{\equal{\githash}{dirty}}
{\newcommand{\footerlink}{\formaturl{github.com/mthornba/cvac}}}
{\newcommand{\footerlink}{\formaturl{github.com/mthornba/cvac/commit/\githash}}}
  Built from YAML using \footerlink}

\fancyfoot[R]{\thepage\ / \pageref{LastPage}}

\newcommand{\printpersonal}{
  \begingroup
  \noindent
  \begin{tabularx}{\textwidth}{@{}Xr@{}}
    {\Huge\name} &
    \lightgrey{
      \begin{tabular}[b]{r}
        \github\separator
        \linkedin
      \end{tabular}
      \begin{tabular}[b]{r}
        \location\ \ \phone\separator
        \email
      \end{tabular}
    }
  \end{tabularx}
  \smallskip\par
  \endgroup
}

%%%
% Print personal info at beginning of document
%%%
\AtBeginDocument{
  \printpersonal
  \hrule
}

%%%
% Sections, e.g. Experience, Education, etc.
%%%
\newenvironment{rSection}[1]{
  \ifx\relax#1\relax
    \let\titletext\relax
  \else
    \def\titletext{\MakeUppercase{\textbf{#1}}}
    \medskip
  \fi
  \noindent
  \titletext
  \smallskip
  \begin{list}{}{
      \setlength{\leftmargin}{1.5em}
    }
    \item[]
      }{
  \end{list}
}

%%%
% Sub-sections, e.g. each job, each education
%%%
\newenvironment{rSubsection}[4]{
  \textbf{#1} \hfill {#2}
  \ifthenelse{\equal{#3}{}}{}{
    \\
    \textit{#3} \hfill \textit{#4}
  }
  \smallskip
  \grey
  \begin{list}{\raisebox{0.4ex}{\tiny$\bullet$}}{\leftmargin=1.3em}
    \setlength{\itemsep}{-0.5em} \vspace{-0.5em}
    }{
  \end{list}
  \vspace{0.5em}
}
