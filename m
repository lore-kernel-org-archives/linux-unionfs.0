Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB78E17A2EF;
	Mon,  9 Jun 2025 11:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749466913; cv=none; b=qghWIMIcSq0TligG1IylqeLmPlw9BkrFww2o1675EwHCrKoK6TCC32WwkamzfuDaiVJQkgIlTGZ0H1Glo0LZSPYUor3YdrN4xQDSc445H10vSKcisXmL8vBjsolSBgqAlwn/qNsoX1ias03xuyxgex8xw++8v6TLLJD+Yg4GLjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749466913; c=relaxed/simple;
	bh=erCnHpnStqHrlRih0vIPjB5H+oqOheDrL+9MLlWq3+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YaCLxhOQB8cGZk+araiWPjJ5d4okJi3tZdzAFPo5ZyHM5xADsfy+sMG+JAKjkDKI+oKtX2HavxxBCFEQHf+uafO1iA0tqDE9r9mJoOFnolN2dGUmBKbcQOEJkfRO0HP4brYBP21ZX8h2fxbKvIZwyWPdsqCtl3J+v9c6XJNeoLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RygJ7r6U; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RygJ7r6U"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ad89333d603so717499266b.2;
        Mon, 09 Jun 2025 04:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749466910; x=1750071710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeaWqE4JpJEuDJkTnO67jvfTXtbag+KhPZAZxYA+Ywg=;
        b=RygJ7r6UR784zs5FZl4AasVOO6DsPQ28+B9xi9+EqItCU66t22dipV1X/pTLFffhAq
         lxzs5mCBQpDHwiQlrUSG1CgIZJhwj7sVEcgXvIX32h7hvPvVKI5j3kd0IweEClvwBQxd
         Hc0dV2qQRQnah6OJ4AUwpAreobHyDU3rw4lNZ3zkEhOsWSbj1gakSHRtZ8FUrn9bIgpe
         C10cH4ULnHrhdzlGnSx/VCnz/V2gTurzzFLiVTTTsT7xEVlFsFs9co+1hGrzPZL00WAa
         B1fUuA3EqZ5wlRDDyNpBro3qIAScvucW8H4cxmrXty728bX90CZ2avc8r187Ys79oTl0
         kb2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749466910; x=1750071710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EeaWqE4JpJEuDJkTnO67jvfTXtbag+KhPZAZxYA+Ywg=;
        b=VHjhtbi6MRbmOHgdqY2pBK7Xd3UID2zC0X1IG0doORZb2VpNagDWAR4zcGvXFcxPak
         wdJULNO4qVvT3K7cpWpE2jhMcfNSfzb4y/ndeSYOJBHpm1hnaGKE6mJn7AA1rgNiioD4
         Z7UzgshyTK9BEPOZQvIktGl277130ldVVU5CGmbwIV8oGYObJyr8MbQ7fC+lGOo8hLxa
         peGzHbZOiwMlxdyYx1Zu17lf53AE7R7KTvgQuBffbuZDZw+/DmVaSld/4l84hiCi7NkB
         laAR+UztT5aJPNI54D6hswVGpLPWqfZQ0nsXw1FgBM4M4u+I0pFJkdjbi+bIddv6Nd7B
         TKAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYI2DwlNSIV3tcIoMHTFLmFODgHQPdSTWNhWLKUx+wbKACzP/3HqnJgkiMYEdZ7MPmSB9q1P8uFjv3tqgUDw==@vger.kernel.org, AJvYcCXBo8Vgt8GWMoBxNJGApEKiNL3TnIyeEtjrB2GQviYZZDNHb/3JOLKbktaZ5AXsiKl6YY87CqI6@vger.kernel.org
X-Gm-Message-State: AOJu0Yw02o0DGAHpWClUwkZiNvRJEC4dPMIW8s98nADIYLSSyYO/ZtAz
	GF84JJbXYHwmtdwjsAWso0K+BbmMHjtC8IeTU6oSYtvrOaqJDIhg1VKpqiczq2xGILhoi2t/w/t
	1JIYEKcTYfg9iMr1suC18iryb7vNF2P8=
