Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47139C4332B
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Jan 2021 22:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB71A64E09
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Jan 2021 22:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhA2W5l (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 17:57:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37276 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhA2W5j (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Jan 2021 17:57:39 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1l5ch8-00El2W-7c; Fri, 29 Jan 2021 15:56:50 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1l5ch7-002DyO-3c; Fri, 29 Jan 2021 15:56:49 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     "Serge E. Hallyn" <serge@hallyn.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <20210119162204.2081137-1-mszeredi@redhat.com>
        <20210119162204.2081137-3-mszeredi@redhat.com>
        <8735yw8k7a.fsf@x220.int.ebiederm.org>
        <20210128165852.GA20974@mail.hallyn.com>
        <87o8h8x1a6.fsf@x220.int.ebiederm.org>
        <20210129154839.GC1130@mail.hallyn.com>
Date:   Fri, 29 Jan 2021 16:55:29 -0600
In-Reply-To: <20210129154839.GC1130@mail.hallyn.com> (Serge E. Hallyn's
        message of "Fri, 29 Jan 2021 09:48:39 -0600")
Message-ID: <87im7fuzdq.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1l5ch7-002DyO-3c;;;mid=<87im7fuzdq.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19X3waKsp4zjyMN3J12N2O9HZ4lenytO+A=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 2/2] security.capability: fix conversions on getxattr
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> On Thu, Jan 28, 2021 at 02:19:13PM -0600, Eric W. Biederman wrote:
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>> 
>> > On Tue, Jan 19, 2021 at 07:34:49PM -0600, Eric W. Biederman wrote:
>> >> Miklos Szeredi <mszeredi@redhat.com> writes:
>> >> 
>> >> > If a capability is stored on disk in v2 format cap_inode_getsecurity() will
>> >> > currently return in v2 format unconditionally.
>> >> >
>> >> > This is wrong: v2 cap should be equivalent to a v3 cap with zero rootid,
>> >> > and so the same conversions performed on it.
>> >> >
>> >> > If the rootid cannot be mapped v3 is returned unconverted.  Fix this so
>> >> > that both v2 and v3 return -EOVERFLOW if the rootid (or the owner of the fs
>> >> > user namespace in case of v2) cannot be mapped in the current user
>> >> > namespace.
>> >> 
>> >> This looks like a good cleanup.
>> >
>> > Sorry, I'm not following.  Why is this a good cleanup?  Why should
>> > the xattr be shown as faked v3 in this case?
>> 
>> If the reader is in &init_user_ns.  If the filesystem was mounted in a
>> user namespace.   Then the reader looses the information that the
>
> Can you be more precise about "filesystem was mounted in a user namespace"?
> Is this a FUSE thing, the fs is marked as being mounted in a non-init userns?
> If that's a possible case, then yes that must be represented as v3.  Using
> is_v2header() may be the simpler way to check for that, but the more accurate
> check would be "is it v2 header and mounted by init_user_ns".

I think the filesystems current relevant are fuse,overlayfs,ramfs,tmpfs.

> Basically yes, in as many cases as possible we want to just give a v2
> cap because more userspace knows what to do with that, but a non-init-userns
> mounted fs which provides a v2 fscap should have it represented as v3 cap
> with rootid being the kuid that owns the userns.

That is the case we that is being fixed in the patch.

> Or am I still thinking wrongly?  Wouldn't be entirely surprised :)

No you got it.

Eric
