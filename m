Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D14AEE6446
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 Sep 2023 08:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjIOI3Q (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbjIOI3O (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Sep 2023 04:29:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DC03C34
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Sep 2023 01:27:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DBE682185F;
        Fri, 15 Sep 2023 08:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1694766445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e/9cmRl5h5dk9/6GIiA/UL/CcKYJr741B4XrAqoH0bo=;
        b=HhPUUVPIKYDk4cHDfHf9NUBAcx1eQaUNE/HIu/4IMcIIBO+VqlirOobpmx5kvEYGwC+/cy
        f2C/ycBwAruaMhMRBCbZtCDlxAFDEZSRFsCSF5kZKhixgraZRHktj2jAArBrwl7wmX0/NX
        S0ElwK2hqPilCwjbqTErK1rD8ubHfvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1694766445;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e/9cmRl5h5dk9/6GIiA/UL/CcKYJr741B4XrAqoH0bo=;
        b=ZVLDXUygJOL75iPXLdPy3UYa2DvtxRIJKVzCXK+7tySblAXSy9j9w4Yzkl9GLHYiDeUVhi
        FTit6oqQ4mDDOwDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CA31F1358A;
        Fri, 15 Sep 2023 08:27:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kqaDMG0VBGUYQQAAMHmgww
        (envelope-from <chrubis@suse.cz>); Fri, 15 Sep 2023 08:27:25 +0000
Date:   Fri, 15 Sep 2023 10:28:11 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Petr Vorel <pvorel@suse.cz>, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: Re: [PATCH 1/3] fanotify13: Test watching overlayfs upper fs
Message-ID: <ZQQVm5p08PmHRX1A@yuki>
References: <20230903111558.2603332-1-amir73il@gmail.com>
 <20230903111558.2603332-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230903111558.2603332-2-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi!
> ---
>  lib/tst_fs_setup.c                            |  2 +-
>  testcases/kernel/syscalls/fanotify/fanotify.h | 21 +++++++
>  .../kernel/syscalls/fanotify/fanotify13.c     | 62 +++++++++++++++++--
>  3 files changed, 79 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/tst_fs_setup.c b/lib/tst_fs_setup.c
> index 6b93483de..30673670f 100644
> --- a/lib/tst_fs_setup.c
> +++ b/lib/tst_fs_setup.c
> @@ -42,7 +42,7 @@ int mount_overlay(const char *file, const int lineno, int skip)
>  			tst_res_(file, lineno, TINFO,
>  				TST_FS_SETUP_OVERLAYFS_MSG);
>  		}
> -	} else {
> +	} else if (skip) {
>  		tst_brk_(file, lineno, TBROK | TERRNO,
>  			"overlayfs mount failed");
>  	}

The skip flag should be called strict, at least that is what we usually
name it, but that is very minor.

...

>  static struct tst_test test = {
>  	.test = do_test,
>  	.tcnt = ARRAY_SIZE(test_cases),
> +	.test_variants = 2,
>  	.setup = do_setup,
>  	.cleanup = do_cleanup,
>  	.needs_root = 1,
>  	.mount_device = 1,
> -	.mntpoint = MOUNT_PATH,
> +	.mntpoint = OVL_BASE_MNTPOINT,
>  	.all_filesystems = 1,
>  	.tags = (const struct tst_tag[]) {
>  		{"linux-git", "c285a2f01d69"},

The git hash for the regression test with variant=1 should have been
added here.


The rest looks good to me. With the two minor issues fixed:

Reviewed-by: Cyril Hrubis <chrubis@suse.cz>

@Peter Vorel Feel free to push the patch with the two fixes applied.

-- 
Cyril Hrubis
chrubis@suse.cz