X-Gm-Gg: ASbGncthW+2xtoNMDr/I0Ct4CW571kC3oHxli0XvN9igfQ7Wmy5BFXkt8ycE9+1Pof3
	zAvbz/1y+NbmYCbHu0sqaTOH3ZYQnrg4SsaZvChoNsrAuOKv0lAcoWuxFstG7bj9nItNm2xq5m9
	is6t45YREq4ZYpW6C8otMJy71vCrrmSHfH7xR5sL5ddDE=
X-Google-Smtp-Source: AGHT+IHDVFVY6ltuHbjDrblMsBCxcUPAXruUgxffwoGjpo7rlMagCbDLgKSnRRXemC7BYMT4Akl2fUFeKiKktjSi7Pk=
X-Received: by 2002:a17:907:1c2a:b0:aca:c507:a4e8 with SMTP id
 a640c23a62f3a-ade1a90995dmr1139238766b.21.1749466909285; Mon, 09 Jun 2025
 04:01:49 -0700 (PDT)
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
 <CAOQ4uxj_rshiLUUrCVS6RO+KhCeLrrgxNH+me3K38Nhc0Byqzw@mail.gmail.com>
 <20250606102909.77jj6txkqii7erpn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhwi9qF-j_XiTQCCy-OH77X2SG6_CGngUqUFfXz1X-SuA@mail.gmail.com> <20250608131616.xf4dx2zwcwbapya3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250608131616.xf4dx2zwcwbapya3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Jun 2025 13:01:37 +0200
X-Gm-Features: AX0GCFtAAGkc60hv39qeGiBOhCDZ_G0rhp19BUn3e792vTkDVPghQSQar9bsTCI
Message-ID: <CAOQ4uxgKmgUroEQfXHz9estFxVqSDbLbYZu3Y7WGWVX_kJ9sBw@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 3:16=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote:
>
> On Fri, Jun 06, 2025 at 02:12:21PM +0200, Amir Goldstein wrote:
> > On Fri, Jun 6, 2025 at 12:29=E2=80=AFPM Zorro Lang <zlang@redhat.com> w=
rote:
> > >
> > > On Fri, Jun 06, 2025 at 09:23:26AM +0200, Amir Goldstein wrote:
> > > > On Fri, Jun 6, 2025 at 3:45=E2=80=AFAM Zorro Lang <zlang@redhat.com=
> wrote:
> > > > >
> > > > > On Thu, Jun 05, 2025 at 08:38:30PM +0200, Amir Goldstein wrote:
> > > > > > On Thu, Jun 5, 2025 at 7:32=E2=80=AFPM Zorro Lang <zlang@redhat=
.com> wrote:
> > > > > > >
> > > > > > > On Tue, Jun 03, 2025 at 12:07:43PM +0200, Amir Goldstein wrot=
e:
> > > > > > > > This test performs shutdown via xfs_io -c shutdown.
> > > > > > > >
> > > > > > > > Overlayfs tests can use _scratch_shutdown, but they cannot =
use
> > > > > > > > "-c shutdown" xfs_io command without jumping through hoops,=
 so by
