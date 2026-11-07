Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794054944;
	b=5Zxw8mVLX7Tmqatz4Uf5B/ZOCipANnZKcehgNhZqTJdL+IS6V8w9pHy77qIWccLb0mqU
	 IeNEZl1hnZ5VTArkqYE4dhK6O4tFne3nbQbLQPfxwOvdQ/TWQEXW4oyup2w1WoyPb7GKL
	 +ay0pqQap23147+Xxx6tQVn1yZVjRnUVO/+Di9QCNu6G9S3UTehSttBamo3bDtU3pAdZr
	 ai1S8qHERIb1ybxuhd1rciJ0K7UaVAeY9MIFDBp2/Xs9fvilMFEfvIOagqQpGwpjFJqVP
	 W01mwzfSI/66QEyFSgk1Eef9Z7kNw8KJceaAOHaBjjqU0XXFHzgXm9SnhikKI8GxMGw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794054944;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qAh0bgBsog7Y7KnhvEREARaQP2vFlXIvO9i9mhA5trA=;
	b=G2mTK7oZAqxSnr7wJqdE7baEF4oKqwtEUfhmw+2Xv7OYLVS/U6BWn+C7i8dmxiEGAJuI
	 8UHfO5Zw/LNFl9G4Vk6g4HGkd/N+llrUJil7PXUAeBISurirh6ktRk7YCHMXVdAtAug58
	 2d63sZyCY9ighd8jbm1VGinbxrkKwPSpYqRropSyBfbtp3hup00sHEZryHuoVHhpdmW6o
	 gevpOUM5xL2xspaHu0Btr3HRYASKRcm13zXWXijNlQ92cnJuAxCh2WrNSkxBFB/q/3gIL
	 +QLY2waS+WgGVPuoqYJmifOo/TGi5sTm0WD0eU2XuNmZM1lW55Y6729LemFtjLxGLyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=teqGjgBJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2692B606A32C
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 12:35:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2692B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=teqGjgBJ
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b6f806f147so712757a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 04:35:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794054942; cv=none;
        d=google.com; s=arc-20260327;
        b=jwW3UPf8vW0tluG9GMzLTGcGhEJJRCW6PWJFoUjtY074nXy3OBZyUUj8MyOCFEEm9K
         4tc/JzxI4wBUA+5DrjhOe++iLzd7dDK76WJjrIhOETtWdj8jhtKId0JH3O9uLxSsWl2S
         6JE/K5Q8AL8wBL8aAYWrkjgqK/j2fWFI1F2p5O741T2zaBeZtA41jzki2zvN5PuX7rWs
         nR6BuT4zReJffULhC957biszmpcQpPVp0dZETIVlXVhxUX9tZxvmErSh3W7jYfgSvgsS
         H6rNJ1/2r1SUVdTlyD0it0wJVMgnSsSGzqVtLNQZP566LW+QVMJ5yIcbTacKdUAewKNH
         qb2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qAh0bgBsog7Y7KnhvEREARaQP2vFlXIvO9i9mhA5trA=;
        fh=KxKXYgqsUbdAlZ5Kcyn+L1+XK16BUj1sRsTRdsqZHmk=;
        b=ZqdQOLMgaxitdLo4v4oP5HLbhDalvuVazTzuApvurJ+BklOYG1WaDChYclNHpW+K1y
         g7sYHPI4RKip3vi1v423/XyCr+J/BFwXCTQ6WvCJbtKSzXNU2xxMPMNQoWCJg56fhWgE
         4+MeQtpesSZlbn/WaiTugX6YBYNu10aP7aWwrJW71iRZcRYQmmkYDfFMRBjTWsmJa4wg
         GqXxFQOn/Og4aDPQbjk0JB9Jgd7aUjvRpJKSOAHekgq6Yr8DQ8xNZUqk5KcOvAfN7D9t
         qHo2CmA05zVzW3zdzknclQuFqUJLm9maNEIw+c/4zh3Y8CyWuLELzbLcjoMzqZXoq6Fp
         Furg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794054942; x=1794659742; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qAh0bgBsog7Y7KnhvEREARaQP2vFlXIvO9i9mhA5trA=;
        b=teqGjgBJvuEB9n6ZIUNiRw+r+b/ZgZYOoqNjsf/AwJ7m0jfQeBp6AWoIv+u8NooF+q
         5Ou/x3/ijsxBDoqXbtBWvSzHWWVZkLmm9NYcKzz9kVHyE1JFU5BznhW004dt0rqRfIff
         cEf5sdiho2+JUWLpvgHqoEKQC5NLvpgwqIw1HDrm0xMZ2KN8OwaSJB8oqh1Yrvwuu9aw
         uo72uhxVmvHq6UJklRMJMxJcGUU27t3utiVCXIxT3NC0duVnvSC5rvDhugqpUlspX4cO
         m3evQLzojeHFKSk5nrO76ywIkY2aght59uvmuUkUeyu1JsnogVoSukhUtSaj0a+prvDj
         X26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794054942; x=1794659742;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qAh0bgBsog7Y7KnhvEREARaQP2vFlXIvO9i9mhA5trA=;
        b=EaypXDJUnRVT1Vw4v2dsO1YWi4AyTDEHPFmUIEscNX0W34cbfQrZe7xGAnb7obKYZj
         yZ5C9J9ffTqXhrJ84A4oCZQ0P3l+6saF3t0brryZvNmg8kx+VQy3WQGILdcY67uKb5Xy
         exHil3SJ8qFbynnNOcrHbMaC2y/NblK+plI5CYD7XeKVJ95hiy+RQ5ED57y8uWa6uIBM
         RChJ3iSVB2d1TsMFt7Rgsy7UzzD/HSSal97QOI4cfhzFZ3Vc2dRfj1v3zTEYJk+cnXS+
         2Wh2IK/x3tl6GiKEdKcLQFNAjGP/50N+DWh6bEoOKsdryDxm7viSVJCRG3lJtw6SQO1I
         b5Eg==
