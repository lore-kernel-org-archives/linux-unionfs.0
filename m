Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB884286D59
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Jun 2025 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749210167; cv=none; b=W99KGlQLabzyQezpUVi6SWKg/Wri5JTbBeVzlw6A3iwRwD0qqzkmoumkgV6I7mNpV5ZjRIS163iVSw9JzZResk4bkOOJIkdiYty4PE099jDUwvz0bINJj9ipMo4OHR1lKfMjz5e9k3YxEYll7w/Zdy9lIonwo28/Ad2PClchg/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749210167; c=relaxed/simple;
	bh=gzYfdGVfPkugVnZ/A6SnyK8iY10Yx3bSAO7zCzq3BK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rV2XI6LSoVHq2bOw2IUlVmxEYF+vcEmn95wEbsV2arjVVU/io9nnMdOGvPBciq/iCgvFywCKY9M0R+srHTXWtiOmHhd2ELM6VopU9HOGxPuPydb1qW4kFXi45sZxHPa7ekFmoGKkSImH+T1OZ6CW6KmhrLaycvYK0qy/Sxd5OP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QwSXRkWs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QwSXRkWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749210163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0su2jZD9IPYPYpC5ndJddWr41xxjTkGsLCKUTYL/W1M=;
	b=QwSXRkWstReSMMEIJyZZ1KH9IJfjjN5KKvBhNbInAcAD93rGhR0vuqZrkuuvofCjkHRv9b
	4c91rR5jvorm2x+oWTSEdjdOw1NVlrqrqwcFJC5G6jU4aeRGVDekRIm0EuT/8YTv5QL98m
	1OiYpCS43hG1vhOn1K9SOq4ixgp8rTo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-I6yAkJMDPJmFN-3wGlOWVA-1; Fri, 06 Jun 2025 07:42:42 -0400
X-MC-Unique: I6yAkJMDPJmFN-3wGlOWVA-1
X-Mimecast-MFC-AGG-ID: I6yAkJMDPJmFN-3wGlOWVA_1749210162
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c5750ca8b2so296834185a.0
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Jun 2025 04:42:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749210161; x=1749814961;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0su2jZD9IPYPYpC5ndJddWr41xxjTkGsLCKUTYL/W1M=;
        b=YsN2FNKhI4mQ6xHh7c4w4o+QEUv3FWMfeQ9Bmm7FgrXdI6i5Oa/acOT5Qv567y32K/
         KbKwGWR1g3LbdP6fjIGmGk06Jsd4rL2a6RfPO8L/IHf3jVfBfBzadGcluVgn9SHmG5m/
         OZ1sS31Fs/S5SWfyiTm2kAFMtav+/ZDgArxUjIP92QfIcK2itoOlZrH6OMbXUPNqgv7+
         zyDQXAuuM8/FGnpKNr1Er1eqSZez+PSjbYmh0fWeSudNgFDf3GuyzQFDCGUXJjuN8YB/
         zjlA9HwfHmu8/YQhlcPzXB+CNCeR70d0WugPpoBlRza4W7gi7CZbh/JGmiSlO1mjvMI6
         JGhA==
X-Forwarded-Encrypted: i=1; AJvYcCVwg03d49h5TzCQq30bDuO9z6qv+6dPIJ1wALu5ymqCaOFvRGgy8a+7cF8UOIqKpneIOSkraHNhSEx+4IJ5@vger.kernel.org
X-Gm-Message-State: AOJu0YzJmBt/ZjxmCwtWczuoNXAaGD66HOYqgHATekN0t0xPKW/Kvk5Z
	L9qdvL4i0jChtXFeZkItvQXANYgrgZjD67PKt0kjbZ4IaeJBw/s4Rl88ulpVoXPrn2YKO7OrfOP
	mRgM3Reiz8B1dXGx6XPITEkpnrcEzA041AjucZhCnE9MwETsKst/6aqtwEH9VDsUznDxjhekbhJ
	P8sA==
X-Gm-Gg: ASbGnctaWvMnOkx3FEISwoGL5E/RwOQnN/XuU1oXlVz8bbKNub18tHWsLqX8MnYbeSP
	EbEEWzsyu4B6bb2ltwL5GaF1Z/6ub916N5jc3y3RyyQXkI2io5a+heP2vVufUtEbXptOLeJPAo5
	BCmabL7W4ibLloqk42eRBdHvhcMTsEuMjwLMyHQmUge0Ad4YpSs1RdxLaxOsq5iWpnm++4RGeDM
	BXrj0p8VSpIAGhWz4NiYdGqVxDMyyDQToDcgm8LYBGyX/nq2rHO7N6NmLOSC7rKYcv4RE23TCsQ
	ZK5pswo7/5TkZu6/8pzCwvOnVs2+66yG0ckUc8yvBMk2V1xKnNMgfbzpwRAq9vU=
X-Received: by 2002:a05:6808:338c:b0:406:6e89:49ba with SMTP id 5614622812f47-40905279fe7mr2079219b6e.33.1749210151386;
        Fri, 06 Jun 2025 04:42:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfLbcDHPoXuPeFRYx5fp5q9Ccq3WJRTPtk55xmwaOfHk2VG5uOtB2vDzo9EX+BAO8GbFT/Og==
X-Received: by 2002:a05:6a21:9990:b0:1f5:889c:3cbd with SMTP id adf61e73a8af0-21ee2619e98mr4557090637.35.1749210139095;
        Fri, 06 Jun 2025 04:42:19 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2f5f782283sm1018482a12.54.2025.06.06.04.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 04:42:18 -0700 (PDT)
