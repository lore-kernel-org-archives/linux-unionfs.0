Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFE8405AB7
	for <linux-unionfs@vger.kernel.org>; Wed, 25 Mar 2026 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774460212; cv=pass; b=fwHd8gE+DiDm21uhV+/8WmueG50f3p4f3qn7rBKxb1y6oOzhB9urufV0rQJYU82wFT6W5WWqB7WR1tLzXzemXVuCyKXsgSGAKULRJJyYlkqUPKVNLigty0yiZshPLxa6Osv9pPQP2RbOKWI/5oIpSoOMzGMB+ZT3DRwszmdpCiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774460212; c=relaxed/simple;
	bh=SXXvNMm4OOeTVI5sEJNC7nVh6MOtnfj6hXf10537/DU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RXc7PI009GCVj8n5FCpCk1KySvSQ4Kh3FrHeQm1pqCeP6kxn+4Kqo5t0p0rPUGHkv6C5zEZvDBZN0uL9LE7Ggd+kXgv0DVVTHV3Oy9rLkxb/sokGIfHyqrWCvyuq40F166vOtNARR/Kj4khhPzLE6ava0aezzFg34aps1Fr7L9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=DD0nH9KQ; arc=pass smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="DD0nH9KQ"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82a893d289bso67072b3a.0
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Mar 2026 10:36:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774460210; cv=none;
        d=google.com; s=arc-20240605;
        b=HQP3jXAUuw6aQ76c1MKbH8w7k6FwT+OZV+l8VkaD7sqKxGA9H2sy3/tOB9zc13SJLr
         cpkqXvAd5bFCLH0bKy7ENZwxRo5KF8EE1oRBaZh3ugHULYPUyhMX67J7x2Y2TSivnyVC
         2aq77+971JsPKZcS3s/hHWJ5GHFbiygHcelud0boD1VfcyZkthm0lwkeDcDbQkQRZsCN
         XunqWaO4Orxky5yzArSNFwzGkuMY8gOwwIB1Uclb4JkR5oR+0QqCYOkK9e+DCG934OVC
         Cg3OvY98VWN1Pk2ibtoYqRdyBw56ydutCBF03G2gHZ1FvFpK5nAz2F7iWsRSbd5V8lA8
         LZMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=560A6QjyhPKgUbe2CXEHtEc1ptAHKSEox2yVMb4TCwU=;
        fh=qbj8FXiA99aE298yEobDwP0Chp/BFouXLtuPooexTkc=;
        b=jvWSEkJJchUL8doXO+FMsv+zNq3hThUuJ7nMyP4YaTLWxyDsn6e7Ar3DwkMMZhVjdv
         M+iFHPq3JZI7SGfRRreDgxSPtqawd41Bgxj60xY8PuXb3t2Hf9Wi7QFL2vkUN2wRENL+
         VNTPr73g211puQI4RDfT8L7bG5F6RCFXdhOOOEB1OymQYA5GqoV/2rwcR3d51CjPIZFa
         OVDhY5N8UWjqaA9MlRMGCo7bJrvJeFUqCmKoRdXUTklabsjrBNBhqXdAUok9vGG8+ePp
         ZQVL1ml8CiwddACJ5t8h3WLl2h/y05Q6nfmQo8KgUpfmrizXX2zGCHFRWl5Co0GrlFMo
         lCGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1774460210; x=1775065010; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=560A6QjyhPKgUbe2CXEHtEc1ptAHKSEox2yVMb4TCwU=;
        b=DD0nH9KQl1IYWPF404uwuX/UIwWdC4xPMi7UnOVf1ppDz5q3jCBTjDJdhfdvWPI3fc
         LIMP3cOmjdPwlRGycoQlHYGk6rQH1RpOqPJjt0IC3iuDQNkNvVVQm/dbKPGlD1UAFZhR
         qdV0RHP73WosmwNpT1GlSz253J1A7GAjwLQQTg2qKjVBpdCL36jNUDIg2HvU2yCbYsSp
         BFYp8s4s4jAA/bI7fyHZZlUCTxYKQcdqCHiP9gQ+ATwH7EDOe/X+8fVlRnWhnVEGLpMn
         MVKvZdmsOlbEjJpKgFV+ZoDBcFnPs6I+9PxG6rxAFW04FS/tT2DuUskI5BxjIV5s/DLO
         1GLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774460210; x=1775065010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=560A6QjyhPKgUbe2CXEHtEc1ptAHKSEox2yVMb4TCwU=;
        b=T9eilMgPwxNM6dfSpeAbNGZJc4pmL8EQZxwvjA2BM8US/8QdpWDY+TBVolMSeFkaz4
         Fy6zZ9WEUfi0N+e8j0eBgUoMkgHoNjFujjpjOddWJ9fQJ4R+WJ12miy0AlSioCOpPfIr
         VDGF+sYQJzbYcIM8NB3eM0I8QcFxde/HgbMp5Jua7R8+TDXfh9AJkzTs03EqkT6bAlPl
         1al4PtoIOWFo+PHb/G2DcDMC60mXdrKiYxefGVw5xCkJ2bcxE3EaqLYjaqaoLN4NkJTC
         fxJ12RJ5IGOA3bVlYMA2Oc7KA7MOVUlveyHp2iChI043MOfb3ed/LqWfO96zG6z2SX+4
         lrUw==
X-Forwarded-Encrypted: i=1; AJvYcCWjVkI/KaPtcuxg/JviZd48R0gj1T502RhzrxPxRNi6+I35wqNB8i2zP+sBCLr7f+3r0tKUY1oJWiEziXyZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7HEfL2d4a4JMFVJdY1ufgt1PfJ3W/Nbab7nXJvNqGzlnL2it7
	CvPq5jeX31Aq8PnEfal7FxRRQMYQmnXMABoXTut+kmJBQv20FWxHxg8PXkz8IK65hgqX6HvmSp1
	UcDdt2k6tLqlt05R9Xe4eSFQ+REUTt08EI296b2kT
