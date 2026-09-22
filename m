Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8E4432F2
	for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 09:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067636; cv=none; b=QRMWVGI8HQeOip1zjBMwEPw9SGCMfT4BoMQnKJFFViZiIiROTm81urze5wJg7FJKAtzJSjsVFsYSYJ2cZp1YJ/JnfpDYXmDx4EFkhGMmHU4st8JEz8lu4EAKp4rW37rbkhgNFUkUMs68zlui0uJkmZLzooUqCi9kAeNquaxJcug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067636; c=relaxed/simple;
	bh=HmmHSOBi6Fqj+ayaB0kp+lUWkEfnbaCEl7Q3FaEXEB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZJatY2yBcU4JV0NeVoFj/4/ds9hpCtwrXo+CJS9hx0cZDjBCH5at0WD28P5ZD1IV1gSigHlbQLPpJBroEOaoiYEovjzY/yuayo9zq3Ow/pDHdR1yW+6VizNNTaSO3GrCgDbPXggoKmFrFRQp+QDAf/ebhC/Ge4vQc61+MUfEvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NcDyGPzS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZypKHgRs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NcDyGPzS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZypKHgRs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790067634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
	b=NcDyGPzSk+OMiF0X1bWzUInOqvB9z2HSoc5ojXzvKOgwPb7cUmUFCsFflXt/le2KvKMXec
	obtk3rO/AuWUHEmccpQZ9d18p4xClILt4VolKeXgbx7yiBa6sVVBsVNKAZfSJcFpaDf4z7
	EH/5zDTC7c8Q5rt8N0Etz1Yon/IHhhY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-VUDYtjBVNf6O-8NmzANOEQ-1; Tue, 22 Sep 2026 05:00:30 -0400
X-MC-Unique: VUDYtjBVNf6O-8NmzANOEQ-1
X-Mimecast-MFC-AGG-ID: VUDYtjBVNf6O-8NmzANOEQ_1790067628
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c29d3ad6b74so230667366b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 02:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790067628; x=1790672428; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
        b=ZypKHgRstyorMfsTmpy3BZXrQ7fojscv8x71Dn0/9DQft3OrpncnJAG2SXwxPrkvK3
         eOTu2XaRj6JvvfcZgoXM5PLdHNtjWOXDZKMiJ+ACU6D4o335QZIrYCPjCTR3ww0yAmxA
         ycWYotpcec/i161wlDz1QIcvc0k2N8MZ63T6JJqYMLbJdRjAi/5RKO4MtynSE8R4s+MW
         n5bRYbwM1zoyzLjx4vqsHWlA3js6MC7O+BdKgfVjUK7cykFOXBp+rmGQB6UXgFha3++I
         yaAbADzzCT8wVTKvlsaCJAkBsqI4O5uOHHxOHV4/gn45dn8m2WFANUGIdkqbA4ypxyeJ
         PBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790067628; x=1790672428;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
        b=fmLLScwLlFh+kPo9+bEUtv+8f9cavplYCFQDdolSrqT3y7tEtA02wvbxa42AetkgP8
         D/17yUaDVDdQinvnAIqb2YI14UIhOumiU5YKPrXu+c/bcCTRIAWfSM2HnS/swki+pv8g
         RtCGntJ1iOuzDe3FoPFzKY5fnNHnFbGe4Sa9B7RVCHKuRCyEFd7t2DffQrVxxYvO9xIP
         pqzrzIMqQ6o4IX5REXVIzJbHlEg+JVfD/IwT6IYapKWY4bzAWVDOz/3Wcl2tfSUaYcEp
         Xwzi/0DuEozp7YT0TF59vX8rgtPeH193Innt62CMOUejMNI5ZlxXlKgCMWnj7RrMCul2
         33XA==
X-Forwarded-Encrypted: i=1; AKwUvBxVx2Wa9ERhBZLjuYeQDTMcQuDSHDIZKk+QBGjq9c/yFgswn9LI68s0edXhgQKINZs0nbRn1ALaZ9dOCAlX@vger.kernel.org
X-Gm-Message-State: AFuF++l5Cm0AlGW9b4HtMv0pN1h3nFf31Jar0RiV8IkOOjzKFc9807A+
	a2mg6LJbb1Eje5P4iI+q/kpE7A0zCiWJ/Lh/s1uxlDhWCIx6WpKrggxHBha7Pd23w7qCaxPz9WI
	rdlOu40j9yjMW4hiYiCKvNSuvNlXKiaTCt5fugxqOWdxfjc3MuHnXU46nmtlBQmiO9Q==
X-Gm-Gg: AYBFou004dzzOA3S+2MqC+1BenYSkexy5a4ovn4AxXHYpVh6bWYleRxsuK5aZoEFsKf
	1auGg8mJnCnZbpvfWu1zPLqBnYs8ND/8eIFbhUVjfDInTLmZDJtD7ulwklYFRQzjcCbb6xC3sbb
	Wjj74NcstgmCZhQlqI+tdmcAJyfJpeYLuoH91lcutXC/mc+Yp82/+/+ftmZTt8ll1eZ2uctQ9vQ
	bPXcPWJ7eN14fb7cd8uPkjSXl/PNdHeYbPCBP1BKIk1Htpi7Ph+1/ayr+I23D5B07L+RN9CxqKY
	Pjn9LAtgaJ/qfFS8Bkdk81qTkrmmdZOHYguFEDRno5LrQArq2RFs5wtO0iuim/hODyac9iLheFb
	JOIn+oqAW2avtcMm4usl+K4QmhkGvxVM2FA==
X-Received: by 2002:a17:906:9fc1:b0:c29:4a1f:76be with SMTP id a640c23a62f3a-c2a15703413mr1217330166b.20.1790067627781;
        Tue, 22 Sep 2026 02:00:27 -0700 (PDT)
X-Received: by 2002:a17:906:9fc1:b0:c29:4a1f:76be with SMTP id a640c23a62f3a-c2a15703413mr1217326266b.20.1790067627294;
        Tue, 22 Sep 2026 02:00:27 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a9c4309c7sm51460566b.6.2026.09.22.02.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:00:26 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:00:26 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org, 
	hch@lst.de, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <arJC542mXklAeswE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260922045144.GP2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922045144.GP2705364@frogsfrogsfrogs>

On 2026-09-21 21:51:44, Darrick J. Wong wrote:
> On Fri, Sep 18, 2026 at 01:15:12PM +0200, Andrey Albershteyn wrote:
> > Hi all,
> > 
> > This is next revision of fsverity for XFS.
> > 
> > The main change from v15 is addion of kmem cache
> > xfs_fsverity_ioend_cache instead of adding work_struct to iomap's ioend
> > struct.
> 
> FWIW, Sashiko found at least one or two bugs, but the reports only got
> echoed to the ext4 list.  Perhaps it's time to discuss allowing it to
> email linux-xfs for bugs that it claims to have found in xfs code?

I'm checking its report for fsverity series, but for other patches
not that often. So, maybe it would be useful for "critical" and
"high" priority issues (not sure if it's possible to configure it
that way).

*this time sashiko sent me a bunch of "no regression found" emails
which I think are not necessary

-- 
- Andrey

