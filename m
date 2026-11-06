Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979176;
	b=iUWo9aWP/9N+N0VM/gNLr/k8VPU+VXyY6jBaF11OKs23CdFk/CVtWMkNxfWUfayr4Eec
	 HzAlQEssVj9EpTZdLvV31W0Drdxo4K9Uc65ZFvHqjIbx61m7dFjkkURt8LeczfiGJtPo3
	 usUS/e//Qerhdxi6ttsmLy5gYCBDMRlGMh27geD0KH+zwV+cE0DsNS8bs5NWNb+zeZhWw
	 Ln/Wmk1XD7KxuiC0IuvKB6+IwbK+LgnjAHwiSTL+NQib39z1D2jKZAJfRbnW/1mszmJ4z
	 JkPZ73BzWz0eqJhKOHYTpSi7RQ4tEvqoDwdd9GgtoGvbXPPNftjlIVpXrhdBNA3Yv1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979176;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=eLtekCGTZ1g1kqoapv9CXM8EnGYDkmS19HQmDBxtEYo=;
	b=BJJJzYk7CL8nUSnLqqfJoa91RZB1k7XwqdXtbQoDoXOcfRkt/jwmCH/7LBqQzbcLHx6+
	 VFvx/5158dxOuo382tc/DGW37FuTw0nZqFR3uyJnw/NHyT+6svQhftwxrHnX8u59SQix+
	 4CprWZhTM3MuiyDsA42HR3BM6wWEZI0jOxDfMTZQt426TElX4eEn42Q4DuiIweGyQ24ao
	 QktJ7ZNhoRctW0CS+PuQ335RYTjUBvyW8MPbAVZy0uQh9mwkOZy2yuTtaIupxwFg1c3vM
	 1FYJw3pyd3114OtcDx/pe760nSMVmw7x/mCccVS34THNUplyrYtzconivgI/Wgpedjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNtKTuox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEB8606A32C;
	Fri,  6 Nov 2026 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNtKTuox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B951F0089F;
	Fri,  6 Nov 2026 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793979176;
	bh=eLtekCGTZ1g1kqoapv9CXM8EnGYDkmS19HQmDBxtEYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hNtKTuoxF5Xot6G9Kno0HmZ04rR42QoPUo6Se28hYZkya+p0GKuoA7XSeAAhJEBdr
	 qBYjqJZK3NzyzP9G7L4Yt/L7ZQQE+ROMQCXC8Zt9qOWuqYZmg1GDENWxUjt1skNdWn
	 K8JdF73p4Haih1iXXQTJsr+TCOqliVktPWIOOJ23UfLO/PC5ZSP3hDcXgbn5j7L4uF
	 I2to/6bgKSKfsGMI1jdfTicTzJcsYJP59VF595JQYHchB7X5fzwsmWMyD7oyZHitxw
	 ZUZgXCvYX8TPBQGsZ6Ug9dNZ1AWHehnFHsXTsFphp65ZwuTz2itIgkXoB7elr8n8HP
	 misg8d7nX4oSQ==
Date: Fri, 6 Nov 2026 16:32:50 +0100
From: Christian Brauner <brauner@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Chris Mason <mason@kernel.org>, Chengguang Xu <cgxu519@mykernel.net>, 
	Chengguang Xu <charliecgxu@tencent.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] ovl: only sync what was written through the
 overlay
Message-ID: <20261106-nebel-fragment-normierung-84511a5676d9@brauner>
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>

On Wed, Nov 04, 2026 at 08:44:57PM +0000, Josef Bacik wrote:
> sync_filesystem() writes every inode on a dirty list, calls ->sync_fs()
> and writes the block device. Only the first step is expensive, because
> of other people's data. With fsync=relaxed overlayfs writes the upper
> inodes whose overlay inode was marked dirty and does the other two steps
> as they are.

I think that makes sense.

The thing that's a bit ugly is that overlayfs open-codes the tail of
sync_filesystems(): ovl_sync_fs() calling upper_sb->s_op->sync_fs() and
sync_blockdev() itself is one more place that needs to know what
sync_filesystem() does.

So we should probably add a helper to fs/sync.c for the ->sync_fs() and
block device part and use that.

> fsync=auto, the default, picks relaxed if the upper file system supports
> RENAME_WHITEOUT.

Eheeeem, isn't that kind of a bad proxy for this? What ->sync_fs() +
block device do is a property of the upper filesystems and how is that
related to RENAME_WHITEOUT? There's a few counter examples you even
give:

>  - f2fs, ubifs, fuse and tmpfs get relaxed as well and I didn't test
>    them. ubifs_sync_fs() doesn't write dirty inodes, so a chmod of the
>    work directory at mount time waits for the flusher there.

So on ubifs a syncfs() in relaxed mode returns with metadata still in
memory. Meh. I know the flag got droppped but that was an overlayfs
speicfic thing. A generic property of ->sync_fs() is a different thing?

> Now an overlay inode is marked dirty when the upper inode is changed,
> mostly from ovl_copyattr() as Amir and Miklos suggested.

Afaict, creation isn't covered. ovl_instantiate() ends up in
ovl_inode_init() which now uses __ovl_copyattr(). So a new file,
directory, symlink or hardlink only dirties the parent but not the new
overlay inode.

Fine for metadata, but a long symlink isn't metadata. We should mark the
new inode dirty where it's instantiated.

> lazytime on the upper file system needs its own handling. The flusher
> leaves the timestamps in memory for up to 12 hours, so the overlay inode
> can't be clean, but it can't stay dirty and pinned for that long either.
> Patch 9 gives it I_DIRTY_TIME like the upper inode has, and forwards
> ->sync_lazytime() to the upper inode.

Parking the overlay inode with I_DIRTY_TIME is fine?

So from what I could research:

* ovl_park_inode() calls mark_inode_dirty_sync(). Jan's deferred inode
  reclaim (cf. [1]) removes exactly that from iput() because it does IO
  from dentry reclaim.

  He replaces it with queue_dirtytime_writeback(). That moves the inode
  to the head of b_dirty_time and wakes the flusher.

So it would be nice if we could base your thing on top of Jan's series
(I hope he'll send v2 soon!) and call queue_dirtytime_writeback() thing.

> An overlay inode that loses its last reference while it is dirty is
> kept until it has been written and then sits on the LRU, like with
> any other file system.

Hm, Jan's series fixes that as well afaict. :)

There's some Sashiko thing btw you should look into?

[1]: https://lore.kernel.org/r/20261009133253.20102-1-jack@suse.cz

-- 
