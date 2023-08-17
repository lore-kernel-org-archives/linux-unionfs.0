Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11450C2FC27
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 13:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351043AbjHQNil (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351372AbjHQNiO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 09:38:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9560226BC
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 06:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27F176714A
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 13:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA83EC433C7;
        Thu, 17 Aug 2023 13:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692279492;
        bh=s/h0F20XytpJpgnAYbgEohLSatrUDXrn5l4X0jy0UPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u4KxQcOXeuSOUP2LgqbMWBftZdyyCFEjlWJq3uzFLtgVXCoTrmq73h8EoKzMlKPEQ
         Tc0HrbLRK9Yp7FOiWtEotfGokDZUex8bBL8Esxxe/QEDAtcmNUnf7H8vcfgoe/GlPf
         tlwW5VjY1cp/2+ziueXtS6hg8ybMHGXYLaJizDJV+mS7YHrN9DJUa41L6ywrbRQuaR
         xfWDU+bZIaCb+HY40MrNJmWaeLIPGmsMDbwDw+NG9f7DAbzqunDhhkpaPSKmbvRNnM
         Fwsp25xXVR5zi9tAF6g4F2bJGvhlNl35VTv08simDPAKTwtEvIYppfXC+YVIv8p/CU
         03vMOBA67j3Uw==
Date:   Thu, 17 Aug 2023 15:38:09 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v3 0/4] fs: export __mnt_{want,drop}_write to modules
Message-ID: <20230817-vagabunden-glatze-c30318a0ecc0@brauner>
References: <20230816152334.924960-1-amir73il@gmail.com>
 <20230817054446.961644-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230817054446.961644-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 08:44:46AM +0300, Amir Goldstein wrote:
> overlayfs is going to use those to grab a write reference on the
> upper fs during copy up.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Christian,
> 
> This patch is needed for the ovl_want_write() changes [1],
> which I forgot to CC you on.
> 
> Please ACK if you approve.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-unionfs/20230816152334.924960-1-amir73il@gmail.com/
> 
>  fs/namespace.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index e157efc54023..370328b204f1 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -386,6 +386,7 @@ int __mnt_want_write(struct vfsmount *m)
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(__mnt_want_write);

Puh, not excited about that but also no real reason to say no other than
generic worries about it being abused.
But maybe let's not export underscore variants. Might make sense to at
least name them differently? mnt_want_write_locked()?
