Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB9FC433DB
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Dec 2020 12:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E643E224B1
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Dec 2020 12:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgLWMtg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 07:49:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728303AbgLWMtf (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Dec 2020 07:49:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 203132247F;
        Wed, 23 Dec 2020 12:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608727735;
        bh=qr6Tgo2rI9O+RPG8qqozKbpDM7yOwFSy58jzf8XnPyc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZEituENikvm+USYFuLfWcMA2BglYEBST0cdzY2zp9G93ZdppwMzhcLp2KH8fBN1hi
         VgtJv+NFAEKNvUDW4dOYl7taNmPOpzg8zHUqWqWuFibs+Bdef+kIfRjIlOCZba3ipq
         x1tTnt9dsy+282z2hRBhfpT3akT40X/K2Cbd0dYJLxw0Vb1xa2+yXbbWQr4NBW/nqL
         zZpvNAYZhwkR5Ss99982GUMsLsk9XXbcamD6mqvl83FG4zLxDgdv+N8157/cx0f/uk
         zPlfpX0xBxyZvp5F7nxTkCQf6euLGJJqZTJzhFf46gNKM6nOFJTaqLmFYA1aWWoPZC
         RfO9y1svIVRyg==
Message-ID: <3b488048b666f22108e7660eb32e10860a75784a.camel@kernel.org>
Subject: Re: [PATCH 2/3] vfs: Add a super block operation to check for
 writeback errors
From:   Jeff Layton <jlayton@kernel.org>
To:     Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc:     amir73il@gmail.com, sargun@sargun.me, miklos@szeredi.hu,
        willy@infradead.org, jack@suse.cz, neilb@suse.com,
        viro@zeniv.linux.org.uk, hch@lst.de
Date:   Wed, 23 Dec 2020 07:48:52 -0500
In-Reply-To: <20201221195055.35295-3-vgoyal@redhat.com>
References: <20201221195055.35295-1-vgoyal@redhat.com>
         <20201221195055.35295-3-vgoyal@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 2020-12-21 at 14:50 -0500, Vivek Goyal wrote:
> Right now we check for errors on super block in syncfs().
> 
> ret2 = errseq_check_and_advance(&sb->s_wb_err, &f.file->f_sb_err);
> 
> overlayfs does not update sb->s_wb_err and it is tracked on upper filesystem.
> So provide a superblock operation to check errors so that filesystem
> can provide override generic method and provide its own method to
> check for writeback errors.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/sync.c          | 5 ++++-
>  include/linux/fs.h | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/sync.c b/fs/sync.c
> index b5fb83a734cd..57e43a16dfca 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -176,7 +176,10 @@ SYSCALL_DEFINE1(syncfs, int, fd)
>  	ret = sync_filesystem(sb);
>  	up_read(&sb->s_umount);
>  
> 
> -	ret2 = errseq_check_and_advance(&sb->s_wb_err, &f.file->f_sb_err);
> +	if (sb->s_op->errseq_check_advance)
> +		ret2 = sb->s_op->errseq_check_advance(sb, f.file);
> +	else
> +		ret2 = errseq_check_and_advance(&sb->s_wb_err, &f.file->f_sb_err);
>  
> 
>  	fdput(f);
>  	return ret ? ret : ret2;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8667d0cdc71e..4297b6127adf 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1965,6 +1965,7 @@ struct super_operations {
>  				  struct shrink_control *);
>  	long (*free_cached_objects)(struct super_block *,
>  				    struct shrink_control *);
> +	int (*errseq_check_advance)(struct super_block *, struct file *);
>  };
>  
> 
>  /*

Also, the other super_operations generally don't take a superblock
pointer when you pass in a different fs object pointer. This should
probably just take a struct file * and then the operation can chase
pointers to the superblock from there.
 
-- 
Jeff Layton <jlayton@kernel.org>

