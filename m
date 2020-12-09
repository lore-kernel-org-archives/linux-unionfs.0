Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104ABC4361B
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Dec 2020 01:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE20823975
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Dec 2020 01:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgLIByQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 20:54:16 -0500
Received: from namei.org ([65.99.196.166]:59052 "EHLO mail.namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgLIByO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Dec 2020 20:54:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.namei.org (Postfix) with ESMTPS id CBD5ADBF;
        Wed,  9 Dec 2020 01:53:30 +0000 (UTC)
Date:   Tue, 8 Dec 2020 17:53:30 -0800 (PST)
From:   James Morris <jmorris@namei.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
cc:     "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] vfs: move cap_convert_nscap() call into
 vfs_setxattr()
In-Reply-To: <20201207163255.564116-2-mszeredi@redhat.com>
Message-ID: <f9866764-15b-e795-60aa-b484916f66b4@namei.org>
References: <20201207163255.564116-1-mszeredi@redhat.com> <20201207163255.564116-2-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 7 Dec 2020, Miklos Szeredi wrote:

> cap_convert_nscap() does permission checking as well as conversion of the
> xattr value conditionally based on fs's user-ns.
> 
> This is needed by overlayfs and probably other layered fs (ecryptfs) and is
> what vfs_foo() is supposed to do anyway.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>


Acked-by: James Morris <jamorris@linux.microsoft.com>


-- 
James Morris
<jmorris@namei.org>

