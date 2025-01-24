Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12A417FE
	for <linux-unionfs@vger.kernel.org>; Fri, 24 Jan 2025 05:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737697376; cv=none; b=TSRSX8/qhObIBnRa4Q6AcD76gcW2u9Y6YMetKsGd5OzrnKB9x40Vwl0VGwDrkfFP/qhlzDPyc6yGRXM5l43EuFO8YyePV1zOSdtg7j0ZwdeOTCK3qIqExuzh60v5y661YAjM1aUgwtQgRQpfHVHyDx2aNhhtFaZtWkVcPFUp1lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737697376; c=relaxed/simple;
	bh=NcCybi90WQjzTwu81hZFhUpsFvOLJogjGuldttLvlCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j6E7fJtcIqYKm0tkj0O+p/AipYww/SdvTLwfOi+7DSlFD+IEVIXq3aOul0gKkjkw0GGwuzPoboSk24o/wRk2psQV98YzRlQiJn4Lblx/4wD6VoBTalKTLVC64oEesAEKm78F/bqXis0NPKJX5E7FWkEXm7yPKvPPRtdTWRuOZrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=glXiUsaZ; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="glXiUsaZ"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-844e12f702dso46914339f.3
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 21:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1737697374; x=1738302174; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MyHAWnvsxWEqkaIajwU9bMH9HrSvktC4b7Oid9sfHUk=;
        b=glXiUsaZ4+HUf0A0uZYGZUs6TkIHBd51YmKGAKNM7BDCS36veQ1rELxqg3rzS9HD5a
         Hjco1nmZHQocAaRAg/UfxgtPA9qcGNVpe1DbqPerU2tPn4I3cWZCUT7U5d2sYHsdA+k8
         t03/sx89chLX3h+hBrYWjZq4V5W9k6HWl8eh/6oXFcwr0E6NffcIDWnLwCR/AgSZBaEQ
         qPljJJOiSyJ39HA1VbUr2zXMz/FVILhho8ujWpAzO9GcVM9rWdsRxwSMBzc0ePo4HDUC
         AbxCrMLICngmM15Vx+AismU4wPMhz2+evxoY7dHHuDLx8FQNTxPLYOJksAaIVt6dR2hi
         smLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737697374; x=1738302174;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MyHAWnvsxWEqkaIajwU9bMH9HrSvktC4b7Oid9sfHUk=;
        b=hb3QX6qXAqC1176HKi9LI4hPBR0bZqLDsI8FZZ11qcYkcTOx32vfLythuldfwt3gcR
         7ASAljKGqe5sxBtbbdyw9oC4/7VBgSQoiSgNNCe1GKteTGLxvmSPeD6TZwEEPWy1KgH2
         EkhtTwHu6a3Vmiyg2P/PgOXGg+xS2Uc8vEKWN6jldSh7tiGvzEw2HNBnYllg0HSHN2AR
         2gcQenrehpE6E7LNQyJiRqXlhEPhICBt2uynWFBBUHMNZ0+4h6lEtMqjQZmBigiqzXUc
         +F4IzgLurPAKBq4NHE500o5PJFAtgJqtT8sx35XTjG5ALdkrbe8jMbAD7LHg+c9eAvJc
         I2wg==
X-Gm-Message-State: AOJu0YzqE/DM61XqCkUWtfSrE/JS6NuD5gQr9495YBCSUS5LbVxOHuJM
	9VIYE8OSzDUpV/88bzwsbU1c/uvn8fXDdDJaQU7ljNEXGQ02f1wR1p/JH4sjqvQ=
X-Gm-Gg: ASbGnctV2/qLyTxDCYRBUqY2ZOkbqnzrgHSaSAAUhGABfFZcvMkSBqV+sIIw+4Wj3gR
	eJMoqF0CTR4dx3YJngaN2AAVWh2SIbRFxwP7EPX0+KFgR493v/eiAw+Ir5Dp1e68udO2Ex3QpA+
	jnj+1cYp26VlOr/dCXpPD+eC4BuL8JeWBbQ7m88EbERH+f78MHY9Ki2Y5uQEb+9rKK8akvdve7f
	b9niKAYSUBA9RGGxryICtHWUWm4OCuQJ5XdYRSGLKXE2bj8+hyBbJxE/qi47HgtHtCQaQR/y+ND
	QW61kFe7mUZynNpMMJIQz2jig/EeXXGh6u74MSLNHH9U
X-Google-Smtp-Source: AGHT+IEy/kTcIrI44bs8C5rNtJhOxTPneM6xRcbAEJmmR+Xv/YFFUzss217P3I1wp7Ks0FfJ5oOLpA==
X-Received: by 2002:a05:6602:6cce:b0:84a:5201:41ff with SMTP id ca18e2360f4ac-851b61658e7mr2416018639f.3.1737697373827;
        Thu, 23 Jan 2025 21:42:53 -0800 (PST)
Received: from ?IPV6:2601:444:600:440:56ac:fee5:d1d1:52d3? ([2601:444:600:440:56ac:fee5:d1d1:52d3])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8521dbb3acdsm39709939f.0.2025.01.23.21.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 21:42:53 -0800 (PST)
Message-ID: <d3499895-9c60-4e03-83b9-edebbfb04bbb@mbaynton.com>
Date: Thu, 23 Jan 2025 23:42:51 -0600
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] fs: allow detached mounts in
 clone_private_mount()
To: Christian Brauner <brauner@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
References: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>
 <20250123-avancieren-erfreuen-3d61f6588fdd@brauner>
