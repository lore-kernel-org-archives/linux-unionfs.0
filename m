Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792468532;
	b=ItXNdKSPViyfWYq34FkvMddEIkWjlhyeAN1nQ9Q6cFE2+kwn/xlwm6JQHVn9fGqy5u16
	 7fNjGCnHbLwuqFgQPwByEquVR0GjrUBd/HjfdzfZewJAAjn6DE7N6gCoKvUrhwVkQuLKE
	 epiOh1z9suC0CJExdfG7m0Tle2QF9RDxMeeqazOhwYsgNOqNPv7je4LFLliJEjUruvYsp
	 3wHVkf/INPL40nshaYNoqNOt+0dwA/t5afSEa4hrVtYwNpFmCXZCaSKMVoDTs6VyzYT6l
	 iAuBpx0Z6Mwwo2kkqIRVVJdxivgIwHhBDemTVN/YPDT5lx5Tf6vUMV5lTzmXQi4x6Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468532;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=WRL+U2GtPXLd9M9soIL/RdABtXtQzxJ+R6mcoH5x5Uk=;
	b=FMzZ55AtqfwNad6jWQj/HBUZ5L/xq4Wc3MzAmw7edqeI8zP5mJYtGn5Ysm1UCyyioMQ2
	 BzIASKeHST4lFfVggWs0AzwNc4T6tokzIXjYswkXUMHynTpIOuIdh3KdyMy/aO9nKUI6y
	 psV2aQuDM6tE/5c+Ezp8wioBLVptkCi56jyaKFDk69ZLWTpsdGW0JxtVJxjTvT4jfah8g
	 Jg98bY7USV9nuwTLw864m9H+HzVndM5bJi2xM+1nY7i6U/d5f3lxbxsSTt1sITJxloV8L
	 atCt9+phfcMyGT2EV9SiIAYY6j2+adXSgklKhxa1ks9o+oMCxNHD/A+ziaqQGZbiMBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=jLxktzrj;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87C6606A31C
	for <linux-unionfs@vger.kernel.org>; Tue, 20 Oct 2026 03:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E87C6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=jLxktzrj
Received: from macsyma.thunk.org (pool-173-48-113-115.bstnma.fios.verizon.net [173.48.113.115])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69K3tInV024476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 23:55:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1792468522; bh=WRL+U2GtPXLd9M9soIL/RdABtXtQzxJ+R6mcoH5x5Uk=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=jLxktzrjCe5UOWn4TudGdJzD1cosG/zRL72ghT8NtJGoJCAFe1Y5GDErOH/M9dC9u
	 7HAms5kTBPifNJhxWb9yHNvOh4SgcqgDnHfR9F6UI9/+GlGDUFiLreWxQH7FDdSRLq
	 qfAJto+h54zQlm2Q4OvgPf5fJODQc8HEaW18zKIOOhtiBY64vSYNBAf1hCYInsXTRn
	 6MeauEXgMUUJE2gbtyA6f8wSM9h1eOBgKpB50oqW87+wBFh++vBmKSWfH3FxxQoUF5
	 wUDuRctDktxaHPmxgvC7yZ64uA+Fv7gilZ66wkjLJCA4emGu+0YyWfLR1Bi4+19skg
	 k502nAxjl5zew==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id AAD2D21B0CD7; Mon, 19 Oct 2026 23:54:18 -0400 (EDT)
Date: Mon, 19 Oct 2026 23:54:18 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Claudio Fernando Pinto <claudiofernandopinto@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org
Subject: Re: overlayfs: unprivileged writes can use ext4's reserved blocks
 with the default resuid
Message-ID: <atbfAjLsKxhkqW-q@mit.edu>
References: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>

On Mon, Oct 19, 2026 at 06:03:17AM -0500, Claudio Fernando Pinto wrote:
> Hello,
> 
> ovl_fill_super() lowers CAP_SYS_RESOURCE in the creator credentials with
> the comment "Never override disk quota limits or use reserved space"
> (fs/overlayfs/super.c:1511 in v7.3-rc7). On an ext4 upper with the
> default reserve owner, the second half does not hold:
> ext4_has_free_clusters() grants the reserve when the allocating task's
> fsuid equals s_resuid, 0 by default, before it looks at the capability
> (fs/ext4/balloc.c:654-657). Writes through overlayfs run with the
> mounter's credentials (ovl_write_iter() sets .cred = ovl_creds(sb) and
> backing_file_write_iter() applies it), so with a root mounter the fsuid
> that reaches ext4 is 0, and an unprivileged writer can spend the blocks
> reserved for root.

I'm not sure why overlayfs is trying to override disk quota limits.
What's the background behind this?

	/* Never override disk quota limits or use reserved space */
	cap_lower(creator_cred->cap_effective, CAP_SYS_RESOURCE);

More the point, why do we have creator_cred in the first place?  We're
not lowering CAP_FOWNER or CAP_DAC_OVERRIDE and fsuid is 0.  So if
we're allowing some file system operations with the mounter's creds,
why is CAP_SYS_RESOURCE special?  Also note that if fsuid is 0, then
regardless of CAP_SYS_RESOURCE, any writes will be charged against
user 0's quota, and user 0 doesn't have any limits (often it doesn't)
there won't be any disk quota limits anyway.

						- Ted
