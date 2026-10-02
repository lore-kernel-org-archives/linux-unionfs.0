Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107221D4606
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 06:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790920895; cv=none; b=m5CFEWibKQn4zCgOvc4WhkOc1FQ6sHMCecQr74l/QGhZ6d7TnEe8V2CkDTPDmNWgXaML7q1DmO0T0z8r3bMGOUM9jQHkUmkJWt1Yj00id6dqhGrr8YindLv9NNjaSLkAat2Fa5I736pbnV4yJEuHyLMvJ8GthBhVi5CYlO4uiYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790920895; c=relaxed/simple;
	bh=Zzl8GQMYT4ovWCoYqlximp5PJDij3vOuu7nwytPtyeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHcCamHt3dToEVVG7XMWMEA+7PwRVvJ68VBO/BE10Y0/iCx7XiYtsiB7fOudue2eGsnawargMMT7enTuzBzad+AT3vXOT1LQDGz7hvhaJeBfTqLyxK0G5jhb6LUJbNukwuXdr0MARvS01SMvsc9sHops01dEiyFOnBQPVtaLebw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m0gEpkWA; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0gEpkWA"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3a02551822eso742991a91.1
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Oct 2026 23:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790920893; x=1791525693; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bvzqwuTjdPy91zWm37KIYjrvoEq9pY5JTP911vnp5Bg=;
        b=m0gEpkWAEcEMiKCKafImmMAllmDHp7tF1YDuCG9bClKS817yH6g98rM+ifBUMFhco9
         XU+LXB4EZxHBk/OxGklmcd/mPfq8lqNu43EHcKShAPE+YQ5wLAMAMfCzU6HCaBMNy5C1
         hK8QUh3KmcUNgqOdjJDmllVDIhv8XnBxx0lf1oNSE2xPvjowHGs3CCctLMfRIe31sy7X
         TnY7mU91UYauds2srysRM8X8F/UMCYhKVafRSDxTVDksMdo1YCu+nrcMDh4sVuPvBfjC
         +Z03FQeEgmIyuonYAAueWYBUhHmnwO5+Z2U2QB/SvVTK6V0iaKUguHGe01zFHxllooyT
         ks/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790920893; x=1791525693;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bvzqwuTjdPy91zWm37KIYjrvoEq9pY5JTP911vnp5Bg=;
        b=C+3O/znv6Nrj+baSKasbbzlXIuD5tbkYUfE/uHnD4zZb76/6rRkdQPdfnXzoP7l4TU
         cndJBWjBKe2TJqnt/5zwVk4clq2E2ezW0j5GGUTurKTOiqy3la/ufm7pxjUmkA67rdPm
         RWOx8d7JL5Pdd3AtzS99TSqIGnzHZm7qHp+exH2afDLeLVYGZ+OxM3SV5dTDpyweJJ02
         4ZNgYV/nVAMkIoBVqLvy07borNJzZCbc3s6QtcGvA6yVevVStdyyRZcDMHZEjJbs0ZKL
         ZqSzrVzsBTZ3PUfnM2gL2SpLDlPsmq0nrmt1IYCPdng99LldXLDGIhRdz8iSTMqX+ZNe
         m+tQ==
X-Forwarded-Encrypted: i=1; AKwUvBzPSvuPHl9Yv63VJmuwNeymWpL0oYKJ55kZZnhKxQPdkIU7OVfIFejt3fLrXVeVXE96MDf7iEuR17zsmvtt@vger.kernel.org
X-Gm-Message-State: AFq9FYJxKkG+0ukblWn5pA87Pd3E8AnDS/MFELQEo9MTFXNZLiPnGmzm
	MHjuDClprMxZTOVWLCMRKRrJYJMdhHYTwL8FoTSzFC4++V47GneELc/X
X-Gm-Gg: AYBFou3cDKcMIWti9UpQExJx5oZQNq0PTOLALBcVfnBlZap4o067PjGKOBW6oBZyI3Z
	zg8kXhT6t1XfG0GU7SIaOiEN6XlxwtJrR4B8rzxKMPbc2+MPcnrRjx+lmhYlAWib4VsHwiIb8dw
	bS9NpkBXNqTCrIDbtPaEDrGziJpJsSUQVSlysaA0QaEZ80fC4Y63HBYgF12RIP/s077dl8/5IJe
	r2YM9R016Y18z7zyc9efmUX8xeNFTbWYkrAM+2yDZU3PkEI5eVWen4JUjCtDJsvVE06WeNqrP/i
	7DUCjoIHtqcH0oNBvDWUs+STA4f9eD0DtuklJIxhPe/Jh2edBAlURZKEsfZm/UCpl+P+t2CyhQx
	eUcT/dEfipd6r+duilrGM+ZIXXYGF841CZ+2Je+9/L8UqeQ3tOnKhxdL8pX83wIy6ocwkucO7ge
	VfFg8rxvc7IGDJPRBcYd3LUEkyEKmXnSfft8j3ItPS/vqo7tZ0kAr4RQxaKWkw
X-Received: by 2002:a17:90b:2644:b0:3a0:f2e1:8af9 with SMTP id 98e67ed59e1d1-3a4f3d124f2mr3588321a91.52.1790920893294;
        Thu, 01 Oct 2026 23:01:33 -0700 (PDT)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc9f721a6afsm519169a12.0.2026.10.01.23.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 23:01:32 -0700 (PDT)
Date: Fri, 2 Oct 2026 15:01:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org, codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu, linux-mm@kvack.org, ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across
 d_alloc_parallel() in d_add_ci()
Message-ID: <ar9IuknaJqrGoF-j@hyunchul-PC02>
References: <20260929034158.1455429-1-neilb@ownmail.net>
 <20260929034158.1455429-2-neilb@ownmail.net>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260929034158.1455429-2-neilb@ownmail.net>

On Tue, Sep 29, 2026 at 01:36:01PM +1000, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> A proposed change will invert the lock ordering between
> d_alloc_parallel() and inode_lock() on the parent.
> When that happens it will not be safe to call d_alloc_parallel() while
> holding the parent lock - even shared.
> 
> We don't need to keep the parent lock held when d_add_ci() is run - the
> VFS doesn't need it as dentry is exclusively held due to
> DCACHE_PAR_LOOKUP and the filesystem has finished its work.
> 
> So drop and reclaim the lock (shared or exclusive as determined by
> LOOKUP_SHARED) to avoid future deadlock.
> 
> Signed-off-by: NeilBrown <neil@brown.name>

For the NTFS part,

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
