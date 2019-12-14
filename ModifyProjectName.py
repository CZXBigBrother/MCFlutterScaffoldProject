#coding: utf-8
import os

def replaceDirName(oldname,newname,path):
    print('正在替换文件夹名字')
    for parent, dirnames, filenames in os.walk(path, topdown=False):
        for dirname in dirnames:
            if oldname in dirname:
                pathdir = os.path.join(parent, dirname)
                mvpathdir = os.path.join(parent, dirname.replace(oldname, newname))
                print(pathdir)
                os.rename(pathdir, mvpathdir)

def replaceFileName(oldname,newname,path):
    print('正在替换文件名字')
    for dirname, subdir, filenames in os.walk(path):
        for filename in filenames:
            pathfile = os.path.join(dirname, filename)
            if oldname in filename:
                mvpathfile = os.path.join(dirname, filename.replace(oldname,newname))
                os.rename(pathfile, mvpathfile)

def replaceFileContext(oldname,newname,path):
    print('正在替换文件内容')
    for root, dirs, files in os.walk(path):
        for file in files:
            # 获取文件所属目录
            # 获取文件路径
            if ('.git' not in file and
                '.idea' not in file and
                'i10n-arb' not in file and
                '.DS_Store' not in file and
                '.dart_tool' not in file and
                'ModifyProjectName' not in file and
                '.png' not in file
                ):
                path = os.path.join(root, file)
                print(file)
                try:
                    import re
                    f = open(path, 'r')
                    alllines = f.readlines()
                    f.close()
                    f = open(path, 'w+')
                    for eachline in alllines:
                        a = re.sub(oldname, newname, eachline)
                        f.writelines(a)
                    f.close()
                except Exception as e:
                    print(e)
if __name__ == '__main__':
    pass
    path = './'
    oldname = ''
    newname = ''
    while oldname == '':
        oldname = input('请输入要替换的旧名字')
    while newname == '':
        newname = input('请输入要替换的新名字')
    if input('是否要替换文件内容Y/n') == 'Y':
        replaceFileContext(oldname,newname,path)
    if input('是否要替换文件名字Y/n') == 'Y':
        replaceFileName(oldname, newname, path)
    if input('是否要替换文件夹名字Y/n') == 'Y':
        replaceDirName(oldname, newname, path)

    #


