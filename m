Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4B112E1C9
	for <linux-unionfs@vger.kernel.org>; Thu,  7 Mar 2024 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709820598; cv=none; b=MWZYQqfFUqrsc3O6WQiiUSTQglZPwO+mfgsTueN7KG/kAbeKbfWO+BaKNl1NRJ1QxOZGXgfjm4CXFNd4EBD8T5ZxKFtIHPxrll9dDS0epqkYA68Pw82qxu8q0QtaifJHr0SZDXK0NEv6DajYsox7aZJ8AGPBEL4vg3J+9ZbOS3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709820598; c=relaxed/simple;
	bh=2ED+9pdp+YlVQvsPdC3jIxYY6GPhCNFl2+qV+Rc3zPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nHTshUwn/gr7gkPthxTxo7XXsDO0SwE81HOP8hqGkYURyRpHwF/+NStGz1z4fHVb169nYSCow7OXL+uXModZC2CtmLHQray6bKFFp8WKWfy4rf6iPRjyEoj1FoBIU+E9Re5omwTU3BDLssxZdfAsAnH9fZ/F0sYPAFEt1u2Byqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=RUIA9eXa; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="RUIA9eXa"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a44628725e3so130344066b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Mar 2024 06:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1709820594; x=1710425394; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5k7ZkrPt1CzNbrUtsGIPmHNYMv0hYyJAkoPlVK0NqiY=;
        b=RUIA9eXaZ/54p7xnPUJb5EOqvPuOyUBPHRpPghlkZVuDDVBTK2+5ksBKvHqZoTISXj
         Dgo3sXOTU/tDjDyFILkY9aY0rm3NGQ9hLqHAeyAe61ky+mQlF6bb2/LOA31APpkHdykx
         JArR8M5Fu484h2MeotpoTGZ/9oBIExoiY9eIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709820594; x=1710425394;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5k7ZkrPt1CzNbrUtsGIPmHNYMv0hYyJAkoPlVK0NqiY=;
        b=qmE2GuN8ZMXxL6D7+1JH8v0S68aFwfeRq3u5GQ6/oPlIIR6zPVMPltbdV3aBOzB9iJ
         ou0yvWZzqvGYZ1zrAB1LfokZqmEWBJxKHq7KgI4N38s4Gp/B/e0JyyXUXXkVOpw+Ei9F
         tr6D/iTdhXv8eAjkrgUn94R4FCz42mvb+zk0JMoyapddIN2OODinRkk6Lg3LgGtwpRat
         30YjJEuUiOacaPrcYpS/EwOFsYE2ce/90iRlzdt1CwaIm6siSjpI7GQbrn/DMApues+M
         Oqhp3v1GOUaaviMuMHSKSH5XVm6I+Z/o4nX2dosSPmxePqS5QNShsPuMRDzZ/mLsXLFN
         rZrg==
X-Forwarded-Encrypted: i=1; AJvYcCU4HAuqTD5PcgdSiaU5rZP21SZWG+oZplowf1KWXpfMGnFMRW8rVvDyCdIIVhWza2zFDq9eQBIXBS6Q6m2Rg9sox4zdHCXudw5nr96uzQ==
X-Gm-Message-State: AOJu0Yy+TmvspBR675uQVj3Rt8aB5Fea0qsgIimXqd/vyGQHsBb8Wmeq
	wlx8aAY9ajouIeRuKamZSz9oamP0/yYlWzq7bbwAhHd4FTfWynMq/RvJMUAV8YUVOEHp39rGC6R
	HaWucHNCSgTbOu1zO5i+ohJMo9rGgQlY8CfBW1UQK69aH1XQX
X-Google-Smtp-Source: AGHT+IHy9vEMpd5ryDhCr2qNIwpuQ3eni1u7LMwkl0/c3KSpoSzMmlX8V/S0jYfU9BwR9jOWmgDVsjfQsGejsR49dZw=
X-Received: by 2002:a17:906:ae95:b0:a44:8f3a:794f with SMTP id
 md21-20020a170906ae9500b00a448f3a794fmr12076477ejb.42.1709820593816; Thu, 07
 Mar 2024 06:09:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307110217.203064-1-mszeredi@redhat.com> <20240307110217.203064-3-mszeredi@redhat.com>
 <CAOQ4uxh9sKB0XyKwzDt74MtaVcBGbZhVJMLZ3fyDTY-TUQo7VA@mail.gmail.com>
In-Reply-To: <CAOQ4uxh9sKB0XyKwzDt74MtaVcBGbZhVJMLZ3fyDTY-TUQo7VA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 7 Mar 2024 15:09:42 +0100
Message-ID: <CAJfpegsQrwuG7Cm=1WaMChUg_ZtBE9eK-jK1m_69THZEG3JkBQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] ovl: only lock readdir for accessing the cache
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 7 Mar 2024 at 14:11, Amir Goldstein <amir73il@gmail.com> wrote:

> I did not see a cover letter, so I am assuming that the reason for this change
> is to improve concurrent readdir.

That's a nice to have, but the real reason was just to get rid of the FIXME.

> If I am reading this correctly users can only iterate pure real dirs in parallel
> but not merged and impure dirs. Right?

Right.

> Is there a reason why a specific cached readdir version cannot be iterated
> in parallel?

It could, but it would take more thought (ovl _cache_update() may
modify a cache entry).

>
> >
> > Move lock/unlock to only protect the cache.  Exception is the refcount
> > which now uses atomic ops.
> >
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > ---
> >  fs/overlayfs/readdir.c | 34 ++++++++++++++++++++--------------
> >  1 file changed, 20 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index edee9f86f469..b98e0d17f40e 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -245,8 +245,10 @@ static void ovl_cache_put(struct ovl_dir_file *od, struct inode *inode)
> >         struct ovl_dir_cache *cache = od->cache;
> >
> >         if (refcount_dec_and_test(&cache->refcount)) {
>
> What is stopping ovl_cache_get() to be called now, find a valid cache
> and increment its refcount and use it while it is being freed?
>
> Do we need refcount_inc_not_zero() in ovl_cache_get()?

Yes.  But it would still be racy (winning ovl_cache_get() would set
oi->cache, then losing ovl_cache_put() would reset it).  It would be a
harmless race, but I find it ugly, so I'll just move the locking
outside of the refcount_dec_and_test().  It's not a performance
sensitive path.


>
> > +               ovl_inode_lock(inode);
> >                 if (ovl_dir_cache(inode) == cache)
> >                         ovl_set_dir_cache(inode, NULL);
> > +               ovl_inode_unlock(inode);
> >
> >                 ovl_cache_free(&cache->entries);
> >                 kfree(cache);
>
> P.S. A guard for ovl_inode_lock() would have been useful in this patch set,
> but it's up to you if you want to define one and use it.

Will look into it.

Thanks for the review.

Miklos
