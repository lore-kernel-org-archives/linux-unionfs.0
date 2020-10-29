Return-Path: <SRS0=8QKN=EE=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1C5C55179
	for <linux-unionfs@archiver.kernel.org>; Thu, 29 Oct 2020 16:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C31B21582
	for <linux-unionfs@archiver.kernel.org>; Thu, 29 Oct 2020 16:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgJ2Qo6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 12:44:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60340 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgJ2Qo5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Oct 2020 12:44:57 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kYB2Q-009eVE-Gs; Thu, 29 Oct 2020 10:44:34 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kYB2N-0000rc-Un; Thu, 29 Oct 2020 10:44:34 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Tycho Andersen <tycho@tycho.pizza>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        containers@lists.linux-foundation.org,
        Miklos Szeredi <miklos@szeredi.hu>, smbarber@chromium.org,
        Christoph Hellwig <hch@infradead.org>,
        linux-ext4@vger.kernel.org, Mrunal Patel <mpatel@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        selinux@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@kernel.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Geoffrey Thomas <geofft@ldpreload.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        John Johansen <john.johansen@canonical.com>,
        Theodore Tso <tytso@mit.edu>,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        linux-api@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Alban Crequy <alban@kinvolk.io>,
        linux-integrity@vger.kernel.org, Todd Kjos <tkjos@google.com>
References: <20201029003252.2128653-1-christian.brauner@ubuntu.com>
        <87pn51ghju.fsf@x220.int.ebiederm.org> <20201029161231.GA108315@cisco>
Date:   Thu, 29 Oct 2020 11:44:33 -0500
In-Reply-To: <20201029161231.GA108315@cisco> (Tycho Andersen's message of
        "Thu, 29 Oct 2020 10:12:31 -0600")
Message-ID: <87blglc77y.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kYB2N-0000rc-Un;;;mid=<87blglc77y.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18l/ky6v0TPp3RfG1uVSiI/idjNvZVspy0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 00/34] fs: idmapped mounts
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Tycho Andersen <tycho@tycho.pizza> writes:

> Hi Eric,
>
> On Thu, Oct 29, 2020 at 10:47:49AM -0500, Eric W. Biederman wrote:
>> Christian Brauner <christian.brauner@ubuntu.com> writes:
>> 
>> > Hey everyone,
>> >
>> > I vanished for a little while to focus on this work here so sorry for
>> > not being available by mail for a while.
>> >
>> > Since quite a long time we have issues with sharing mounts between
>> > multiple unprivileged containers with different id mappings, sharing a
>> > rootfs between multiple containers with different id mappings, and also
>> > sharing regular directories and filesystems between users with different
>> > uids and gids. The latter use-cases have become even more important with
>> > the availability and adoption of systemd-homed (cf. [1]) to implement
>> > portable home directories.
>> 
>> Can you walk us through the motivating use case?
>> 
>> As of this year's LPC I had the distinct impression that the primary use
>> case for such a feature was due to the RLIMIT_NPROC problem where two
>> containers with the same users still wanted different uid mappings to
>> the disk because the users were conflicting with each other because of
>> the per user rlimits.
>> 
>> Fixing rlimits is straight forward to implement, and easier to manage
>> for implementations and administrators.
>
> Our use case is to have the same directory exposed to several
> different containers which each have disjoint ID mappings.

Why do the you have disjoint ID mappings for the users that are writing
to disk with the same ID?

>> Reading up on systemd-homed it appears to be a way to have encrypted
>> home directories.  Those home directories can either be encrypted at the
>> fs or at the block level.  Those home directories appear to have the
>> goal of being luggable between systems.  If the systems in question
>> don't have common administration of uids and gids after lugging your
>> encrypted home directory to another system chowning the files is
>> required.
>> 
>> Is that the use case you are looking at removing the need for
>> systemd-homed to avoid chowning after lugging encrypted home directories
>> from one system to another?  Why would it be desirable to avoid the
>> chown?
>
> Not just systemd-homed, but LXD has to do this,

I asked why the same disk users are assigned different kuids and the
only reason I have heard that LXD does this is the RLIMIT_NPROC problem.

Perhaps there is another reason.

In part this is why I am eager to hear peoples use case, and why I was
trying very hard to make certain we get the requirements.

I want the real requirements though and some thought, not just we did
this and it hurts.  Changning the uids on write is a very hard problem,
and not just in implementating it but also in maintaining and
understanding what is going on.

Eric
