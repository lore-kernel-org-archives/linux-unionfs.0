Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9373C4361B
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 19:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80661239EE
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 19:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgLQT31 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 14:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgLQT31 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Dec 2020 14:29:27 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9732C0617A7
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 11:28:41 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id i18so28653662ioa.1
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 11:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eaMl7OU+cLplK9NUSCXWVynpmRSo4RGMzL4oovUcya0=;
        b=scDq54vDyqYIOiv8aIQXcP7Y523FknK8sr9ukPbZkvl4WZSjKbQGSJyC9klnYciCAO
         ZV2gkSp7pbGNqjHjbomkmN5XQ5W6+xP06YDxucABIyIN/g7Gk7ThX6Tp9LKkAvsRarAF
         4lyGU2P3pBkC9xVLdxdAP+811bX9iRMg4/SlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eaMl7OU+cLplK9NUSCXWVynpmRSo4RGMzL4oovUcya0=;
        b=YEXyEGrcpZsAZvlP2pJczs9s09uiIBENVgpxbaH1tLEZjP7vNcR6pLfw6P4sVlyRAf
         3iu2aUtcsc8zfVgVHpNQWMuLl3wpjRy4Ya3KOsqknmliAy4f0JQ5ajC+AcAoM5t47wf9
         +HL6jkmg7UyF9dEV/fOi9K8MAt5/tVCOeQVpXL5Y91xPSC/9VXhMPb0CH9GVJcZzRcaq
         z3x4aED7ZLMBfK7sa3dYc0ptaD5KycTS/5Ih97mOm2iTrhYE6cKsoDOKb//G+U8IQEkC
         Ut7LIbFjM4+QsQR/HuV71je4PVH9sIlieHdEln7FvW/lpELZQ3vOItz3dLhzNW5okkq7
         BsUQ==
X-Gm-Message-State: AOAM531dQ+GiRrD1d7xXO0I25HEKBPIRDuqRX1cvHZptvYI4A7/E9J68
        UQFofE3XKq7pW4jDX0CtRGnojw==
X-Google-Smtp-Source: ABdhPJyZUXVanonRSXXZpaXRPF2TmFPNb1+aKXJHOkCGu7h7BKh6zK64nbS874/9ti+Me60XWagKgw==
X-Received: by 2002:a6b:6f07:: with SMTP id k7mr608570ioc.48.1608233321071;
        Thu, 17 Dec 2020 11:28:41 -0800 (PST)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id f29sm3960008ilg.3.2020.12.17.11.28.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Dec 2020 11:28:40 -0800 (PST)
Date:   Thu, 17 Dec 2020 19:28:39 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        NeilBrown <neilb@suse.com>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 2/2] overlayfs: propagate errors from upper to
 overlay sb in sync_fs
Message-ID: <20201217192838.GA28177@ircssh-2.c.rugged-nimbus-611.internal>
References: <20201213132713.66864-1-jlayton@kernel.org>
 <20201213132713.66864-3-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213132713.66864-3-jlayton@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Dec 13, 2020 at 08:27:13AM -0500, Jeff Layton wrote:
> Peek at the upper layer's errseq_t at mount time for volatile mounts,
> and record it in the per-sb info. In sync_fs, check for an error since
> the recorded point and set it in the overlayfs superblock if there was
> one.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/overlayfs/ovl_entry.h |  1 +
>  fs/overlayfs/super.c     | 14 +++++++++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 1b5a2094df8e..fcfcc3951973 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -79,6 +79,7 @@ struct ovl_fs {
>  	atomic_long_t last_ino;
>  	/* Whiteout dentry cache */
>  	struct dentry *whiteout;
> +	errseq_t err_mark;
>  };
>  
>  static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 290983bcfbb3..2985d2752970 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -264,8 +264,13 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>  	if (!ovl_upper_mnt(ofs))
>  		return 0;
>  
> -	if (!ovl_should_sync(ofs))
> -		return 0;
> +	if (!ovl_should_sync(ofs)) {
> +		/* Propagate errors from upper to overlayfs */
> +		ret = errseq_check(&upper_sb->s_wb_err, ofs->err_mark);
> +		errseq_set(&sb->s_wb_err, ret);
> +		return ret;
> +	}
> +
>  	/*
>  	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
>  	 * All the super blocks will be iterated, including upper_sb.
> @@ -1945,8 +1950,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  
>  		sb->s_stack_depth = ovl_upper_mnt(ofs)->mnt_sb->s_stack_depth;
>  		sb->s_time_gran = ovl_upper_mnt(ofs)->mnt_sb->s_time_gran;
> -
>  	}
> +
> +	if (ofs->config.ovl_volatile)
> +		ofs->err_mark = errseq_peek(&ovl_upper_mnt(ofs)->mnt_sb->s_wb_err);
> +
>  	oe = ovl_get_lowerstack(sb, splitlower, numlower, ofs, layers);
>  	err = PTR_ERR(oe);
>  	if (IS_ERR(oe))
> -- 
> 2.29.2
> 

I've tested this with the following scenarios, seems to work:
Test:
1. Mount ext2 on /mnt/loop, and cause a writeback error
2. Verify syncfs on /mnt/loop shows error
3. Mount volatile filesystem  
4. Create file on volatile filesystem, and verify that I can syncfs it without error
---
Fork:

5a. Create a file on overlayfs, and generate a writeback error
6a. Syncfs overlayfs.
7a. Create a new file on overlayfs, and syncfs, and verify it returns error

---
5b. Create a file on loop back, and generate a writeback error
6b. Sync said file
7b. Verify syncfs on loop returns error once, and then success on next attempts
8b. Verify all syncfs on overlayfs now fail

---
5c. Create file on overlayfs, and generate a writeback error
6c. Sync overlayfs, and verify all syncs are failures               
7c. Verify syncfs on loop fails once.




