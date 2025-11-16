Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2521283FE2
	for <linux-unionfs@vger.kernel.org>; Sun, 16 Nov 2025 08:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763281397; cv=none; b=ihZ7hsX5LRKIIdwTwRPV8VWT1DMKVpC4o9Bs6xE5mb5wANZJJtSbO410KVZ8Hk58Xg/KNOgPPaU/SqQCHlGF/23/ANKF9Db+wROVtgfrnSv3v9JbgyJ4mfA4+dilUAP1jcA8HllNbhScaPL/qDNzthxgy0j2xLHkM8pi2WOdlCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763281397; c=relaxed/simple;
	bh=C+JcvFRwZHyavGe7kxRswHzD35IQVhdGIfMoOL9ybQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M80tEjPWyAzLDfKD87TY/VrdUrIegBdl9i++rWvH0qkKAwBmalxW6dSl9dzCWU7z+qvSip6iOyb6YVZy27Xn6mSHOvs3lyaIYNhRHaxYF5sZJbYgiUDmdJJU9uZFBYFoUMOVM5yyLAezvtMaCw8U0EbzpjFwsl/B5rUbyN9QmhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LAFpYxoi; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LAFpYxoi"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-297e982506fso39638415ad.2
        for <linux-unionfs@vger.kernel.org>; Sun, 16 Nov 2025 00:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763281395; x=1763886195; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M4MaMBAoduJmljAfpOLsOwZXGopJOVWqjmgthPn26W4=;
        b=LAFpYxoiJGcYCTAW2kOg1UFBq9oMMmEaBg4IvoS0x3oCTo4DCvJt3kTJIKB0DB5SL7
         NJDSdSfhSUy6img3FIkk9DZo93wSfy/IQfxyXAy6nDow269dr8fz2JWVYR2FIsFXjAQ0
         6SHD9N2jFT5ezuoq/DJaH6tv4TwQfB25O47G/5O+HEeM/r7mF4AIebekDNxdrWcmQ39u
         NVZ9AS0QiPWLnpgRmkIicMuRk263e5xdrNFcBbAuXJO5c1Qv8Kr2mRr+4x0u/bfpWq65
         Td07/17O4ZU71mQrPJ/qJtNKqi/9DqB5XVUZhh78859hNaw+PP8r8dqXyw4pnhkA0gvB
         IvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763281395; x=1763886195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4MaMBAoduJmljAfpOLsOwZXGopJOVWqjmgthPn26W4=;
        b=TIh0s6Q+880gL152vgqP3odec3xmgl80CRAaIIJ/zvoq57rWaQOmJX6fRRT4f1Lw38
         6XajXmiyjsuFPq3FS0/3ARaQvlFRdehYtp4xFIVhRLalHphQJ8y/qtn73BRWBAypIBfM
         gs+tZFXEIqP/blagpnXboaaU4pMOCxG+17nx5wf72pylEAhT/K5q3a8WFBdouBeAd1LA
         6FfGlXmLOE3FCTaEvOAJJEoLLlxmIIverZ+cd4N7a9hBp9ilOcy1wJQgyeA3U6bFfCCp
         g65s5df70lbQx2lg/WS61SIKo72g6HKLOZs/ED27mLVWz2rfKbaIMPyl0s29livX7gVr
         Ao1w==
X-Forwarded-Encrypted: i=1; AJvYcCU+tWgmdq5WzCUwZmAxjqMU1xeGZR0O+3JrnAdpqwLcmpUXUJM14qzOVAzbXZ+k+ym9CPdZlE70gVlH+gmH@vger.kernel.org
X-Gm-Message-State: AOJu0YxN/Cymgjo8uh2C7wappbJ8J9IxvBUTh4LlkTtDLqP3Wb4JqTJs
	2jkiJzDOzBr2zFtX0615+E2Ps5SY1IGg/OhnfvfB8opDLinlZhWUwSflPWHFDsHdmr8=
X-Gm-Gg: ASbGncvhzwp5eridrEurpKWgO8+ky/4Lcx9Eixpu0QLF2rA1sotdJa9XQpLbbJYRs1U
	8bFPaqvSg1VlisRQypZYzoE76bm2ekZbl9Pxc4Kg8r+aKJyhKgT6TB3C/gUboHwOO28vGjhlIqu
	cpzQ8/eHrQ44hBvOx/2ZBEsGquQES2JEjSudPydoL8YiGenrnzWyOAEuY1wkr3Srta7/N9S8Ny9
	EMfr7nhqid8fnoXeEs/v9REX02Tn/cM66sNJaVx5hlncseF1kHU9uMjWAqfeBSPNqxxD6g/LQqV
	QYggG1l7g5Bpf1SWmlv7/fdyqeL0oGBW1EU9meceUmBCP9VdLa3b1gwBqgOmAVhmy1qZAx0in1p
	rMrTJ1oSiNIak6LG6AILT6463Sgy3DdHPsnFDAtKOGBoqE9QHIACMvD39ECqIPiDTC9wsX/9OVV
	+rVkB0ThYzMyKpinTaYZMp01jujzfDqusPaeXoENbN0x7XP8fjlaauosI+oyxf9Q==
X-Google-Smtp-Source: AGHT+IE2kISBEpmbZV/bnZzdrwmOacrEejG6ljtHkn9ZRcGe++TC5tzXGzGVsKaVV/gcvGARY/ZhHw==
X-Received: by 2002:a17:903:41ca:b0:294:ec7d:969c with SMTP id d9443c01a7336-2986a769988mr112616935ad.49.1763281394800;
        Sun, 16 Nov 2025 00:23:14 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29864b00fc9sm79958015ad.40.2025.11.16.00.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 00:23:14 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vKY2R-0000000BUhZ-3a27;
	Sun, 16 Nov 2025 19:23:11 +1100
Date: Sun, 16 Nov 2025 19:23:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	io-uring@vger.kernel.org, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 14/14] xfs: enable non-blocking timestamp updates
Message-ID: <aRmJ728evgFnBLhn@dread.disaster.area>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114062642.1524837-15-hch@lst.de>

On Fri, Nov 14, 2025 at 07:26:17AM +0100, Christoph Hellwig wrote:
> The lazytime path using generic_update_time can never block in XFS
> because there is no ->dirty_inode method that could block.  Allow
> non-blocking timestamp updates for this case.
> 
> Fixes: 66fa3cedf16a ("fs: Add async write file modification handling.")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iops.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index bd0b7e81f6ab..3d7b89ffacde 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1195,9 +1195,6 @@ xfs_vn_update_time(
>  
>  	trace_xfs_update_time(ip);
>  
> -	if (flags & S_NOWAIT)
> -		return -EAGAIN;
> -
>  	if (inode->i_sb->s_flags & SB_LAZYTIME) {
>  		if (!((flags & S_VERSION) &&
>  		      inode_maybe_inc_iversion(inode, false)))
> @@ -1207,6 +1204,9 @@ xfs_vn_update_time(
>  		log_flags |= XFS_ILOG_CORE;
>  	}
>  
> +	if (flags & S_NOWAIT)
> +		return -EAGAIN;
> +
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
>  	if (error)
>  		return error;

Not sure this is correct - this can now bump iversion and then
return -EAGAIN. That means S_VERSION likely won't be set on the
retry, and we'll go straight through the non-blocking path to
generic_update_time() and skip logging the iversion update....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
