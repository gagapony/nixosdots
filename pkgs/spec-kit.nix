{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "spec-kit";
  version = "0.0.90";

  src = fetchFromGitHub {
    owner = "github";
    repo = "spec-kit";
    rev = "v${version}";
    hash = "sha256-ulAii6//DT9uqLxYk6qmX6dwWWjhuARbBmjH5u1YGGM=";
  };

  pyproject = true;
  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    typer
    rich
    httpx
    platformdirs
    readchar
    truststore
  ] ++ (with python3Packages.httpx.optional-dependencies; [ socks ]);

  pythonImportsCheck = [
    "specify_cli"
  ];

  meta = {
    description = "Bootstrap your projects for Spec-Driven Development (SDD)";
    homepage = "https://github.com/github/spec-kit";
    license = lib.licenses.mit;
    mainProgram = "specify";
  };
}
