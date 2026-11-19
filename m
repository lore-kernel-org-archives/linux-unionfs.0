Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.171.160.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795085920;
	b=IGF17+Q70sYRRHvh62fn6VdGczAghtjCk/NPPeMb0a2kJVUrlh0bQx7WOaINnbQsan2U
	 rirMhHCEP9kjyj2SbuhU9tof5hsnO5QT50F3zcyupsYzdv8wQguUhajhm0t7l282N7JiD
	 lLXZvcWoEtCRbeTmi0wlcnAaVrK7yL5o5uZkt44TuMPEqxIvMgAE/j0tKHzuZuJLL+syt
	 RBYgISJcekSZ4n7diiYeXwk+cTGrLxazCsz0L/0TIt0ZjfPZdaeNAwQKQU8J/jt78lPCf
	 sV8ZtxolFVyMuEqVR57aYnxAUVPcYMklq5N/o0WpIB9lH5HvFn0sZMfZ45K7NxtPVPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795085920;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 User-Agent:MIME-Version:Content-Type;
	bh=eu8s7ba4whbxVZt98CCqbePfX8He1ghLwLHh7HUZVOQ=;
	b=j5vb22OlZIlmaDBqrl2Uy8lph9Nrb6Y8s9uQpVQPPnbv/ZoahM/PrDFjrg63YJU1RrMX
	 0TNL1gbx0Jc54UHi7QIK4jBu8if5g1A1nw5F78ZN/95e9qZeBwGdmUPB199Wvfn9rwxWk
	 eIzONefRnJvlR3XB9UayQ/Bo4XyWyFz7zH9Obu83spwoOam/OEONe0RXi9IBC2/E6Jdld
	 WhA98Z241szAqGV7DE4FwVD5fSbrzIX5H4I+CtYMQUmcaOs72fi+z7/V0mFw+3ASuH0gM
	 1NOMoOZLfqaFMpzH9K8GXaphMxNdj6P3kORXOPJayFDW4EICN9ARehp/Uw9x4kBWNJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.parknet.co.jp;
	spf=pass smtp.mailfrom=parknet.co.jp;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=rsa-sha256 header.s=20250114 header.b=KYekbOUE;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=ed25519-sha256 header.s=20250114-ed25519 header.b=E9BT3gtc;
	arc=none smtp.remote-ip=210.171.160.6
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07EA606A320;
	Thu, 19 Nov 2026 10:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C07EA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.a=rsa-sha256 header.s=20250114 header.b=KYekbOUE;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=ed25519-sha256 header.s=20250114-ed25519 header.b=E9BT3gtc
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 90D1420BD290;
	Thu, 19 Nov 2026 19:58:35 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1795085915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eu8s7ba4whbxVZt98CCqbePfX8He1ghLwLHh7HUZVOQ=;
	b=KYekbOUEPhJ5XxSPyxzVUJQJ+UIEHq0O0y0GXTSD5eLcv8HXCU2UaM0bZ9zQxTPcgQ1VSv
	V6qx1Ku9+OH/fFnMzgS3wYxXo0skzRKsbF1AuzAqASQKzXwuNfLCEcIX1uyhwHwUb89qVv
	+399XMaOId4KS2PMsf6WlkIFWoZ63nr1IDkKl3krJBg1qyYLzq+EeEjtTEE4VA1Hqk550e
	rZVJEI+zmfJvO+l53eSmeKCa8qtZpzkgNo03DUn9rJWO++L16qmpluTmLLieR2djAJNzRp
	ffY+hPR1afF91S2kMnV050DmtkLnmHcdgCN2a0nYd3Y51M1Y7QKgqitQFqt/8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1795085915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eu8s7ba4whbxVZt98CCqbePfX8He1ghLwLHh7HUZVOQ=;
	b=E9BT3gtcRFyXVnIif6ZyBLF8gdOPGA1huyUO29ZxEMSX+cmz2M+dWEd4nMiSlV8vJTwJQc
	ksXqe4+XVahjfBAw==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 1552CE00181;
	Thu, 19 Nov 2026 19:58:35 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 0D55F220021A; Thu, 19 Nov 2026 19:58:35 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>,  Miklos Szeredi <miklos@szeredi.hu>,
  Amir Goldstein <amir73il@gmail.com>,  Christian Brauner
 <brauner@kernel.org>,  Alexander Viro <viro@zeniv.linux.org.uk>,
  Christoph Hellwig <hch@infradead.org>,  Chris Mason <mason@kernel.org>,
  Chengguang Xu <cgxu519@mykernel.net>,  linux-unionfs@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/7] fs: add write_inode_for_sync()
