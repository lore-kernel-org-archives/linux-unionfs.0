Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOG4o0jT"
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E927130;
	Mon,  4 Dec 2023 11:02:09 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-58d3c9badf5so3301868eaf.1;
        Mon, 04 Dec 2023 11:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701716529; x=1702321329; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKPTPcF6ICsIrbVFUAAhGYavbyjf6RZckjl5bI3V1zw=;
        b=aOG4o0jTheuOW9w4RtXFzEtpAc47UPJrW0llV6O8wGmWwoU52F486ENx5dQ2Ku806m
         IR4ZnJbCEQWHu/S42ITiKymXuzAjC89mK7gHlIzclFDZE3xuJxwBakI9Iqdq2cISqdQz
         p4q+5SnnujVe6tV1a198Fl1id694FgPmIIjfT0MOC7PBP+5xcKotgtf7ov/XvS8qOVhz
         4RLRGp0BGyZK52VSdciiMQe+WtLUAu1Ez2GOocHzQ7CJZfSDWA4Pb+yS9exIiSxTioqU
         cDH/Bp7Q93slbRubcbf7NKZULfDEeKOt0K3SCIS/ngEYJiG1L3C526wS62xBMxG51ZjN
         Ivyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701716529; x=1702321329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AKPTPcF6ICsIrbVFUAAhGYavbyjf6RZckjl5bI3V1zw=;
        b=NO+9vLvAmYxjH21BAAVERHxrczQ/iNZ2bMSVQHr4ThDrmeCE0VU76kuQRZHS9jFtoW
         PPBSLzbhaWVq/0/1JSJtDiRGZxaC3a0fmERX5NIbgollevprjT6QhpBeOOVwnJJ+lTky
         UMN54aaaA9XRsWpiWuRbodLdCUdxtbxWfEJkH8WCcxdxLKu0yAUOSqYgwxLq3565nn0x
         gyEqBjZY5G8J5TUXK9FmfK/bJ7A+UDdGQG/q9fFuVQOlj4GkYTsjABnaHOUAyWfHvoPP
         2OZBXLVMDrtxbs8CVcfWaZi6WG2sQngPwuF7FB0ZmSZVO8DAF+yX5TrKfYXC5hva81QN
         XPNA==
X-Gm-Message-State: AOJu0YzmCip7BOeCi/r6bnp8HKjhfYkNzJlt5aBEb7t4wNaWrP5gq2/D
	vb4XcnCcoWvSX8TlJ8blj8CkrnddDzHyZ9OIoP5An98fqp4=
X-Google-Smtp-Source: AGHT+IEU6ihF0p6TqOF8vs0d7mlPZeI/o9hCHovhmbMgVxW9KEOafP3WBTwDr62jriSk/JALLHkvzadc/MOXdvyKQM4=
X-Received: by 2002:a05:6358:52ca:b0:16b:4f8c:93c7 with SMTP id
 z10-20020a05635852ca00b0016b4f8c93c7mr5213212rwz.23.1701716528597; Mon, 04
 Dec 2023 11:02:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231122152013.2569153-1-amir73il@gmail.com> <20231204165817.6bz2vf2rogo7a6mo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj8RZzg0+vXQqDZQH6J+xWiD=JyfmKjsH8WLkUQLBAhBg@mail.gmail.com> <20231204175233.vo227ejohm5z55ol@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231204175233.vo227ejohm5z55ol@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 4 Dec 2023 21:01:57 +0200
