Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C44C433DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Jan 2021 18:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA6B222B4B
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Jan 2021 18:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbhALSu6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 13:50:58 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:45652 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbhALSu6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Jan 2021 13:50:58 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kzOkC-009ArJ-Ab; Tue, 12 Jan 2021 11:50:16 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kzOkB-005FSx-Em; Tue, 12 Jan 2021 11:50:15 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        <linux-api@vger.kernel.org>
References: <20201207163255.564116-1-mszeredi@redhat.com>
        <20201207163255.564116-2-mszeredi@redhat.com>
        <87czyoimqz.fsf@x220.int.ebiederm.org>
        <20210111134916.GC1236412@miu.piliscsaba.redhat.com>
        <874kjnm2p2.fsf@x220.int.ebiederm.org>
        <CAJfpegtKMwTZwENX7hrVGUVRWgNTf4Tr_bRxYrPpPAH_D2fH-Q@mail.gmail.com>
        <87bldugfxx.fsf@x220.int.ebiederm.org>
Date:   Tue, 12 Jan 2021 12:49:12 -0600
In-Reply-To: <87bldugfxx.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Tue, 12 Jan 2021 12:36:58 -0600")
Message-ID: <87blduf0t3.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kzOkB-005FSx-Em;;;mid=<87blduf0t3.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ju0OPFy9uih7pH63u6KWksVfbPTCfYQ0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v2 01/10] vfs: move cap_convert_nscap() call into vfs_setxattr()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> So there is the basic question do we want to read the raw bytes on disk
> or do we want to return something meaningful to the reader.  As the
> existing tools use the xattr interface to set/clear fscaps returning
> data to user space rather than raw bytes seems the perfered interface.
>
> My ideal semantics would be:
>
> - If current_user_ns() == sb->s_user_ns return the raw data.
>
>   I don't know how to implement this first scenario while permitting
>   stacked filesystems.

    After a little more thought I do.

    In getxattr if the get_cap method is not implemented by the
    filesystem if current_user_ns() == sb->s_user_ns simply treat it as
    an ordinary xattr read/write.

    Otherwise call vfs_get_cap and translate the result as described
    below.
    
    The key point of this is it allows for seeing what is actually on
    disk (when it is not confusing).

> - Calculate the cpu_vfs_cap_data as get_vfs_caps_from_disk does.
>   That gives the meaning of the xattr.
>
> - If "from_kuid(current_userns(), krootid) == 0" return a v2 cap.
>
> - If "rootid_owns_currentns()" return a v2 cap.
>
> - Else return an error.  Probably a permission error.
>
>   The fscap simply can not make sense to the user if the rootid does not
>   map.  Return a v2 cap would imply that the caps are present on the
>   executable (in the current context) which they are not.


Eric
