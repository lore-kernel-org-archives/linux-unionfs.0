Return-Path: <charleszheng44@gmail.com>
MIME-Version: 1.0
From: charles zheng <charleszheng44@gmail.com>
Date: Mon, 16 Oct 2017 00:59:42 -0400
Message-ID: <CAAeanMxnXUrik+QSAdoVUSWe37tb=YPx6swb_=4nJOgL7OM2Fg@mail.gmail.com>
Subject: [OVERLAYFS] Can I create file in directory on lower layer located on NFS
Content-Type: multipart/alternative; boundary="089e08223920eefe88055ba2dfa5"
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Cc: Lukas Rupprecht <Lukas.Rupprecht@ibm.com>, Vasily <vtarasov@us.ibm.com>, Douglas Thain <dthain@nd.edu>, Dean Hildebrand <seattleplus@gmail.com>, mmohamed@us.ibm.com, dimitrios.skourtis@ibm.com, aswarke@us.ibm.com
List-ID: <linux-unionfs@vger.kernel.org>

--089e08223920eefe88055ba2dfa5
Content-Type: text/plain; charset="UTF-8"

Hi Miklos,

We are developing a docker related system that requires to union
directories on NFS and local filesystem.  I successfully created a
overlayfs that has lower layer located on NFS and upper layer located on
the local file system. But when I tried to create new files in the
directory located on NFS, I got error message: "Operation not supported".
Does that mean I can not create new files inside the directory located on
NFS? But base on the documentation of overlayfs, lower layer does not need
to be writable.

Steps to reproduce the problem are (/mnt/nfs is the NFS mount, /home/zc is
the local mount)

1. create directory "/mnt/nfs/lower/lower_dir"

2. create directories "/home/zc/upper/upper_dir", "/home/zc/work" and
"/home/zc/merged"

3. create overlayfs by running command

mount -t overlay overlay -o\
lowerdir=/mnt/nfs/lower,\
upperdir=/home/zc/upper,\
workdir=/home/zc/work \
/home/zc/merged

4. Try to create new file "/merged/lower_dir/test.txt" and get error
message "Operation not supported"

Thanks,
Charles

--089e08223920eefe88055ba2dfa5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-size:small">Hi =
Miklos,</div><div class=3D"gmail_default" style=3D"font-size:small"><br></d=
iv><div class=3D"gmail_default" style=3D"font-size:small">We are developing=
 a docker related system that requires to union directories on NFS and loca=
l filesystem.=C2=A0 I successfully created a overlayfs that has lower layer=
 located on NFS and upper layer located on the local file system. But when =
I tried to create new files in the directory located on NFS, I got error me=
ssage: &quot;Operation not supported&quot;. Does that mean I can not create=
 new files inside the directory located on NFS? But base on the documentati=
on of overlayfs, lower layer does not need to be writable.</div><div class=
=3D"gmail_default" style=3D"font-size:small"><br></div><div class=3D"gmail_=
default" style=3D"font-size:small">Steps to reproduce the problem are (/mnt=
/nfs is the NFS mount, /home/zc is the local mount)</div><div class=3D"gmai=
l_default" style=3D"font-size:small"><br></div><div class=3D"gmail_default"=
 style=3D"font-size:small">1. create directory &quot;/mnt/nfs/lower/lower_d=
ir&quot;</div><div class=3D"gmail_default" style=3D"font-size:small"><br></=
div><div class=3D"gmail_default" style=3D"font-size:small">2. create direct=
ories &quot;/home/zc/upper/upper_dir&quot;, &quot;/home/zc/work&quot; and &=
quot;/home/zc/merged&quot;</div><div class=3D"gmail_default" style=3D"font-=
size:small"><br></div><div class=3D"gmail_default" style=3D"font-size:small=
">3. create overlayfs by running command</div><div class=3D"gmail_default" =
style=3D"font-size:small"><br></div><div class=3D"gmail_default" style=3D"f=
ont-size:small">mount -t overlay overlay -o\</div><div class=3D"gmail_defau=
lt" style=3D"font-size:small">lowerdir=3D/mnt/nfs/lower,\</div><div class=
=3D"gmail_default" style=3D"font-size:small">upperdir=3D/home/zc/upper,\</d=
iv><div class=3D"gmail_default" style=3D"font-size:small">workdir=3D/home/z=
c/work \</div><div class=3D"gmail_default" style=3D"font-size:small">/home/=
zc/merged</div><div class=3D"gmail_default" style=3D"font-size:small"><br><=
/div><div class=3D"gmail_default" style=3D"font-size:small">4. Try to creat=
e new file &quot;/merged/lower_dir/test.txt&quot; and get error message &qu=
ot;Operation not supported&quot;=C2=A0</div><div class=3D"gmail_default" st=
yle=3D"font-size:small"><br></div><div class=3D"gmail_default" style=3D"fon=
t-size:small">Thanks,</div><div class=3D"gmail_default" style=3D"font-size:=
small">Charles</div></div>

--089e08223920eefe88055ba2dfa5--
