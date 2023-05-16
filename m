Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FC3C77B7A
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 May 2023 15:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbjEPPmk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 16 May 2023 11:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjEPPmj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2023 11:42:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BEF1989;
        Tue, 16 May 2023 08:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 911FD61B0D;
        Tue, 16 May 2023 15:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDF3C433D2;
        Tue, 16 May 2023 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684251757;
        bh=/4eCX/rOw6AlVX/hcqhfyVDRcwUOfZqMSsz45Vv4rMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LbLTYIlaEpLHrhRRJEYtX/dvy1ZamGfUx0JkGuWLkkA2SnjDljYGJMdmSol/3hqun
         nfWZMT4/m3kq1iYVfYKioJUsz8puw5Wr+p9zR9EBQyy5ZTASVrREWV/2DpgUgWZZsg
         PgzT7mGYhbgupveN7fjkjsS8Ip5ismaGMnNAnmo/BqX0tTcKpqyUHdHnxfLlucaZ4W
         Rxf50+Z+wrsf6tzjiA4TBkcpxivsIqpf+oe1SdL+OgNtrtUPgnmALYr+/BO+hKoQXN
         9lVhifCVcFE8qU/YRibP6XlIkBus28DZ2lDlN+iRK23ZVFfT1f9JSq49F5hcHzhXJZ
         j6uqht2IbGjuw==
Date:   Tue, 16 May 2023 17:42:33 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     miklos@szeredi.hu, amir73il@gmail.com,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] ovl: Fix null ptr dereference at realinode in
 rcu-walk
Message-ID: <20230516-topografie-gejubelt-dba162b6e735@brauner>
References: <20230516141619.2160800-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230516141619.2160800-1-chengzhihao1@huawei.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 16, 2023 at 10:16:16PM +0800, Zhihao Cheng wrote:
> v1->v2:
>   Extract a helper to get realpath and real inode from ovl inode.
>   Get realinode from realpath in do_ovl_get_acl().
> v2->v3:
>   Modify original helper ovl_i_path_real() to return the realinode.
> 
> Zhihao Cheng (3):
>   ovl: Let helper ovl_i_path_real() return the realinode
>   ovl: ovl_permission: Fix null pointer dereference at realinode in
>     rcu-walk mode
>   ovl: get_acl: Fix null pointer dereference at realinode in rcu-walk
>     mode
> 
>  fs/overlayfs/inode.c     | 17 ++++++++---------
>  fs/overlayfs/overlayfs.h |  2 +-
>  fs/overlayfs/util.c      |  7 ++++---
>  3 files changed, 13 insertions(+), 13 deletions(-)

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