Content-Language: en-US
From: Mike Baynton <mike@mbaynton.com>
In-Reply-To: <20250123-avancieren-erfreuen-3d61f6588fdd@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 13:19, Christian Brauner wrote:
> In container workloads idmapped mounts are often used as layers for
> overlayfs. Recently I added the ability to specify layers in overlayfs
> as file descriptors instead of path names. It should be possible to
> simply use the detached mounts directly when specifying layers instead
> of having to attach them beforehand. They are discarded after overlayfs
> is mounted anyway so it's pointless system calls for userspace and
> pointless locking for the kernel.
> 
> This just recently come up again in [1]. So enable clone_private_mount()
> to use detached mounts directly. Following conditions must be met:
> 
> - Provided path must be the root of a detached mount tree.
> - Provided path may not create mount namespace loops.
> - Provided path must be mounted.
> 
> It would be possible to be stricter and require that the caller must
> have CAP_SYS_ADMIN in the owning user namespace of the anonymous mount
> namespace but since this restriction isn't enforced for move_mount()
> there's no point in enforcing it for clone_private_mount().
> 
> Link: https://lore.kernel.org/r/fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com [1]
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/namespace.c | 78 ++++++++++++++++++++++++++++----------------------
>  1 file changed, 43 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 4013fbac354a..3985a695d373 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2287,6 +2287,28 @@ bool has_locked_children(struct mount *mnt, struct dentry *dentry)
>  	return false;
>  }
>  
> +/*
> + * Check that there aren't references to earlier/same mount namespaces in the
> + * specified subtree.  Such references can act as pins for mount namespaces
> + * that aren't checked by the mount-cycle checking code, thereby allowing
> + * cycles to be made.
> + */
> +static bool check_for_nsfs_mounts(struct mount *subtree)
> +{
> +	struct mount *p;
> +	bool ret = false;
> +
> +	lock_mount_hash();
> +	for (p = subtree; p; p = next_mnt(p, subtree))
> +		if (mnt_ns_loop(p->mnt.mnt_root))
> +			goto out;
> +
> +	ret = true;
> +out:
> +	unlock_mount_hash();
> +	return ret;
> +}
> +
>  /**
>   * clone_private_mount - create a private clone of a path
>   * @path: path to clone
> @@ -2295,6 +2317,8 @@ bool has_locked_children(struct mount *mnt, struct dentry *dentry)
>   * will not be attached anywhere in the namespace and will be private (i.e.
>   * changes to the originating mount won't be propagated into this).
>   *
> + * This assumes caller has called or done the equivalent of may_mount().
> + *
>   * Release with mntput().
>   */
>  struct vfsmount *clone_private_mount(const struct path *path)
> @@ -2302,30 +2326,36 @@ struct vfsmount *clone_private_mount(const struct path *path)
>  	struct mount *old_mnt = real_mount(path->mnt);
>  	struct mount *new_mnt;
>  
> -	down_read(&namespace_sem);
> +	scoped_guard(rwsem_read, &namespace_sem)
>  	if (IS_MNT_UNBINDABLE(old_mnt))
> -		goto invalid;
> +		return ERR_PTR(-EINVAL);
> +
> +	if (mnt_has_parent(old_mnt)) {
> +		if (!check_mnt(old_mnt))
> +			return ERR_PTR(-EINVAL);
> +	} else {
> +		/* Make sure this isn't something purely kernel internal. */
> +		if (!is_anon_ns(old_mnt->mnt_ns))
> +			return ERR_PTR(-EINVAL);
>  
> -	if (!check_mnt(old_mnt))
> -		goto invalid;
> +		/* Make sure we don't create mount namespace loops. */
> +		if (!check_for_nsfs_mounts(old_mnt))
> +			return ERR_PTR(-EINVAL);
> +
> +		if (!path_mounted(path))
> +			return ERR_PTR(-EINVAL);
> +	}
>  
>  	if (has_locked_children(old_mnt, path->dentry))
> -		goto invalid;
> +		return ERR_PTR(-EINVAL);
>  
>  	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
> -	up_read(&namespace_sem);
> -
>  	if (IS_ERR(new_mnt))
> -		return ERR_CAST(new_mnt);
> +		return ERR_PTR(-EINVAL);
>  
>  	/* Longterm mount to be removed by kern_unmount*() */
>  	new_mnt->mnt_ns = MNT_NS_INTERNAL;
> -
>  	return &new_mnt->mnt;
> -
> -invalid:
> -	up_read(&namespace_sem);
> -	return ERR_PTR(-EINVAL);
>  }
>  EXPORT_SYMBOL_GPL(clone_private_mount);
>  
> @@ -3123,28 +3153,6 @@ static inline int tree_contains_unbindable(struct mount *mnt)
>  	return 0;
>  }
>  
> -/*
> - * Check that there aren't references to earlier/same mount namespaces in the
> - * specified subtree.  Such references can act as pins for mount namespaces
> - * that aren't checked by the mount-cycle checking code, thereby allowing
> - * cycles to be made.
> - */
> -static bool check_for_nsfs_mounts(struct mount *subtree)
> -{
> -	struct mount *p;
> -	bool ret = false;
> -
> -	lock_mount_hash();
> -	for (p = subtree; p; p = next_mnt(p, subtree))
> -		if (mnt_ns_loop(p->mnt.mnt_root))
> -			goto out;
> -
> -	ret = true;
> -out:
> -	unlock_mount_hash();
> -	return ret;
> -}
> -
>  static int do_set_group(struct path *from_path, struct path *to_path)
>  {
>  	struct mount *from, *to;

Confirmed this works for the use case I'm interested in of directly
passing idmapped mounts to lower layers.

Tested-by: Mike Baynton <mike@mbaynton.com>
