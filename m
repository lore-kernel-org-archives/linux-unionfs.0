Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969AE4A3C
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Jun 2025 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489987; cv=none; b=iD4OX/LESRc12YCEzHsO7ci/4mqicI5NF6TOgV5MrD0BVFselg/t9O8lUNy7mFpeSXBIaR7cpsNyBz3UtzNSMP8orY0YN5P/WFtDKodxjmmogTbgTA9DP7q1/zWvzq+ELoJUJfWOyCBWH+NvfBREJc4KueA5jKWVTiu76Zg/qMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489987; c=relaxed/simple;
	bh=2ypGj7sL8YMWYD+tmUrX2yUjguCJ8/xSjBoQKhdiTho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uT3CIi45zpd9pLFYqISbKZHD7sUofCYt8+Lxoh8XfzJdfDr/OoAR88u4lb9wWYsqCK8/z84M6w/w7t1GxaGf54rII0LiYhvqllsMy9jhdlCP68yU7sHSRkuxNlCshw0Zak6ma0gmATI5wa89zo38g2FFRROJZHVNuqVkAL7fzMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BgorZ36P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BgorZ36P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749489984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YQaG/EqC361nqelOl4fSnXTIiRKr5nwMwahZprMG/oc=;
	b=BgorZ36PwCu1wXzjg7P76iuugJj0eAomn2CHtlaHdpnPDOrAilitWTzpdQN6ug0sac+9fb
	Yfe4k2KieeswyT/emrbytiNV53uIVNSxL2db4qkyYRgAcL/1ebKFaACUE2btUiOSMYOvCq
	sUN/fwjJ/v5rVLLlNh7qPhDcSNTPpGc=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-kL62QCkOOFWdFZywjFuNoQ-1; Mon, 09 Jun 2025 13:26:23 -0400
X-MC-Unique: kL62QCkOOFWdFZywjFuNoQ-1
X-Mimecast-MFC-AGG-ID: kL62QCkOOFWdFZywjFuNoQ_1749489982
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b00e4358a34so2583466a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Jun 2025 10:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749489982; x=1750094782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQaG/EqC361nqelOl4fSnXTIiRKr5nwMwahZprMG/oc=;
        b=jcXyArs8udTVSYuIpIoKWXZVeIodnbDrx06WmmNdhYB/inDlFWIshYM3we2YdBFb/i
         5R/y/pSAk9ruUEPujyR6ZjsrjNJX/B3PqFN5g2xlw9VDfyZAV/U0c0e9SFkGFGNDIHO8
         hVEYag6Ijq2I7XBP+ReI6EaNvfWv4qh0FBFJ/+Rrgcn0Gd6luoPV31AL+VdC0AY7j3Tv
         ttAa5F5vvvSsXmAF6n0K4w3xbbah0cnGYrrsIfYCbGP7gHjzoUdeYV2duhh368AnlSGe
         RRBW/hQvnvAu8/VgjdhvYf2EGrDrk0YgYaUZFINCNlaOspFzEKmech1VTYjM7pGUAdZv
         qGWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXelnYLhcv173gPLe/Jz6ZzWk7fQr/m0U5xP2Xawv/F3BEyHFDkI3pRIJUUZxjaVTB/vvFufWC5OqaUaudo@vger.kernel.org
X-Gm-Message-State: AOJu0YzaqrrGK9fgwqREaH/jqWl73SdAQjjMQrVXhVTnuVWpZ9uKC4Zl
	D+YYDac+wBU4chHIWdnVL813iXzbWQPnuF805HZcPT+fGJvRA0X9WQjTNuHDONGEMp5SSEMstZf
	KvMt6y796PFIyK3hS7QTGVNw3jt8p7LNf8xpv6i+Z6QW4dlLzu/i7A6xSXX87zDMDXIQ=
X-Gm-Gg: ASbGncs+gxj1XgQhOlLEoX6iprenYYUWfv1+l3p7SxAZ+NLAwYAnDhF/Od6CqvCrSU9
	FiWE599HbmnDxvWw2i+jWC4DC5xjFFeg6JVrUViCnuML6R+mVu78sQqLrtjQfXHW1/vykpFiHT7
	bVjVRzZ96iX1HiYz/OF3eoYyqwy4Yoz65tLNGYQKrtMeo84xhqxck1U4tg+VNV8t1mdml7mLJ73
	SrOV1k3gOwVjQkwFP5+z3q3GoHf/X22jFftrBKlGgBQY56rdxhCcTchJgydqPZM8Swqvs7/E41n
	SqRaQCbEZOQEcs19GZYJ+RlKPmpnfpST9CWXFNe2IKB8cbTH2F2gPA83drHev5c=
X-Received: by 2002:a05:6a21:6011:b0:215:eac9:1ab2 with SMTP id adf61e73a8af0-21ee2629136mr20785253637.28.1749489982434;
        Mon, 09 Jun 2025 10:26:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1nSnBkZshyyYIYU3axfH/8shuCaNlM1OSMmKqRk0S5atr6tO6Z2ZzImGlZL4JwvTwe+yyyg==