X-Forwarded-Encrypted: i=1; AL+hErEh0UDg34aiCNq/9Ycib3rmsCLk/JwVYEDoVO0mi+JNO88Mpb8ceXjLBjX3TP2m9SO7qbNQAA1mMloa44iD@vger.kernel.org
X-Gm-Message-State: APuU4Z99W+C+dJGxiL54iJRhzVT948fXGyNnRem/YbWX7FA1nVqq3EZN
	UQhmJMk/4CFHH1BP2vTVeKC3W00+QSZDuftgmoAdAi9kmf3+DxjcOJsk10gy9E9I6T/a+eW+C8C
	Wj+hcz9dKnWw0VUO2CWpromLVA1RwC9Y=
X-Gm-Gg: AYBFou2mBqzsyQvos6vdqstW9+u25T3Gif760+Q+znRHzCsl0BEkW7LWnfoqbC80+02
	Ft9R6j9YQrMS4Ich47v4oiOKTBALztYylv6OELCuv1dMhv9iM21QUTKHc6BQsa7bXNeCxp8vfQl
	USg8Wb79x26Ohe+cPJQFctWiZW6PQ05clI5wuvAbHxiCO1022VE4Mju57cYHYY8DaxUnhVaQ7Ny
	RnzmyhJ6BFEBz3xO6ktaoSbPb0MnnRnRgVdKfYN8+OBhooI+KXSVtcPYekfLwIHblVHQppEOyAG
	rp8I3T/38Xcz3UfmvWM1UzPvrn5SkQIPL24F5H7piaXAAIWgav4kf190UtRaiIJmQvatOO5NgYi
	feiNf887ChW4iSIGN4dzggtQDLQwO4Xxa80G8LI9d7Aexnt4uowkZwFHkCKKRebK/TM+cTE3oOK
	9CbwTe2Px4W7Zv7p0=
X-Received: by 2002:a05:6402:51d1:b0:6b6:e83b:6fc6 with SMTP id
 4fb4d7f45d1cf-6b6e83b70a5mr2926584a12.32.1794054942352; Sat, 07 Nov 2026
 04:35:42 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
 <20261106-nebel-fragment-normierung-84511a5676d9@brauner> <5ba0cd611f787673e219509aba8b81a0.josef@toxicpanda.com>
In-Reply-To: <5ba0cd611f787673e219509aba8b81a0.josef@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 7 Nov 2026 13:35:31 +0100
X-Gm-Features: AclHuK-7zpwSdqr5f1prmL6hTFzHE5Q5jFkb22xQF-E3GZFK1ObGfIvxTBr_qPE
Message-ID: <CAOQ4uxiRhKvZ5UJNDTF56L-q-SaB-uVuc9UhKWPG5d4VKx32qQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] ovl: only sync what was written through the overlay
To: Josef Bacik <josef@toxicpanda.com>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, Chengguang Xu <charliecgxu@tencent.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 5:53=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> w=
rote:
>
> On Fri, Nov 06, 2026 at 04:32:50PM +0100, Christian Brauner wrote:
> > The thing that's a bit ugly is that overlayfs open-codes the tail of
> > sync_filesystems(): ovl_sync_fs() calling upper_sb->s_op->sync_fs() and
> > sync_blockdev() itself is one more place that needs to know what
> > sync_filesystem() does.
> >
> > So we should probably add a helper to fs/sync.c for the ->sync_fs() and
> > block device part and use that.
>
> v4 went out a couple of hours before this, it only swaps in v2 of Amir's
> patch, so all of this applies to it as well.
>
> I've added sync_fs_and_bdev(sb, wait) for v5, sync_filesystem() calls it
> twice and ovl_sync_fs() once.
>
> > Eheeeem, isn't that kind of a bad proxy for this? What ->sync_fs() +
> > block device do is a property of the upper filesystems and how is that
> > related to RENAME_WHITEOUT? There's a few counter examples you even
> > give:
>
> [...]
>
> > So on ubifs a syncfs() in relaxed mode returns with metadata still in
> > memory. Meh. I know the flag got droppped but that was an overlayfs
> > speicfic thing. A generic property of ->sync_fs() is a different thing?
>
> I dropped the flag after v1 because nobody liked it, me included, and I
> don't want to touch every file system for this.
>
> What relaxed leaves to ->sync_fs() and the block device is only the
> upper inodes that have no overlay inode, that's whiteouts and the work
> directories. With creation fixed (below) everything else is on the dirty
> list and gets written.
>
> For the file systems that pass the probe: ext4, xfs and btrfs log all
> metadata. ext4 without a journal has it in the buffers of the block
> device, which we write. f2fs writes its dirty inodes in the checkpoint,
> f2fs_sync_inode_meta(). ubifs writes names, whiteouts and links to its
> journal when they are made, only setattr leaves an inode dirty in the
> VFS. The only setattr overlayfs does on an inode it doesn't track is the
> chmod of the work directory to 0 at mount time, right after it was
> created with mode 0. That's the counter example from the cover letter,
> and it's the only one I could find.
>
> Anybody who needs more than that has fsync=3Don and fsync=3Dstrict, which
> sync the whole upper file system like before.
>

