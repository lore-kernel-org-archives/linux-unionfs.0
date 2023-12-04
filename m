Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4CdJ3Sa"
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66FAC1;
	Mon,  4 Dec 2023 09:09:21 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-67a9febb2bfso27251846d6.1;
        Mon, 04 Dec 2023 09:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701709761; x=1702314561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oux7nu1Xqkl7T17ZfdYKMfdp/hDqQWsWL1VRVo5nX/c=;
        b=D4CdJ3SaHVVlJyZDnPZkRx8nop+Psvke+l+chX/KZRCwb3aPSHik8qNzHJqs++GCr+
         KRCHL+14yUB1LAItNdniBlKc0r47YM4UvL2AdRBiJepZyPSDB5cSM+pG/JTnmHdWN0x2
         OhMebbJuC9Z9ZsoCAIpVz8BoSwmjNQwuAT3iYqOajbOiSFywU2zxWzreurX9LZJ4IQ3J
         6INXu9sk8W/mtRXu9N0k6jfFvaOruJjctEXRMnIr9VGw0pT7gGypgZZsD/XgUkV6fh2j
         s3BehpAUjW9jw2wgcDbkMSy+ID+GBT/Y5RCdTpCvB/6i7z4nW6kQ/4V9fqAg6b2E1qvf
         7P3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701709761; x=1702314561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oux7nu1Xqkl7T17ZfdYKMfdp/hDqQWsWL1VRVo5nX/c=;
        b=qYKReTUrggQ5fH2fYDINj4kq0Yg8+/uu56B2JzG1B0Vxgters7rosYwXLb9Gx6R9O4
         aLrQX8Km+ORw72dyD8QCqs922bKdIe6SX5G+jE52hFP3UOV+DXkv/mutC+S9aiev6lG+
         5gbE5TjajZBQptY+N0SkjkboIBf9MzwA1VZP/9Z6WPlTVJzb4/gCNwu86bqyj1nlgjSX
         d3fKULQQTxcyySoMDR0WFbtrNijZg9oPfQ6JmZBPn1S0nIlLpj/du2Gt6KsX/ZKuDdGe
         CFgUo+dhrV6iXBxkMIEjOeAhOU/bHVD3nz/sOeaFHXoWNu0kRbNjWdMxA1jchWlrQbQH
         rKuw==
X-Gm-Message-State: AOJu0YzTKblY/MJUTGWL2NHeLfhY62+QaKficPWdhhTe1oOeTA/Cd6uF
	dvi5jNw1icx3B5AfCCNeKB/0b5Arjep6QIFnAYw=
X-Google-Smtp-Source: AGHT+IFFo1NHiX23c+GLfjKU93xVbjEy61MHJhulapFwkhSwp6Y9iG4FjpSoCzVz6RNo0rICGhYNUUu7uVph6LJ29V8=
X-Received: by 2002:a05:6214:e62:b0:679:e2cb:2a30 with SMTP id
 jz2-20020a0562140e6200b00679e2cb2a30mr35845578qvb.52.1701709760793; Mon, 04
 Dec 2023 09:09:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231122152013.2569153-1-amir73il@gmail.com> <20231204165817.6bz2vf2rogo7a6mo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231204165817.6bz2vf2rogo7a6mo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 4 Dec 2023 19:09:08 +0200
Message-ID: <CAOQ4uxj8RZzg0+vXQqDZQH6J+xWiD=JyfmKjsH8WLkUQLBAhBg@mail.gmail.com>
Subject: Re: [PATCH v2] overlay/026: Fix test expectation for newer kernels
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 6:58=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote:
>
> On Wed, Nov 22, 2023 at 05:20:13PM +0200, Amir Goldstein wrote:
> > From: Alexander Larsson <alexl@redhat.com>
> >
> > The test checks the expectaion from old kernels that set/get of
> > trusted.overlay.* xattrs is not supported on an overlayfs filesystem.
> >
> > New kernels support set/get xattr of trusted.overlay.* xattrs, so adapt
> > the test to check that either both set and get work on new kernel, or
> > neither work on old kernel.
> >
> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Zorro,
> >
> > Per your request on v1 [1], I've added a helper to check escaped overla=
y
> > xattrs support.
> >
> > The helper was taken from the patch that adds test overlay/084 [2], and
> > re-factored, but other than that, overlay/084 itself is unchanged, so
> > I am not re-posting it nor any of the other patches in the overlay test=
s
> > for v6.7-rc1.
> >
> > Let me know if this works for you.
>
>
>
>
> >
> > Thanks,
> > Amir.
> >
> > [1] https://lore.kernel.org/fstests/20231116075250.ntopaswush4sn2qf@del=
l-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> > [2] https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73il@g=
mail.com/
> >
> >  common/overlay        | 19 +++++++++++++++++++
> >  tests/overlay/026     | 42 +++++++++++++++++++++++++++++-------------
> >  tests/overlay/026.out |  2 --
> >  3 files changed, 48 insertions(+), 15 deletions(-)
> >
> > diff --git a/common/overlay b/common/overlay
> > index 7004187f..8f275228 100644
> > --- a/common/overlay
> > +++ b/common/overlay
> > @@ -201,6 +201,25 @@ _require_scratch_overlay_features()
> >       _scratch_unmount
> >  }
> >
> > +_check_scratch_overlay_xattr_escapes()
> > +{
> > +     local testfile=3D$1
> > +
> > +     touch $testfile
> > +     ! ($GETFATTR_PROG -n trusted.overlay.foo $testfile 2>&1 | grep -E=
 -q "not (permitted|supported)")
> > +}
> > +
> > +_require_scratch_overlay_xattr_escapes()
> > +{
> > +     _scratch_mkfs > /dev/null 2>&1
> > +     _scratch_mount
> > +
> > +        _check_scratch_overlay_xattr_escapes $SCRATCH_MNT/file || \
> > +                  _notrun "xattr escaping is not supported by overlay"
> > +
> > +     _scratch_unmount
> > +}
> > +
>
> Hi Amir,
>
> Sorry for this late review, got a little busy on other things recently.
> Won't this patch be conflict with another patchset which you/Alex have se=
nt:
>   https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73il@gmail=
.com/
>
> So you'll rebase that patchset on this, right?

I rebased and pushed to this branch:
https://github.com/amir73il/xfstests/commits/overlayfs-devel

If you want I can re-post the entire series, but really, the only change is
the common/overlay chunk in the first patch which should be ignored.
The version of _require_scratch_overlay_xattr_escapes() in this patch
is newer.

If you remove the overlay/common chunk from the overlay/084 patch,
it will apply cleanly.

Thanks,
Amir.
