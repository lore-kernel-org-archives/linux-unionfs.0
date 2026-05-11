Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6602B36E46E
	for <linux-unionfs@vger.kernel.org>; Mon, 11 May 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778498146; cv=none; b=YYqaRmui3zalEHHFLjVfmEsOGojn4iO1I4yKwSSbMhrpfDK4aG9FsxmTr89pjtrlSeyaSlDkIU8JibsThaVHkoKFrT6xLGn/Vvh9nM9G9rTF4xafnKiaAQInPMq/Wl4xSjJIGHB7l2EEHZ60YjwCcDHrrodrvtkrgdTN1yXs/e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778498146; c=relaxed/simple;
	bh=RR1NenBgrAYdu1c55iySbUR6WPCvJPcX8MV/1pGj/Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrjEMR/Z2XeS0TcGZwzzNBG56uQqQVDfOXaHv6Zx0VYYugMPenO2XbUxhTugcdeFBDicXRKZUvpZ1vH01A+hTcLufgxTVYYIL7eYzbpxiuk7mhABL4d/1euyQdti3tYarIiLjtpqdtSWsQ683w3qSQVO/hERsFC87kffWcunsFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eiOXnVzB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JD7RYlZU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eiOXnVzB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JD7RYlZU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778498144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yQi40JXMVWHDZRjke+rHrQlcRrLFkKa2WRv/wpGjnDg=;
	b=eiOXnVzB/pI21G1epMBuoDXb6oNlBBDexTMU4Pa0JCBceD31HbvlXiXC/IZQa1Fj8l9LKV
	pw5PgOlAYz+3TPAX39WKLM4LkRWOgM1cChU19NATJtSHTy8eIWrTpo/2dvzXU9R2NFykm3
	lwEojr5JQKwtDDdhTXGyrl+BoIaiuCg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-fSTMOdysNluxrAqvHGEgLA-1; Mon, 11 May 2026 07:15:43 -0400
X-MC-Unique: fSTMOdysNluxrAqvHGEgLA-1
X-Mimecast-MFC-AGG-ID: fSTMOdysNluxrAqvHGEgLA_1778498142
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48d0889c1ecso26355475e9.0
        for <linux-unionfs@vger.kernel.org>; Mon, 11 May 2026 04:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778498142; x=1779102942; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQi40JXMVWHDZRjke+rHrQlcRrLFkKa2WRv/wpGjnDg=;
        b=JD7RYlZU6EskBY0iebQXhrP6fG75D84nXogDPu32FfcEw63rnM1IikbMUF2W/1X4Dt
         vZt+Wq8PziYB+4Hp7ysslCShy8FNO/Ok6TcQ4mFZ6m0CiQTd60l6VyvOfoqewkkfBYYQ
         FkZf3iCfI+5BBlhha7ptXvQZyNtIxwStyV/4KlGARJYEQYkV5SXdLGUxd+I4kXg7z+vB
         r/CeTPBzHD4KfQFNbu0VqhuEplLProVADaEeS+0jmKCpu725WyJezz2C61yDE0sToe9q
         lDw3yxAMwWPWjke4qYIA79uVQLaRPgr0bJBWYyFBaIo/2EAZGrKxl8U4V5UuHvErYF9T
         vgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778498142; x=1779102942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQi40JXMVWHDZRjke+rHrQlcRrLFkKa2WRv/wpGjnDg=;
        b=sQVCv5OO0wKJbXLf3VVRJ0l6NghYh5SPiKQ4EM3jdeI/kjKpCHNFooZ39yTU2thBcS
         Vw/VclmU7etfKwLvSDJsIc6rzTZILeW2zVRNYg4XhHFGiWsUZj+R8bhwIMuhFaKsvERw
         ejn6DqAh3b8JTE9DMvkm4FCJuDw1GfPunCu7Bi39aIxrWhI6WGO7RTQrJ1yme8kExdO8
         RoxI+h6zdhJTQgEejOX4T7mxvWywaxyCvVSE6sRFkANe/jnCgor4J3JxEhmGixic3TY+
         dpr817YiMKqMLP4zBpPLTub2JliTL3u2oOLVWK7IkzI1uuiTA1/63ZOY/eA9wGXnWqoK
         0gjQ==
X-Forwarded-Encrypted: i=1; AFNElJ/MgDTRAo7aL/PXdxLu3QFq59Pl9LTCPiuwiXqdBBK8gTiP5eJMWTqfepwm007JNu7SjnYIu8jT6bxITBpa@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4YlRb0C5pqs7qb7AIAHlhyctHvFbT8eVQlH6Yf+lGVo6y+cWE
	EY8qO3LKqalnYKTKlCtp9aTjKXAF9E80MCkPocNXewsbHIL10qbDgjdbTbVPpkcv/Qu3WlwZeIt
	CZ/3nk5cHkrO0/m9kbuGFu0NT5fR9j8AU0Q6yxkDiWzaVpHLd4kg/Fa3ySw2M3JiMog==
X-Gm-Gg: Acq92OE37O8WxCA/kWKc1chVzexFVK7SCQmadT+Tk82QLlFCQxXlIQq+tRHkHixrlfn
	oVPPAlLujPjcEIC9dJbVbr1h83u7BVmnm5pxF7xdiOEh9Q7SXSBg+2exqqiQaAHpHGoNQ0ApEzX
	MHXT1B/Xb92j3tB95saoQoKTXrck/G/qF+Iuq07vHSpj6Iw4BfERanhHcMopJge6dc8q5mAtPOc
	uGBmKdRQ+AEtazE9qJQ+f9McRG7zzTuukPsq2TmLEO7Q20L33+RfOfigc9W0oes1TgVBij5i2nK
	ej3jB7ysCZpy0jHeVWRvJtOBl4b/6j+AInoh7ykSAmDE6g8JO/Z/zfb5ykRSgkGB577CEiFY24z
	rLI33CBs5P6g=
X-Received: by 2002:a05:600c:1f89:b0:48e:8741:fd4c with SMTP id 5b1f17b1804b1-48e8741ff98mr21083635e9.18.1778498141653;
        Mon, 11 May 2026 04:15:41 -0700 (PDT)
X-Received: by 2002:a05:600c:1f89:b0:48e:8741:fd4c with SMTP id 5b1f17b1804b1-48e8741ff98mr21082605e9.18.1778498140980;
        Mon, 11 May 2026 04:15:40 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e7040a9a9sm309872515e9.9.2026.05.11.04.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:15:40 -0700 (PDT)
Date: Mon, 11 May 2026 13:15:39 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org, 
	david@fromorbit.com
Subject: Re: [PATCH v9 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <hnsxzymuydf5evoxw4chao7rkixm4eafolebxfjtsqschgfazh@nll3fdfnsigx>
References: <20260428083332.768693-1-aalbersh@kernel.org>
 <20260507055217.GA19888@lst.de>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507055217.GA19888@lst.de>

On 2026-05-07 07:52:17, Christoph Hellwig wrote:
> On Tue, Apr 28, 2026 at 10:33:06AM +0200, Andrey Albershteyn wrote:
> > This series based on v7.0 with Christoph's read ioends patchset [1].
> 
> That's not a good baseline.  We'll need it on the -rc that has everything
> from the current merge window at least.  It might also interact with
> the fsverity fix that just went in.

Sure, I will sent v10 with a latest master and that fix soon.

> 
> This might also be time to come up with a merge plan to figure out through
> what tree(s) to merge it as there don't seem to be any maintainer
> objections.
> 
> 

-- 
- Andrey

