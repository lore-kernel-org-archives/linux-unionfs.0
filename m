Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970F51CFBA
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Jun 2025 01:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749174352; cv=none; b=nmAu1ARDzMWd9k6zcAPYwAEVeIWcP7i986vA1MzjAX3XETliS9Muk7KVr1IDfdLyLzT8UUpYVSAO5ye7Va6ErKsvOSMtZhQiiKYrz9NWW7TRx6g41ZUV7O0hCQtI/0y8vmFwbUZRXJjR51APWt/8U5qCoiGURlJYW0gMImSRv/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749174352; c=relaxed/simple;
	bh=fRwX4NL71YKnC///tHUad0GYyW0jRy5qO3daiRA6QN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1AmU0N/rZ5wJCjE1FBYfUM6GzN25kLRkOfwhkdXRjkvYae/q0JfFbiRr4GVvR0ofaQF/XLn6kmxcbHS77FlokLzADGssyc20YgBInzjDGRy5Tt3L8QaVDVfhpao3X8xuZB4jWx8FNcdFO8zwguG9qq+s2IUvyA4fHxIESpnoTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z9uGCQbE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z9uGCQbE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749174349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VxFpMxItACBBhKv1mbalHBSHH0dg43+BeND5BLOlbp8=;
	b=Z9uGCQbEOE9tVZ3kvAZPXIvL9vH7J95s/vPCv1idhC7KtceptepTWaPgX32hj2pp5xvLJd
	5UcytLimQ3PMcQ4LdPide9kJd1p0dYGY7VOpCJ9M/wmzrFk8w+jpSkcPZjUuZ85t4gwMbu
	KlqWtTxAyblUHuXZ1QLTdDEJt3KZG24=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-S-qcHSkiMryntm9KW6HGsg-1; Thu, 05 Jun 2025 21:45:48 -0400
X-MC-Unique: S-qcHSkiMryntm9KW6HGsg-1
X-Mimecast-MFC-AGG-ID: S-qcHSkiMryntm9KW6HGsg_1749174348
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4a44e608379so37835331cf.2
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 18:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749174347; x=1749779147;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VxFpMxItACBBhKv1mbalHBSHH0dg43+BeND5BLOlbp8=;
        b=heoGf170EOlh2aSFpJOBoCC26LXaxPK/0ORSfLCM67qRrApDZm6qSVO8fE+GzaDOG1
         bdBg/zjFF1OToitS7Ok1h8MDz4f9encKFUwDSWq2vDW5Okp1MMs9QAKlvIHa5a4FSLlT
         wH/Ln/NAMddILcaPlJQCZLDszWYdLNiA1eJa7Ebta8BAHp9JS+/z1e9N4dofCWvqxoVl
         ZNzNtqrdE/wZ+NjXBkcu+7VIif1uHyz11EO3nmNYiJv4XIlNfbTZ7nafrcqhFpQuyObn
         I/dSH69wtxGelBKbgnGtZ3Di5ipdzDl5JXCTjO0Wug7qCh2nMpwS95bzXcc4NTphsTQX
         GC7g==
X-Forwarded-Encrypted: i=1; AJvYcCVzILs8sxyXLrml1l9kz25Ti3QijYJbqlx83AJpaOQ1bElQO/E6muLvg8RvIKTRxofLrNPgVxqeaAHjY7ET@vger.kernel.org
X-Gm-Message-State: AOJu0YwXo7vloRIejWBQ1jxomwAbcYWnw3Pu6+UBdDp8uVgfdWzxY3zi
	jcHYMCtDw30zSK84kPROXJ9YSo51vz1GiqCRdhhNv+jQP/yMUPJzh1sjDvjqVUsfh9ClawHixat
	YqVL2uKzf7W5HNatjBG0WGzvrccR4Tyh+MVA9JpUvxawQcIIdV+zGl/nY4VZ9Nwk38tcv/O8gQq
	E=
X-Gm-Gg: ASbGncuY4LOVvlJLdD4Z0i8I6xthYnUmdmEBB8Ywb3MJb75K6vOtCC84wC4m4aYaqF8
	uXkZdTGPVSKgDG/9td0iT/yn9YYFtRR8057XbDcadi67VhSaV/sygwyd+sCnXl/P6ST1C6y3T6s
	eLdpTLFyvDtv6/JrXoyh5o83Ok4xLqWMcAQ0xtP+WQhGKc6/46qkcSJ/UYW8JIGsghDw6/T7VUO
	CmIs87xSEMP4wicb+TtG4NXE6ekh9wYw9sghIvMgf6XDecu5H4j0gU7zatI5nZp3fAFy62env0X
	SksHGohTfBK45bt0lgiMGtS8Dhk31H40eeF8PXFWuigya6oY2QinFvSTHlf2i4w=
