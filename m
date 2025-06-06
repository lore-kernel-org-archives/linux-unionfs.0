Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B513425A2A7;
	Fri,  6 Jun 2025 12:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749211959; cv=none; b=IRXZ98U73qcplYEuE/VVwoH21VDM/UOhBfl9FLeBZifXqTIo+nkS33d4wAoJPlBcCP6AkZ98N2nhHYhJIyuTrsr3h2FZhyjw10qjqsdHb3XXU5fsWa1luASpEaEo01PTf752HTzK93fdwWFYOzKTMlVsSQ0oPbdwJpW96SRAOAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749211959; c=relaxed/simple;
	bh=2x9I+G0fm+vMMx4ntLjqWsWP0uk/GLVxRBAuLw6i5WU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GEKXeMF7xiLj1ILEv8hpO3+y0jz44F8Gmbo4oMkoXmFxTMq8OEXkv1zvX/DC1VeErbaPY2I8huPss+8SNcRKU58uX8ZO6NFTvZV1rlxShUdFp3qjgTDs50wkH1dxhruu16LeO5Xz7/IPZONC4mALBTmtVsFhnVfNK42IK2ZL1fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6+RCRbV; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6+RCRbV"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ad8a6c202ffso371273866b.3;
        Fri, 06 Jun 2025 05:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749211954; x=1749816754; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcBHyMCABs00Qwda9ZB3FB8C0kpa/dXCBWT46VIP47I=;
        b=e6+RCRbVAbkGllO0vVLVx5SlJFSUFP5LSwI7jNTPOv0m8z/YIggv+DkuCwHZuExvcy
         muGBb7I+/cBGa5PPj3vFJOPZI08rZUnHKG2M/rvgmy9dbH3ZgxhLMqiO1ETr7uwiiLYY
         Ojssl/cMsaggv5ofaEViih7ChT2ClFGRoe+Tg6Z/QaPb5vcSB5UL06HRLfXa4TYZYzr8
         n/8mdrhDbAGOyYpFVV1/gwnJFMggr7wzfRmZ66r29Y6NDVH4zzcYpqdWCaK7DZHB2Jd/
         jPtLkfGSuYrL3eTH3EQPYCMl9CdQQj7yL9siRN3tJY/nWydU9VWAcgT+T60EqJpavhdP
         yoiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749211954; x=1749816754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcBHyMCABs00Qwda9ZB3FB8C0kpa/dXCBWT46VIP47I=;
        b=Z0sUHFD7dciiWyoasty6SNR0eDh7V8H90Z3tNM1oBeVlU8Fzs1k1soSXQN6G63p9O4
         1L+5sn3FJkQLT4Bzfg04pWRBWiKWGWD9z2m3u9dS2nvNQvcAbilIRHwC2wv1RDr4S1zp
         FiQBhcMOik5cZYjWo13T7oSGAi3eOqg5mFvW0zqqstbLP5SMX0b7pE9HGcBRF6QutUKs
         QSb9BuWlMkTaLB1xnZBqocza7D3DBhq8rx6xoJHRAUIrShYCrtvj6D06aUb2n+nlEbMT
         sr3bJdn5P8e0MIkL3w+4XRsj5ve2H/b1kjZtBau9ViF9a+xbcu2Pkfq9Nd0NStUBkZSY
         gb1g==
X-Forwarded-Encrypted: i=1; AJvYcCWMN1PT+lb/s+aiUmzhlYp5zKB5jNWtR4iTM2voiQmTjiMclsF0KkyuikTKBeJVZhxsbQS19K2/7Ta00YBD0Q==@vger.kernel.org, AJvYcCWe95aIgUFvAwT8podEI4abuj928wy5WAcgs56U4CmFn6DVMsiV3EwwVGzBY+o2lm3Cp+Y4zKlb@vger.kernel.org
X-Gm-Message-State: AOJu0YziPdGCK8UiG6YnrbX1k7ubEzNUyVmkKMCAb4Q4e6f9Fqq1nMgy
	kmwW4YkyU1LbcYqzYlTCDJABAJFE34nZD4uVyUcLnI8o4nuijksuU/FWabCUkISLToKHTVwQYH1
	NRyokSiPMUNBrSsrJnJMf5FveygW3d2A=
X-Gm-Gg: ASbGncsvKbwzjgSIh4zKxfcy0e/N5kugaiTTrW6csR3Jqe9WJGVuNpXA7MDdQBUiLtX
	PE/Wt7xH4djwrwqV/Uio2uMKwmfldkukY5/4i+GoD/9FCIVINM+mu7adPvtIPq2uWGTil8UooOF
	YDQtlHLfN+mK8m3+o8LmGEqy9blVW9ImVt
