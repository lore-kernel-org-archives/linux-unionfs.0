Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABABFC2BBCA
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Dec 2020 17:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670B222515
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Dec 2020 17:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbgLOQpf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:45:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729601AbgLOQpa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Dec 2020 11:45:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608050643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvoLfPDS3GPj2oJUm//iV65orCWI3rrZ866PIW/DZco=;
        b=d8+fG0fqHUz/0zDSvTavFN2zqgIjNE9N4KxvUqneDiVa1qgqmIBF9nhg2ySK5xo5obOZR0
        bXCvwLGGCyyFnYZcTI5sqXuV2HnigZfC50vZ/AOoh7mRTpktsYdlPu9vKsJVPjg7BQ9Lhg
        5T+7T704ScmZJOWvZMSa6iQQu20IHv8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-ztZ8op53Piqk5POLDWa8fQ-1; Tue, 15 Dec 2020 11:44:00 -0500
X-MC-Unique: ztZ8op53Piqk5POLDWa8fQ-1
Received: by mail-qt1-f198.google.com with SMTP id w3so5244508qti.17
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Dec 2020 08:44:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yvoLfPDS3GPj2oJUm//iV65orCWI3rrZ866PIW/DZco=;
        b=HLxF11pwiF2TNxLMGBuKHdGGRWzyjuz+auCq1VLMPCUmj70mFrwCQ4uEADKVLUhTmF
         gxe95U5jS5fsc8NDmxZ83bav38zmM8sgNuGiGGza9+Q0tpM/rZgp0Sb/rFjBD3JDKtdR
         Pk40sbR7sRfvUpFoe7Anpd/nXa7rlnYNXWzAHhScRPhCVUu632rtJ1s/o8mE6QYwjjZZ
         SwuV98/LtQmhWLKJXZ1MXAv+lWZxUv6T+TGxb4kOypN0ePhR5yGgprtZ0hpcu/S+s9/T
         MJ+N5f/nXciBeiXDGEQjDmI7CuP1p3s/ASXrOH2OoNOuol9sfHOoT9upG5cNhf9t1uBW
         FBJg==
X-Gm-Message-State: AOAM5318sNTumtMaXsmrMq0pi+u+ZVWguhyUYeWM+uIzX9D4tTHSr/sH
        3oE2VD7Emumr4NtGX+wyr601H+lAaZ2iF1XiRoh4MhPhPn1rvsXXnW1fLsxFCN4LJRnMtyYRcKB
        4BoBRWSxGxP1334CErbsHgntLKg==
X-Received: by 2002:a05:6214:370:: with SMTP id t16mr38461081qvu.22.1608050640249;
        Tue, 15 Dec 2020 08:44:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMy1c5wQ24dBIZOGEhHnUL92nLjKe4utbF/3+yoD7VULpdYcfqRgLGG8zxEf2n+2LL7W+org==
X-Received: by 2002:a05:6214:370:: with SMTP id t16mr38461064qvu.22.1608050640026;
        Tue, 15 Dec 2020 08:44:00 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 17sm16625931qtu.23.2020.12.15.08.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 08:43:58 -0800 (PST)
Message-ID: <882fa590d1e77a43ff5b1d705d6f7551e309eadf.camel@redhat.com>
Subject: Re: [RFC PATCH v2 2/2] overlayfs: propagate errors from upper to
 overlay sb in sync_fs
From:   Jeff Layton <jlayton@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        NeilBrown <neilb@suse.com>, Jan Kara <jack@suse.cz>
Date:   Tue, 15 Dec 2020 11:43:57 -0500
In-Reply-To: <20201215163058.GC63355@redhat.com>
References: <20201214221421.1127423-1-jlayton@kernel.org>
         <20201214221421.1127423-3-jlayton@kernel.org>
         <20201215163058.GC63355@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 2020-12-15 at 11:30 -0500, Vivek Goyal wrote:
> On Mon, Dec 14, 2020 at 05:14:21PM -0500, Jeff Layton wrote:
> > Peek at the upper layer's errseq_t at mount time for volatile mounts,
> > and record it in the per-sb info. In sync_fs, check for an error since
> > the recorded point and set it in the overlayfs superblock if there was
> > one.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/overlayfs/ovl_entry.h |  1 +
> >  fs/overlayfs/super.c     | 19 ++++++++++++++-----
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index 1b5a2094df8e..f4285da50525 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -79,6 +79,7 @@ struct ovl_fs {
> >  	atomic_long_t last_ino;
> >  	/* Whiteout dentry cache */
> >  	struct dentry *whiteout;
> > +	errseq_t errseq;
> >  };
> >  
> > 
> > 
> > 
> > 
> > 
> > 
> > 
> >  static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 290983bcfbb3..3f0cb91915ff 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -264,8 +264,16 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
> >  	if (!ovl_upper_mnt(ofs))
> >  		return 0;
> >  
> > 
> > 
> > 
> > 
> > 
> > 
> > 
> > -	if (!ovl_should_sync(ofs))
> > -		return 0;
> > +	upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
> > +
> > +	if (!ovl_should_sync(ofs)) {
> > +		/* Propagate errors from upper to overlayfs */
> > +		ret = errseq_check(&upper_sb->s_wb_err, ofs->errseq);
> > +		if (ret)
> > +			errseq_set(&sb->s_wb_err, ret);
> > +		return ret;
> > +	}
> > +
> 
> I have few concerns here. I think ovl_sync_fs() should not be different
> for volatile mounts and non-volatile mounts. IOW, if an overlayfs
> user calls syncfs(fd), then only difference with non-volatile mount
> is that we will not call sync_filesystem() on underlying filesystem. But
> if there is an existing writeback error then that should be reported
> to syncfs(fd) caller both in case of volatile and non-volatile mounts.
> 
> Additional requirement in case of non-volatile mount seems to be that
> as soon as we detect first error, we probably should mark whole file
> system bad and start returning error for overlay operations so that
> upper layer can be thrown away and process restarted.
> 

That was the reason the patch did the errseq_set on every sync_fs
invocation for a volatile mount. That should ensure that syncfs always
returns an error. Still, there probably are cleaner ways to do this...

> And final non-volatile mount requirement seems to that we want to detect
> writeback errors in non syncfs() paths, for ex. mount(). That's what
> Sargun is trying to do. Keep a snapshot of upper_sb errseq on disk
> and upon remount of volatile overlay make sure no writeback errors
> have happened since then. And that's where I think we should be using
> new errseq_peek() and errseq_check(&upper_sb->s_wb_err, ofs->errseq)
> infracture. That way we can detect error on upper without consuming
> it upon overlay remount.
> 
> IOW, IMHO, ovl_sync_fs(), should use same mechanism to report error to
> user space both for volatile and non-volatile mounts. And this new
> mechanism of peeking at error without consuming it should be used
> in other paths like remount and possibly other overlay operations(if need
> be). 
> 
> But creating a special path in ovl_sync_fs() for volatile mounts
> only will create conflicts with error reporting for non-volatile
> mounts. And IMHO, these should be same.
> 
> Is there a good reason that why we should treat volatile and non-volatile
> mounts differently in ovl_sync_fs() from error detection and reporting
> point of view.
> 

Fair enough. I'm not that well-versed in overlayfs, so if you see a
better way to do this, then that's fine by me. I just sent this out as a
demonstration of how you could do it. Feel free to drop the second
patch.

I think the simplest solution to most of these issues is to add a new
f_op->syncfs vector. You shouldn't need to propagate errors to the ovl
sb at all if you add that. You can just operate on the upper sb's
s_wb_err, and ignore the one in the ovl sb.

> >  	/*
> >  	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
> >  	 * All the super blocks will be iterated, including upper_sb.
> > @@ -277,8 +285,6 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
> >  	if (!wait)
> >  		return 0;
> >  
> > 
> > 
> > 
> > -	upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
> > -
> >  	down_read(&upper_sb->s_umount);
> >  	ret = sync_filesystem(upper_sb);
> >  	up_read(&upper_sb->s_umount);
> > @@ -1945,8 +1951,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >  
> > 
> > 
> > 
> >  		sb->s_stack_depth = ovl_upper_mnt(ofs)->mnt_sb->s_stack_depth;
> >  		sb->s_time_gran = ovl_upper_mnt(ofs)->mnt_sb->s_time_gran;
> > -
> >  	}
> > +
> > +	if (ofs->config.ovl_volatile)
> > +		ofs->errseq = errseq_peek(&ovl_upper_mnt(ofs)->mnt_sb->s_wb_err);
> > +
> >  	oe = ovl_get_lowerstack(sb, splitlower, numlower, ofs, layers);
> >  	err = PTR_ERR(oe);
> >  	if (IS_ERR(oe))
> > -- 
> > 2.29.2
> > 
> 

-- 
Jeff Layton <jlayton@redhat.com>

