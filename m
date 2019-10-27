Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191024122923.24689-1-cgxu519@mykernel.net> <CAOQ4uxidZ=g29hGmKxinRA4Gp6CiWbOB9RqLWPPFXwtCB4DWog@mail.gmail.com>
 <16e007f78f9.12a9e815231850.7849365151361114799@mykernel.net>
In-Reply-To: <16e007f78f9.12a9e815231850.7849365151361114799@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 27 Oct 2019 15:59:36 +0200
Message-ID: <CAOQ4uxgZDKnMGB3pbCJpyH_RxWzbEHLQMB2Mpc10PK=7=xYLOg@mail.gmail.com>
Subject: Re: [PATCH v3] overlay/066: copy-up test for variant sparse files
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Oct 25, 2019 at 4:19 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2019-10-25 05:02:07 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Thu, Oct 24, 2019 at 3:29 PM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
>  > >
>  > > This is intensive copy-up test for sparse files,
>  > > these cases will be mainly used for regression test
>  > > of copy-up improvement for sparse files.
>  > >
>  > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > >
>  > > ---
>  > > v1->v2:
>  > > - Call _get_block_size to get fs block size.
>  > > - Add comment for test space requirement.
>  > > - Print meaningful error message when copy-up fail.
>  > > - Adjust random hole range to 1M~5M.
>  > > - Fix typo.
>  > >
>  > > v2->v3:
>  > > - Fix space requiremnt for test.
>  > > - Add more descriptions for test files and hole patterns.
>  > > - Define well named variables to replace unexplained numbers.
>  > > - Fix random hole algorithm to what Amir suggested.
>  > > - Adjust iosize to start from 1K.

Chengguang,

Sorry, I did't notice that you did that. Why?
As you can see below, this change has a very bad impact on test run time.
Any reason not to use _get_block_size?


>  > > - Remove from quick test group.
>  >
>  > Why? you said it takes 7s without the kernel patch.
>  > The test overlay/001 is in quick group and it copies up 2*4GB
>  > sparse files.
>
> I noticed that after changed to start from 1K iosize the test took about =
23s.
> I'm afraid maybe it will take more time on low performance VM env.
>
> The test overlay/001 took 8s/1s with/without kernel patch, so mainly test=
 time
> wasted on creating test files on test overlay/066.

You are correct about the time spent on creating the files, but...

On my low perf VM, the test runs 95s with overlay over xfs+reflink

But if I set start iosize=3D4 (which what my fs block size is) the test
runs only 30s.

IOW, most of the test time is spent on creating the files with small iosize
below fs block size, which doesn't test copy up of holes at all.

If I further change file size to be a multiply of iosize (x10),
test run time drops to 6s!
I don't think we loose too much test coverage if we do that?
If anything we gain testing different file sizes.

The disk space requirement formula for ${iosize}K_holefiles becomes:
10*(2^0 + 2^11)K*12/2 =3D~ 10 * 1024 * 12
same as before, just needs explaining.
(the formula assumes the worst case of min_iosize=3D1)

-------------
 #
 # |-- hole --|-- data --| ... |-- data --|-- hole --|

-iosize=3D1
+min_iosize=3D$(($(_get_block_size "${lowerdir}") / 1024 ))
+iosize=3D$min_iosize
 max_iosize=3D2048
-file_size=3D10240
-max_pos=3D`expr $file_size - $max_iosize`

 while [ $iosize -le $max_iosize ]; do
+       file_size=3D$((10*$iosize))
+       max_pos=3D`expr $file_size - $iosize`
+       date >>$seqres.full
+       echo "Creating ${testfile}_iosize${iosize}K_holefile..." >>$seqres.=
full
        pos=3D$iosize
        $XFS_IO_PROG -fc "truncate ${file_size}K" \
                "${lowerdir}/${testfile}_iosize${iosize}K_holefile"
>>$seqres.full
-----------


>
>  >
>  > Tests that are not in quick group are far less likely to be run
>  > regularly by developers.
>
> hmm...well, lets add 'quick' group again and remove it  if anyone complai=
ns later.
>

I am now complaining ;-), but after fixes above, test is really quick

Please send a fix patch (to already merged test) to fir test runtime
and possibly use _get_block_size.

Thanks,
Amir.
