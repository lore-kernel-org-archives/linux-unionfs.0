Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082390;
	b=DEUCrLQ9BVrBkn+qpfkyr4L75wrNs6rF79ykt7k1efg+IIF3g3TclJEPLQsy++YwM/3Y
	 lKxLedv0DsLrqjSj23soSGRSV5sNQsHnAb2HgVviyPKtz3vRmfKu+WzO7to1xbQKeOf+m
	 zjTh04y/y7BzWH9RtykOPedOzU1iLIct+XDis2z7saRmF84aqJqNlv4/qSf2dtXLVobY8
	 IooAwXiBlwbwqyRYAMclQwPIIjoTY3Iy+S2QIhQLjZT78+aoffjNaQIChGQIP8lhDBn98
	 oSvTKHr2lDMDzUAvI8MRMVb1bfUkUpnSSQhnArx1Qi69pXeYCTxA4YwrDnZPWqPOlVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082390;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=aiYHDIZQ5jG3jQ7j7MP9rOiLFvmE1F2pL6ubbq+jFP0=;
	b=vLPDmexS/jqnppvPEUtZ9keDBF9YfrpWEiZUrMHVC2Ofo2YgXS+qk9k1M6ct+BAet/dn
	 TetwKMLEma9mL56yB4c7r8deCYLCAeKumdp7uraSG/3BNjPGzXwDBTUUskH8FgTaITXfW
	 A1vN0YSiB2pQ7MFgxlRCzwxbZY/ujvI5GbyZ+xU4ujioON97RzWk07HE9AF0Ms3fGCovo
	 bRU0LRYb+aOhGRe22yeAQ/jydyxN6/5T4e1IB05y8JJZ36XjkhlZhIOVlRetBCu0TM/Qo
	 Bzv9CJANYnZ0lyZa0JTtKhVifIOelDHE5lTQT6Cr4ACwIpCEDZhWJ7/aHbW8/0Bd+7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="qp/ekXOo";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WBdYquTk;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="qp/ekXOo";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WBdYquTk;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF446606A320;
	Thu, 19 Nov 2026 09:59:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF446606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qp/ekXOo;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WBdYquTk;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qp/ekXOo;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WBdYquTk
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BE46C1F452;
	Thu, 19 Nov 2026 09:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795082387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aiYHDIZQ5jG3jQ7j7MP9rOiLFvmE1F2pL6ubbq+jFP0=;
	b=qp/ekXOoI+oc19f1oRzBP+xzJfoMbCMjV2uDxep5WeIVXDR84eV/6n0j5wMXktZlhy/jAL
	jAEpizOQTiPKKAgcK7WfRrEqNyH71ZICqihMVpGsBfcCi9fRtKy1mC5H7Dxy+Sl784wa+8
	jGjWvn6WWrT+x61qvg3BngRdSsXArJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795082387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aiYHDIZQ5jG3jQ7j7MP9rOiLFvmE1F2pL6ubbq+jFP0=;
	b=WBdYquTkyQCY6u25V0p0siNyPtty2Ved3MFpHUZLh4gMQTGjs8WBZEGV7drmeK1Tp9aI7B
	LLYPx/Y2kVNBjDDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qp/ekXOo";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WBdYquTk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795082387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aiYHDIZQ5jG3jQ7j7MP9rOiLFvmE1F2pL6ubbq+jFP0=;
	b=qp/ekXOoI+oc19f1oRzBP+xzJfoMbCMjV2uDxep5WeIVXDR84eV/6n0j5wMXktZlhy/jAL
	jAEpizOQTiPKKAgcK7WfRrEqNyH71ZICqihMVpGsBfcCi9fRtKy1mC5H7Dxy+Sl784wa+8
	jGjWvn6WWrT+x61qvg3BngRdSsXArJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795082387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aiYHDIZQ5jG3jQ7j7MP9rOiLFvmE1F2pL6ubbq+jFP0=;
	b=WBdYquTkyQCY6u25V0p0siNyPtty2Ved3MFpHUZLh4gMQTGjs8WBZEGV7drmeK1Tp9aI7B
	LLYPx/Y2kVNBjDDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 942831334C;
	Thu, 19 Nov 2026 09:59:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rdCMG5PI/mricAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Nov 2026 09:59:47 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 1F1ED2518E; Thu, 19 Nov 2026 10:59:47 +0100 (CET)
