Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.171.160.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795081639;
	b=sZs5QIUb38Fjgpe5WQ80j1rAA0dwnl6T5nyynqz8ZlW6EPhpihY2SoZuI4w7H+G3n8KH
	 32RG/hSRM6hpD69k7s+EGk8jeZg6ta5obqWXNBxAWIBSN5xfFg+mNLOwhDVwcyT7MsW1m
	 CHPhOBK//xNj0YvFitR3dogBm/5RD87Ci/tfTUAfP9rVtheXAPDs8NFtEivYeLTwBYoR8
	 F1ww0jkG5ehwmr5nwnMeIELcQjLW3ayQGKh4D5UwNiRzhH0ytGhpsW6XCpZwC73EW0vVR
	 l2YIXQVKT2rkPVFP1IbD/f22kf/PRmSWAKhtcmOVHKXTKDlDjroIRUqe76EknNpDbzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795081639;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 User-Agent:MIME-Version:Content-Type;
	bh=WBEHu4DEjCVhl6ZgliAFGwGo+qGlwuitZqHdVLEx500=;
	b=SRVG4U2FcNIqHDvGzG3rBda9p65m7n8oBjLnxZVEVX4+gQ/uAabP84l75wsu6r/B85yg
	 u7cjFuLZrbHp+QG/BhhkekA/axM3MZNQQB5fs6odwxMgXiN/TzRNMQcKya9qcUDpFzBUN
	 6afouLkrcU/oLF9c3fjk2wXnH5XoUOopPicN5/bCWqgLwjX2tVN5J8DARthJey6oTfr41
	 g3+I7Wj5JCHhEiyoszpVlAYx7NDf7Ma9SW3Cd3a6wxMwR19322DI4QrzejedfWEntn5MV
	 tBiRnLUwiIanFgA84UdbYzUz31+JwV3PrHOOtd+PUgNHuWLMhsWjRP+7vy9zxUDJI6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.parknet.co.jp;
	spf=pass smtp.mailfrom=parknet.co.jp;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=rsa-sha256 header.s=20250114 header.b=JilNpQL1;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=ed25519-sha256 header.s=20250114-ed25519 header.b=lPuSvrgM;
	arc=none smtp.remote-ip=210.171.160.6
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BDA606A320;
	Thu, 19 Nov 2026 09:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81BDA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=parknet.co.jp header.i=@parknet.co.jp header.a=rsa-sha256 header.s=20250114 header.b=JilNpQL1;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=ed25519-sha256 header.s=20250114-ed25519 header.b=lPuSvrgM
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id C50EA20BD290;
	Thu, 19 Nov 2026 18:47:09 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1795081630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WBEHu4DEjCVhl6ZgliAFGwGo+qGlwuitZqHdVLEx500=;
	b=JilNpQL1nULap2pu/am5a4KDJ8SNNA/RVzZad04e3FW7DUv7X9TmxhCd6Z7pBK3VgQ7ohd
	FeEDWqmbCuLMbD4fpavsLYYWbqoZNtnWWF7zi45HoD7WtyoQenL0hntUXdshYvbDh8Wbts
	rRpWqXHXdp2GLmkIQdAABgVflUQNH/vzz2yg1u3LVfNUO3wZOveK2asPkHXnPt3Zt8GB1q
	NOzNeIEAl81xXE27MbXm/DdCQVgrP2uJXY9bXzBsrQ2QqEErnn6BP73kPA3Bq/f1iU5xCe
	z9QvLuqOcumsbGiTVVK2kuXN/fVut1t0idx3KfkS10S8IR3udgBT8OBVPgKccw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1795081630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WBEHu4DEjCVhl6ZgliAFGwGo+qGlwuitZqHdVLEx500=;
	b=lPuSvrgM3hY/v56M6B7pzn9LwgkJFDa70v7PEJdxEARMRDh8vJBFyLBgwWJjeEotqC7MGv
	0IuMNIJPn9vCD6DA==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 362DDE00181;
	Thu, 19 Nov 2026 18:47:09 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 2D0B92200214; Thu, 19 Nov 2026 18:47:09 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>,  Miklos Szeredi <miklos@szeredi.hu>,
  Amir Goldstein <amir73il@gmail.com>,  Christian Brauner
 <brauner@kernel.org>,  Alexander Viro <viro@zeniv.linux.org.uk>,
  Christoph Hellwig <hch@infradead.org>,  Chris Mason <mason@kernel.org>,
  Chengguang Xu <cgxu519@mykernel.net>,  linux-unionfs@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/7] fs: add write_inode_for_sync()
