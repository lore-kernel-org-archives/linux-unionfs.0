Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a7ZNjDoz"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C035A109
	for <linux-unionfs@vger.kernel.org>; Mon,  4 Dec 2023 09:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701712360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OV4gcInjXxm+kZ3QdTl4k4Gel0TTIs4D8+WtLHI3/7s=;
	b=a7ZNjDozdpIY7/BBF+N8YZljXii90kULlL0LqghqCvC/mmqjVd0o8respqW55BusA99CpA
	hjkVSsKBLFhpxGroSnTNaQnwuYi98UqT7PQ4Rya3GA+PmS2pa74j1EzFWnpYm8B1/xTAQV
	ssRpXvTQNF44ML/sLh2tzPKbSOQn2vQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-n76glBerNR23YGc8VO2nwg-1; Mon, 04 Dec 2023 12:52:38 -0500
X-MC-Unique: n76glBerNR23YGc8VO2nwg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-28649b11e86so3573569a91.0
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Dec 2023 09:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701712357; x=1702317157;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OV4gcInjXxm+kZ3QdTl4k4Gel0TTIs4D8+WtLHI3/7s=;
        b=wDNWSV5HcHvi0X5HEgqKnHfN3ekYuQMhv/wxvDEdzgaNoXLR3l56rE8tcsF0gcbF+5
         gsxwQFlRrpne/rTiDRHFSdoT+blt/0SilUaxU0HnWI041VGGRVawpAx5GhDBm4a+ytVN
         Gh6KQOy6vee1iiJmUWqsG3m5rH2H6KS2d30Hd724EmfJrOYis5yktVE0ZsBEQrRm2gus
         Zzb4vBHAyxZMX0m18lGJyFmuhzoPeZakKUXSaXMKphNPZ9sBfR5gXX/XxMluQhcW2Yb2
         rktyWCWTLhlYgpCtVPYp+dKQgTQweod1RuROGhfDCznXyqPZF6GNRW5ONU3Gsir6yRyZ
         wL+A==
X-Gm-Message-State: AOJu0YyQyfWQMyPKmVnIm6Ej6jIYwA+3KwFbzmwYbDyYAKHW31JXNxuK
	FG1HqM2zD7gFt8OHon0KCGKjXoCHqgTGIgjh8K/N2pPKwtu8WB6qdUmKkPdtL+GRajzmwEn+b0o
	wlrDYIlBQQa3zgB1d9xzn5lpQMQ==
X-Received: by 2002:a17:90b:4d09:b0:286:a93f:bdb9 with SMTP id mw9-20020a17090b4d0900b00286a93fbdb9mr1328149pjb.33.1701712357444;
        Mon, 04 Dec 2023 09:52:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEc4Hha1wHQqX925XUIFoMcJWk6LqiRRFQG9kW+tidVpWN0IDPIwP84FEnlAJgAk6uip9cIsA==
X-Received: by 2002:a17:90b:4d09:b0:286:a93f:bdb9 with SMTP id mw9-20020a17090b4d0900b00286a93fbdb9mr1328142pjb.33.1701712357130;
        Mon, 04 Dec 2023 09:52:37 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h9-20020a17090aea8900b00286579ea46dsm6258585pjz.54.2023.12.04.09.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 09:52:36 -0800 (PST)
Date: Tue, 5 Dec 2023 01:52:33 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v2] overlay/026: Fix test expectation for newer kernels
Message-ID: <20231204175233.vo227ejohm5z55ol@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231122152013.2569153-1-amir73il@gmail.com>
 <20231204165817.6bz2vf2rogo7a6mo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj8RZzg0+vXQqDZQH6J+xWiD=JyfmKjsH8WLkUQLBAhBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxj8RZzg0+vXQqDZQH6J+xWiD=JyfmKjsH8WLkUQLBAhBg@mail.gmail.com>