Date: Thu, 19 Nov 2026 10:59:47 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, Josef Bacik <josef@toxicpanda.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/7] fs: add write_inode_for_sync()
Message-ID: <2z4x35murtwkmuzosciww63z4hfnnaefitc5qinzazvq4pr7qb@uor7pldovwan>
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
 <20261118-b4-ovl-containerized-sync-v7-4-54f45743fe55@toxicpanda.com>
 <vafoz7tqboipgnsotuqbv27a2ywgiihbxqtlbegctyoygfbi7a@i4gmvgmj7wnd>
 <87a4n517c2.fsf@mail.parknet.co.jp>
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
In-Reply-To: <87a4n517c2.fsf@mail.parknet.co.jp>
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,toxicpanda.com,szeredi.hu,gmail.com,kernel.org,zeniv.linux.org.uk,infradead.org,mykernel.net,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: BE46C1F452

On Thu 19-11-26 18:47:09, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Wed 18-11-26 17:03:27, Josef Bacik wrote:
> >> sync_inodes_sb() has the flusher write every dirty inode of a superblock
> >> with WB_SYNC_ALL and for_sync set.  That writes the pages without waiting
> >> for them, hands over the timestamps that lazytime has deferred while it
> >> holds I_SYNC, and calls ->write_inode() in a way that tells the filesystem
> >> that ->sync_fs() follows, so ext4 does not commit a transaction for every
> >> inode.
> >> 
> >> overlayfs is about to sync some of the inodes of its upper filesystem, and
> >> none of the exported functions does that for one inode.  write_inode_now()
> >> and sync_inode_metadata() either do not wait for somebody else who is
> >> writing the inode and leave deferred timestamps alone, or they wait for the
> >> pages, clear the error flags of the mapping and make ext4 commit.
> >> 
> >> Add a function that writes one inode the way a sync does.
> >> 
> >> Nothing calls it yet.
> >> 
> >> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> >
> > Looks good. Feel free to add:
> >
> > Reviewed-by: Jan Kara <jack@suse.cz>
> >
> > Actually Ogawa wanted the very same function for FAT flushing of dirty data
> > on close so it looks like a generally useful primitive to have. Just the
> > description of the function is really hard to parse (at least to me as a
> > non-native speaker). 
> >
> >> +/**
> >> + * write_inode_for_sync - write an inode like a sync of its filesystem does
> >> + * @inode: inode to write to disk
> >> + *
> >> + * This does for one inode what sync_inodes_sb() has the flusher do for every
> >> + * dirty inode of a superblock.  It writes all dirty pages, the timestamps that
> >> + * lazytime has deferred and the inode.  It waits for somebody else who is
> >> + * writing the inode, but not for the pages it writes, and it does not ask the
> >> + * filesystem to commit anything.
> >> + *
> >> + * This is for a caller that syncs some of the inodes of a filesystem.  It has
> >> + * to wait for the pages with filemap_fdatawait_keep_errors(), like
> >> + * wait_sb_inodes() does, and to call sync_fs_and_bdev() in the end.
> >
> > I'd write:
> > This writes out inode like e.g. sync(2) would do it. On high level that
> > means we make sure anything dirty is submitted to the storage but we don't
> > wait for any completion. In particular, it means we wait if there's
> > somebody else submitting writeback for the inode (I_SYNC state set), we
> > make sure all dirty pages are submitted for writeback waiting for locks,
> > and we treat the inode as dirty if it has dirty timestamps. However we
> > don't wait for any IO to complete and we don't persist other inode-related
> > metadata through ->sync_inode_metadata(). If the caller wants data
> > persistency guarantee, it has to wait for IO completion (e.g. using
> > filemap_fdatawait_keep_errors()) and also persist common filesystem
> > metadata using sync_fs_and_bdev().
> 
> Looks good (except the name of function though). What I want is, not
> emulate sync, it is flushing dirty stuff. Now both are same usage
> though, may not be same by future changes.

The intention behind both users is "reliably submit everything for IO but
don't wait for IO completion". So I think they overlap not only in the
implementation and there's good chance they won't diverge...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
