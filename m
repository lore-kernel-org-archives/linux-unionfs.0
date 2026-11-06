Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793984035;
	b=aer6y3tkDvQgXEcYHwA0Fyf12HwZBQpLoD+R9aNRGe8SqVClsq7EvKLMh6QIvfHBvP+R
	 AZiVDyV3xMT/7Zgue7iWnrRY+7gZ+6rRBw9CjJnUH0UAt6BPoFOPa7dEi/ZQriyX7zriv
	 SRuzIanQCkobvAUggij+6WrNUgcGBB5xoeMEtMRONRtkRH+ggylWpU+QYkJIT4UsGJ31t
	 Smr0DtSZMaEa5uuqidxM7CJ4yNqEKw1MvpaoNge2vwcm62ja/ztMFwuFG9zCbVepfKRrS
	 PZPI8doW4vwocgcmcS9R/s0G+Ksz3PgAuQKPfbI8uvnDdpdqjytI/Tnhy7PlyVMGldg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793984035;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AG0jNrJz1ZIzn99iYysxWdVpqyd2imosrQ397ggvDJc=;
	b=zO9FRsaT351k8RJ9C8VbtfhSRzHjXbpSlQJVstAXanGHpQWVYn42d7tIfqMgMqRUnp9Z
	 bRPZ3g3IxbLdo1RK9Hz3Vn69Pg8vT0TpNO5EiOsOfKvwNZd3u1HTrkT0u+1loOqEUFaZ6
	 4YU8PZywsglFKnDundPU5qrm0GcMgoJWfFPp8M/xmz+xHrYds43o8bsM+DJqxCdfj+K4+
	 S/Ib19dAMcL/prz0TelnPGdcwm2antSxkQemruS8Yx+rPccWBAD7GQHjykwS+rUGc/yx/
	 LRpLpYEV1vIfmTyliY6bnr0BWG3dvxD4kFH8VYsoIIjkn1NFLJl3N4+idZsQe3XylcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b="fNm/ZUuP";
	arc=none smtp.remote-ip=209.85.160.170
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A886606A32C
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 16:53:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A886606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=fNm/ZUuP
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-537548b811aso5739071cf.3
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 08:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793984033; x=1794588833; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AG0jNrJz1ZIzn99iYysxWdVpqyd2imosrQ397ggvDJc=;
        b=fNm/ZUuPBsjUNtceFUOAljbfiOj9vdSbrqV7Nm5HENgnIe3b8kAupl3fuoEB3VPWQE
         i9FMYCzIiwBSq+yolJGbMcHoPM2fyJmKZ7jpVnPHzw44JDkhgNUavUl+aoBUVIMdueBm
         qEoQLrDLmt5084mt22tQwDwFppEj3sEC9YMDzZ11D0W3w1oOrjJoXW/0togk1J8tgHuw
         5/hZ375AJ0cFVtp0EmNU4sOnjit5EvZjySCNjScTGgZO2IIOpJssHsXRNG6CBMvR32ad
         q2NpM9LtZfWV2kcQmiLaDv46dcXtqeVBJxhS2fmXmOZl4hmnO2smZwn/tRwmkOgm3kNY
         eu9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793984033; x=1794588833;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AG0jNrJz1ZIzn99iYysxWdVpqyd2imosrQ397ggvDJc=;
        b=I/azabltpJn8mrtU43zULhzbOiQgr2Ql0je+fJ73gnwS+MP5L/72YusPYeeSL5ZhQA
         1a/2KxAIjp29atTpFGI6k6BdAXBNpMlal6UMyDgH65RUsBvN8jqSxtem+sOP9qk0uRHT
         4f73CtpsH5zRl5ur5OvlPa4kG5KuMJ58NgKYIXQF15rtJfxDMBMTswp/m1+4GOgE1cqw
         B7kbgqnWrhOyAMtJ/fO52Gdl0G5K5iWN20gBMJK1gnY+bX/c6FZVZyNKX4eUQ0NTiBnq
         Fxx4vyj56kJkTIESdVJ86iwhexELIxBwyXzEeMfUjwFoLfRxuYggjxM/6GBF3/fdeDGT
         42+A==