> > > > > > > > default we do not support it.
> > > > > > > >
> > > > > > > > Add this condition to _require_xfs_io_command and add the r=
equire
> > > > > > > > statement to test generic/623 so it wont run with overlayfs=
.
> > > > > > > >
> > > > > > > > Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > > > > > > > Tested-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > > > > > > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro=
-v1-1-2350b1493d94@igalia.com/
> > > > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > > > ---
> > > > > > > >  common/rc         | 8 ++++++++
> > > > > > > >  tests/generic/623 | 1 +
> > > > > > > >  2 files changed, 9 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/common/rc b/common/rc
> > > > > > > > index d8ee8328..bffd576a 100644
> > > > > > > > --- a/common/rc
> > > > > > > > +++ b/common/rc
> > > > > > > > @@ -3033,6 +3033,14 @@ _require_xfs_io_command()
> > > > > > > >               touch $testfile
> > > > > > > >               testio=3D`$XFS_IO_PROG -c "syncfs" $testfile =
2>&1`
> > > > > > > >               ;;
> > > > > > > > +     "shutdown")
> > > > > > > > +             if [ $FSTYP =3D "overlay" ]; then
> > > > > > > > +                     # Overlayfs tests can use _scratch_sh=
utdown, but they
> > > > > > > > +                     # cannot use "-c shutdown" xfs_io com=
mand without jumping
> > > > > > > > +                     # through hoops, so by default we do =
not support it.
> > > > > > > > +                     _notrun "xfs_io $command not supporte=
d on $FSTYP"
> > > > > > > > +             fi
> > > > > > > > +             ;;
> > > > > > >
> > > > > > > Hmm... I'm not sure this's a good way.
> > > > > > > For example, overlay/087 does xfs_io shutdown too,
> > > > > >
> > > > > > Yes it does but look at the effort needed to do that properly:
> > > > > >
> > > > > > $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutd=
own -f
> > > > > > ' -c close -c syncfs $SCRATCH_MNT | \
> > > > > >         grep -vF '[00'
> > > > > >
> > > > > > > generally it should calls
> > > > > > > _require_xfs_io_command "shutdown" although it doesn't. If so=
meone overlay
> > > > > > > test case hope to test as o/087 does, and it calls _require_x=
fs_io_command "shutdown",
> > > > > > > then it'll be _notrun.
> > > > > >
> > > > > > If someone knows enough to perform the dance above with _scratc=
h_shutdown_handle
> > > > > > then that someone should know enough not to call
> > > > > > _require_xfs_io_command "shutdown".
> > > > > > OTOH, if someone doesn't know then default is to not run.
> > > > >
> > > > > Sure, I can understand that, just this logic is a bit *obscure* :=
) It sounds like:
> > > > > "If an overlay test case wants to do xfs_io shutdown, it shouldn'=
t call
> > > > > _require_xfs_io_command "shutdown". Or call that to skip a shutdo=
wn test
> > > > > on overlay :)"
> > > > >
> > > > > And the expected result of _require_xfs_io_command "shutdown" wil=
l be totally
> > > > > opposite with _require_scratch_shutdown on overlay, that might be=
 confused.
