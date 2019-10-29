Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191029055713.28191-1-cgxu519@mykernel.net> <CAOQ4uxgzZHXOv7K++BArYmaTEHbYr5oCkgXw8WVUsQgh0uyqhg@mail.gmail.com>
 <16e173c434a.11f8ced8d40796.3954073574203284331@mykernel.net> <CAOQ4uxjddbot29=cYqLMLyqT=w=pWmLOPqVzvi-5mcXQ3AB3EQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjddbot29=cYqLMLyqT=w=pWmLOPqVzvi-5mcXQ3AB3EQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 29 Oct 2019 14:32:43 +0200
Message-ID: <CAOQ4uxiZgmA6Z8Lq=ac7O9f1+CMnSmyLoAA7TDu6Hyt=-pUctw@mail.gmail.com>
Subject: Re: [PATCH] overlay/066: adjust test file size && add more test patterns
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Oct 29, 2019 at 1:58 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Oct 29, 2019 at 1:17 PM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
> >
> >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2019-10-29 16:32:32 Amir G=
oldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
> >  > On Tue, Oct 29, 2019 at 7:57 AM Chengguang Xu <cgxu519@mykernel.net>=
 wrote:
> >  > >
> >  >
> >  > Can you please send the patch as plain/text.
> >  > Your mailer has sent it with quoted printable encoding and git am
> >  > fails to apply the patch:
> >  > https://lore.kernel.org/fstests/20191029055713.28191-1-cgxu519@myker=
nel.net/raw
> >  >
> >
> > Sorry for that,  I'm not clear for the reason, so I send you the patch =
in attachment first.
> >
>

OK, I can verify that test runs quick (5s) on my VM.

But there is one more issue that I think needs to be addressed, either
in this fix patch or in a follow up patch.

If the test ever fails on some run with a specific random holes sequence,
it is going to be quite hard for reporter to report this sequence or for
developers to reproduce the same random sequence.

One way to fix this is to output the sequence of commands that
generated the random files to full output, so it can be used as a recipe
for reproducer in case of a failure.

If you do that, please make sure that the recipe for creating
small random file is clearly separated from recipe for creating
big random file.

Thanks,
Amir.