In-Reply-To: <vafoz7tqboipgnsotuqbv27a2ywgiihbxqtlbegctyoygfbi7a@i4gmvgmj7wnd>
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
	<20261118-b4-ovl-containerized-sync-v7-4-54f45743fe55@toxicpanda.com>
	<vafoz7tqboipgnsotuqbv27a2ywgiihbxqtlbegctyoygfbi7a@i4gmvgmj7wnd>
Date: Thu, 19 Nov 2026 18:47:09 +0900
Message-ID: <87a4n517c2.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

> On Wed 18-11-26 17:03:27, Josef Bacik wrote:
>> sync_inodes_sb() has the flusher write every dirty inode of a superblock
>> with WB_SYNC_ALL and for_sync set.  That writes the pages without waiting
>> for them, hands over the timestamps that lazytime has deferred while it
>> holds I_SYNC, and calls ->write_inode() in a way that tells the filesystem
>> that ->sync_fs() follows, so ext4 does not commit a transaction for every
>> inode.
>> 
>> overlayfs is about to sync some of the inodes of its upper filesystem, and
>> none of the exported functions does that for one inode.  write_inode_now()
>> and sync_inode_metadata() either do not wait for somebody else who is
>> writing the inode and leave deferred timestamps alone, or they wait for the
>> pages, clear the error flags of the mapping and make ext4 commit.
>> 
>> Add a function that writes one inode the way a sync does.
>> 
>> Nothing calls it yet.
>> 
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>
> Looks good. Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
> Actually Ogawa wanted the very same function for FAT flushing of dirty data
> on close so it looks like a generally useful primitive to have. Just the
> description of the function is really hard to parse (at least to me as a
> non-native speaker). 
>
>> +/**
>> + * write_inode_for_sync - write an inode like a sync of its filesystem does
>> + * @inode: inode to write to disk
>> + *
>> + * This does for one inode what sync_inodes_sb() has the flusher do for every
>> + * dirty inode of a superblock.  It writes all dirty pages, the timestamps that
>> + * lazytime has deferred and the inode.  It waits for somebody else who is
>> + * writing the inode, but not for the pages it writes, and it does not ask the
>> + * filesystem to commit anything.
>> + *
>> + * This is for a caller that syncs some of the inodes of a filesystem.  It has
>> + * to wait for the pages with filemap_fdatawait_keep_errors(), like
>> + * wait_sb_inodes() does, and to call sync_fs_and_bdev() in the end.
>
> I'd write:
> This writes out inode like e.g. sync(2) would do it. On high level that
> means we make sure anything dirty is submitted to the storage but we don't
> wait for any completion. In particular, it means we wait if there's
> somebody else submitting writeback for the inode (I_SYNC state set), we
> make sure all dirty pages are submitted for writeback waiting for locks,
> and we treat the inode as dirty if it has dirty timestamps. However we
> don't wait for any IO to complete and we don't persist other inode-related
> metadata through ->sync_inode_metadata(). If the caller wants data
> persistency guarantee, it has to wait for IO completion (e.g. using
> filemap_fdatawait_keep_errors()) and also persist common filesystem
> metadata using sync_fs_and_bdev().

Looks good (except the name of function though). What I want is, not
emulate sync, it is flushing dirty stuff. Now both are same usage
though, may not be same by future changes.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