> > > > > Can we have a clearer way to deal with that?
> > > > >
> > > >
> > > > I don't really understand the confusion.
> > > >
> > > > _require_xfs_io_command "shutdown"
> > > >
> > > > Like any other _require statement
> > > > requires support for what this test does -
> > > > meaning that a test does xfs_io -c shutdown, just like test generic=
/623 does
> > > >
> > > > and _require_scratch_shutdown implies that the test does
> > > > _scratch_shutdown
> > > >
> > > > FSTYP overlay happens to be able to do _scratch_shutdown
> > > > but not able to do xfs_io -c shutdown $SCRATCH_MNT
> > > >
> > > > The different _require statements simply reflect reality as it is.
> > > >
> > > > We can solve the confused about o/087 not having
> > > > _require_xfs_io_command "shutdown"
> > > > by moving the special hand crafted xfs_io command in o/087
> > > > to a helper _scratch_shutdown_and_syncfs to hide those internal
> > > > implementation details from test writers.
> > > > See attached patch.
> > >
> > > Hmm... give me a moment to order my thoughts step by step :)
> > >
> > > There're only 2 cases tend to do xfs_io shutdown on overlay currently
> > > (others are xfs specific test cases):
> > >
> > >   $ grep -rsn shutdown tests/|grep -- "-c"
> > >   tests/generic/623:29:$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k=
" -c shutdown -c fsync \
> > >   tests/overlay/087:50:$XFS_IO_PROG -x -c "open $(_scratch_shutdown_h=
andle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> > >   tests/overlay/087:57:$XFS_IO_PROG -x -c "open $(_scratch_shutdown_h=
andle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> > >   ...
> > >
> > > others shutdown cases nearly all use *_scratch_shutdown* with
> > > *_require_scratch_shutdown*, these two functions are consistent in
> > > code logic. And no one calls "_require_xfs_io_command shutdown" curre=
ntly.
> > >
> > > So g/623 and o/087 are specifal, actually they call _require_scratch_=
shutdown
> > > too, that makes sense for o/087. Now only g/623 doesn't make sense. N=
ow we
> > > need to help it to make sense.
> > >
> > > I think the key is in _require_scratch_shutdown function [1], how abo=
ut add an
> > > argument to clearly tell it we need to check shutdown "only on the to=
p layer
> > > $SCRATCH_MNT" or "try the lowest layer $BASE_SCRATCH_MNT if there is"=
.
> > >
> > > For example:
> > >
> > > diff --git a/common/rc b/common/rc
> > > index c3af8485c..5f30143e4 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -4075,15 +4075,17 @@ _require_exportfs()
> > >         _require_open_by_handle
> > >  }
> > >
> > > -# Does shutdown work on this fs?
> > > +# Does shutdown work on this [lower|top] layer fs?
> > >  _require_scratch_shutdown()
> > >  {
> > > +       local layer=3D"${1:-lower}"
> > > +
> > >         [ -x $here/src/godown ] || _notrun "src/godown executable not=
 found"
> > >
> > >         _scratch_mkfs > /dev/null 2>&1 || _notrun "_scratch_mkfs fail=
ed on $SCRATCH_DEV"
> > >         _scratch_mount
> > >
> > > -       if [ $FSTYP =3D "overlay" ]; then
> > > +       if [ $FSTYP =3D "overlay" -a "$level" =3D "lower" ]; then
> > >                 if [ -z $OVL_BASE_SCRATCH_DEV ]; then
> > >                         # In lagacy overlay usage, it may specify dir=
ectory as
> > >                         # SCRATCH_DEV, in this case OVL_BASE_SCRATCH_=
DEV
> > > diff --git a/tests/generic/623 b/tests/generic/623
> > > index b97e2adbe..af0f55397 100755
> > > --- a/tests/generic/623
> > > +++ b/tests/generic/623
> > > @@ -15,7 +15,7 @@ _begin_fstest auto quick shutdown mmap
> > >         "xfs: restore shutdown check in mapped write fault path"
> > >
> > >  _require_scratch_nocheck
> > > -_require_scratch_shutdown
> > > +_require_scratch_shutdown top
> >
> > Sorry I find this utterly confusing.
> >
> > Think of all the 95% of fstests developers that do not care about overl=
ayfs
> > what does this top mean to them and why should they use it for tests
> > that do xfs_io -c shutdown and not for tests that do _scratch_shutdown?
> >
> > The test author and reviewers should be able to look at the tests and
> > easily derive what the test requirements should be according to simple =
rules.
> > For example:
> >
> > 1. A test that calls _scrash_shutdown needs to _require_scratch_shutdow=
n
> > 2. A test that calls _scratch_shutdown_and_syncfs needs to
> > _require_scratch_shutdown_and_syncfs
> > 3. A test that calls xfs_io -c shutdown needs to _require_xfs_io_shutdo=
wn
> >
> > I completely understand why you do not like my hack of
> > _require_xfs_io_command "shutdown"
> >
> > Would you approve if it was an explicit _require_xfs_io_shutdown helper=
?
> >
> > # Requirements for tests that call xfs_io -c shutdown instead of using =
the
> > # _scratch_shutdown helper
>
> OK, but you might metion that it's better not be used if _scratch_shutdow=
n_handle
> is called for xfs_io, as we hope the lower layer fs supports shutdown at =
that time:)
>

