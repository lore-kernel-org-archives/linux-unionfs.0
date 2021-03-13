Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAECC433DB
	for <linux-unionfs@archiver.kernel.org>; Sat, 13 Mar 2021 03:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98DCA64F47
	for <linux-unionfs@archiver.kernel.org>; Sat, 13 Mar 2021 03:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhCMDiW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 22:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbhCMDiI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Mar 2021 22:38:08 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C00BC061574;
        Fri, 12 Mar 2021 19:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=5bxRXwU9Lww+kI4ncSJbUw275heo/O/4MARQE1zH7iw=; b=E3WuZCSuFT4PkgiKsHeowCvcPR
        3ByVzMi0Gdh8wud8fEeFZPItThFTMgGGLz6FxYLzs4aaPG6Mb2sqlmqL9Ov23DHJYHVoRQ4mLH5oZ
        mw8ZDksT1kMMkHbncLUN55zrvxAxxUz3jOxRLUExcC66xq92Ie0sWQb0scxL5L8LmS3Gzp65Rs4P4
        a9Cu6pcqrDPYRN5N9qa1Vp64bFdPgiLXlDYmMM9MPwmF5OfNWmLN8yJ4PdxdukCmFU4ZmVzkZQDuG
        JnvuS16dLGzydxKcMRJ8nySryJ0p/Ho4cU0uTC3h5d5Ef66MKAt9la+U+bexd24GgNSn/pLrQ3OM2
        mYnAKV2w==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKv6L-0017Jl-Vh; Sat, 13 Mar 2021 03:38:06 +0000
Subject: Re: [PATCH] fs: overlayfs: Trivial typo fixes in the file inode.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210313033023.28411-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7c1ecd2f-1fb6-2e6c-b37d-8ffa013e59db@infradead.org>
Date:   Fri, 12 Mar 2021 19:38:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210313033023.28411-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 3/12/21 7:30 PM, Bhaskar Chowdhury wrote:
> 
> s/peresistent/persistent/
> s/xatts/xattrs/  ---> this is a filesystem attribute, so, it spell like this.
> s/annotaion/annotation/
> 
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

In the future, please drop "fs: " in the Subject:. Compare:

$ git log --oneline fs/overlayfs/
d46b7cd68336 ovl: plumb through flush method
335d3fc57941 ovl: implement volatile-specific fsync error behaviour
03fedf93593c ovl: skip getxattr of security labels
e04527fefba6 ovl: fix dentry leak in ovl_get_redirect
b854cc659dcb ovl: avoid deadlock on directory ioctl
554677b97257 ovl: perform vfs_getxattr() with mounter creds
9efb069de4ba ovl: add warning on user_ns mismatch
029a52ada6a7 overlayfs: do not mount on top of idmapped mounts
549c7297717c fs: make helpers idmap mount aware
6521f8917082 namei: prepare for idmapped mounts
9fe61450972d namei: introduce struct renamedata
c7c7a1a18af4 xattr: handle idmapped mounts
e65ce2a50cf6 acl: handle idmapped mounts
2f221d6f7b88 attr: handle idmapped mounts
21cb47be6fb9 inode: make init and permission helpers idmapped mount aware
47291baa8ddf namei: make permission helpers idmapped mount aware
0558c1bf5a08 capability: handle idmapped mounts
459c7c565ac3 ovl: unprivieged mounts
87b2c60c6127 ovl: do not get metacopy for userxattr
b6650dab404c ovl: do not fail because of O_NOATIME
6939f977c54a ovl: do not fail when setting origin xattr
2d2f2d7322ff ovl: user xattr
82a763e61e2b ovl: simplify file splice
89bdfaf93d91 ovl: make ioctl() safe
c846af050f94 ovl: check privs before decoding file handle


> ---
>  Note: The second change has nothing to do with dictionary words.
> 
>  fs/overlayfs/inode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index d739e14c6814..e5588fc90a7d 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -114,7 +114,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
>  		 * high xinobits, so we use high xinobits to partition the
>  		 * overlay st_ino address space. The high bits holds the fsid
>  		 * (upper fsid is 0). The lowest xinobit is reserved for mapping
> -		 * the non-peresistent inode numbers range in case of overflow.
> +		 * the non-persistent inode numbers range in case of overflow.
>  		 * This way all overlay inode numbers are unique and use the
>  		 * overlay st_dev.
>  		 */
> @@ -403,7 +403,7 @@ static bool ovl_can_list(struct super_block *sb, const char *s)
>  	if (ovl_is_private_xattr(sb, s))
>  		return false;
> 
> -	/* List all non-trusted xatts */
> +	/* List all non-trusted xattrs */
>  	if (strncmp(s, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) != 0)
>  		return true;
> 
> @@ -533,7 +533,7 @@ static const struct address_space_operations ovl_aops = {
>   * stackable i_mutex locks according to stack level of the super
>   * block instance. An overlayfs instance can never be in stack
>   * depth 0 (there is always a real fs below it).  An overlayfs
> - * inode lock will use the lockdep annotaion ovl_i_mutex_key[depth].
> + * inode lock will use the lockdep annotation ovl_i_mutex_key[depth].
>   *
>   * For example, here is a snip from /proc/lockdep_chains after
>   * dir_iterate of nested overlayfs:
> --

Acked-by: Randy Dunlap <rdunlap@infradead.org>


-- 
~Randy