X-Forwarded-Encrypted: i=1; AKwUvBx6ICpfNoMRuWpA7ImadOgyyYauSfFlST7oETVjfZQEseh8NZDOEn1ODbZcUxGLVPmhzaUa6Ew/zVtwlfo/@vger.kernel.org
X-Gm-Message-State: APuU4Z83Zulr0usZHANkC0FXvNxX1cxsGXXtT8etiLZqYHK3erHDC2TN
	k4VFen1qLiH1w4JEq64p1lIG44+n+kxTNl5D8wl8N/FKaHOquS3mp2pmSO16XhEynaI=
X-Gm-Gg: AYBFou1CSmFXUqcwN6l2LNvNMCD2ATij3U2xhDd1eqfQ1XWORzDC9fUH5XC45QNJlZk
	U0QocQiqO/zQq8++pr5tKDldy3vt3BJ1HM72yc5Gt+pYIEqR6Lk9f4Vi6Yfyc8rZ9QHLmqBL+uj
	gSqmBexHUKvpSdB/qwXHcEN0752sqhv/azEVYXn9be0tF/cVbqPaJZ0Q0bqdzOmP1TFpVscsyia
	+kL8yM4EV6aQhfgAmUm4kiK0LwDzP6aECJZwo/l1wPIaknBFM1gdctrLgM91sx6lCAWUHQbp1Q9
	wCj//rKW6PqH12agnZuFqMQNVJS5XWp+u/T3HKCBTXuBA3G4feeay7mfRUJ7gCHt6SJaU7RjZBP
	g68jtjgAMQTrzhnzrwFb9R97pfl8BqNhGzw5ojEwB1Amc78suxxMXYH108HCo9jCUBjjRnNIjeD
	hTIxqhVZY1bDNdRcFTnR8tyGBg8KuEXK1TQaoB0bX0zsByuzRc1kQOXO82SlEeR2+2zlU0ccINF
	Kk09F3rKgX97CfTu31UkxrnppGDklWaeq/Tem5aXZw1NuKK/H7Jq6HWnCvvs3u2Xsja//Dc4108
	ZT/kNOutlBzbZtsisPBwzLHtRy7wAVfVYxPYKJmfX7jS+g==
X-Received: by 2002:a05:622a:418b:b0:535:b506:11e8 with SMTP id d75a77b69052e-54e0d35a069mr48834131cf.0.1793984033239;
        Fri, 06 Nov 2026 08:53:53 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e257862a6sm24440811cf.8.2026.11.06.08.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 08:53:52 -0800 (PST)
Date: Fri, 06 Nov 2026 16:53:51 +0000
Message-ID: <5ba0cd611f787673e219509aba8b81a0.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>,
 Chengguang Xu <cgxu519@mykernel.net>,
 Chengguang Xu <charliecgxu@tencent.com>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] ovl: only sync what was written through the
 overlay
In-Reply-To: <20261106-nebel-fragment-normierung-84511a5676d9@brauner>
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
 <20261106-nebel-fragment-normierung-84511a5676d9@brauner>
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
Content-Transfer-Encoding: 7bit

On Fri, Nov 06, 2026 at 04:32:50PM +0100, Christian Brauner wrote:
> The thing that's a bit ugly is that overlayfs open-codes the tail of
> sync_filesystems(): ovl_sync_fs() calling upper_sb->s_op->sync_fs() and
> sync_blockdev() itself is one more place that needs to know what
> sync_filesystem() does.
>
> So we should probably add a helper to fs/sync.c for the ->sync_fs() and
> block device part and use that.

v4 went out a couple of hours before this, it only swaps in v2 of Amir's
patch, so all of this applies to it as well.

I've added sync_fs_and_bdev(sb, wait) for v5, sync_filesystem() calls it
twice and ovl_sync_fs() once.

