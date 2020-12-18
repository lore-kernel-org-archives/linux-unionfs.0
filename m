Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91059C2BBD5
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Dec 2020 15:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7165223AC9
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Dec 2020 15:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgLRPDt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 10:03:49 -0500
Received: from mail-qk1-f173.google.com ([209.85.222.173]:39546 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731426AbgLRPDo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 18 Dec 2020 10:03:44 -0500
Received: by mail-qk1-f173.google.com with SMTP id p14so2208673qke.6
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Dec 2020 07:03:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zjs7hNTEDKHlxBiYlsWxr44ZfT9qxL9IbjWkb/fejuo=;
        b=Zd8hXM6ZJBsy9zWRtoZHiDH/6AU1xxYE/zeromuRHD3WmgnKF72lgsgcok9Bs3nqMj
         Kqhfj8bmsF5/MLe5Gahw3osg8vbJmQD56uwZO8edds9aNT6yOFMHpW7ybKLPcwlSIC/W
         AOohGgcPkIURTxgerfz+HjKgfGLrVC3nnnd325CmcBBUJUc14qHUXT1mA6d0fcbYb6QW
         7AvlpDQ1/pon5aIpS/So3Bx0KQyrgCBpeoPq2pzenbxRhaNXMzbZ1UNJ2Y413E4FvNmr
         n2hjJz5AhY32S2XYZDoTr+oUsSJT3GUip5rkh5248D4Uy6SkhVApExWc8Ol+ak224WJ7
         jIcA==
X-Gm-Message-State: AOAM5318PlQauIuXT8QoB+x3DSpZJHofzot2NiJRQhk6AY57+xJ0WogS
        uoFUfUjgZil1g/jVuROkJpoSxg==
X-Google-Smtp-Source: ABdhPJyG4Nr4/zWsyUFtL20wO1j3BGOj0dhaf7PB/Ya6U+DCM0Kc+Gqeu3Oh+aj/pho+XYIGdqM1Tg==
X-Received: by 2002:a37:ef10:: with SMTP id j16mr5133179qkk.129.1608303782338;
        Fri, 18 Dec 2020 07:03:02 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id v1sm6213367qki.96.2020.12.18.07.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 07:03:01 -0800 (PST)
Date:   Fri, 18 Dec 2020 10:02:58 -0500
From:   Jeff Layton <jlayton@kernel.org>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, jlayton@kernel.org,
        amir73il@gmail.com, sargun@sargun.me, miklos@szeredi.hu,
        willy@infradead.org, jack@suse.cz, neilb@suse.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/3] overlayfs: Check writeback errors w.r.t upper in
 ->syncfs()
Message-ID: <20201218150258.GA866424@tleilax.poochiereds.net>
References: <20201216233149.39025-1-vgoyal@redhat.com>
 <20201216233149.39025-4-vgoyal@redhat.com>
 <20201217200856.GA707519@tleilax.poochiereds.net>
 <20201218144418.GA3424@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218144418.GA3424@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Dec 18, 2020 at 09:44:18AM -0500, Vivek Goyal wrote:
> On Thu, Dec 17, 2020 at 03:08:56PM -0500, Jeffrey Layton wrote:
> > On Wed, Dec 16, 2020 at 06:31:49PM -0500, Vivek Goyal wrote:
> > > Check for writeback error on overlay super block w.r.t "struct file"
> > > passed in ->syncfs().
> > > 
> > > As of now real error happens on upper sb. So this patch first propagates
> > > error from upper sb to overlay sb and then checks error w.r.t struct
> > > file passed in.
> > > 
> > > Jeff, I know you prefer that I should rather file upper file and check
> > > error directly on on upper sb w.r.t this real upper file.  While I was
> > > implementing that I thought what if file is on lower (and has not been
> > > copied up yet). In that case shall we not check writeback errors and
> > > return back to user space? That does not sound right though because,
> > > we are not checking for writeback errors on this file. Rather we
> > > are checking for any error on superblock. Upper might have an error
> > > and we should report it to user even if file in question is a lower
> > > file. And that's why I fell back to this approach. But I am open to
> > > change it if there are issues in this method.
> > > 
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  fs/overlayfs/ovl_entry.h |  2 ++
> > >  fs/overlayfs/super.c     | 15 ++++++++++++---
> > >  2 files changed, 14 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > > index 1b5a2094df8e..a08fd719ee7b 100644
> > > --- a/fs/overlayfs/ovl_entry.h
> > > +++ b/fs/overlayfs/ovl_entry.h
> > > @@ -79,6 +79,8 @@ struct ovl_fs {
> > >  	atomic_long_t last_ino;
> > >  	/* Whiteout dentry cache */
> > >  	struct dentry *whiteout;
> > > +	/* Protects multiple sb->s_wb_err update from upper_sb . */
> > > +	spinlock_t errseq_lock;
> > >  };
> > >  
> > >  static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
> > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > > index b4d92e6fa5ce..e7bc4492205e 100644
> > > --- a/fs/overlayfs/super.c
> > > +++ b/fs/overlayfs/super.c
> > > @@ -291,7 +291,7 @@ int ovl_syncfs(struct file *file)
> > >  	struct super_block *sb = file->f_path.dentry->d_sb;
> > >  	struct ovl_fs *ofs = sb->s_fs_info;
> > >  	struct super_block *upper_sb;
> > > -	int ret;
> > > +	int ret, ret2;
> > >  
> > >  	ret = 0;
> > >  	down_read(&sb->s_umount);
> > > @@ -310,10 +310,18 @@ int ovl_syncfs(struct file *file)
> > >  	ret = sync_filesystem(upper_sb);
> > >  	up_read(&upper_sb->s_umount);
> > >  
> > > +	/* Update overlay sb->s_wb_err */
> > > +	if (errseq_check(&upper_sb->s_wb_err, sb->s_wb_err)) {
> > > +		/* Upper sb has errors since last time */
> > > +		spin_lock(&ofs->errseq_lock);
> > > +		errseq_check_and_advance(&upper_sb->s_wb_err, &sb->s_wb_err);
> > > +		spin_unlock(&ofs->errseq_lock);
> > > +	}
> > 
> > So, the problem here is that the resulting value in sb->s_wb_err is
> > going to end up with the REPORTED flag set (using the naming in my
> > latest set). So, a later opener of a file on sb->s_wb_err won't see it.
> > 
> > For instance, suppose you call sync() on the box and does the above
> > check and advance. Then, you open the file and call syncfs() and get
> > back no error because REPORTED flag was set when you opened. That error
> > will then be lost.
> 
> Hi Jeff,
> 
> In this patch, I am doing this only in ->syncfs() path and not in
> ->sync_fs() path. IOW, errseq_check_and_advance() will take place
> only if there is a valid "struct file" passed in. That means there
> is a consumer of the error and that means it should be fine to
> set the sb->s_wb_err as SEEN/REPORTED, right?
> 
> If we end up plumbming "struct file" in existing ->sync_fs() routine,
> then I will call this only if a non NULL struct file has been 
> passed in. Otherwise skip this step. 
> 
> IOW, sync() call will not result in errseq_check_and_advance() instead
> a syncfs() call will. 
> 