Message-ID: <CAOQ4uxgyvsWXYMLpb_PcMTyjGSy1UtJUx6Wke+P-UHhrKd6zmQ@mail.gmail.com>
Subject: Re: [PATCH v2] overlay/026: Fix test expectation for newer kernels
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 7:52=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote:
>
> On Mon, Dec 04, 2023 at 07:09:08PM +0200, Amir Goldstein wrote:
> > On Mon, Dec 4, 2023 at 6:58=E2=80=AFPM Zorro Lang <zlang@redhat.com> wr=
ote:
> > >
> > > On Wed, Nov 22, 2023 at 05:20:13PM +0200, Amir Goldstein wrote:
> > > > From: Alexander Larsson <alexl@redhat.com>
> > > >
> > > > The test checks the expectaion from old kernels that set/get of
> > > > trusted.overlay.* xattrs is not supported on an overlayfs filesyste=
m.
> > > >
> > > > New kernels support set/get xattr of trusted.overlay.* xattrs, so a=
dapt
> > > > the test to check that either both set and get work on new kernel, =
or
> > > > neither work on old kernel.
> > > >
> > > > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Zorro,
> > > >
> > > > Per your request on v1 [1], I've added a helper to check escaped ov=
erlay
> > > > xattrs support.
> > > >
> > > > The helper was taken from the patch that adds test overlay/084 [2],=
 and
> > > > re-factored, but other than that, overlay/084 itself is unchanged, =
so
> > > > I am not re-posting it nor any of the other patches in the overlay =
tests
> > > > for v6.7-rc1.
> > > >
> > > > Let me know if this works for you.
> > >
> > >
> > >
> > >
> > > >
> > > > Thanks,
> > > > Amir.
> > > >
> > > > [1] https://lore.kernel.org/fstests/20231116075250.ntopaswush4sn2qf=
@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> > > > [2] https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73=
il@gmail.com/
> > > >
> > > >  common/overlay        | 19 +++++++++++++++++++
> > > >  tests/overlay/026     | 42 +++++++++++++++++++++++++++++----------=
---
> > > >  tests/overlay/026.out |  2 --
> > > >  3 files changed, 48 insertions(+), 15 deletions(-)
> > > >
> > > > diff --git a/common/overlay b/common/overlay
> > > > index 7004187f..8f275228 100644
> > > > --- a/common/overlay
> > > > +++ b/common/overlay
> > > > @@ -201,6 +201,25 @@ _require_scratch_overlay_features()
> > > >       _scratch_unmount
> > > >  }
> > > >
> > > > +_check_scratch_overlay_xattr_escapes()
> > > > +{
> > > > +     local testfile=3D$1
> > > > +
> > > > +     touch $testfile
> > > > +     ! ($GETFATTR_PROG -n trusted.overlay.foo $testfile 2>&1 | gre=
p -E -q "not (permitted|supported)")
> > > > +}
> > > > +
> > > > +_require_scratch_overlay_xattr_escapes()
> > > > +{
> > > > +     _scratch_mkfs > /dev/null 2>&1
> > > > +     _scratch_mount
> > > > +
> > > > +        _check_scratch_overlay_xattr_escapes $SCRATCH_MNT/file || =
\
> > > > +                  _notrun "xattr escaping is not supported by over=
lay"
> > > > +
> > > > +     _scratch_unmount
> > > > +}
> > > > +
> > >
> > > Hi Amir,
> > >
> > > Sorry for this late review, got a little busy on other things recentl=
y.
> > > Won't this patch be conflict with another patchset which you/Alex hav=
e sent:
> > >   https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73il@g=
mail.com/
> > >
> > > So you'll rebase that patchset on this, right?
> >
> > I rebased and pushed to this branch:
> > https://github.com/amir73il/xfstests/commits/overlayfs-devel
> >
> > If you want I can re-post the entire series, but really, the only chang=
e is
> > the common/overlay chunk in the first patch which should be ignored.
>
> Hi Amir,
>
> I just tried, there're two _require_scratch_overlay_xattr_escapes() in
> common/overlay [1].

Yes, as I said, the one from *this* patch is the correct one
the other one is obsolete.

> So please rebase and re-send that patchset, then I can
> merge them easily and clearly.

Ok. Sent v2.
You should apply it on top of this patch.

Thanks,
Amir.