In-Reply-To: <2z4x35murtwkmuzosciww63z4hfnnaefitc5qinzazvq4pr7qb@uor7pldovwan>
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
	<20261118-b4-ovl-containerized-sync-v7-4-54f45743fe55@toxicpanda.com>
	<vafoz7tqboipgnsotuqbv27a2ywgiihbxqtlbegctyoygfbi7a@i4gmvgmj7wnd>
	<87a4n517c2.fsf@mail.parknet.co.jp>
	<2z4x35murtwkmuzosciww63z4hfnnaefitc5qinzazvq4pr7qb@uor7pldovwan>
Date: Thu, 19 Nov 2026 19:58:35 +0900
Message-ID: <875wxt1410.fsf@mail.parknet.co.jp>
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

> On Thu 19-11-26 18:47:09, OGAWA Hirofumi wrote:
>> Jan Kara <jack@suse.cz> writes:
>> 
>> > On Wed 18-11-26 17:03:27, Josef Bacik wrote:
>> >> sync_inodes_sb() has the flusher write every dirty inode of a superblock
>> >> with WB_SYNC_ALL and for_sync set.  That writes the pages without waiting
>> >> for them, hands over the timestamps that lazytime has deferred while it
>> >> holds I_SYNC, and calls ->write_inode() in a way that tells the filesystem
>> >> that ->sync_fs() follows, so ext4 does not commit a transaction for every
>> >> inode.
>> >> 
>> >> overlayfs is about to sync some of the inodes of its upper filesystem, and
>> >> none of the exported functions does that for one inode.  write_inode_now()
>> >> and sync_inode_metadata() either do not wait for somebody else who is
>> >> writing the inode and leave deferred timestamps alone, or they wait for the
>> >> pages, clear the error flags of the mapping and make ext4 commit.
>> >> 
>> >> Add a function that writes one inode the way a sync does.
>> >> 
>> >> Nothing calls it yet.
>> >> 
>> >> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> >
>> > Looks good. Feel free to add:
>> >
>> > Reviewed-by: Jan Kara <jack@suse.cz>
>> >
>> > Actually Ogawa wanted the very same function for FAT flushing of dirty data
>> > on close so it looks like a generally useful primitive to have. Just the
>> > description of the function is really hard to parse (at least to me as a
>> > non-native speaker). 
>> >
>> >> +/**
>> >> + * write_inode_for_sync - write an inode like a sync of its filesystem does
>> >> + * @inode: inode to write to disk
>> >> + *
>> >> + * This does for one inode what sync_inodes_sb() has the flusher do for every
>> >> + * dirty inode of a superblock.  It writes all dirty pages, the timestamps that
>> >> + * lazytime has deferred and the inode.  It waits for somebody else who is
>> >> + * writing the inode, but not for the pages it writes, and it does not ask the
>> >> + * filesystem to commit anything.
>> >> + *
>> >> + * This is for a caller that syncs some of the inodes of a filesystem.  It has
>> >> + * to wait for the pages with filemap_fdatawait_keep_errors(), like
>> >> + * wait_sb_inodes() does, and to call sync_fs_and_bdev() in the end.
>> >
>> > I'd write:
>> > This writes out inode like e.g. sync(2) would do it. On high level that
>> > means we make sure anything dirty is submitted to the storage but we don't
>> > wait for any completion. In particular, it means we wait if there's
>> > somebody else submitting writeback for the inode (I_SYNC state set), we
>> > make sure all dirty pages are submitted for writeback waiting for locks,
>> > and we treat the inode as dirty if it has dirty timestamps. However we
>> > don't wait for any IO to complete and we don't persist other inode-related
>> > metadata through ->sync_inode_metadata(). If the caller wants data
>> > persistency guarantee, it has to wait for IO completion (e.g. using
>> > filemap_fdatawait_keep_errors()) and also persist common filesystem
>> > metadata using sync_fs_and_bdev().
>> 
>> Looks good (except the name of function though). What I want is, not
>> emulate sync, it is flushing dirty stuff. Now both are same usage
>> though, may not be same by future changes.
>
> The intention behind both users is "reliably submit everything for IO but
> don't wait for IO completion". So I think they overlap not only in the
> implementation and there's good chance they won't diverge...

Possible. However, current implementation is unclear name and boolean
.for_sync. Not combination of clear flags, so it is also possible to
introduce unintended code for flush via sync changes.

Well, anyway, what I wanted is make it clear for future developers.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