On Mon, Dec 04, 2023 at 07:09:08PM +0200, Amir Goldstein wrote:
> On Mon, Dec 4, 2023 at 6:58 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Wed, Nov 22, 2023 at 05:20:13PM +0200, Amir Goldstein wrote:
> > > From: Alexander Larsson <alexl@redhat.com>
> > >
> > > The test checks the expectaion from old kernels that set/get of
> > > trusted.overlay.* xattrs is not supported on an overlayfs filesystem.
> > >
> > > New kernels support set/get xattr of trusted.overlay.* xattrs, so adapt
> > > the test to check that either both set and get work on new kernel, or
> > > neither work on old kernel.
> > >
> > > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Zorro,
> > >
> > > Per your request on v1 [1], I've added a helper to check escaped overlay
> > > xattrs support.
> > >
> > > The helper was taken from the patch that adds test overlay/084 [2], and
> > > re-factored, but other than that, overlay/084 itself is unchanged, so
> > > I am not re-posting it nor any of the other patches in the overlay tests
> > > for v6.7-rc1.
> > >
> > > Let me know if this works for you.
> >
> >
> >
> >
> > >
> > > Thanks,
> > > Amir.
> > >
> > > [1] https://lore.kernel.org/fstests/20231116075250.ntopaswush4sn2qf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> > > [2] https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73il@gmail.com/
> > >
> > >  common/overlay        | 19 +++++++++++++++++++
> > >  tests/overlay/026     | 42 +++++++++++++++++++++++++++++-------------
> > >  tests/overlay/026.out |  2 --
> > >  3 files changed, 48 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/common/overlay b/common/overlay
> > > index 7004187f..8f275228 100644
> > > --- a/common/overlay
> > > +++ b/common/overlay
> > > @@ -201,6 +201,25 @@ _require_scratch_overlay_features()
> > >       _scratch_unmount
> > >  }
> > >
> > > +_check_scratch_overlay_xattr_escapes()
> > > +{
> > > +     local testfile=$1
> > > +
> > > +     touch $testfile
> > > +     ! ($GETFATTR_PROG -n trusted.overlay.foo $testfile 2>&1 | grep -E -q "not (permitted|supported)")
> > > +}
> > > +
> > > +_require_scratch_overlay_xattr_escapes()
> > > +{
> > > +     _scratch_mkfs > /dev/null 2>&1
> > > +     _scratch_mount
> > > +
> > > +        _check_scratch_overlay_xattr_escapes $SCRATCH_MNT/file || \
> > > +                  _notrun "xattr escaping is not supported by overlay"
> > > +
> > > +     _scratch_unmount
> > > +}
> > > +
> >
> > Hi Amir,
> >
> > Sorry for this late review, got a little busy on other things recently.
> > Won't this patch be conflict with another patchset which you/Alex have sent:
> >   https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73il@gmail.com/
> >
> > So you'll rebase that patchset on this, right?
> 
> I rebased and pushed to this branch:
> https://github.com/amir73il/xfstests/commits/overlayfs-devel
> 
> If you want I can re-post the entire series, but really, the only change is
> the common/overlay chunk in the first patch which should be ignored.

Hi Amir,

I just tried, there're two _require_scratch_overlay_xattr_escapes() in
common/overlay [1]. So please rebase and re-send that patchset, then I can
merge them easily and clearly. This patch is good to me, let me give RVB
to this patch at first.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

[1]
_require_scratch_overlay_xattr_escapes()
{
        _scratch_mkfs > /dev/null 2>&1
        _scratch_mount

        _check_scratch_overlay_xattr_escapes $SCRATCH_MNT/file || \
                  _notrun "xattr escaping is not supported by overlay"

        _scratch_unmount
}

_require_scratch_overlay_xattr_escapes()
{
        _scratch_mkfs > /dev/null 2>&1
        _overlay_scratch_mount_dirs $OVL_BASE_SCRATCH_MNT/$OVL_LOWER $OVL_BASE_SCRATCH_MNT/$OVL_UPPER $OVL_BASE_SCRATCH_MNT/$OVL_WORK -o rw

        touch $SCRATCH_MNT/file
        (getfattr -n trusted.overlay.foo $SCRATCH_MNT/file 2>&1 | grep -q "not supported") && \
                  _notrun "xattr escaping is not supported by overlay"

        _scratch_unmount
}


> The version of _require_scratch_overlay_xattr_escapes() in this patch
> is newer.
> 
> If you remove the overlay/common chunk from the overlay/084 patch,
> it will apply cleanly.
> 
> Thanks,
> Amir.
> 

