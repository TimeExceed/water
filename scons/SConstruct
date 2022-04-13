#!/bin/env python3
# -*- python -*-

# The MIT License (MIT)

# Copyright (c) 2015 tyf00@aliyun.com (https://github.com/TimeExceed/water)

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List
import subprocess as sp
import random
from datetime import datetime
import hashlib
import re
from pathlib import Path

env = Environment()
mode = ARGUMENTS.get('mode', 'debug')
env['BUILD_DIR'] = env.Dir('build/%s' % mode)
TMP_DIR_PATTERN = '$BUILD_DIR/tmp/%s.%s.%s/'
env['RANDOM'] = random.Random()
env['HEADER_DIR'] = env.Dir('$BUILD_DIR/include')
env['BIN_DIR'] = env.Dir('$BUILD_DIR/bin')
env['LIB_DIR'] = env.Dir('$BUILD_DIR/lib')
env.SetOption('duplicate', 'soft-hard-copy')
env.Decider('MD5')

# helper functions

def pathToFile(p: Path):
    p = p.resolve()
    return File(str(p))

def pathToDir(p: Path):
    p = p.resolve()
    return Dir(str(p))

def sconsToPath(p) -> Path:
    return Path(p.abspath)

def newTmpDir(env, usr):
    ts = datetime.utcnow()
    ts = ts.strftime('%Y%m%dT%H%M%S.%f')
    salt = env['RANDOM'].randint(0, 10000)
    d = env.Dir(TMP_DIR_PATTERN % (usr, ts, salt))
    p = sconsToPath(d)
    p.mkdir(parents=True)
    return d

env.AddMethod(newTmpDir)

def subDir(env, subd):
    env.SConscript('%s/SConscript' % subd, exports='env')

env.AddMethod(subDir)

_Glob = env.Glob
def Glob(pathname, ondisk=True, source=False, strings=False):
    fs = _Glob(pathname, ondisk, source, strings)
    fs.sort(key=lambda x:x.path)
    return fs
env.Glob = Glob

def symlink(src: Path, dst: Path):
    if src.is_symlink():
        src = src.readline()
    if dst.is_dir():
        base = src.name
        dst = dst.joinpath(base)
    src.symlink_to(dst)

# prepare build dir

def makeBuildDir():
    for d in [env['BUILD_DIR'], env['HEADER_DIR']]:
        d = sconsToPath(d)
        d.mkdir(parents=True, exist_ok=True)

def cleanBuildDir():
    todos = [sconsToPath(env['BUILD_DIR'])]
    files: List[Path] = []
    dirs: List[Path] = []
    while len(todos) > 0:
        p = todos.pop()
        if p.is_file():
            files.append(p)
        if p.is_dir():
            dirs.append(p)
            for x in p.iterdir():
                todos.append(x)
    for f in files:
        if f.is_symlink() or f.name.endswith('.gcda') or f.name.endswith('.gcno'):
            f.unlink()
    while len(dirs) > 0:
        d = dirs.pop()
        if len(list(zip([None], d.iterdir()))) == 0:
            d.rmdir()

def buildRoot(rt: Path, p: Path):
    last = None
    while rt != p:
        last = p
        p = p.parent
    return last

def cloneFile(rt: Path, src: Path):
    dst = sconsToPath(env['BUILD_DIR']).joinpath(src.relative_to(rt))
    dst.parent.mkdir(parents=True, exist_ok=True)
    try:
        dst.symlink_to(src)
    except:
        print(src, '->', dst)
        raise

def cloneWorkSpace():
    rt = Path.cwd()
    buildDir = buildRoot(rt, sconsToPath(env['BUILD_DIR']))
    IGNORES = set(['.git', '.gitignore', '.sconsign.dblite', 'SConstruct'])
    todos = [x for x in rt.iterdir() if x.name not in IGNORES and x.name != buildDir.name]
    while len(todos) > 0:
        p = todos.pop()
        if p.is_file():
            cloneFile(rt, p)
        if p.is_dir():
            for x in p.iterdir():
                if x not in IGNORES:
                    todos.append(x)

makeBuildDir()
cleanBuildDir()
cloneWorkSpace()

# for latex

def calcAuxDigest(tex: Path):
    aux = tex.with_suffix('.aux')
    if aux.exists():
        digest = hashlib.md5()
        with aux.open('rb') as f:
            digest.update(f.read())
        return digest.digest()
    else:
        return None

def runLuaLatex(tex: Path):
    aux = calcAuxDigest(tex)
    while True:
        sp.check_call(['lualatex', '-shell-escape', tex], cwd=tex.parent)
        newAux = calcAuxDigest(tex)
        if aux == newAux:
            break
        aux = newAux

def _latex(target, source, env: Environment):
    assert len(target) == len(source)
    for tex in source:
        tex = sconsToPath(env.File(tex))
        runLuaLatex(tex)

env.Append(BUILDERS={'_Latex': Builder(action=_latex, suffix='.pdf')})

def texDepends(tex: Path) -> List[Path]:
    with tex.open() as fp:
        content = fp.read()
    return [tex.parent.joinpath(m.group(1)).resolve()
        for m in re.finditer('\\\\includegraphics.*?[{](.*?)[}]', content)]

def latex(env, tex):
    pdf = env._Latex(tex)
    tex = sconsToPath(env.File(tex))
    deps = texDepends(tex)
    env.Depends(pdf, [pathToFile(x) for x in deps])
    return pdf

env.AddMethod(latex)

def _beamer(target, source, env):
    assert len(source) == 1
    source = sconsToPath(source[0])
    with source.open() as fp:
        source = fp.read()

    assert len(target) == 2
    replacements = [
        '\setbeameroption{show notes}',
        '\setbeameroption{hide notes}',
    ]
    target_pdf = [sconsToPath(x) for x in target]
    target_tex = [x.with_suffix('.tex') for x in target_pdf]
    for tex, rep in zip(target_tex, replacements):
        with tex.open('w') as fp:
            fp.write(source.replace('% $BEAMER_NOTES', rep))
    for tex in target_tex:
        runLuaLatex(tex)

def beamerEmitter(target, source, env):
    assert len(target) == 1
    tgt = sconsToPath(target[0])
    target = [
        pathToFile(tgt.with_suffix('.notes.pdf')),
        pathToFile(tgt.with_suffix('.no_notes.pdf')),
    ]
    return target, source

bld = Builder(
    action = _beamer,
    suffix = '.pdf',
    emitter = beamerEmitter,
)
env.Append(BUILDERS={'_beamer': bld})

def beamer(env, tex):
    pdf = env._beamer(tex)
    tex = sconsToPath(env.File(tex))
    deps = texDepends(tex)
    env.Depends(pdf, [pathToFile(x) for x in deps])
    return pdf

env.AddMethod(beamer)

# gogogo

env.SConscript('$BUILD_DIR/SConscript', exports='env')