Another way of putting this is that this entire sub-thread revolves around
what should be the default value of OVERLAY_FS_FSYNC_AUTO
for upstream kernel, because the distros are likely to change it anyway.

AFAIK, the only upper fs which is going to be getting the wrong default
with the current OVERLAY_FS_FSYNC_AUTO=3Dy is ubifs.

My rationale regarding ubifs is that it is a very specific and unique user
base for embedded/IoT/mobile devices.

The durability of overlayfs is already wrong on ubifs without
fsync=3Dstrict. We tried to fix this without opt-in, but we failed,
so using ubifs requires fsync=3Dstrict anyway for correct durability.

I admit that this is a weak excuse for regressing syncfs for ovl+ubifs,
but I am still leaning towards leaving OVERLAY_FS_FSYNC_AUTO=3Dy
as the upstream default.

> > Afaict, creation isn't covered. ovl_instantiate() ends up in
> > ovl_inode_init() which now uses __ovl_copyattr(). So a new file,
> > directory, symlink or hardlink only dirties the parent but not the new
> > overlay inode.
> >
> > Fine for metadata, but a long symlink isn't metadata. We should mark th=
e
> > new inode dirty where it's instantiated.
>
> Yup, ovl_instantiate() marks it in v5. Nothing gets lost today, ext4
> journals the block of a long symlink, xfs logs it, btrfs has it in the
> tree and f2fs writes it in f2fs_symlink(), but we shouldn't depend on
> that. I've added a long symlink to the fstest.
>
> > * ovl_park_inode() calls mark_inode_dirty_sync(). Jan's deferred inode
> >   reclaim (cf. [1]) removes exactly that from iput() because it does IO
> >   from dentry reclaim.
> >
> >   He replaces it with queue_dirtytime_writeback(). That moves the inode
> >   to the head of b_dirty_time and wakes the flusher.
> >
> > So it would be nice if we could base your thing on top of Jan's series
> > (I hope he'll send v2 soon!) and call queue_dirtytime_writeback() thing=
.
>
> The one in ovl_park_inode() is called from ->write_inode(), not from
> iput(), and it's on the overlay inode, which has no ->dirty_inode(), so
> it only moves it to another list.
>
> The one that does IO from dentry reclaim is iput() of an overlay inode
> with I_DIRTY_TIME, that's sync_lazytime() -> ovl_sync_lazytime() ->
> mark_inode_dirty_sync(upper). Jan's patch 2 takes that out of iput(), so
> it goes away without any change on my side, and then using
> queue_dirtytime_writeback() in ovl_park_inode() makes sense too. It
> would have to be exported for that.
>
> I only need patches 1 and 2 of that series, and they don't depend on the
> rest of it. Jan, could those two go in ahead of the deferred reclaim
> part? Then I'll rebase on top of them. Otherwise I'd rather do this as a
> follow up than wait for the whole thing.
>
> > > An overlay inode that loses its last reference while it is dirty is
> > > kept until it has been written and then sits on the LRU, like with
> > > any other file system.
> >
> > Hm, Jan's series fixes that as well afaict. :)
>
> I don't see how, what am I missing? overlayfs has inode_just_drop() for
> ->drop_inode(), so a dirty overlay inode is evicted on the last iput()
> and we forget that the upper inode has to be written. Patch 6 keeps it
> around until it's clean.
>
> > There's some Sashiko thing btw you should look into?
>
> The only mails I got from it are on v1, those are fixed since v2, except
> for dirtied_time_when of a parked inode, which I left alone on purpose,
> it's in the v2 changelog.

I am not sure what the current policy is for Sashiko and emails for ovl rev=
iews.

There are 3 high severity comments on v3 that are still in v4:
https://sashiko.dev/#/patchset/20261106-b4-ovl-containerized-sync-v4-0-6ddd=
e0b7dd8a%40toxicpanda.com

Thanks,
Amir.