X-Gm-Gg: ATEYQzx3BIA1hxnaymAfTT5eMdc5YbQRg5cIYuKquG79M+mA32/TtGRzFD3akWiQEtq
	GD3FT7SSSurMsOhPiGWgiME6vzhedn+G9h7KjUyUlECNA/KAJ7ayTJBRXB+vd2pI08mJa83hLux
	rbGuCaGRFmTpg0DNIqWDZkYBnMPK+BdbfzjHzTCSMZ0WcGPigMtHDDBjV+WZYa+BOqy/sXr5TBg
	TgFudkeU5uEnpyPdrdqpwm74pSFZ2oQSJrVSrOaPnKu5lXm4MtPWWlagRtGipTAXxfQ6VVeW/Im
	sTnHEGY=
X-Received: by 2002:a05:6a00:4219:b0:827:2ee0:411f with SMTP id
 d2e1a72fcca58-82c6de7aa7cmr3962195b3a.4.1774460210073; Wed, 25 Mar 2026
 10:36:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323042510.3331778-4-paul@paul-moore.com> <20260323042510.3331778-5-paul@paul-moore.com>
 <CAKCV-6t=m-8eu1xoTORnLwhG4kQB5u1v5diJDQDFcat=tH8WgA@mail.gmail.com>
In-Reply-To: <CAKCV-6t=m-8eu1xoTORnLwhG4kQB5u1v5diJDQDFcat=tH8WgA@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 25 Mar 2026 13:36:37 -0400
X-Gm-Features: AaiRm53RXGI_5fUjjLSR_a0KxLZyxKMzyTIPSX8PFvRbx9JxRVkJ2AR_0Hlvr9w
Message-ID: <CAHC9VhRNOGk0dGERbD+RRLTWebZu1-7cbvB0a2D0njbnqBRNXQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/2] lsm: add backing_file LSM hooks
To: Ryan Lee <ryan.lee@canonical.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <xiang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 7:01=E2=80=AFPM Ryan Lee <ryan.lee@canonical.com> w=
rote:
>
> Hi Paul,
>
> I'm currently looking at the patch more closely to implement the hooks
> for AppArmor, but here are some typofixes and the like below:

Thanks Ryan, I appreciate the extra eyes.

> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 83a646d72f6f..1e4c68d5877f 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h                          unsigned long p=
rot);
> > @@ -1140,6 +1146,15 @@ static inline void security_file_release(struct =
file *file)
> >  static inline void security_file_free(struct file *file)
> >  { }
> >
> > +int security_backing_file_alloc(void **backing_file_blobp,
> > +                               const struct file *user_file)
> > +{
> > +       return 0;
> > +}
> > +
> > +void security_backing_file_free(void **backing_file_blobp)
> > +{ }
> > +
>
> Should these two placeholders be static inline functions, like the
> other ones around them?

Yes :)  The kernel test robot found the same problem yesterday, I've
already fixed it in my working branch.

> > diff --git a/security/lsm_init.c b/security/lsm_init.c
> > index 573e2a7250c4..020eace65973 100644
> > --- a/security/lsm_init.c
> > +++ b/security/lsm_init.c
> > @@ -293,6 +293,8 @@ static void __init lsm_prepare(struct lsm_info *lsm=
)
> >         blobs =3D lsm->blobs;
> >         lsm_blob_size_update(&blobs->lbs_cred, &blob_sizes.lbs_cred);
> >         lsm_blob_size_update(&blobs->lbs_file, &blob_sizes.lbs_file);
> > +       lsm_blob_size_update(&blobs->lbs_backing_file,
> > +                            &blob_sizes.lbs_backing_file);
> >         lsm_blob_size_update(&blobs->lbs_ib, &blob_sizes.lbs_ib);
> >         /* inode blob gets an rcu_head in addition to LSM blobs. */
> >         if (blobs->lbs_inode && blob_sizes.lbs_inode =3D=3D 0)
> > @@ -441,6 +443,8 @@ int __init security_init(void)
> >         if (lsm_debug) {
> >                 lsm_pr("blob(cred) size %d\n", blob_sizes.lbs_cred);
> >                 lsm_pr("blob(file) size %d\n", blob_sizes.lbs_file);
> > +               lsm_pr("blob(backing_file) size %d\n",
> > +                      blob_sizes.lbs_backing_file);
> >                 lsm_pr("blob(ib) size %d\n", blob_sizes.lbs_ib);
> >                 lsm_pr("blob(inode) size %d\n", blob_sizes.lbs_inode);
> >                 lsm_pr("blob(ipc) size %d\n", blob_sizes.lbs_ipc);
> > @@ -462,6 +466,11 @@ int __init security_init(void)
> >                 lsm_file_cache =3D kmem_cache_create("lsm_file_cache",
> >                                                    blob_sizes.lbs_file,=
 0,
> >                                                    SLAB_PANIC, NULL);
> > +       if (blob_sizes.lbs_backing_file)
> > +               lsm_backing_file_cache =3D kmem_cache_create(
> > +                                                  "lsm_backing_file_ca=
che",
> > +                                                  blob_sizes.lbs_file,=
 0,
> > +                                                  SLAB_PANIC, NULL);
>
> Shouldn't blob_sizes.lbs_file here be blob_sizes.lbs_backing_file instead=
?

Good catch, thank you!  I'll have the fix in the next posting.  I'm
hoping to do some more testing today/tomorrow and post a non-RFC patch
by the end of the week.  If you find anything else that looks awry, or
just doesn't work, please let me know.

--=20
paul-moore.com
