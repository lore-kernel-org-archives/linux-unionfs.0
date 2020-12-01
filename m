Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80421C64E7A
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Dec 2020 12:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3760520857
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Dec 2020 12:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B5j5x9hc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgLAMrV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 07:47:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390186AbgLAMrU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Dec 2020 07:47:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606826753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sfLmN6LKi+/cx/A7X3IVbom0/z1aD5TcebxYU0pmAC0=;
        b=B5j5x9hcvjkRftU5yGXUVaCRm6Hfn+DYXulMUKUPz5IYTt789y8kMSCO83iPYcYhhwlTxd
        eAcALzNqzteMRhjTDWwCnegs+9S9LNWwByXYAIQmFe9TJ6BJlsMnS7XodGHJL6KBhooz3t
        0r/cWb0T5z12XnmQk1VngHogo1TgmOw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-PPwiTOktOCWJOAGYcYIsSg-1; Tue, 01 Dec 2020 07:45:50 -0500
X-MC-Unique: PPwiTOktOCWJOAGYcYIsSg-1
Received: by mail-qk1-f198.google.com with SMTP id t141so1206441qke.22
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Dec 2020 04:45:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sfLmN6LKi+/cx/A7X3IVbom0/z1aD5TcebxYU0pmAC0=;
        b=K74Txk1JkwqOuHxc/ttwefskcwYGwNSYxd4Jh1JkJRT9MYDBnZ3ktgHh/+C7bNjNt3
         8UYLA1oT2YSGLxGo+GPtYkSpUappzRVVB6pq7fH8HzfY5HalwfYt7VFO4rQEqjuoTbex
         9rjrUa35GWbeC7AThHcbP7iQEHE8OWohaMn3ABW8lOAtcsGRsj5TsjEggnouB1zhk5NL
         /V2xYsdDw1L8amON2fuJF2pAA7yf4AyKG7MBUtrJWtNo7ibRvV0jQ1Hj54nh82ShXhBH
         hPZSUhpB8GodiGlvZMtvarXOFKtD7bsX36cTkWqnXVLsuTUh/kgwMAygoKh2hrO/dmjl
         s4Bw==
X-Gm-Message-State: AOAM532fTzRbWPp0+CE6fxVI0LpYyvif3pqRSyjYnaLoEpHPaozFo0TB
        fB0626SVPkh3yuGtLdN2SuiKYeX83V2Rp18Se9dN6gxE2Ro4Owhmcy54ADFzO/lCMJJ/eX0h6QX
        bemuXs3B86z4ejq2BJrbCkE/KCQ==
X-Received: by 2002:ac8:6bc6:: with SMTP id b6mr2557525qtt.127.1606826749873;
        Tue, 01 Dec 2020 04:45:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJoHXLOyEJ5cZuEBQHddUI5KwMH+6XW0JGwiKb1k3eN95o9FTB2BM5XulXIXdas6d2+AWE+w==
X-Received: by 2002:ac8:6bc6:: with SMTP id b6mr2557507qtt.127.1606826749648;
        Tue, 01 Dec 2020 04:45:49 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id c138sm1365892qke.95.2020.12.01.04.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 04:45:48 -0800 (PST)
Message-ID: <49ad785d0862dc49a043ec4f876892df80b51292.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] overlay: Add rudimentary checking of writeback
 errseq on volatile remount
