Return-Path: <cgxu519@mykernel.net>
Date: Mon, 28 Oct 2019 22:11:06 +0800
From: Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
Message-ID: <16e12b4c2d4.107038d9f36138.3957762737837230842@mykernel.net>
In-Reply-To: <CAOQ4uxjFvTTbKRW1BChnzfNSqg1yeyM3gjwjZ77i161D_XLFRg@mail.gmail.com>
References: <20191024122923.24689-1-cgxu519@mykernel.net> <CAOQ4uxidZ=g29hGmKxinRA4Gp6CiWbOB9RqLWPPFXwtCB4DWog@mail.gmail.com>
 <16e007f78f9.12a9e815231850.7849365151361114799@mykernel.net>
 <CAOQ4uxgZDKnMGB3pbCJpyH_RxWzbEHLQMB2Mpc10PK=7=xYLOg@mail.gmail.com> <16e1244e1c9.ccaa038637864.8395134351025208019@mykernel.net> <CAOQ4uxjFvTTbKRW1BChnzfNSqg1yeyM3gjwjZ77i161D_XLFRg@mail.gmail.com>
Subject: Re: [PATCH v3] overlay/066: copy-up test for variant sparse files
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=80, 2019-10-28 20:29:03 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Mon, Oct 28, 2019 at 2:09 PM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E6=97=A5, 2019-10-27 21:59:36 Amir =
Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > On Fri, Oct 25, 2019 at 4:19 AM Chengguang Xu <cgxu519@mykernel.net=
> wrote:
 > >  > >
 > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2019-10-25 05:02:07 =
Amir Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > >  > On Thu, Oct 24, 2019 at 3:29 PM Chengguang Xu <cgxu519@mykerne=
l.net> wrote:
 > >  > >  > >
 > >  > >  > > This is intensive copy-up test for sparse files,
 > >  > >  > > these cases will be mainly used for regression test
 > >  > >  > > of copy-up improvement for sparse files.
 > >  > >  > >
 > >  > >  > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
 > >  > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > >  > >  > >
 > >  > >  > > ---
 > >  > >  > > v1->v2:
 > >  > >  > > - Call _get_block_size to get fs block size.
 > >  > >  > > - Add comment for test space requirement.
 > >  > >  > > - Print meaningful error message when copy-up fail.
 > >  > >  > > - Adjust random hole range to 1M~5M.
 > >  > >  > > - Fix typo.
 > >  > >  > >
 > >  > >  > > v2->v3:
 > >  > >  > > - Fix space requiremnt for test.
 > >  > >  > > - Add more descriptions for test files and hole patterns.
 > >  > >  > > - Define well named variables to replace unexplained numbers=
.
 > >  > >  > > - Fix random hole algorithm to what Amir suggested.
 > >  > >  > > - Adjust iosize to start from 1K.
 > >  >
 > >  > Chengguang,
 > >  >
 > >  > Sorry, I did't notice that you did that. Why?
 > >  > As you can see below, this change has a very bad impact on test run=
 time.
 > >  > Any reason not to use _get_block_size?
 > >
 > > Use _get_block_size cannot mitigate the effect perfectly,
 > > in the worst case that we formatted fs with blocksize=3D1K,
 > > the test will  take long time and also test time is not fixed.
 > >
 > >  >
 > >  >
 > >  > >  > > - Remove from quick test group.
 > >  > >  >
 > >  > >  > Why? you said it takes 7s without the kernel patch.
 > >  > >  > The test overlay/001 is in quick group and it copies up 2*4GB
 > >  > >  > sparse files.
 > >  > >
 > >  > > I noticed that after changed to start from 1K iosize the test too=
k about 23s.
 > >  > > I'm afraid maybe it will take more time on low performance VM env=
.
 > >  > >
 > >  > > The test overlay/001 took 8s/1s with/without kernel patch, so mai=
nly test time
 > >  > > wasted on creating test files on test overlay/066.
 > >  >
 > >  > You are correct about the time spent on creating the files, but...
 > >  >
 > >  > On my low perf VM, the test runs 95s with overlay over xfs+reflink
 > >  >
 > >  > But if I set start iosize=3D4 (which what my fs block size is) the =
test
 > >  > runs only 30s.
 > >  >
 > >  > IOW, most of the test time is spent on creating the files with smal=
l iosize
 > >  > below fs block size, which doesn't test copy up of holes at all.
 > >  >
 > >  > If I further change file size to be a multiply of iosize (x10),
 > >  > test run time drops to 6s!
 > >  > I don't think we loose too much test coverage if we do that?
 > >  > If anything we gain testing different file sizes.
 > >
 > > hmm, for small iosize the file size is even smaller than
 > > copy-up CHUNK SIZE(1M),  so that all contents(data+hole)
 > > will be passed at once, I'm not very sure is it helpful for
 > > hole copy-up logic in kernel patch. What do you think?
 > >
 >=20
 > Not sure. I don't think we should target the test by what we know your
 > patch does, but by maximizing test coverage in a cost effective way.
 >=20
 > Creating a 10M file with so many small holes doesn't add much to test
 > coverage IMO. If you feel those are needed, you should use a C helper
 > to create those files more efficiently.
 >=20
 > BTW I think what is missing from test coverage is small holes
 > that are not aligned to 1M boundary.
 >=20

Agreed.

So how about change test pattern to below, it will cover  most of the
cases that we want. I haven't done test for the performance(test time)
but I think it will be fast enough.


One 4K empty file.
One 4M empty file.
One 10M file with random small holes (4K~512K)
One 100M file with random big holes (1M~5M)


 >=20
 > >
 > >  >
 > >  > The disk space requirement formula for ${iosize}K_holefiles becomes=
:
 > >  > 10*(2^0 + 2^11)K*12/2 =3D~ 10 * 1024 * 12
 > >
 > > That's the mean of 12/2 ?
 >=20
 > it's the formula to the sum of the series:
 > 2^0+2^2+...2^11 =3D (2^0 + 2^11)*12/2

oh, sorry, I misread the formula.=20

 >=20
 > >
 > >  > same as before, just needs explaining.
 > >  > (the formula assumes the worst case of min_iosize=3D1)
 > >  >
 > >  > -------------
 > >  >  #
 > >  >  # |-- hole --|-- data --| ... |-- data --|-- hole --|
 > >  >
 > >  > -iosize=3D1
 > >  > +min_iosize=3D$(($(_get_block_size "${lowerdir}") / 1024 ))
 > >  > +iosize=3D$min_iosize
 > >  >  max_iosize=3D2048
 > >  > -file_size=3D10240
 > >  > -max_pos=3D`expr $file_size - $max_iosize`
 > >  >
 > >  >  while [ $iosize -le $max_iosize ]; do
 > >  > +       file_size=3D$((10*$iosize))
 > >  > +       max_pos=3D`expr $file_size - $iosize`
 > >  > +       date >>$seqres.full
 > >
 > > That's the purpose for putting data info here?
 >=20
 > leftover from my debugging patch to figure out what takes so much time
 > You don't need it
 >=20
 > Thanks,
 > Amir.
 >