X-Google-Smtp-Source: AGHT+IEmC4rmbTpXUH1t6sBF0j+75ehxWLzDUBCKucMuj9fIl+W1RkzWB2HJ2wbI3tW8ku92E3i/8rIcRhDzxcObWfg=
X-Received: by 2002:a17:906:3ec2:b0:ade:2e4b:50cd with SMTP id
 a640c23a62f3a-ade2e4b5ba6mr72010066b.36.1749211953312; Fri, 06 Jun 2025
 05:12:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-1-amir73il@gmail.com> <20250603100745.2022891-5-amir73il@gmail.com>
 <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com>
 <20250606014531.d5t4gwx4iymqiqlo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj_rshiLUUrCVS6RO+KhCeLrrgxNH+me3K38Nhc0Byqzw@mail.gmail.com> <20250606102909.77jj6txkqii7erpn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250606102909.77jj6txkqii7erpn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Jun 2025 14:12:21 +0200
X-Gm-Features: AX0GCFs6ywdHzxZ_b8PTyAiXxoOPQ5ryPsDRs4m3tfZ5suAgpkCttoQM9LW_2fQ
Message-ID: <CAOQ4uxhwi9qF-j_XiTQCCy-OH77X2SG6_CGngUqUFfXz1X-SuA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 12:29=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Fri, Jun 06, 2025 at 09:23:26AM +0200, Amir Goldstein wrote:
> > On Fri, Jun 6, 2025 at 3:45=E2=80=AFAM Zorro Lang <zlang@redhat.com> wr=
ote:
> > >
> > > On Thu, Jun 05, 2025 at 08:38:30PM +0200, Amir Goldstein wrote:
> > > > On Thu, Jun 5, 2025 at 7:32=E2=80=AFPM Zorro Lang <zlang@redhat.com=
> wrote:
> > > > >
> > > > > On Tue, Jun 03, 2025 at 12:07:43PM +0200, Amir Goldstein wrote:
> > > > > > This test performs shutdown via xfs_io -c shutdown.
> > > > > >
> > > > > > Overlayfs tests can use _scratch_shutdown, but they cannot use
> > > > > > "-c shutdown" xfs_io command without jumping through hoops, so =
by
> > > > > > default we do not support it.
> > > > > >
> > > > > > Add this condition to _require_xfs_io_command and add the requi=
re
> > > > > > statement to test generic/623 so it wont run with overlayfs.
> > > > > >
> > > > > > Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > > > > > Tested-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > > > > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-=
1-2350b1493d94@igalia.com/
> > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > ---
> > > > > >  common/rc         | 8 ++++++++
> > > > > >  tests/generic/623 | 1 +
> > > > > >  2 files changed, 9 insertions(+)
> > > > > >
> > > > > > diff --git a/common/rc b/common/rc
> > > > > > index d8ee8328..bffd576a 100644
> > > > > > --- a/common/rc
> > > > > > +++ b/common/rc
> > > > > > @@ -3033,6 +3033,14 @@ _require_xfs_io_command()
> > > > > >               touch $testfile
> > > > > >               testio=3D`$XFS_IO_PROG -c "syncfs" $testfile 2>&1=
`
> > > > > >               ;;
> > > > > > +     "shutdown")
> > > > > > +             if [ $FSTYP =3D "overlay" ]; then
> > > > > > +                     # Overlayfs tests can use _scratch_shutdo=
wn, but they
> > > > > > +                     # cannot use "-c shutdown" xfs_io command=
 without jumping
> > > > > > +                     # through hoops, so by default we do not =
support it.
> > > > > > +                     _notrun "xfs_io $command not supported on=
 $FSTYP"
> > > > > > +             fi
> > > > > > +             ;;
> > > > >
> > > > > Hmm... I'm not sure this's a good way.
> > > > > For example, overlay/087 does xfs_io shutdown too,
> > > >
> > > > Yes it does but look at the effort needed to do that properly:
> > > >
> > > > $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown =
-f
> > > > ' -c close -c syncfs $SCRATCH_MNT | \
> > > >         grep -vF '[00'
> > > >
> > > > > generally it should calls
> > > > > _require_xfs_io_command "shutdown" although it doesn't. If someon=
e overlay
> > > > > test case hope to test as o/087 does, and it calls _require_xfs_i=
o_command "shutdown",
> > > > > then it'll be _notrun.
> > > >
> > > > If someone knows enough to perform the dance above with _scratch_sh=
utdown_handle
> > > > then that someone should know enough not to call
> > > > _require_xfs_io_command "shutdown".
> > > > OTOH, if someone doesn't know then default is to not run.
> > >
> > > Sure, I can understand that, just this logic is a bit *obscure* :) It=
 sounds like:
> > > "If an overlay test case wants to do xfs_io shutdown, it shouldn't ca=
ll
> > > _require_xfs_io_command "shutdown". Or call that to skip a shutdown t=
est
> > > on overlay :)"
> > >
> > > And the expected result of _require_xfs_io_command "shutdown" will be=
 totally