From:   Jeff Layton <jlayton@redhat.com>
To:     Sargun Dhillon <sargun@sargun.me>, Vivek Goyal <vgoyal@redhat.com>
Cc:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date:   Tue, 01 Dec 2020 07:45:47 -0500
In-Reply-To: <20201201115630.GC24837@ircssh-2.c.rugged-nimbus-611.internal>
References: <20201201115630.GC24837@ircssh-2.c.rugged-nimbus-611.internal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 2020-12-01 at 11:56 +0000, Sargun Dhillon wrote:
> On Mon, Nov 30, 2020 at 02:33:42PM -0500, Vivek Goyal wrote:
> > On Fri, Nov 27, 2020 at 01:20:58AM -0800, Sargun Dhillon wrote:
> > > Volatile remounts validate the following at the moment:
> > >  * Has the module been reloaded / the system rebooted
> > >  * Has the workdir been remounted
> > > 
> > > This adds a new check for errors detected via the superblock's
> > > errseq_t. At mount time, the errseq_t is snapshotted to disk,
> > > and upon remount it's re-verified. This allows for kernel-level
> > > detection of errors without forcing userspace to perform a
> > > sync and allows for the hidden detection of writeback errors.
> > > 
> > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > Cc: linux-fsdevel@vger.kernel.org
> > > Cc: linux-unionfs@vger.kernel.org
> > > Cc: Miklos Szeredi <miklos@szeredi.hu>
> > > Cc: Amir Goldstein <amir73il@gmail.com>
> > > Cc: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  fs/overlayfs/overlayfs.h | 1 +
> > >  fs/overlayfs/readdir.c   | 6 ++++++
> > >  fs/overlayfs/super.c     | 1 +
> > >  3 files changed, 8 insertions(+)
> > > 
> > > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > > index de694ee99d7c..e8a711953b64 100644
> > > --- a/fs/overlayfs/overlayfs.h
> > > +++ b/fs/overlayfs/overlayfs.h
> > > @@ -85,6 +85,7 @@ struct ovl_volatile_info {
> > >  	 */
> > >  	uuid_t		ovl_boot_id;	/* Must stay first member */
> > >  	u64		s_instance_id;
> > > +	errseq_t	errseq;	/* Implemented as a u32 */
> > >  } __packed;
> > >  
> > > 
> > > 
> > > 
> > >  /*
> > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > index 7b66fbb20261..5795b28bb4cf 100644
> > > --- a/fs/overlayfs/readdir.c
> > > +++ b/fs/overlayfs/readdir.c
> > > @@ -1117,6 +1117,12 @@ static int ovl_verify_volatile_info(struct ovl_fs *ofs,
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > 
> > > 
> > > 
> > > +	err = errseq_check(&volatiledir->d_sb->s_wb_err, info.errseq);
> > 
> > Might be a stupid question. Will ask anyway.
> > 
> > But what protects against wrapping of counter. IOW, Say we stored info.errseq
> > value as A. It is possible that bunch of errors occurred and at remount
> > time ->s_wb_err is back to A and we pass the check. (Despite the fact lots
> > of errors have occurred since we sampled).
> > 
> > Thanks
> > Vivek
> > 
> 
> +Jeff Layton <jlayton@redhat.com>
> 
> Nothing. The current errseq API works like this today where if you have 2^20
> (1048576) errors, and syncfs (or other calls that mark the errseq as seen), and
> the error that occured 1048575 times ago was the same error as you just last
> had, and the error on the upperdir has already been marked as seen, the error
> will be swallowed up silently.
 
> This exists throughout all of VFS. I think we're potentially making this more
> likely by checkpointing to disk. The one aspect which is a little different about
> the usecase in the patch is that it relies on this mechanism to determine if
> an error has occured after the entire FS was constructed, so it's somewhat
> more consequential than the current issue in VFS which will just bubble up
> errors in a few files.
> 
> On my system syncfs takes about 2 milliseconds, so you have a chance to
> experience this every ~30 minutes if the syscalls align in the right way. If
> we expanded the errseq_t to u64, we would potentially get a collision
> every 4503599627370496 calls, or assuming the 2 millisecond invariant
> holds, every 285 years. Now, we probably don't want to make errseq_t into
> a u64 because of performance reasons (not all systems have native u64
> cmpxchg), and the extra memory it'd take up.
> 
> If we really want to avoid this case, I can think of one "simple" solution,
> which is something like laying out errseq_t as something like a errseq_t_src
> that's 64-bits, and all readers just look at the lower 32-bits. The longer
> errseq_t would exist on super_blocks, but files would still get the shorter one.
> To potentially avoid the performance penalty of atomic longs, we could also
> do something like this:
> 
> typedef struct {
>     atomic_t overflow;
>     u32 errseq;
> } errseq_t_big;
> 
> And in errseq_set, do:
> /* Wraps */
> if (new < old)
>         atomic_inc(&eseq->overflow);
> 
> *shrug*
> I don't think that the above scenario is likely though.
> 


The counter is only bumped if the seen flag is set, so you'd need to
record 2^20 errors _and_ fetch them that many times, and just get
unlucky once and hit the exact counter value that you had previously
sampled.

If that's your situation, then you probably have much bigger problems
than the counter wrapping.

-- 
Jeff Layton <jlayton@redhat.com>

