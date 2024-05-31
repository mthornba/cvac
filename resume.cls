\ProvidesClass{resume}[2022/12/17 v3.0 Resume class]
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

%%%
% Set margins
%%%
\usepackage{geometry}
\geometry{
  top=0.6in,
  bottom=0.6in,
  left=0.75in,
  right=0.75in,
}

\newcommand{\name}[1]{\renewcommand{\name}{#1}}
\newcommand{\email}[1]{\renewcommand{\email}{#1}}
\newcommand{\phone}[1]{\renewcommand{\phone}{#1}}
\newcommand{\addressSep}{\\}

\let \@addressone \relax
\let \@addresstwo \relax
\let \@addressthree \relax

\newcommand{\address}[1]{
  \@ifundefined{@addressone}{
    \def \@addressone {#1}
  }{
    \@ifundefined{@addresstwo}{
      \def \@addresstwo {#1}
    }{
      \def \@addressthree {#1}
    }
  }
}

\newcommand{\printaddress}[1]{
  \begingroup
    \def \\ {\addressSep}
    \raggedleft{#1}
  \endgroup
  \par
  \smallskip
}

\newcommand{\printnameandaddress}{
  \begingroup
    \noindent
    \begin{tabularx}{\textwidth}{@{}Xr@{}}
      {\huge\bfseries\name} &
      \begin{tabular}[b]{r}
        \@ifundefined{@addressone}{}{\@addressone\addressSep}
        \@ifundefined{@addresstwo}{}{\@addresstwo\addressSep}
        \@ifundefined{@addressthree}{}{\@addressthree}
      \end{tabular}
      \begin{tabular}[b]{r@{}}
        \phone \\ \email
      \end{tabular}
    \end{tabularx}
    \smallskip\par
  \endgroup
}

%%%
% Print personal info at beginning of document
%%%
\AtBeginDocument{
  \printnameandaddress
  \hrule
}

%%%
% Sections, e.g. Experience, Education, etc.
%%%
\newenvironment{rSection}[1]{
  \medskip
  \MakeUppercase{\textbf{#1}}
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
  \begin{list}{$\cdot$}{\leftmargin=0em}
    \setlength{\itemsep}{-0.5em} \vspace{-0.5em}
}{
  \end{list}
  \vspace{0.5em}
}