> > > opposite with _require_scratch_shutdown on overlay, that might be con=
fused.
> > > Can we have a clearer way to deal with that?
> > >
> >
> > I don't really understand the confusion.
> >
> > _require_xfs_io_command "shutdown"
> >
> > Like any other _require statement
> > requires support for what this test does -
> > meaning that a test does xfs_io -c shutdown, just like test generic/623=
 does
> >
> > and _require_scratch_shutdown implies that the test does
> > _scratch_shutdown
> >
> > FSTYP overlay happens to be able to do _scratch_shutdown
> > but not able to do xfs_io -c shutdown $SCRATCH_MNT
> >
> > The different _require statements simply reflect reality as it is.
> >
> > We can solve the confused about o/087 not having
> > _require_xfs_io_command "shutdown"
> > by moving the special hand crafted xfs_io command in o/087
> > to a helper _scratch_shutdown_and_syncfs to hide those internal
> > implementation details from test writers.
> > See attached patch.
>
> Hmm... give me a moment to order my thoughts step by step :)
>
> There're only 2 cases tend to do xfs_io shutdown on overlay currently
> (others are xfs specific test cases):
>
>   $ grep -rsn shutdown tests/|grep -- "-c"
>   tests/generic/623:29:$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c=
 shutdown -c fsync \
>   tests/overlay/087:50:$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handl=
e)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
>   tests/overlay/087:57:$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handl=
e)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
>   ...
>
> others shutdown cases nearly all use *_scratch_shutdown* with
> *_require_scratch_shutdown*, these two functions are consistent in
> code logic. And no one calls "_require_xfs_io_command shutdown" currently=
.
>
> So g/623 and o/087 are specifal, actually they call _require_scratch_shut=
down
> too, that makes sense for o/087. Now only g/623 doesn't make sense. Now w=
e
> need to help it to make sense.
>
> I think the key is in _require_scratch_shutdown function [1], how about a=
dd an
> argument to clearly tell it we need to check shutdown "only on the top la=
yer
> $SCRATCH_MNT" or "try the lowest layer $BASE_SCRATCH_MNT if there is".
>
> For example:
>
> diff --git a/common/rc b/common/rc
> index c3af8485c..5f30143e4 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4075,15 +4075,17 @@ _require_exportfs()
>         _require_open_by_handle
>  }
>
> -# Does shutdown work on this fs?
> +# Does shutdown work on this [lower|top] layer fs?
>  _require_scratch_shutdown()
>  {
> +       local layer=3D"${1:-lower}"
> +
>         [ -x $here/src/godown ] || _notrun "src/godown executable not fou=
nd"
>
>         _scratch_mkfs > /dev/null 2>&1 || _notrun "_scratch_mkfs failed o=
n $SCRATCH_DEV"
>         _scratch_mount
>
> -       if [ $FSTYP =3D "overlay" ]; then
> +       if [ $FSTYP =3D "overlay" -a "$level" =3D "lower" ]; then
>                 if [ -z $OVL_BASE_SCRATCH_DEV ]; then
>                         # In lagacy overlay usage, it may specify directo=
ry as
>                         # SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
> diff --git a/tests/generic/623 b/tests/generic/623
> index b97e2adbe..af0f55397 100755
> --- a/tests/generic/623
> +++ b/tests/generic/623
> @@ -15,7 +15,7 @@ _begin_fstest auto quick shutdown mmap
>         "xfs: restore shutdown check in mapped write fault path"
>
>  _require_scratch_nocheck
> -_require_scratch_shutdown
> +_require_scratch_shutdown top

Sorry I find this utterly confusing.

Think of all the 95% of fstests developers that do not care about overlayfs
what does this top mean to them and why should they use it for tests
that do xfs_io -c shutdown and not for tests that do _scratch_shutdown?

The test author and reviewers should be able to look at the tests and
easily derive what the test requirements should be according to simple rule=
s.
For example:

1. A test that calls _scrash_shutdown needs to _require_scratch_shutdown
2. A test that calls _scratch_shutdown_and_syncfs needs to
_require_scratch_shutdown_and_syncfs
3. A test that calls xfs_io -c shutdown needs to _require_xfs_io_shutdown

I completely understand why you do not like my hack of
_require_xfs_io_command "shutdown"

Would you approve if it was an explicit _require_xfs_io_shutdown helper?

# Requirements for tests that call xfs_io -c shutdown instead of using the
# _scratch_shutdown helper
_require_xfs_io_shutdown()
{
                if [ $FSTYP =3D "overlay" ]; then
                        # Overlayfs tests can use _scratch_shutdown, but th=
ey
                        # cannot use "xfs_io -c shutdown"  command
without jumping
                        # through hoops, so by default we do not support it=
.
                        _notrun "xfs_io -c shutdown not supported on $FSTYP=
"
                fi
                _require_xfs_io_command "shutdown"
                _require_scratch_shutdown
}

Thanks,
Amir
