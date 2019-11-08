Return-Path: <anders.dellien@axis.com>
From: Anders Dellien <anders.dellien@axis.com>
Subject: [Help] Problem when using overlayfs with LoadPin
Date: Fri, 8 Nov 2019 08:42:02 +0000
Message-ID: <1573202522019.97305@axis.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

Hi all,=0A=
=0A=
I have previously successfully used LoadPin [https://www.kernel.org/doc/htm=
l/latest/admin-guide/LSM/LoadPin.html]=0A=
together with overlayfs, however commit a6518f "vfs: don't open real" intro=
duces a regression.=0A=
=0A=
(from loadpin.c):=0A=
=0A=
        /* file_dentry sees through overlays */=0A=
        load_root =3D file_dentry(file)->d_sb;  (here, load_root->s_bdev is=
 NULL and not the actual block device from the lower layer)=0A=
=0A=
Questions:=0A=
* Maybe this is expected behavior and I am doing something wrong? Maybe the=
re is some build- or mount option that=0A=
could fix the problem?=0A=
* If this really is a bug in overlayfs then I would be happy to try to fix =
it - however as I am not familiar with the code=0A=
I would very much appreciate if someone more knowledgeable could point me i=
n the right direction.=0A=
=0A=
Thanks,=0A=
Anders=0A=
=0A=
