Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D845C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Feb 2022 11:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355978AbiBULWb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Feb 2022 06:22:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356393AbiBULVG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Feb 2022 06:21:06 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914AB2193
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Feb 2022 03:11:51 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x5so28493178edd.11
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Feb 2022 03:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mZK3sq6aCOHjPE/wikruaHnKvlqiGOa64aJPVy9I1wc=;
        b=qV8+5WSPKScehLKtlkkkCIXQYywQ3YFx/N/gs5DkozC+Euq35Yxjydk1dU/ABDn18t
         9Y6t+u2sNVo6gasjPHp+8r2VlqZAybV0kVF+ABBbG1qb+oOT93BH4fg7dl/mh7eQTjey
         8ovdEUMqE4pnjXV+r89bY+vgajbp7hhnD+cAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mZK3sq6aCOHjPE/wikruaHnKvlqiGOa64aJPVy9I1wc=;
        b=GJWeCa8w2KaSCatUsbKVkVMmmsfUdy0UT7KIhI+5EfJ+1wmZv0gLCwhiPR5FxKgRgy
         xOlctzlbCUJ8qMEZ5p1jc725NWTZSrDxZNrsjXRSIWYAIV+ImCbgqh17kJYoqsVm9EhM
         BXh47kSUmav7TlzA6dqq3VbrC5R0ZXlPO9Veqq1SjkU5F64h7oqCCBE8Ns3mxt3mC9Sq
         geEURI+KDyQn0vPjDwduTqq3Txc2th+0+coIcOAITl+hN4apj5h63XdrS21OUP8TeaL/
         0ZNCoU/QIXeVwoRexL9+KV+gfSebtwuPGq9lqOXrk+qBGb7x9tR/1/FRIjgjSw+LMP5m
         SksA==
X-Gm-Message-State: AOAM5338Q9gWYK9IjE6mfPBv8aj2V9Dk9bc44PTLKx5ScGuZR99UgRhb
        qeN5fJrdKKzrVWrnEgAmw8sfvFTrVWNNmA==
X-Google-Smtp-Source: ABdhPJxJzcjLPzJzGYO9f0nhLLry7CASSgSeVyxigW4CfvIOhfF9RUUR+7eq3ZIvVTYPfwQocOekqw==
X-Received: by 2002:a05:6402:d08:b0:412:a33e:24fe with SMTP id eb8-20020a0564020d0800b00412a33e24femr21029638edb.281.1645441910177;
        Mon, 21 Feb 2022 03:11:50 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-178-48-189-3.catv.fixed.vodafone.hu. [178.48.189.3])
        by smtp.gmail.com with ESMTPSA id ay16sm2462214ejb.61.2022.02.21.03.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:11:49 -0800 (PST)
Date:   Mon, 21 Feb 2022 12:11:47 +0100
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Alois Wohlschlager <alois1@gmx-topmail.de>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ovl: warn if trusted xattr creation fails
Message-ID: <YhNzc/++SHzdMXyt@miu.piliscsaba.redhat.com>
References: <2783448.iqOl4yHqVZ@genesis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2783448.iqOl4yHqVZ@genesis>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Feb 03, 2022 at 12:02:46PM +0100, Alois Wohlschlager wrote:
> When mounting overlayfs in an unprivileged user namespace, trusted xattr
> creation will fail. This will lead to failures in some file operations,
> e.g. in the following situation:
> 
>   mkdir lower upper work merged
>   mkdir lower/directory
>   mount -toverlay -olowerdir=lower,upperdir=upper,workdir=work none merged
>   rmdir merged/directory
>   mkdir merged/directory
> 
> The last mkdir will fail:
> 
>   mkdir: cannot create directory 'merged/directory': Input/output error
> 
> The cause for these failures is currently extremely non-obvious and hard
> to debug. Hence, warn the user and suggest using the userxattr mount
> option, if it is not already supplied and xattr creation fails during
> the self-check.

Thanks for the patch.

How about the following (untested) variant?

Thanks,
Miklos


diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7bb0a47cb615..955aeefc3b29 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1413,11 +1413,12 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	 */
 	err = ovl_do_setxattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE, "0", 1);
 	if (err) {
+		pr_warn("failed to set xattr on upper\n");
 		ofs->noxattr = true;
 		if (ofs->config.index || ofs->config.metacopy) {
 			ofs->config.index = false;
 			ofs->config.metacopy = false;
-			pr_warn("upper fs does not support xattr, falling back to index=off,metacopy=off.\n");
+			pr_warn("...falling back to index=off,metacopy=off.\n");
 		}
 		/*
 		 * xattr support is required for persistent st_ino.
@@ -1425,8 +1426,10 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		 */
 		if (ofs->config.xino == OVL_XINO_AUTO) {
 			ofs->config.xino = OVL_XINO_OFF;
-			pr_warn("upper fs does not support xattr, falling back to xino=off.\n");
+			pr_warn("...falling back to xino=off.\n");
 		}
+		if (err == -EPERM && !ofs->config.userxattr)
+			pr_info("try mounting with 'userxattr' option\n");
 		err = 0;
 	} else {
 		ovl_do_removexattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE);
