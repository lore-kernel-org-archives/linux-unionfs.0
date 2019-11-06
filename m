Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191106073945.12015-1-cgxu519@mykernel.net> <CAOQ4uxgBO6zZVJsa2uor5kwa1jp05Xrte6fifZdOsX=yF=v0-g@mail.gmail.com>
 <16e403ebe86.e4a465d3522.6312283139717764767@mykernel.net>
In-Reply-To: <16e403ebe86.e4a465d3522.6312283139717764767@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 6 Nov 2019 13:26:07 +0200
Message-ID: <CAOQ4uxjWjjMw7o32JaG_nuqw4oXw_Qo+jWjhRXkQ9pd9o1QjmQ@mail.gmail.com>
Subject: Re: [PATCH v3] overlay/066: adjust test file size && add more test patterns
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Nov 6, 2019 at 12:24 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2019-11-06 18:01:54 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Wed, Nov 6, 2019 at 9:40 AM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
>  > >
>  > > Making many small holes in 10M test file seems not very
>  > > helpful for test coverage and it takes too much time on
>  > > creating test files. In order to improve test speed we
>  > > adjust test file size to (10 * iosize) for iosize aligned
>  > > hole files and meanwhile add more test patterns for small
>  > > random holes and small empty file.
>  > >
>  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>  >
>  > Please send me a plain text version of the patch so I can test it.
>  >
>
> Hi Amir,
>
> Sorry for that again but I really don't know what was wrong for this patc=
h.
> I sent using 'git send-email' and there was nothing broken or unusual com=
pare
> to other normal patches. So I have to send this patch in attachment again=
.
>

Test runs fine, except big random file has a single chunk 32MB of data:

Big random hole test write scenarios ---

/root/xfstests/bin/xfs_io -i -fc "pwrite 1024K 30862K"
/vdf/ovl-lower/copyup_sparse_test_random_big
wrote 31602688/31602688 bytes at offset 1048576
30 MiB, 7716 ops; 0.1295 sec (232.614 MiB/sec and 59553.1201 ops/sec)

That is because of this typo:

@@ -133,7 +133,7 @@ file_size=3D102400
 min_hole=3D1024
 max_hole=3D5120
 pos=3D$min_hole
-max_hole=3D$(($file_size - 2*$max_hole))
+max_pos=3D$(($file_size - 2*$max_hole))

If you re-submit, please add my Reviewed-by tag.

Thanks,
Amir.