Sure I'll add that

> Actually I'm wondering if we should help xfstests to support BASE_FSTYP a=
nd FSTYP
> for more upper layer fs, likes nfs, cifs, and so on.

I think that could be very useful, but will require cifs/nfs to implement
more complicated _mount/umount/remount helpers like overlay.

> If so, overlay will not be
> the only one fs who uses BASE_FSTYP and BASE_SCRATCH_DEV things, then we =
need to
> differentiate if a feature (e.g. shutdown) is needed by upper layer fs or=
 underlying
> fs in a case.
>

First of all, terminology. Many get this wrong.
In overlayfs, the "upper" and "lower" refer to the different underlying lay=
ers.
In fstests BASE_SCRATCH_DEV is always the same for both OVL_UPPER and
OVL_LOWER layers.

Referring to the BASE_SCRATCH_DEV as "underlying" or "base" fs is
unambiguous in all cases of overlay/nfs/cifs.

I do not have a good terminology to offer for referring to the "fs under te=
st"
be it overlay/cifs/nfs. You are welcome to offer your suggestions.

> ...
> BTW, a question which isn't belong to this patch:)  There're also some fa=
ilures
> from those xfstests overlay cases which run unionmount-testsuite (can't r=
ememember
> all, maybe o/102~109, o/144~117). The error (diff) output are similar as =
[1].
> Is there a fix for that too? Or I missed the fix?

I do not get these errors.
I suppose you are using the latest unionmount-testsuite,
although it hasn't been changed for a while anyway.

>
> Thanks,
> Zorro
>
> [1]
> --- /dev/fd/63  2025-06-07 05:16:59.489929312 -0400
> +++ overlay/103.out.bad 2025-06-07 05:16:59.445716549 -0400
> @@ -1,2 +1,17 @@
>  QA output created by 103
> +mount: /mnt/fstests/SCRATCH_DIR/union/m: wrong fs type, bad option, bad =
superblock on overlay, missing codepage or helper program, or other error.
> +       dmesg(1) may have more information after failed mount system call=
.

Reason for failure to mount is likely to be found in dmesg.
Please try to see if it is there.

> +Traceback (most recent call last):
> +  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/mast=
er/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/./run", =
line 362, in <module>
> +    func(ctx)
> +  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/mast=
er/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/tests/re=
name-file.py", line 71, in subtest_5
> +    ctx.rename(f, f2)
> +  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/mast=
er/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/context.=
py", line 1254, in rename
> +    remount_union(self, rotate_upper=3DTrue)
> +  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/mast=
er/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/remount_=
union.py", line 35, in remount_union
> +    system(cmd)
> +  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/mast=
er/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/tool_box=
.py", line 25, in system
> +    raise RuntimeError("Command failed: " + command)
> +RuntimeError: Command failed: mount -t overlay overlay /mnt/fstests/SCRA=
TCH_DIR/union/m -orw,xino=3Don -olowerdir=3D/mnt/fstests/SCRATCH_DIR/union/=
6/u:/mnt/fstests/SCRATCH_DIR/union/5/u:/mnt/fstests/SCRATCH_DIR/union/4/u:/=
mnt/fstests/SCRATCH_DIR/union/3/u:/mnt/fstests/SCRATCH_DIR/union/2/u:/mnt/f=
stests/SCRATCH_DIR/union/1/u:/mnt/fstests/SCRATCH_DIR/union/0/u:/mnt/fstest=
s/SCRATCH_DIR/union/l,upperdir=3D/mnt/fstests/SCRATCH_DIR/union/7/u,workdir=
=3D/mnt/fstests/SCRATCH_DIR/union/7/w

Nothing looks obviously wrong in the mount command above.
Was this a regression for you?
with kernel upgrade? libmount upgrade?

Thanks,
Amir.
