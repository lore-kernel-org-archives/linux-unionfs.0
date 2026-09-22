Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB814E0B76
	for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 09:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068446; cv=none; b=mZ7Pm+SFICrGR1WD+OA+9C28GCs7s0s4TxRFcL+tTLyTixKV3MkhNercqa0b6IVNINhPMbN51785z5uzeKJ4w0yajIZ99YBP5EqoyfxPAm1N8DRJdkhYTqRPg+S6UZ8CbDqnUjupYZxBlzje2YpFr1i3koOmqidCo6dTdrlUjD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068446; c=relaxed/simple;
	bh=x6HQo2Ql98Umszl1bLbKyaBGyakHflH2Y/8sgqKcP6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlnYIwlMv+/hpfxcLn0ADD3G9fCu0WboAYLHBtj6x3TRV3SeKofAO96qo3kW+CZRQYqXljVsL88ZgU4hZGuzbUkuGF3rVqtaDkDQITvSBWALBf4UCzTXiucSmS3NeKPRWw85356anVzmbDhP19MF/InyiUiMFm/7HrZ1MgT+Sqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LxEqbqpA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=l1HC45aM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LxEqbqpA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="l1HC45aM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790068443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o4baz/6RzxjMCiX3WhcQq7uKFgXpKloXgi45FkMIoFs=;
	b=LxEqbqpA48CzjEIfWwWsfdnJQ6DT+0Gjr7rFHl0yKicXf1qYOb1O62HmQqJJbrcdgsZOvI
	0APRDD3VKbsWISf1sRQfEoUpx1K0YWTA79KKjXpgsPaLSz84QhbWeoqvoeRTD2Yf/OMui5
	MP4xAfhC71olnrxRGu96mC00EWFG9Yw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-m7vpQTO0PsOuBzOQxa_1cg-1; Tue, 22 Sep 2026 05:14:00 -0400
X-MC-Unique: m7vpQTO0PsOuBzOQxa_1cg-1
X-Mimecast-MFC-AGG-ID: m7vpQTO0PsOuBzOQxa_1cg_1790068439
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e735659b7so31212285e9.3
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 02:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790068439; x=1790673239; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o4baz/6RzxjMCiX3WhcQq7uKFgXpKloXgi45FkMIoFs=;
        b=l1HC45aMBgZ3xdsjio+YOyFachXKLMHZ43yaEiUZSxWNLhureP/1vW00dqcUTs4Cfs
         cAZ7eDbExdfqfd7jumDGq05Wqgy43tgavAFljqCZwrZDPlodroYA7n0cw53ZsFu88knm
         /vUil+LjTJ2WzWoEnH/r2T1nHlFILNDmT8T84h5WGMfoWudwr6aALc4ysvJURZyvNsm+
         WkHIfqXvEnDl7/f+lAfOPN2nP/ooQQTMbcT5x2AodvDKawVN93woRz2w7FCYoDQ8UmJV
         4o/kz4S8Oxs91owRFPG390XpDgUi3Z9VrbKXP8ePWIar68iP6lU+M0SuEWokdxpZkRu6
         eexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790068439; x=1790673239;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o4baz/6RzxjMCiX3WhcQq7uKFgXpKloXgi45FkMIoFs=;
        b=PKOezHxw73/soE3rx9KFFxotdQWilKW1ABbTy8y2BUmD9UsdLar/LtjNqh5eoEBAlC
         CPllx7lwmdeq/QmidMSIOv390NpKSNoulkEKr7XWUdvFpk8EdyG5A+6ceL2ALsfb+sVh
         3cCLtMTsP2/SDrPWTcogRsRZjTCWWSOOLfADEXiOnOMg9Yv4y+WqFe+KAwXX54N4tHU7
         PqGh+CR3g8tGmWbBuE/jPE1kg9VUV+9oNiALk0U1zVmfbex4FRSjHxn2+tWS4pRAFbHI
         VYIa4cYeOe76IaR4NgyzZVD1+LdPL6W4w7+tDLO7hFoEqoMySuChUyJjA1OuWuQD/8sH
         dlNA==