X-Received: by 2002:a05:622a:5c97:b0:4a5:882b:1681 with SMTP id d75a77b69052e-4a5b9a03c3fmr33970161cf.4.1749174347579;
        Thu, 05 Jun 2025 18:45:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzvVnqK85H5jYTjl3WCvx6ZmoQtL1a+k07+d4E49a38gG8UumJFmbRLLaLUqAuSiBYs7TizA==
X-Received: by 2002:a17:90b:1c0e:b0:311:ff18:b84b with SMTP id 98e67ed59e1d1-31347681484mr2066449a91.25.1749174336424;
        Thu, 05 Jun 2025 18:45:36 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31349fc374asm363694a91.29.2025.06.05.18.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 18:45:36 -0700 (PDT)
Date: Fri, 6 Jun 2025 09:45:31 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
Message-ID: <20250606014531.d5t4gwx4iymqiqlo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-5-amir73il@gmail.com>
 <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com>

On Thu, Jun 05, 2025 at 08:38:30PM +0200, Amir Goldstein wrote:
> On Thu, Jun 5, 2025 at 7:32 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Tue, Jun 03, 2025 at 12:07:43PM +0200, Amir Goldstein wrote:
> > > This test performs shutdown via xfs_io -c shutdown.
> > >
> > > Overlayfs tests can use _scratch_shutdown, but they cannot use
> > > "-c shutdown" xfs_io command without jumping through hoops, so by
> > > default we do not support it.
> > >
> > > Add this condition to _require_xfs_io_command and add the require
> > > statement to test generic/623 so it wont run with overlayfs.
> > >
> > > Reported-by: André Almeida <andrealmeid@igalia.com>
> > > Tested-by: André Almeida <andrealmeid@igalia.com>
> > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  common/rc         | 8 ++++++++
> > >  tests/generic/623 | 1 +
> > >  2 files changed, 9 insertions(+)
> > >
> > > diff --git a/common/rc b/common/rc
> > > index d8ee8328..bffd576a 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -3033,6 +3033,14 @@ _require_xfs_io_command()
> > >               touch $testfile
> > >               testio=`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
> > >               ;;
> > > +     "shutdown")
> > > +             if [ $FSTYP = "overlay" ]; then
> > > +                     # Overlayfs tests can use _scratch_shutdown, but they
> > > +                     # cannot use "-c shutdown" xfs_io command without jumping
> > > +                     # through hoops, so by default we do not support it.
> > > +                     _notrun "xfs_io $command not supported on $FSTYP"
> > > +             fi
> > > +             ;;
> >
> > Hmm... I'm not sure this's a good way.
> > For example, overlay/087 does xfs_io shutdown too,
> 
> Yes it does but look at the effort needed to do that properly:
> 
> $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f
> ' -c close -c syncfs $SCRATCH_MNT | \
>         grep -vF '[00'
> 
> > generally it should calls
> > _require_xfs_io_command "shutdown" although it doesn't. If someone overlay
> > test case hope to test as o/087 does, and it calls _require_xfs_io_command "shutdown",
> > then it'll be _notrun.
> 
> If someone knows enough to perform the dance above with _scratch_shutdown_handle
> then that someone should know enough not to call
> _require_xfs_io_command "shutdown".
> OTOH, if someone doesn't know then default is to not run.

Sure, I can understand that, just this logic is a bit *obscure* :) It sounds like:
"If an overlay test case wants to do xfs_io shutdown, it shouldn't call
_require_xfs_io_command "shutdown". Or call that to skip a shutdown test
on overlay :)"

And the expected result of _require_xfs_io_command "shutdown" will be totally
opposite with _require_scratch_shutdown on overlay, that might be confused.
Can we have a clearer way to deal with that?

> 
> >
> > If g/623 is not suitable for overlay, how about skip it for overlay clearly, by
> > `_exclude_fs overlay` ?
> >
> 
> I do not personally mind doing this _exclude_fs overlay, but it is usually
> prefered to require what the test needs.
> 
> Whatever you prefer is fine by me.

I don't perfer "_exclude_fs overlay", just before we have a clear way to deal with
overlay shutdown, this might be simple and forthright :)

Thanks,
Zorro

> 
> Thanks,
> Amir.
> 