> Eheeeem, isn't that kind of a bad proxy for this? What ->sync_fs() +
> block device do is a property of the upper filesystems and how is that
> related to RENAME_WHITEOUT? There's a few counter examples you even
> give:

[...]

> So on ubifs a syncfs() in relaxed mode returns with metadata still in
> memory. Meh. I know the flag got droppped but that was an overlayfs
> speicfic thing. A generic property of ->sync_fs() is a different thing?

I dropped the flag after v1 because nobody liked it, me included, and I
don't want to touch every file system for this.

What relaxed leaves to ->sync_fs() and the block device is only the
upper inodes that have no overlay inode, that's whiteouts and the work
directories. With creation fixed (below) everything else is on the dirty
list and gets written.

For the file systems that pass the probe: ext4, xfs and btrfs log all
metadata. ext4 without a journal has it in the buffers of the block
device, which we write. f2fs writes its dirty inodes in the checkpoint,
f2fs_sync_inode_meta(). ubifs writes names, whiteouts and links to its
journal when they are made, only setattr leaves an inode dirty in the
VFS. The only setattr overlayfs does on an inode it doesn't track is the
chmod of the work directory to 0 at mount time, right after it was
created with mode 0. That's the counter example from the cover letter,
and it's the only one I could find.

Anybody who needs more than that has fsync=on and fsync=strict, which
sync the whole upper file system like before.

> Afaict, creation isn't covered. ovl_instantiate() ends up in
> ovl_inode_init() which now uses __ovl_copyattr(). So a new file,
> directory, symlink or hardlink only dirties the parent but not the new
> overlay inode.
>
> Fine for metadata, but a long symlink isn't metadata. We should mark the
> new inode dirty where it's instantiated.

Yup, ovl_instantiate() marks it in v5. Nothing gets lost today, ext4
journals the block of a long symlink, xfs logs it, btrfs has it in the
tree and f2fs writes it in f2fs_symlink(), but we shouldn't depend on
that. I've added a long symlink to the fstest.

> * ovl_park_inode() calls mark_inode_dirty_sync(). Jan's deferred inode
>   reclaim (cf. [1]) removes exactly that from iput() because it does IO
>   from dentry reclaim.
>
>   He replaces it with queue_dirtytime_writeback(). That moves the inode
>   to the head of b_dirty_time and wakes the flusher.
>
> So it would be nice if we could base your thing on top of Jan's series
> (I hope he'll send v2 soon!) and call queue_dirtytime_writeback() thing.

The one in ovl_park_inode() is called from ->write_inode(), not from
iput(), and it's on the overlay inode, which has no ->dirty_inode(), so
it only moves it to another list.

The one that does IO from dentry reclaim is iput() of an overlay inode
with I_DIRTY_TIME, that's sync_lazytime() -> ovl_sync_lazytime() ->
mark_inode_dirty_sync(upper). Jan's patch 2 takes that out of iput(), so
it goes away without any change on my side, and then using
queue_dirtytime_writeback() in ovl_park_inode() makes sense too. It
would have to be exported for that.

I only need patches 1 and 2 of that series, and they don't depend on the
rest of it. Jan, could those two go in ahead of the deferred reclaim
part? Then I'll rebase on top of them. Otherwise I'd rather do this as a
follow up than wait for the whole thing.

> > An overlay inode that loses its last reference while it is dirty is
> > kept until it has been written and then sits on the LRU, like with
> > any other file system.
>
> Hm, Jan's series fixes that as well afaict. :)

I don't see how, what am I missing? overlayfs has inode_just_drop() for
->drop_inode(), so a dirty overlay inode is evicted on the last iput()
and we forget that the upper inode has to be written. Patch 6 keeps it
around until it's clean.

> There's some Sashiko thing btw you should look into?

The only mails I got from it are on v1, those are fixed since v2, except
for dirtied_time_when of a parked inode, which I left alone on purpose,
it's in the v2 changelog. Thanks,

Josef
