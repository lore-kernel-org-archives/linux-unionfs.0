Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7123C4167B
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Dec 2020 01:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8692923A75
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Dec 2020 01:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgLIB6L (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 20:58:11 -0500
Received: from namei.org ([65.99.196.166]:59072 "EHLO mail.namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgLIB6L (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Dec 2020 20:58:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.namei.org (Postfix) with ESMTPS id 0430BDC0;
        Wed,  9 Dec 2020 01:57:30 +0000 (UTC)
Date:   Tue, 8 Dec 2020 17:57:29 -0800 (PST)
From:   James Morris <jmorris@namei.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
cc:     "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v2 04/10] ovl: make ioctl() safe
In-Reply-To: <20201207163255.564116-5-mszeredi@redhat.com>
Message-ID: <e5876ecc-1cce-76d0-528-40b9bc54d0c2@namei.org>
References: <20201207163255.564116-1-mszeredi@redhat.com> <20201207163255.564116-5-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 7 Dec 2020, Miklos Szeredi wrote:

> ovl_ioctl_set_flags() does a capability check using flags, but then the
> real ioctl double-fetches flags and uses potentially different value.
> 
> The "Check the capability before cred override" comment misleading: user
> can skip this check by presenting benign flags first and then overwriting
> them to non-benign flags.

Is this a security bug which should be fixed in stable?

-- 
James Morris
<jmorris@namei.org>

