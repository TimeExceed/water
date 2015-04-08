# -*- python -*-
import os
import os.path as op
import shutil as sh
import subprocess as sp
import random
from datetime import datetime

env = Environment()
mode = ARGUMENTS.get('mode', 'debug')
env['BUILD_DIR'] = env.Dir('build/%s' % mode)
env['TMP_DIR_PATTERN'] = '$BUILD_DIR/%{user}s.tmp.%{ts}s.%{salt}s/'
env['RANDOM'] = random.Random()

# helper functions

def newTmpDir(env, usr):
    ts = datetime.utcnow()
    ts = ts.strftime('%Y%m%dT%H%M%S.%f')
    salt = env['RANDOM'].randint(0, 10000)
    d = env['TMP_DIR_PATTERN'] % (usr, ts, salt)
    os.makedirs(d)
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

# prepare build dir

def makeBuildDir():
    buildDir = env['BUILD_DIR'].abspath
    if not op.exists(buildDir):
        os.makedirs(buildDir)
    assert op.isdir(buildDir)

def cleanBuildDir():
    buildDir = env['BUILD_DIR'].abspath
    for rt, dirs, files in os.walk(buildDir):
        try:
            dirs.remove('.git')
        except:
            pass
        for f in files:
            f = op.join(rt, f)
            if op.islink(f):
                os.remove(f)

def firstDirname(p):
    x = p
    y = op.dirname(p)
    while len(y) > 0:
        x = y
        y = op.dirname(x)
    return x

def cloneFile(rt, fn):
    d = op.join(env['BUILD_DIR'].path, rt)
    if not op.exists(d):
        os.makedirs(d)
    os.symlink(op.abspath(op.join(rt, fn)), op.join(d, fn))
    
def cloneWorkSpace():
    buildDir = firstDirname(env['BUILD_DIR'].path)
    paths = os.listdir('.')
    for x in [buildDir, '.git', '.gitignore', '.sconsign.dblite', 'SConstruct']:
        try:
            paths.remove(x)
        except:
            pass
    for x in paths:
        if op.isfile(x):
            cloneFile('', x)
        if op.isdir(x):
            for rt, _, files in os.walk(x):
                for f in files:
                    cloneFile(rt, f)

makeBuildDir()
cleanBuildDir()
cloneWorkSpace()

flags = {
    'CFLAGS': ['--std=c11'],
    'CXXFLAGS': ['--std=c++11'],
    'CCFLAGS': ['-Wall', '-Wfloat-equal',
                '-fsanitize=address',
                '-g', '-gdwarf-4', '-fvar-tracking-assignments'],
    'LINKFLAGS': ['-fsanitize=address']}
if mode == 'debug':
    flags['CCFLAGS'] += ['-O0', '--coverage']
    flags['LINKFLAGS'] += ['--coverage']
elif mode == 'release':
    flags['CCFLAGS'] += ['-O2', '-Werror', '-DNDEBUG']
env.MergeFlags(flags)
    
# gogogo

env.SConscript('$BUILD_DIR/SConscript', exports='env')