X-Forwarded-Encrypted: i=1; AKwUvBwRnj8JHgB4rzN1ymUN630sZ9TWW0qZmVOyEkZkflp70+9biNrjooO4kpybgBy+hKyjwNRs0l+cst7mGF4X@vger.kernel.org
X-Gm-Message-State: AFuF++llmwx0nYVNRPePkuuRqXjDbyc4O6/sY8K9bm72n+M1Bsf+WlOf
	kq80PpRre4tsmkH3ApUdu+viFqUZPw00zycoJ9I235CpnHMcumITnMqFEkGTb9dAzlc5sYPnMVr
	WU8x486NaYG3nc2bhjbtkCX00GDp1wj+mD2v/3csNInQ9YA3q3vqann/ojD0txZ1RGQ==
X-Gm-Gg: AYBFou3n2sq/Mo/sZvkgWk8GY5te+vfnxpH/zOC6NdPFQBydEd+XvAaggS10RkRSGxN
	KRDcbL7HcMz7RCXXOf0SbrgsBrbMW8sZpxjaz2pPlUm5UHaaxN4o5mDafhMrhu8Zi6QbaSU5mIL
	t1XgI5UFAgz9+X9L6uZFC2XVi2T1MhZVFkfx8VDn38nMsjpLAUsFv3bYV82OchkcyPbiHZ/TiuR
	PayB+5a/mY+wP5S60mGjRooqBnutU1naALqTn5CfqAH7tMq8R1dk8YUdwbOPKpij05tT1YFkPAB
	dbx12r0+nJtPSs73jU7LqZCoO5mWyyGRnYMEjplbJ+llxCj5tXG0DArM6Bajsmx/acj/alB/VeT
	4djh/DjXeFk70JHO6tRZesqDmfF8vFw6AyA==
X-Received: by 2002:a05:600c:46c7:b0:49e:7a00:b9a5 with SMTP id 5b1f17b1804b1-49fc56dbb20mr184454665e9.4.1790068438826;
        Tue, 22 Sep 2026 02:13:58 -0700 (PDT)
X-Received: by 2002:a05:600c:46c7:b0:49e:7a00:b9a5 with SMTP id 5b1f17b1804b1-49fc56dbb20mr184454405e9.4.1790068438389;
        Tue, 22 Sep 2026 02:13:58 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdaa4e47csm74372105e9.1.2026.09.22.02.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:13:58 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:13:57 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org, 
	ebiggers@kernel.org, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 12/21] xfs: use read ioend for fsverity data
 verification
Message-ID: <arJFUV3WDkY6zmfD@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-13-aalbersh@kernel.org>
 <arIrtgZ3-9zNuru_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIrtgZ3-9zNuru_@infradead.org>

On 2026-09-22 00:18:14, Christoph Hellwig wrote:
> On Fri, Sep 18, 2026 at 01:15:24PM +0200, Andrey Albershteyn wrote:
> > +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
> > +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
> > +		if (ioend->io_flags & IOMAP_IOEND_INTEGRITY) {
> > +			fsv_ioend = kmem_cache_zalloc(xfs_fsverity_ioend_cache,
> > +					GFP_KERNEL);
> > +			if (!fsv_ioend) {
> 
> This needs a mempool to be deadlock safe.
> 
> > +				iomap_finish_ioends(ioend, -ENOMEM);
> > +				return;
> > +			}
> > +			fsv_ioend->ioend = ioend;
> > +			INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
> > +
> > +			fsverity_enqueue_verify_work(&fsv_ioend->work);
> > +			return;
> > +		}
> > +
> > +		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
> > +		error = blk_status_to_errno(ioend->io_bio.bi_status);
> 
> And I think you always need to do the offload because fsverity can
> synchronously read metadata.
> 

hmmm not sure what case you see here.

Without integrity:
For data reads we get here. Here, while verifing data page, fsverity
requests reads of merkle tree pages which WILL NOT go through this
path as no read completion is done for them.

With integrity:
For data reads we get here. Here, while verifing data page, fsverity
requests reads of merkle tree pages which WILL go through this
path as they need integrity verification on the read completion.
Therefore, to use this workqueue for merkle tree pages integrity
verification we offload data block verification to fsverity
workqueue.

-- 
- Andrey