Date: Fri, 6 Jun 2025 19:42:13 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org,
	Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH v2 1/6] overlay: workaround libmount failure to remount,ro
Message-ID: <20250606114213.luz33dqezeuimxic@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-2-amir73il@gmail.com>
 <20250605175129.oqqzr5qluxv52m6b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxg2D-ED3vy=jedEKbpEJvWBLD=QYtfp=DCU3pQGGCaGog@mail.gmail.com>
 <20250606011223.gx6xearyoqae5byp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxh9b285dnw+SO2h6HqtNC5Xog0TQSqhFAQaV1brBnVxVQ@mail.gmail.com>
 <20250606103518.c3xklsm2ksjl5w4u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxi-ZTzatP-iVbWjzYVnv7_JA1F7WjTfjjBUTCmhoWCr-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxi-ZTzatP-iVbWjzYVnv7_JA1F7WjTfjjBUTCmhoWCr-g@mail.gmail.com>

On Fri, Jun 06, 2025 at 12:58:24PM +0200, Amir Goldstein wrote:
> On Fri, Jun 6, 2025 at 12:35 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Fri, Jun 06, 2025 at 09:35:36AM +0200, Amir Goldstein wrote:
> > > On Fri, Jun 6, 2025 at 3:12 AM Zorro Lang <zlang@redhat.com> wrote:
> > > >
> > > > On Thu, Jun 05, 2025 at 08:30:53PM +0200, Amir Goldstein wrote:
> > > > > On Thu, Jun 5, 2025 at 7:51 PM Zorro Lang <zlang@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Jun 03, 2025 at 12:07:40PM +0200, Amir Goldstein wrote:
> > > > > > > libmount >= v1.39 calls several unneeded fsconfig() calls to reconfigure
> > > > > > > lowerdir/upperdir when user requests only -o remount,ro.
> > > > > > >
> > > > > > > Those calls fail because overlayfs does not allow making any config
> > > > > > > changes with new mount api, besides MS_RDONLY.
> > > > > > >
> > > > > > > We workaround this problem with --options-mode ignore.
> > > > > > >
> > > > > > > Reported-by: André Almeida <andrealmeid@igalia.com>
> > > > > > > Suggested-by: Karel Zak <kzak@redhat.com>
> > > > > > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> > > > > > > Link: https://lore.kernel.org/fstests/CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com/
> > > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > > ---
> > > > > > >
> > > > > > > Changes since v1 [1]:
> > > > > > > - Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mode=ignore
> > > > > > >
> > > > > > > [1] https://lore.kernel.org/fstests/20250526143500.1520660-1-amir73il@gmail.com/
> > > > > >
> > > > > > I'm not sure if I understand clearly. Does overlay list are fixing this issue
> > > > > > on kernel side, then providing a workaround to fstests to avoid the issue be
> > > > > > triggered too?
> > > > > >
> > > > >
> > > > > Noone agreed to fix it on the kernel side.
> > > > > At least not yet.
> > > >
> > > > If so, I have two questions:)
> > > > 1) Will overlay fix it on kernel or mount util side?
> > >
> > > This is not known at this time.
> >
> > Oh, I thought it's getting fix :-D
> >
> > >
> > > > 2) Do you plan to keep this workaround until the issue be fixed in one day?
> > > >    Then revert this workaround?
> > >
> > > Maybe, but keep in mind that the workaround is simply
> > > telling the library what we want to do.
> > >
> > > We want to remount overlay ro and nothing else and that is exactly
> > > what  "--options-mode ignore" tells the library to do.
> > >
> > > I could have just as well written a test helper src/remount_rdonly.c
> > > and not have to deal with the question of which libmount version
> > > the test machine is using.
> > >
> > > Note that the tests in question are not intended to test the remount,ro
> > > functionality itself, they are intended to test the behavior of fs in
> > > some scenarios involving a rdonly mount.
> > >
> > > I do not want to lose important test coverage of these scenarios
> > > because of regressions in the kernel/libmount API.
> > >
> > > We can add a new test that ONLY tests remount,ro and let that
> > > test fail on overlayfs to keep us reminded of the real regresion that
> > > needs to be fixed, but the "workaround" or as I prefer to call it
> > > "using the right tool for the test case" has to stay for those other tests.
> >
> > OK, I just tried to figure out if "hide this error output on new mount APIs"
> > is what overlay list wants. If overlay list (or vfs) acks this patch, and
> > will track this issue. I'm good to merge this workaround for testing :)
> >
> 
> This workaround in v2 was suggested by libmount maintainer
> and approved by overlayfs maintainer:
> 
> "> So, you do not need LIBMOUNT_FORCE_MOUNT2= workaround, use
> > "--options-mode ignore" or source and target ;-)
> 
> Yeah, that's definitely a better workaround.
> 
> I wouldn't call it a fix, since "mount -oremount,ro /overlay" still
> doesn't work the way it is supposed to, and the thought of adding code
> to the kernel to work around the current libmount behavior makes me go
> bleah."

OK, just to make sure overlay/vfs folks know why these failures gone :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

With this patch, I've merged 5 patches of this patchset. Now only 4/6
still need more reviewing (I've provided my suggestion about that). If
patch 4/6 can't catch up the release of this week, don't worry, I'll
push these 5 patches at first, feel free to send patch 4/6 singly later :)

Thanks,
Zorro

> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-unionfs/CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com/
> 

