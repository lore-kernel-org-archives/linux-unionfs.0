Return-Path: <cgxu519@mykernel.net>
Date: Fri, 25 Oct 2019 09:19:44 +0800
From: Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
Message-ID: <16e007f78f9.12a9e815231850.7849365151361114799@mykernel.net>
In-Reply-To: <CAOQ4uxidZ=g29hGmKxinRA4Gp6CiWbOB9RqLWPPFXwtCB4DWog@mail.gmail.com>
References: <20191024122923.24689-1-cgxu519@mykernel.net> <CAOQ4uxidZ=g29hGmKxinRA4Gp6CiWbOB9RqLWPPFXwtCB4DWog@mail.gmail.com>
Subject: Re: [PATCH v3] overlay/066: copy-up test for variant sparse files
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2019-10-25 05:02:07 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Thu, Oct 24, 2019 at 3:29 PM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > This is intensive copy-up test for sparse files,
 > > these cases will be mainly used for regression test
 > > of copy-up improvement for sparse files.
 > >
 > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > >
 > > ---
 > > v1->v2:
 > > - Call _get_block_size to get fs block size.
 > > - Add comment for test space requirement.
 > > - Print meaningful error message when copy-up fail.
 > > - Adjust random hole range to 1M~5M.
 > > - Fix typo.
 > >
 > > v2->v3:
 > > - Fix space requiremnt for test.
 > > - Add more descriptions for test files and hole patterns.
 > > - Define well named variables to replace unexplained numbers.
 > > - Fix random hole algorithm to what Amir suggested.
 > > - Adjust iosize to start from 1K.
 > > - Remove from quick test group.
 >=20
 > Why? you said it takes 7s without the kernel patch.
 > The test overlay/001 is in quick group and it copies up 2*4GB
 > sparse files.

I noticed that after changed to start from 1K iosize the test took about 23=
s.
I'm afraid maybe it will take more time on low performance VM env.

The test overlay/001 took 8s/1s with/without kernel patch, so mainly test t=
ime
wasted on creating test files on test overlay/066.

 >=20
 > Tests that are not in quick group are far less likely to be run
 > regularly by developers.

hmm...well, lets add 'quick' group again and remove it  if anyone complains=
 later.=20

Thanks,
Chengguang
