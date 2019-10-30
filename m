Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191029055713.28191-1-cgxu519@mykernel.net> <CAOQ4uxgzZHXOv7K++BArYmaTEHbYr5oCkgXw8WVUsQgh0uyqhg@mail.gmail.com>
 <16e173c434a.11f8ced8d40796.3954073574203284331@mykernel.net>
 <CAOQ4uxjddbot29=cYqLMLyqT=w=pWmLOPqVzvi-5mcXQ3AB3EQ@mail.gmail.com>
 <CAOQ4uxiZgmA6Z8Lq=ac7O9f1+CMnSmyLoAA7TDu6Hyt=-pUctw@mail.gmail.com> <16e1afc4097.118c98c8b43000.1263688409904269456@mykernel.net>
In-Reply-To: <16e1afc4097.118c98c8b43000.1263688409904269456@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Oct 2019 07:33:59 +0200
Message-ID: <CAOQ4uxjqMTFc-Fmpg3oGChy01X2JzQoG_jqxk5iEz+bR4yoQjg@mail.gmail.com>
Subject: Re: [PATCH] overlay/066: adjust test file size && add more test patterns
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 30, 2019 at 6:46 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2019-10-29 20:32:43 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Tue, Oct 29, 2019 at 1:58 PM Amir Goldstein <amir73il@gmail.com> wr=
ote:
>  > >
>  > > On Tue, Oct 29, 2019 at 1:17 PM Chengguang Xu <cgxu519@mykernel.net>=
 wrote:
>  > > >
>  > > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2019-10-29 16:32:32 A=
mir Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > > >  > On Tue, Oct 29, 2019 at 7:57 AM Chengguang Xu <cgxu519@mykernel=
.net> wrote:
>  > > >  > >
>  > > >  >
>  > > >  > Can you please send the patch as plain/text.
>  > > >  > Your mailer has sent it with quoted printable encoding and git =
am
>  > > >  > fails to apply the patch:
>  > > >  > https://lore.kernel.org/fstests/20191029055713.28191-1-cgxu519@=
mykernel.net/raw
>  > > >  >
>  > > >
>  > > > Sorry for that,  I'm not clear for the reason, so I send you the p=
atch in attachment first.
>  > > >
>  > >
>  >
>  > OK, I can verify that test runs quick (5s) on my VM.
>  >
>  > But there is one more issue that I think needs to be addressed, either
>  > in this fix patch or in a follow up patch.
>  >
>  > If the test ever fails on some run with a specific random holes sequen=
ce,
>  > it is going to be quite hard for reporter to report this sequence or f=
or
>  > developers to reproduce the same random sequence.
>
> IMO, it's not so hard as you thought,  I prefer to use filefrag to check =
it.
>
> I think below tidy info is very clear and easy to understand what had hap=
pened.
>
> [root@hades ovl-lower]# filefrag -k -e copyup_sparse_test_random_small_ho=
lefile
> Filesystem type is: 58465342
> File size of copyup_sparse_test_random_small_holefile is 10485760 (10240 =
blocks of 1024 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        4..     411:    2625148..   2625555:    408:          4:
>    1:      816..    1259:    2626172..   2626615:    444:    2625960:
>    2:     1696..    1783:    2627196..   2627283:     88:    2627052:
>    3:     1872..    2207:    2627372..   2627707:    336:
>    4:     2544..    3019:    2629244..   2629719:    476:    2628044:
>    5:     3496..    3599:    2629720..   2629823:    104:
>    6:     3704..    3819:    2629928..   2630043:    116:
>    7:     3936..    3959:    2630044..   2630067:     24:
>    8:     3980..    4487:    2631292..   2631799:    508:    2630088:
>    9:     4992..    5235:    2631800..   2632043:    244:
>   10:     5472..    5715:    2632044..   2632287:    244:
>   11:     5956..    6355:    2633340..   2633739:    400:    2632528:
>   12:     6752..    6787:    2633740..   2633775:     36:
>   13:     6820..    6907:    2633808..   2633895:     88:
>   14:     6996..    7447:    2633896..   2634347:    452:
>   15:     7900..    8211:    2637436..   2637747:    312:    2634800:
>   16:     8516..    8867:    2638052..   2638403:    352:
>   17:     9216..    9703:    2638752..   2639239:    488:             las=
t
> copyup_sparse_test_random_small_holefile: 7 extents found
>

There is a difference between understanding what happened and
reproducing, but there is no reason to choose one method over
the other.

As a developer, when I get a bug report I would rather have both
an easy reproducer and all the postmortem  information available.
Therefore, please echo xfs_io commands, at least for creation of
random files to full log AND filefrag info, at least for the random
files to full log.

Thanks,
Amir.
