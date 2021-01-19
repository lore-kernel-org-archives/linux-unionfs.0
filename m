Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEF3C433DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD0CC22D71
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbhASVMf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 16:12:35 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:47868 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391929AbhASVMY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Jan 2021 16:12:24 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1l1yHc-0074ac-TD; Tue, 19 Jan 2021 14:11:24 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1l1yHb-009ut1-VR; Tue, 19 Jan 2021 14:11:24 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <code@tyhicks.com>
References: <20210119162204.2081137-1-mszeredi@redhat.com>
Date:   Tue, 19 Jan 2021 15:10:14 -0600
In-Reply-To: <20210119162204.2081137-1-mszeredi@redhat.com> (Miklos Szeredi's
        message of "Tue, 19 Jan 2021 17:22:02 +0100")
Message-ID: <87y2go8wg9.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1l1yHb-009ut1-VR;;;mid=<87y2go8wg9.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/4Ah3dTvupV5EVHSjncD8jAwEeZNW5C5M=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 0/2] capability conversion fixes
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> writes:

> It turns out overlayfs is actually okay wrt. mutliple conversions, because
> it uses the right context for lower operations.  I.e. before calling
> vfs_{set,get}xattr() on underlying fs, it overrides creds with that of the
> mounter, so the current user ns will now match that of
> overlay_sb->s_user_ns, meaning that the caps will be converted to just the
> right format for the next layer
>
> OTOH ecryptfs, which is the only other one affected by commit 7c03e2cda4a5
> ("vfs: move cap_convert_nscap() call into vfs_setxattr()") needs to be
> fixed up, since it doesn't do the cap override thing that overlayfs does.
>
> I don't have an ecryptfs setup, so untested, but it's a fairly trivial
> change.
>
> My other observation was that cap_inode_getsecurity() messes up conversion
> of caps in more than one case.  This is independent of the overlayfs user
> ns enablement but affects it as well.
>
> Maybe we can revisit the infrastructure improvements we discussed, but I
> think these fixes are more appropriate for the current cycle.

I mostly agree.  Fixing the bugs in a back-portable way is important.

However we need to sort out the infrastructure, and implementation.

As far as I can tell it is only the fact that overlayfs does not support
the new mount api aka fs_context that allows this fix to work and be
correct.

I believe the new mount api would allow specifying a different userns
thatn curent_user_ns for the overlay filesystem and that would break
this.

So while I agree with the making a minimal fix for now.  We need a good
fix because this code is much too subtle, and it can break very easily
with no one noticing.

Eric





> Thanks,
> Miklos
>
> Miklos Szeredi (2):
>   ecryptfs: fix uid translation for setxattr on security.capability
>   security.capability: fix conversions on getxattr
>
>  fs/ecryptfs/inode.c  | 10 +++++--
>  security/commoncap.c | 67 ++++++++++++++++++++++++++++----------------
>  2 files changed, 50 insertions(+), 27 deletions(-)