It still seems odd and I'm not sure you won't end up with weird corner
cases due to the flag handling. If you're doing this in the new
f_op->syncfs, then why bother with sb->s_wb_err at all? You can just do
this, and avoid the overlayfs sb altogether:

if (errseq_check(&upper_sb->s_wb_err, file->f_sb_err)) {
	/* Upper sb has errors since last time */
	spin_lock(&file->f_lock);
	errseq_check_and_advance(&upper_sb->s_wb_err, &file->f_sb_err);
	spin_unlock(&file->f_lock);
}

That's simpler than trying to propagate the error between two
errseq_t's. You would need to sample the upper_sb->s_wb_err at
open time in the overlayfs ->open handler though, to make sure
you're tracking the right one.

> > 
> > >  
> > > +	ret2 = errseq_check_and_advance(&sb->s_wb_err, &file->f_sb_err);
> > >  out:
> > >  	up_read(&sb->s_umount);
> > > -	return ret;
> > > +	return ret ? ret : ret2;
> > >  }
> > >  
> > >  /**
> > > @@ -1903,6 +1911,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> > >  	if (!cred)
> > >  		goto out_err;
> > >  
> > > +	spin_lock_init(&ofs->errseq_lock);
> > >  	/* Is there a reason anyone would want not to share whiteouts? */
> > >  	ofs->share_whiteout = true;
> > >  
> > > @@ -1975,7 +1984,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> > >  
> > >  		sb->s_stack_depth = ovl_upper_mnt(ofs)->mnt_sb->s_stack_depth;
> > >  		sb->s_time_gran = ovl_upper_mnt(ofs)->mnt_sb->s_time_gran;
> > > -
> > > +		sb->s_wb_err = errseq_sample(&ovl_upper_mnt(ofs)->mnt_sb->s_wb_err);
> > 
> > This will mark the error on the upper_sb as REPORTED, and that's not
> > really that's the case if you're just using it set s_wb_err in the
> > overlay. You might want to use errseq_peek in this situation.
> 
> For now I am still looking at existing code and not new code. Because
> I belive that new code does not change existing behavior instead
> provides additional functionality to allow sampling the error without
> marking it seen as well as provide helper to not force seeing an
> unseen error.
> 
> So current errseq_sample() does not mark error SEEN. And if it is
> an unseen error, we will get 0 and be forced to see the error next
> time.
> 
> One small issue with this is that say upper has unseen error. Now
> we mount overlay and save that value in sb->s_wb_err (unseen). Say
> a file is opened on upper and error is now seen on upper. But
> we still have unseen error cached in overlay and if overlay fd is
> now opened, f->f_sb_err will be 0 and it will be forced to see
> err on next syncfs().
> 
> IOW, despite the fact that overlay fd was opened after upper sb had
> been marked seen, it still will see error. I think it probably is
> not a big issue.
> 

Good point. I was thinking about the newer code that may mark it
OBSERVED when you sample at open time.

Still, I think working with the overlayfs sb->s_wb_err is just adding
complexity for little benefit.  Assuming that writeback errors can only
happen on the upper layer, you're better off avoiding it.

> 
> > 
> > >  	}
> > >  	oe = ovl_get_lowerstack(sb, splitlower, numlower, ofs, layers);
> > >  	err = PTR_ERR(oe);
> > > -- 
> > > 2.25.4
> > > 
> > 
> 