X-Received: by 2002:a05:6a21:6011:b0:215:eac9:1ab2 with SMTP id adf61e73a8af0-21ee2629136mr20785231637.28.1749489982057;
        Mon, 09 Jun 2025 10:26:22 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b083f30sm5981133b3a.80.2025.06.09.10.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 10:26:21 -0700 (PDT)
Date: Tue, 10 Jun 2025 01:26:17 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
Message-ID: <20250609172617.4ucu7khc56cgud2d@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-5-amir73il@gmail.com>
 <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com>
 <20250606014531.d5t4gwx4iymqiqlo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj_rshiLUUrCVS6RO+KhCeLrrgxNH+me3K38Nhc0Byqzw@mail.gmail.com>
 <20250606102909.77jj6txkqii7erpn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhwi9qF-j_XiTQCCy-OH77X2SG6_CGngUqUFfXz1X-SuA@mail.gmail.com>
 <20250608131616.xf4dx2zwcwbapya3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgKmgUroEQfXHz9estFxVqSDbLbYZu3Y7WGWVX_kJ9sBw@mail.gmail.com>
 <CAOQ4uxg7ZCh3woWKKGbr6_Ff1xF3Hk5SznQ-hgPDGvfJ5LLy_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg7ZCh3woWKKGbr6_Ff1xF3Hk5SznQ-hgPDGvfJ5LLy_A@mail.gmail.com>

On Mon, Jun 09, 2025 at 01:12:35PM +0200, Amir Goldstein wrote:
> > > Actually I'm wondering if we should help xfstests to support BASE_FSTYP and FSTYP
> > > for more upper layer fs, likes nfs, cifs, and so on.
> >
> > I think that could be very useful, but will require cifs/nfs to implement
> > more complicated _mount/umount/remount helpers like overlay.
> >
> > > If so, overlay will not be
> > > the only one fs who uses BASE_FSTYP and BASE_SCRATCH_DEV things, then we need to
> > > differentiate if a feature (e.g. shutdown) is needed by upper layer fs or underlying
> > > fs in a case.
> > >
> >
> > First of all, terminology. Many get this wrong.
> > In overlayfs, the "upper" and "lower" refer to the different underlying layers.
> > In fstests BASE_SCRATCH_DEV is always the same for both OVL_UPPER and
> > OVL_LOWER layers.
> >
> > Referring to the BASE_SCRATCH_DEV as "underlying" or "base" fs is
> > unambiguous in all cases of overlay/nfs/cifs.
> >
> > I do not have a good terminology to offer for referring to the "fs under test"
> > be it overlay/cifs/nfs. You are welcome to offer your suggestions.
> >
> 
> Sorry, I forgot to answer the question.
> 
> So far, with overlayfs there was no need for anything other than
> _require_scratch_shutdown and _scratch_shutdown and
> _scratch_remount for generic tests that do shutdown and remount
> to test consistency after a crash.
> 
> overlay tests that are aware of the underlying layers and perform
> operations explicitly on underlying layers are not generic tests
> they are overlay/* tests, so the generic helpers are not for them.
> 
> Bottom line is that I do not think that _require_scratch_shutdown
> should refer to fs under test or base fs, until I see a generic
> test case that suggests otherwise.
> 
> What we could do is a re-factoring:
> 
> _require_shutdown()
> {
>         local dev=$1
>         local mnt=$2
> ...
> }
> 
> _require_scratch_shutdown()
> {
>         _require_shutdown $SCRATCH_DEV $SCRATCH_MNT
> }
> 
> Then overlay,cifs,nfs/* tests can call _require_shutdown on base fs
> if they want to, but first, let's see a test case that needs it.

Actually I thought about the _require_shutdown when I reviewed this
patch. Something likes:

g/623: _require_shutdown $SCRATCH_MNT ...
o/087: _require_shutdown $BASE_SCRATCH_MNT ...

But I dropped this idea for two reasons:
1) _require_shutdown needs to do real "shutdown" on a directory, a flexible
   argument to be "shutdown" is dangerous. If someone would like to check
   "shutdown" is supported on a $mnt, but if some exceptions cause the $mnt
   isn't mounted the expected fs, then the "/" might be down.
2) shutdown checking need to shutdown the $mnt and remount it. It's not
   only about $mnt and $dev, but also about mount options. _require_scratch_shutdown
   can use _scratch_mount, but how to deal with a flexible $mnt?

The 1) problem might can be fixed by checking the $mnt is a mountpoint, or return.
The 2) problem is difficult to me, except we let _require_shutdown accept the mount
options list as the 3rd argument. I think that looks ugly for a _require_ function :)

If you have good idea, it can replace this patch 4/6 :)

Thanks,
Zorro

> 
> Thanks,
> Amir.
> 

