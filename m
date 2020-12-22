Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42A3C433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Dec 2020 03:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D1A22B2D
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Dec 2020 03:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgLVD1R (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 22:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgLVD1R (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Dec 2020 22:27:17 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B055C0613D3;
        Mon, 21 Dec 2020 19:26:37 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krYJl-0037Dw-Lf; Tue, 22 Dec 2020 03:26:33 +0000
Date:   Tue, 22 Dec 2020 03:26:33 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Liangyan <liangyan.peng@linux.alibaba.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, joseph.qi@linux.alibaba.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] ovl: fix  dentry leak in ovl_get_redirect
Message-ID: <20201222032633.GS3579531@ZenIV.linux.org.uk>
References: <20201222030626.181165-1-liangyan.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222030626.181165-1-liangyan.peng@linux.alibaba.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Dec 22, 2020 at 11:06:26AM +0800, Liangyan wrote:

> Cc: <stable@vger.kernel.org>
> Fixes: a6c606551141 ("ovl: redirect on rename-dir")
> Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>

Fine by me...  I can put it through vfs.git#fixes, but IMO
that would be better off in overlayfs tree.
